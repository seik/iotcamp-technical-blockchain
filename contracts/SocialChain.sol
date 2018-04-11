pragma solidity ^0.4.19;

import "./token/KarmaToken.sol";

contract SocialChain {

    struct Post {
        uint256 id;
        address owner;
        string content;
    }

    mapping(uint256 => uint256) postsKarma;
    mapping(uint256 => mapping(address => bool)) userLiked;
    mapping(address => bool) joined;

    uint256 public postId;
    Post[] public posts;

    KarmaToken karmaToken;

    function SocialChain(address _karmaToken) public {
        karmaToken = KarmaToken(_karmaToken);
    }

    function publish(string _content) public {
        bool exists = joined[msg.sender];

        if (!exists) {
            karmaToken.generate(msg.sender, 100);
            joined[msg.sender] = true;
        }

        posts.push(Post(postId, msg.sender, _content));
        postId++;
    }

    function upvote(uint256 _postId) public returns (bool success){
        bool liked = userLiked[_postId][msg.sender];
        require(!liked);

        postsKarma[_postId] = postsKarma[_postId]++;
        userLiked[_postId][msg.sender] = true;

        karmaToken.upvote(msg.sender, posts[_postId].owner);
        return true;
    }

    function getPost(uint256 _position) public view returns (uint256 id, address owner, string content, bool liked){
        Post memory post = posts[_position];
        return (post.id, post.owner, post.content, userLiked[_position][msg.sender]);
    }
}