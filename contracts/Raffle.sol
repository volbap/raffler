// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/VRFV2Wrapper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A smart contract that represents a ticketed lottery.
/// @notice In a raffle participants can buy tickets at a given fixed price.
/// Each sold ticket has the same probabilities of being picked as winner,
/// therefore, buying more tickets increments the odds of winning the prize.
/// The prize is calculated based on the amount collected by sold tickets,
/// minus some predefined percentage, considered profits, that goes to a specific
/// beneficiary address that is configured when creating this contract.
/// When the raffle is closed the contract automatically picks a winner ticket
/// at random. Randomness is obtained by relying on a Chainlink's VRF node.
/// Once a winner ticket is picked, the buyer address of that ticket can
/// redeem the prize by calling a function on this smart contract.
/// The currency used in this raffle can be any ERC-20 token, which is configured
/// when deploying this contract. All amounts will be expressed in terms of such
/// token, using the number of decimals that the token defines.
contract Raffle is VRFV2WrapperConsumerBase, Ownable {
    // TODO: shouldn't all these be read-only?
    // TODO: The LINK amount to spend should be transferred when the draw occurs, not before, so it can be estimated more accurately (it depends on network conditions)
    // TODO: Add a configurable amount of time after which the raffle will get cancelled, so players don't get stuck forever if the owner never finishes the raffle.
    // TODO: Convert reverts to error codes
    // TODO: Use variables nomenclature (s_, i_, etc)
    // TODO: Write unit tests in node.js (hardhat / localhost)
    // TODO: Write staging tests in node.js (testnet)

    /// @return The amount of tokens that it costs to buy one ticket.
    uint256 public ticketPrice;

    /// @return The minimum ticket number (e.g. 1)
    uint256 public ticketMinNumber;

    /// @return The maximum ticket number (e.g. 200)
    uint256 public ticketMaxNumber;

    /// @return The address of the ERC-20 token contract which is used as currency for the raffle.
    address public tokenAddress;

    /// @return The address that can claim the collected profits from this raffle.
    address public beneficiaryAddress;

    /// @return A number between 0 and 100 that determines how much percentage
    /// of the gathered amount from the sold tickets goes to profits.
    /// @notice For instance, for a `profitPercentage` of 15, it means that 15% of the sales
    /// will be considered profits and can be claimed by `beneficiaryAddress`,
    /// whereas the remaining 85% goes to the prize and can be claimed
    /// by the winner of the raffle.
    uint8 public profitPercentage;

    /// @return The current state of the raffle.
    /// @notice 0 = `created` -> Default state when contract is deployed. Raffle is defined but tickets are not on sale yet.
    /// @notice 1 = `sellingTickets` -> The raffle is open. Users can buy tickets.
    /// @notice 2 = `salesFinished` -> The raffle is closed. Users can no longer buy tickets.
    /// @notice 3 = `calculatingWinner` -> A draw is occurring. The contract is calculating a winner.
    /// @notice 4 = `cancelled` -> The raffle has been cancelled for some reason. Users can claim refunds for any tickets they have bought.
    /// @notice 5 = `finished` -> The raffle has finished and there is a winner. The winner can redeem the prize.
    enum RaffleState {
        created,
        sellingTickets,
        salesFinished,
        calculatingWinner,
        cancelled,
        finished
    }
    RaffleState public currentState = RaffleState.created;

    /// @notice Maps each ticket number to the address that bought that ticket.
    /// @return The address that owns that ticket number.
    mapping(uint256 => address) public ticketAddress;

    /// @notice Maps each address to the total amount spent in tickets by that address.
    /// @return The total amount spent in tickets by the address.
    /// @dev Useful for claiming funds.
    mapping(address => uint256) public addressSpentAmount;

    /// @return The list of ticket numbers that have been sold.
    /// @notice They are stored in the order that they were sold.
    uint256[] public soldTickets;

    /// @return A value that identifies unequivocally the Chainlink's VRF node.
    // bytes32 public vrfKeyHash;

    /// @return The amount of LINK required as gas to get a random number from Chainlink's VRF, with 18 decimals.
    // uint256 public vrfLinkFee;

    /// @return The address of the LINK token used to pay for VRF randomness requests.
    address public vrfLinkToken;

    /// @return The random number that was obtained from Chainlink's VRF.
    /// -1 if random number has not been obtained yet.
    int256 public obtainedRandomNumber = -1;

    /// @return The winner ticket number that was picked.
    /// -1 if winner ticket has not been picked yet.
    int256 public winnerTicketNumber = -1;

    /// @return The address that bought the winner ticket, who can claim the prize.
    address public winnerAddress;

    /// @return Whether or not the prize has been transferred to the winner.
    bool public prizeTransferred;

    /// @return Whether or not the profits have been transferred to the beneficiary.
    bool public profitsTransferred;

    VRFV2Wrapper private vrfV2Wrapper;

    /// @dev The id of the last VRF randomness request that was performed.
    /// @dev This id is used to match the asynchronous response.
    uint256 private vrfRequestId;

    ////////////////////////////////////////////////////////////
    // EVENTS
    ////////////////////////////////////////////////////////////

    /// Triggered when this contract requests a random number from Chainlink's VRF.
    /// @param requestId A code that identifies this Chainlink request unequivocally.
    event RequestedRandomness(uint256 indexed requestId);

    /// @notice Triggered when the tickets sale is opened.
    event OpenedTicketsSale();

    /// @notice Triggered when the tickets sale is closed.
    event ClosedTicketsSale();

    /// @notice Triggered when a ticket is sold.
    /// @param buyer The address of the buyer of the ticket.
    /// @param ticketNumber The ticket number that was purchased.
    event TicketSold(address indexed buyer, uint256 indexed ticketNumber);

    /// @notice Triggered when the contract has picked a winner.
    /// @param winnerAddress The address that owns the winner ticket.
    /// @param winnerTicketNumber The number of the ticket that was picked as winner.
    event ObtainedWinner(address indexed winnerAddress, uint256 indexed winnerTicketNumber);

    /// @notice Triggered when prize funds have been transferred to the winner.
    /// @param recipient The address that received the tokens.
    /// @param amount The amount of tokens that were transferred.
    event PrizeTransferred(address indexed recipient, uint256 indexed amount);

    /// @notice Triggered when profits have been transferred to the beneficiary.
    /// @param recipient The address that received the tokens.
    /// @param amount The amount of tokens that were transferred.
    event ProfitsTransferred(address indexed recipient, uint256 indexed amount);

    /// @notice Triggered when a refund has been transferred to the claimer.
    /// @param recipient The address that received the refund.
    /// @param amount The amount of tokens that were transferred.
    event RefundsTransferred(address indexed recipient, uint256 indexed amount);

    /// @notice Triggered when the raffle is cancelled by the owner.
    event RaffleCancelled();

    ////////////////////////////////////////////////////////////
    // PUBLIC FUNCTIONS
    ////////////////////////////////////////////////////////////

    /// @notice Buys a ticket for the caller.
    /// @param _ticketNumber The number of the ticket to buy.
    /// @notice Transaction will revert if `_ticketNumber` is not available.
    function buyTicket(uint256 _ticketNumber) public onlyWhenAt(RaffleState.sellingTickets) {
        address buyer = msg.sender;
        require(
            _ticketNumber >= ticketMinNumber && _ticketNumber <= ticketMaxNumber,
            "Invalid ticket number"
        );
        require(ticketAddress[_ticketNumber] == address(0), "Ticket number not available");
        require(
            IERC20(tokenAddress).balanceOf(buyer) >= ticketPrice,
            "This address doesn't have enough balance to buy a ticket"
        );
        IERC20(tokenAddress).transferFrom(buyer, address(this), ticketPrice);
        ticketAddress[_ticketNumber] = buyer;
        addressSpentAmount[buyer] += ticketPrice;
        soldTickets.push(_ticketNumber);
        emit TicketSold(buyer, _ticketNumber);
    }

    /// @return The amount of tokens that the winner will obtain
    /// from this raffle.
    function getCurrentPrizeAmount() public view returns (uint256) {
        return getTotalAccumulatedAmount() - getCurrentProfitsAmount();
    }

    /// @return The amount of tokens that the beneficiary will obtain
    /// from this raffle as profit.
    function getCurrentProfitsAmount() public view returns (uint256) {
        return (getTotalAccumulatedAmount() * profitPercentage) / 100;
    }

    /// @return The total accumulated amount of tokens provided by sold tickets.
    function getTotalAccumulatedAmount() public view returns (uint256) {
        return soldTickets.length * ticketPrice;
    }

    /// @return The amount that can be returned as refunds to the caller.
    /// @notice Refunds are only available if the caller has bought tickets and
    /// the raffle got cancelled.
    function getRefundableAmount() public view returns (uint256) {
        if (currentState != RaffleState.cancelled) {
            return 0;
        }
        return addressSpentAmount[msg.sender];
    }

    /// @notice Claims refunds.
    /// @notice If the caller has bought tickets and the raffle
    /// got cancelled, the total amount they spent will be returned
    /// to their account when executing this transaction.
    function claimRefunds() public {
        address recipient = msg.sender;
        uint256 amount = getRefundableAmount();
        require(amount > 0, "This address doesn't have a refundable amount");
        addressSpentAmount[recipient] = 0;
        IERC20(tokenAddress).transfer(recipient, amount);
        emit RefundsTransferred(recipient, amount);
    }

    ////////////////////////////////////////////////////////////
    // WINNER
    ////////////////////////////////////////////////////////////

    /// @notice Redeems the raffle prize.
    /// @notice If the caller has won the raffle, the prize amount
    /// will get transferred to their address when calling this function.
    function redeemPrize()
        public
        onlyWinner
        onlyWhenAt(RaffleState.finished)
        onlyIfPrizeNotYetTransferred
    {
        address recipient = msg.sender;
        uint256 amount = getCurrentPrizeAmount();
        prizeTransferred = true;
        IERC20(tokenAddress).transfer(recipient, amount);
        emit PrizeTransferred(recipient, amount);
    }

    ////////////////////////////////////////////////////////////
    // BENEFICIARY
    ////////////////////////////////////////////////////////////

    /// @notice Claims the profits obtained from this raffle.
    /// @notice Only available once the raffle has finished.
    /// @notice Profits are calculated by multiplying the
    /// total accumulated amount * the `profitPercentage`.
    function claimProfits()
        public
        onlyBeneficiary
        onlyWhenAt(RaffleState.finished)
        onlyIfProfitsNotYetTransferred
    {
        address recipient = msg.sender;
        uint256 amount = getCurrentProfitsAmount();
        profitsTransferred = true;
        IERC20(tokenAddress).transfer(recipient, amount);
        emit ProfitsTransferred(recipient, amount);
    }

    ////////////////////////////////////////////////////////////
    // OWNER
    ////////////////////////////////////////////////////////////

    /// @param _tokenAddress The ERC-20 that will be used as currency for this raffle.
    /// @param _ticketPrice The price at which each ticket will be sold, expressed in the selected ERC-20's decimals.
    /// @param _ticketMinNumber The minimum ticket number (e.g. 1)
    /// @param _ticketMaxNumber The maximum ticket number (e.g. 200)
    /// @param _profitPercentage The percentage of the total gathered amount that is considered profits and goes to a beneficiary. (e.g. `15` means 15% of the total)
    /// @param _beneficiaryAddress The address that will collect the profits from this raffle.
    /// @param _vrfLinkToken The address of the LINK token, necessary for randomness requests to Chainlink VRF nodes.
    /// @param _vrfV2Wrapper The address of the VRFV2Wrapper (see https://docs.chain.link/vrf/v2/direct-funding/#explanation)
    constructor(
        address _tokenAddress,
        uint256 _ticketPrice,
        uint256 _ticketMinNumber,
        uint256 _ticketMaxNumber,
        uint8 _profitPercentage,
        address _beneficiaryAddress,
        address _vrfLinkToken,
        address _vrfV2Wrapper
    ) VRFV2WrapperConsumerBase(_vrfLinkToken, _vrfV2Wrapper) {
        require(
            _ticketMinNumber <= _ticketMaxNumber,
            "_ticketMaxNumber must be greater than _ticketMinNumber"
        );
        require(
            _profitPercentage >= 0 && _profitPercentage <= 100,
            "_profitPercentage must be between 0 and 100"
        );
        tokenAddress = _tokenAddress;
        ticketPrice = _ticketPrice;
        ticketMinNumber = _ticketMinNumber;
        ticketMaxNumber = _ticketMaxNumber;
        profitPercentage = _profitPercentage;
        beneficiaryAddress = _beneficiaryAddress;
        vrfLinkToken = _vrfLinkToken;
        vrfV2Wrapper = VRFV2Wrapper(_vrfV2Wrapper);
    }

    /// @notice Opens the raffle so participants can start buying tickets.
    function openTicketsSale() public onlyOwner onlyWhenAt(RaffleState.created) {
        currentState = RaffleState.sellingTickets;
        emit OpenedTicketsSale();
    }

    /// @notice Closes the raffle. Participants won't be able to buy any more tickets.
    /// @notice This transaction won't perform the draw just yet, it leaves the winner calculation for later.
    function closeTicketsSale() public onlyOwner onlyWhenAt(RaffleState.sellingTickets) {
        currentState = RaffleState.salesFinished;
        emit ClosedTicketsSale();
    }

    /// @notice Closes the raffle. Participants won't be able to buy any more tickets.
    /// @notice It also performs the draw and starts calculating a winner immediately.
    /// @notice Once the winner is picked, the event `ObtainedWinner` is emitted.
    /// @notice This transaction will revert if this contract doesn't have enough LINK to pay for the VRF randomness request.
    /// @param _vrfCallbackGasLimit The maximum amount of gas you are willing to spend in the VRF randomness request.
    /// @param _vrfBlockConfirmations The number of block confirmations you want for the VRF randomness request.
    function closeTicketsSaleAndPickWinner(
        uint32 _vrfCallbackGasLimit,
        uint16 _vrfBlockConfirmations
    ) public onlyOwner onlyWhenAt(RaffleState.sellingTickets) {
        closeTicketsSale();
        pickWinner(_vrfCallbackGasLimit, _vrfBlockConfirmations);
    }

    /// @notice Performs the draw and starts calculating a winner. This action takes a while.
    /// @notice Once the winner is picked, the event `ObtainedWinner` is emitted.
    /// @notice This transaction will revert if this contract doesn't have enough LINK to pay for the VRF randomness request.
    /// @param _vrfCallbackGasLimit The maximum amount of gas you are willing to spend in the VRF randomness request.
    /// @param _vrfBlockConfirmations The number of block confirmations you want for the VRF randomness request.
    function pickWinner(
        uint32 _vrfCallbackGasLimit,
        uint16 _vrfBlockConfirmations
    ) public onlyOwner onlyWhenAt(RaffleState.salesFinished) {
        currentState = RaffleState.calculatingWinner;
        _requestRandomNumberToPickWinner(_vrfCallbackGasLimit, _vrfBlockConfirmations);
    }

    /// @notice Cancels the raffle.
    /// @notice After cancelling, players can claim refunds for the tickets they have purchased.
    function cancelRaffle() public onlyOwner onlyBefore(RaffleState.calculatingWinner) {
        currentState = RaffleState.cancelled;
        emit RaffleCancelled();
    }

    /// @notice Transfers all the LINK owned by this contract to the caller.
    /// @notice Only the owner of this contract can use this function.
    /// @notice The owner can call this function after the draw has occurred to redeem
    /// the excess LINK tokens that weren't consumed by the randomness request.
    // TODO: Figure out if this is necessary, or if the owner can call IERC20.transfer directly
    function transferExcessLINK() public onlyOwner {
        IERC20 link = IERC20(vrfLinkToken);
        link.transfer(msg.sender, link.balanceOf(address(this)));
    }

    ////////////////////////////////////////////////////////////
    // Private / Internal
    ////////////////////////////////////////////////////////////

    /// Requests a random number from Chainlink's VRF in order to pick the winner ticket.
    function _requestRandomNumberToPickWinner(
        uint32 _vrfCallbackGasLimit,
        uint16 _vrfBlockConfirmations
    ) private returns (uint256) {
        // We'll connect to the Chainlink VRF Node
        // using the "Request and Receive" cycle model

        // R&R -> 2 transactions:
        // 1) Request the data from the Chainlink Oracle through a function (requestRandomness)
        // 2) Callback transaction -> Chainlink node returns data to the contract into another function (fulfillRandomness)

        // requestRandomness function is provided by VRFV2WrapperConsumerBase
        vrfRequestId = requestRandomness(_vrfCallbackGasLimit, _vrfBlockConfirmations, 1);

        // We emit the following event to be able to retrieve the requestId in the tests.
        // Also, events work as logs for the contract.
        emit RequestedRandomness(vrfRequestId);

        return vrfRequestId;
    }

    // We need to override fulfillRandomWords from VRFV2WrapperConsumerBase in order to
    // retrieve the random number.
    // This function will be called for us by the VRFWrapper, that's why it's internal.
    // This function works asynchronously.
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(
            currentState == RaffleState.calculatingWinner,
            "Raffle is not calculating winners yet"
        );
        require(_requestId == vrfRequestId, "requestId doesn't match");
        require(_randomWords.length > 0 && _randomWords[0] > 0, "Random number not found");

        // Calculate winner ticket number
        uint256 winnerTicketIndex = _randomWords[0] % soldTickets.length;
        uint256 winnerNumber = soldTickets[winnerTicketIndex];

        // Update contract variables
        obtainedRandomNumber = int256(_randomWords[0]);
        winnerTicketNumber = int256(winnerNumber);
        winnerAddress = ticketAddress[winnerNumber];

        // Finish up
        require(winnerAddress != address(0), "Cannot find a winner");
        currentState = RaffleState.finished;
        emit ObtainedWinner(winnerAddress, uint256(winnerTicketNumber));
    }

    modifier onlyWhenAt(RaffleState _state) {
        require(currentState == _state, "Invalid state");
        _;
    }

    modifier onlyBefore(RaffleState _state) {
        require(currentState < _state, "Invalid state");
        _;
    }

    modifier onlyWinner() {
        require(msg.sender == winnerAddress, "Only the raffle winner can execute this function");
        _;
    }

    modifier onlyBeneficiary() {
        require(
            msg.sender == beneficiaryAddress,
            "Only the raffle beneficiary can execute this function"
        );
        _;
    }

    modifier onlyIfPrizeNotYetTransferred() {
        require(prizeTransferred == false, "The prize has already been transferred");
        _;
    }

    modifier onlyIfProfitsNotYetTransferred() {
        require(profitsTransferred == false, "Profits have already been transferred");
        _;
    }
}
