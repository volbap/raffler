# Raffle



> A smart contract that represents a ticketed lottery.

In a raffle participants can buy tickets at a given fixed price. Each sold ticket has the same probabilities of being picked as winner, therefore, buying more tickets increments the odds of winning the prize. The prize is calculated based on the amount collected by sold tickets, minus some predefined percentage, considered profits, that goes to a specific beneficiary address that is configured when creating this contract. When the raffle is closed the contract automatically picks a winner ticket at random. Randomness is obtained by relying on a Chainlink&#39;s VRF node. Once a winner ticket is picked, the buyer address of that ticket can redeem the prize by calling a function on this smart contract. The currency used in this raffle can be any ERC-20 token, which is configured when deploying this contract. All amounts will be expressed in terms of such token, using the number of decimals that the token defines.



## Methods

### addressSpentAmount

```solidity
function addressSpentAmount(address) external view returns (uint256)
```

Maps each address to the total amount spent in tickets by that address.

*Useful for claiming funds.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The total amount spent in tickets by the address. |

### beneficiaryAddress

```solidity
function beneficiaryAddress() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | The address that can claim the collected profits from this raffle. |

### buyTicket

```solidity
function buyTicket(uint256 _ticketNumber) external nonpayable
```

Buys a ticket for the caller.Transaction will revert if `_ticketNumber` is not available.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _ticketNumber | uint256 | The number of the ticket to buy. |

### cancelRaffle

```solidity
function cancelRaffle() external nonpayable
```

Cancels the raffle.After cancelling, players can claim refunds for the tickets they have purchased.




### claimProfits

```solidity
function claimProfits() external nonpayable
```

Claims the profits obtained from this raffle.Only available once the raffle has finished.Profits are calculated by multiplying the total accumulated amount * the `profitPercentage`.




### claimRefunds

```solidity
function claimRefunds() external nonpayable
```

Claims refunds.If the caller has bought tickets and the raffle got cancelled, the total amount they spent will be returned to their account when executing this transaction.




### closeTicketsSale

```solidity
function closeTicketsSale() external nonpayable
```

Closes the raffle. Participants won&#39;t be able to buy any more tickets.This transaction won&#39;t perform the draw just yet, it leaves the winner calculation for later.




### closeTicketsSaleAndPickWinner

```solidity
function closeTicketsSaleAndPickWinner(uint32 _vrfCallbackGasLimit, uint16 _vrfBlockConfirmations) external nonpayable
```

Closes the raffle. Participants won&#39;t be able to buy any more tickets.It also performs the draw and starts calculating a winner immediately.Once the winner is picked, the event `ObtainedWinner` is emitted.This transaction will revert if this contract doesn&#39;t have enough LINK to pay for the VRF randomness request.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _vrfCallbackGasLimit | uint32 | The maximum amount of gas you are willing to spend in the VRF randomness request. |
| _vrfBlockConfirmations | uint16 | The number of block confirmations you want for the VRF randomness request. |

### currentState

```solidity
function currentState() external view returns (enum Raffle.RaffleState)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | enum Raffle.RaffleState | undefined |

### getCurrentPrizeAmount

```solidity
function getCurrentPrizeAmount() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The amount of tokens that the winner will obtain from this raffle. |

### getCurrentProfitsAmount

```solidity
function getCurrentProfitsAmount() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The amount of tokens that the beneficiary will obtain from this raffle as profit. |

### getRefundableAmount

```solidity
function getRefundableAmount() external view returns (uint256)
```

Refunds are only available if the caller has bought tickets and the raffle got cancelled.




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The amount that can be returned as refunds to the caller. |

### getTotalAccumulatedAmount

