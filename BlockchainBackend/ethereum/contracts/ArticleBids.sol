pragma solidity ^0.4.17;
contract ArticleBids {

    struct Voter {
        address ad;
        uint bid; 
    }
    struct Article {
        string url; 
        uint upvotes;
        uint downvotes;
        Voter[] upvoters; 
        Voter[] downvoters; 
        int status; 
    }
    struct PermArticle {
        string url;
    }

    mapping(address => Voter) voters;
    Article[] articles;
    PermArticle[] perm_articles;
    
    /// Create a new ballot with $(_numProposals) different proposals.
    function ArticleBids(uint8 _numProposals) public {
        // voters[chairperson].weight = 1;
        articles.length = _numProposals;
    }

    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    // function giveRightToVote(address toVoter) public {
    //     if (msg.sender != chairperson || voters[toVoter].voted) return;
    //     voters[toVoter].weight = 1;
    // 
    /// Delegate your vote to the voter $(to).
    // function delegate(address to) public {
    //     Voter storage sender = voters[msg.sender]; // assigns reference
    //     if (sender.voted) return;
    //     while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
    //         to = voters[to].delegate;
    //     if (to == msg.sender) return;
    //     sender.voted = true;
    //     sender.delegate = to;
    //     Voter storage delegateTo = voters[to];
    //     if (delegateTo.voted)
    //         proposals[delegateTo.vote].voteCount += sender.weight;
    //     else
    //         delegateTo.weight += sender.weight;
    // }

    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toArticle, uint typ) public payable {
        //Voter storage sender = voters[msg.sender];
        
        if(articles.length-toArticle < 10)
        {
            articles.length += 10; 
        }
        if(typ < 0)
        {
            articles[toArticle].downvotes += 1;
            Voter memory u;
            u.ad = msg.sender;
            u.bid = msg.value;
            articles[toArticle].downvoters[articles[toArticle].downvotes] = u; 
        }
        else
        {
            articles[toArticle].upvotes +=1; 
            Voter memory v;
            v.ad = msg.sender;
            v.bid = msg.value;
            articles[toArticle].upvoters[articles[toArticle].upvotes] = v; 
        }
    }
    function returnPayout(uint8 toArticle) public payable {
        if(articles[toArticle].upvotes >= articles[toArticle].downvotes)
        {
            articles[toArticle].status = 1; 
            uint tot = 0; 
            for(uint j = 0; j < articles[toArticle].downvoters.length; j++)
            {
                tot+=(articles[toArticle].downvoters[j].bid);
            }
            uint winnings = tot/(articles[toArticle].downvoters.length);
            for(uint jj = 0; jj < articles[toArticle].upvoters.length; jj++)
            {
                articles[toArticle].upvoters[jj].ad.transfer(articles[toArticle].upvoters[jj].bid + winnings);
            }
        }
        else
        {
            articles[toArticle].status = -1; 
            uint tott = 0; 
            for(uint ii = 0; ii < articles[toArticle].upvoters.length; ii++)
            {
                tott+=(articles[toArticle].upvoters[ii].bid);
            }
            winnings = tott/(articles[toArticle].upvoters.length);
            for(uint iii = 0; iii < articles[toArticle].downvoters.length; iii++)
            {
                articles[toArticle].downvoters[iii].ad.transfer(articles[toArticle].downvoters[iii].bid + winnings);
            }
        }
    }
    
    // function winningProposal() public constant returns (uint8 _winningProposal) {
    //     uint256 winningVoteCount = 0;
    //     for (uint8 prop = 0; prop < proposals.length; prop++)
    //         if (proposals[prop].voteCount > winningVoteCount) {
    //             winningVoteCount = proposals[prop].voteCount;
    //             _winningProposal = prop;
    //         }
    // }
}