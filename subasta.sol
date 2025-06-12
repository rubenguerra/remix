// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Subasta{
    // Parameter: Beneficiary of the auction (seller).
    address payable public beneficiary;

    // Contract's variables.
    uint public auctionEndTime;
    uint public contractCreacionTime;
    address public highestBidder;
    uint public highestBid;

    // Contract's constant.
    uint public BID_CONSTANT = 600; // Total auction's time. 10 minutes.


    // This mapping allows withdrawals of previous bids 
    mapping(address => uint) pendingReturns;

    // This struct allows gruoping the bidders and them bids' amount.
    struct Bidder{
        address bidder;
        uint amount;
    }

    Bidder[] public bidders;

    // Set to true at the end, disallows any change.
    // By default initialized to 'false'.
    bool ended;

    event HighestBidIncreased(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // They will be shown when the user is asked to corfirm a transaction
    // or when an error is displayed.

    /// Auction has already ended.
    error AuctionAlreadyEnded();
    /// There is already a higher or equal bid.
    error BidNotHighEnough(uint highestBid);
    /// Auction has not ended yet.
    error AuctionNotYetEnded();
    /// The function auctionEnd has already been called.
    error AuctionEndAlreadyCalled();

    constructor(
        address payable beneficiaryAddress
    ){
        beneficiary = beneficiaryAddress;
        contractCreacionTime = block.timestamp;
    }

     // Modifier
    modifier onlyBeneficiary() {
        require(msg.sender == beneficiary, "Beneficiary active this function.");
        _;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    function bid() external payable{
        // No arguments are necessary, all
        // information is already part of
        // the transaction. The keyword payable
        // is required for the function to
        // be able to receive Ether.

        auctionEndTime = block.timestamp;
        if (contractCreacionTime > auctionEndTime + BID_CONSTANT)
            revert AuctionAlreadyEnded();
            
        // The bid must be highest that 5% of the last bid.
        // If the bid is not higher, doesn't take the bid.
        if (msg.value <= (highestBid*105/100))
            revert BidNotHighEnough(highestBid);

        if (highestBid !=0){
            pendingReturns[highestBidder] += highestBid;
        }


        highestBidder = msg.sender;
        highestBid = msg.value;

        bidders.push(Bidder(msg.sender, msg.value));

        emit HighestBidIncreased(msg.sender, msg.value);
    }


    /// Withdraw  bid that was overbid.
    function withdraw() public{
        uint amount = pendingReturns[msg.sender];
        require(amount > 0);
        // It is important to set this to zero because the recipient
        // can call this function again as part of the receiving call
        // before send returns.

        pendingReturns[msg.sender] = 0;

        // The bidders withdraw them bid with a 2% minus.
        (bool success,) = msg.sender.call{value: (amount*98/100)}("");
        require(success);
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    // Only beneficiary can active this function, after the auctionEndTime is equal to 10 min.
    function auctionEnd() external onlyBeneficiary{
        
        if (block.timestamp < auctionEndTime)
            revert AuctionNotYetEnded();
        if (ended)
            revert AuctionEndAlreadyCalled();

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        beneficiary.transfer(highestBid);
    }

    // This function lists the bidders and the amount.
    function getBidder() public view returns(Bidder[] memory){
        return (bidders);
    }
}
