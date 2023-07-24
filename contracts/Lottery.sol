// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Lottery is ERC721Enumerable, Ownable {
    uint256[] public tickets;
    mapping(uint256 => uint256) public winners;
    uint256 public round;

    bool public isPlayMode = true;

    uint256 public playFee = 0.01 ether;

    uint256 public tokenIdCounter;

    event TicketIssued(address indexed player, uint indexed ticketId);
    event WinnerChosen(uint256 indexed round, uint indexed winningTicketId);

    constructor() ERC721('LotteryNFT', 'LNFT') {
        round = 0;

        tokenIdCounter = 1;
        //New round is started by default
        startNewRound();
    }

    function mintTicket(address to) private returns (uint tokenIdMinted) {
        _safeMint(to, tokenIdCounter);
        tokenIdMinted = tokenIdCounter;
        tokenIdCounter++;
    }

    function getTicketsInCurrentRound()
        external
        view
        returns (uint256[] memory)
    {
        return tickets;
    }

    function play() external payable {
        require(isPlayMode == true, 'Not in Play Mode');
        require(msg.value >= playFee, 'Play fee required');

        // Issue an NFT ticket to the buyer
        uint256 ticketTokenId = mintTicket(msg.sender); // nftContract.tokenIdCounter() - 1
        tickets.push(ticketTokenId);
        emit TicketIssued(msg.sender, ticketTokenId);
    }

    /**
     *
     * Todo - Replace this with an external Oracle - say ChainLink VRF
     */
    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, tickets)
                )
            );
    }

    function pickWinner() external onlyOwner {
        require(tickets.length > 0, 'No tickets in the current round');

        uint256 index = random() % tickets.length;
        uint256 winningTicket = tickets[index];
        winners[round] = winningTicket;

        emit WinnerChosen(round, winningTicket);

        // Transfer the contract balance to the winner, winner is whoever holds the NFT
        uint256 contractBalance = address(this).balance;

        address winnerNFTHolder = ownerOf(winningTicket);
        payable(winnerNFTHolder).transfer(contractBalance);

        isPlayMode = false;
    }

    function startNewRound() public onlyOwner {
        // Start a new round
        delete tickets;
        round++;
        isPlayMode = true;
    }

    function seeCurrentRoundWinner()
        public
        view
        returns (address winnerNFTHolder)
    {
        return seeRoundWinner(round);
    }

    function seeRoundWinner(
        uint256 rnd
    ) public view returns (address winnerNFTHolder) {
        uint winningTicket = winners[rnd];
        winnerNFTHolder = ownerOf(winningTicket);
    }

    function changeFee(uint256 newFee) public onlyOwner {
        playFee = newFee;
    }
}
