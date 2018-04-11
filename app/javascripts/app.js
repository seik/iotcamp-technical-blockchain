// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3 } from "web3";
import { default as contract } from "truffle-contract";

import addresses_storage from "../../utils/addresses.json";

import social_artifacts from "../../build/contracts/SocialChain.json";
import token_artifacts from "../../build/contracts/StandardToken.json";

const SocialChain = contract(social_artifacts);
const KarmaToken = contract(token_artifacts);

const socialInstance = SocialChain.at(addresses_storage.addresses.SocialChain);

const karmaTokenInstance = KarmaToken.at(
  addresses_storage.addresses.KarmaToken
);

window.App = {
  start: async function() {
    SocialChain.setProvider(web3.currentProvider);
    SocialChain.defaults({ from: web3.eth.coinbase });

    KarmaToken.setProvider(web3.currentProvider);
    KarmaToken.defaults({ from: web3.eth.coinbase });

    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("there was an error fetching your accoutns.");
        return;
      }
      if (accs.length == 0) {
        alert("No accounts");
        return;
      }
    });

    this.loadPosts();
    this.loadKarma();
  },

  loadPosts: async function() {
    let postId = (await socialInstance.postId()).toNumber();

    let fromElement = postId <= 10 ? 0 : postId - 10;

    for (let i = fromElement; i < postId; i++) {
      const result = await socialInstance.getPost(i);

      const post = {
        id: result[0].toNumber(),
        owner: result[1],
        content: result[2],
        liked: result[3]
      };

      this.showPost(post);
    }

    document.getElementById("number-posts").textContent = postId;
  },

  publishPost: async function() {
    const content = document.getElementById("post-content").value;

    if (content.trim()) {
      await socialInstance.publish(content);
    }
  },

  showPost: async function(postElement) {
    let templatePost = document.querySelector("#post");

    let clone = document.importNode(templatePost, true);

    clone.content.querySelector("#post-id").id = postElement.id;
    clone.content.querySelector("#owner").textContent = postElement.owner;
    clone.content.querySelector("#content").textContent = postElement.content;

    const hearth = clone.content.querySelector("#hearth");
    if (postElement.liked) {
      hearth.parentNode.removeChild(hearth);
    }

    const posts = document.getElementById("posts");
    posts.insertBefore(clone.content, posts.childNodes[0]);
  },

  loadKarma: async function() {
    const karmaAmount = await karmaTokenInstance.balanceOf(web3.eth.coinbase);
    document.getElementById("user-karma").textContent = karmaAmount.toNumber();
  },

  upvote: async function(id) {
    const postId = parseInt(id);
    await socialInstance.upvote(postId);
  }
};

window.addEventListener("load", function() {
  if (typeof web3 !== "undefined") {
    console.warn(
      "Using web3 detected from external source. If you find that your accounts don't appear, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask"
    );
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn(
      "No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask"
    );
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(
      new Web3.providers.HttpProvider("http://localhost:8545")
    );
  }

  App.start();
});
