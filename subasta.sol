// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Subasta{
    // Parameter: Beneficiary of the auction (seller).
    address payable public beneficiary;
    uint public auctionEndTime;

    // Variable state of the auction.
    address public highestBidder;
    uint public highestBid;

    // Allowed withdrawals of previous bids
    mapping (address => uint) pendingReturns;

    // Set to true at the end, disallows any change.
    // By default initialized to 'false'.
    bool ended;

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    //Errors that describe failures.
    // Use natspec comments.
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

    /// Create auction with beneficiary address `beneficiaryAddress`.
    constructor(
        address payable beneficiaryAddress
    ){
        beneficiary = beneficiaryAddress;
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

        require(block.timestamp <= auctionEndTime + 10 minutes, AuctionAlreadyEnded());

        // If the bid is not higher, send the
        // Ether back.
        if(msg.value <= highestBid)
            revert BidNotHighEnough(highestBid);

        // The bid must be highest that 5% of value.
        if(highestBid != 0 && highestBid >= highestBid + (highestBid * 5/100)){
            // Sending back the Ether by simply using
            // highestBidder.send(highestBid) is a security risk
            // because it could execute an untrusted contract.
            // It is always safe to let the recipients
            // withdraw their Ether themselves.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;

        // The event is done.
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw  bid that was overbid.
    function withdraw() external returns (bool){
        uint amount = pendingReturns[msg.sender];
        if (amount > 0){
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before 'send' returns.
            pendingReturns[msg.sender] = 0;

            // msg.sender is not of type 'address payable' and must be
            // explicity converted using 'payable(msg.sender)' in order
            // use the member function 'send()'.
            if (!payable(msg.sender).send(amount)){
                // No need to call throw here, just reset the amount owing
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd() external {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with

        // 1. Coonditions
        if (block.timestamp  < auctionEndTime)
            revert AuctionNotYetEnded();
        if (ended)
            revert AuctionEndAlreadyCalled();

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        beneficiary.transfer(highestBid);
    }

}
