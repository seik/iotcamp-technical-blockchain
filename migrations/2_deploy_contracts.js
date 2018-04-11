const fs = require("fs");
var path = require("path");
const addresses_storage = require("../utils/addresses.json");

const SocialChain = artifacts.require("SocialChain");
const KarmaToken = artifacts.require("KarmaToken");

module.exports = async function(deployer) {
  await deployer.deploy(KarmaToken);
  await deployer.deploy(SocialChain, KarmaToken.address);

  let karmaTokenInstance = await KarmaToken.deployed();
  await karmaTokenInstance.setOwner(SocialChain.address);

  addresses_storage.addresses.SocialChain = SocialChain.address;
  addresses_storage.addresses.KarmaToken = KarmaToken.address;

  var jsonPath = path.join(__dirname, "..", "utils", "addresses.json");

  await fs.writeFile(jsonPath, JSON.stringify(addresses_storage), err => {
    if (err) console.log(err);
  });
};