```solidity
function getTotalAccumulatedAmount() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The total accumulated amount of tokens provided by sold tickets. |

### obtainedRandomNumber

```solidity
function obtainedRandomNumber() external view returns (int256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | int256 | The random number that was obtained from Chainlink&#39;s VRF. -1 if random number has not been obtained yet. |

### openTicketsSale

```solidity
function openTicketsSale() external nonpayable
```

Opens the raffle so participants can start buying tickets.




### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### pickWinner

```solidity
function pickWinner(uint32 _vrfCallbackGasLimit, uint16 _vrfBlockConfirmations) external nonpayable
```

Performs the draw and starts calculating a winner. This action takes a while.Once the winner is picked, the event `ObtainedWinner` is emitted.This transaction will revert if this contract doesn&#39;t have enough LINK to pay for the VRF randomness request.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _vrfCallbackGasLimit | uint32 | The maximum amount of gas you are willing to spend in the VRF randomness request. |
| _vrfBlockConfirmations | uint16 | The number of block confirmations you want for the VRF randomness request. |

### prizeTransferred

```solidity
function prizeTransferred() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | Whether or not the prize has been transferred to the winner. |

### profitPercentage

```solidity
function profitPercentage() external view returns (uint8)
```

For instance, for a `profitPercentage` of 15, it means that 15% of the sales will be considered profits and can be claimed by `beneficiaryAddress`, whereas the remaining 85% goes to the prize and can be claimed by the winner of the raffle.




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint8 | A number between 0 and 100 that determines how much percentage of the gathered amount from the sold tickets goes to profits. |

### profitsTransferred

```solidity
function profitsTransferred() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | Whether or not the profits have been transferred to the beneficiary. |

### rawFulfillRandomWords

```solidity
function rawFulfillRandomWords(uint256 _requestId, uint256[] _randomWords) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _requestId | uint256 | undefined |
| _randomWords | uint256[] | undefined |

### redeemPrize

```solidity
function redeemPrize() external nonpayable
```

Redeems the raffle prize.If the caller has won the raffle, the prize amount will get transferred to their address when calling this function.




### renounceOwnership

```solidity
function renounceOwnership() external nonpayable
```



*Leaves the contract without owner. It will not be possible to call `onlyOwner` functions anymore. Can only be called by the current owner. NOTE: Renouncing ownership will leave the contract without an owner, thereby removing any functionality that is only available to the owner.*


### soldTickets

```solidity
function soldTickets(uint256) external view returns (uint256)
```

They are stored in the order that they were sold.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The list of ticket numbers that have been sold. |

### ticketAddress

```solidity
function ticketAddress(uint256) external view returns (address)
```

Maps each ticket number to the address that bought that ticket.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | The address that owns that ticket number. |

### ticketMaxNumber

```solidity
function ticketMaxNumber() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The maximum ticket number (e.g. 200) |

### ticketMinNumber

```solidity
function ticketMinNumber() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The minimum ticket number (e.g. 1) |

### ticketPrice

```solidity
function ticketPrice() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The amount of tokens that it costs to buy one ticket. |

### tokenAddress

```solidity
function tokenAddress() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | The address of the ERC-20 token contract which is used as currency for the raffle. |

### transferExcessLINK

```solidity
function transferExcessLINK() external nonpayable
```

Transfers all the LINK owned by this contract to the caller.Only the owner of this contract can use this function.The owner can call this function after the draw has occurred to redeem the excess LINK tokens that weren&#39;t consumed by the randomness request.




### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |

### vrfLinkToken

```solidity
function vrfLinkToken() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | The address of the LINK token used to pay for VRF randomness requests. |

### winnerAddress

```solidity
function winnerAddress() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | The address that bought the winner ticket, who can claim the prize. |

### winnerTicketNumber

```solidity
function winnerTicketNumber() external view returns (int256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | int256 | The winner ticket number that was picked. -1 if winner ticket has not been picked yet. |



## Events

### ClosedTicketsSale

```solidity
event ClosedTicketsSale()
```

Triggered when the tickets sale is closed.




### ObtainedWinner

```solidity
event ObtainedWinner(address indexed winnerAddress, uint256 indexed winnerTicketNumber)
```

Triggered when the contract has picked a winner.



#### Parameters

| Name | Type | Description |
|---|---|---|
| winnerAddress `indexed` | address | The address that owns the winner ticket. |
| winnerTicketNumber `indexed` | uint256 | The number of the ticket that was picked as winner. |

### OpenedTicketsSale

```solidity
event OpenedTicketsSale()
```

Triggered when the tickets sale is opened.




### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |

### PrizeTransferred

```solidity
event PrizeTransferred(address indexed recipient, uint256 indexed amount)
```

Triggered when prize funds have been transferred to the winner.



#### Parameters

| Name | Type | Description |
|---|---|---|
| recipient `indexed` | address | The address that received the tokens. |
| amount `indexed` | uint256 | The amount of tokens that were transferred. |

### ProfitsTransferred

```solidity
event ProfitsTransferred(address indexed recipient, uint256 indexed amount)
```

Triggered when profits have been transferred to the beneficiary.



#### Parameters

| Name | Type | Description |
|---|---|---|
| recipient `indexed` | address | The address that received the tokens. |
| amount `indexed` | uint256 | The amount of tokens that were transferred. |

### RaffleCancelled

```solidity
event RaffleCancelled()
```

Triggered when the raffle is cancelled by the owner.




### RefundsTransferred

```solidity
event RefundsTransferred(address indexed recipient, uint256 indexed amount)
```

Triggered when a refund has been transferred to the claimer.



#### Parameters

| Name | Type | Description |
|---|---|---|
| recipient `indexed` | address | The address that received the refund. |
| amount `indexed` | uint256 | The amount of tokens that were transferred. |

### RequestedRandomness

```solidity
event RequestedRandomness(uint256 indexed requestId)
```

Triggered when this contract requests a random number from Chainlink&#39;s VRF.



#### Parameters

| Name | Type | Description |
|---|---|---|
| requestId `indexed` | uint256 | A code that identifies this Chainlink request unequivocally. |

### TicketSold

```solidity
event TicketSold(address indexed buyer, uint256 indexed ticketNumber)
```

Triggered when a ticket is sold.



#### Parameters

| Name | Type | Description |
|---|---|---|
| buyer `indexed` | address | The address of the buyer of the ticket. |
| ticketNumber `indexed` | uint256 | The ticket number that was purchased. |



