# VRFCoordinatorV2Mock









## Methods

### BASE_FEE

```solidity
function BASE_FEE() external view returns (uint96)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint96 | undefined |

### GAS_PRICE_LINK

```solidity
function GAS_PRICE_LINK() external view returns (uint96)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint96 | undefined |

### MAX_CONSUMERS

```solidity
function MAX_CONSUMERS() external view returns (uint16)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |

### acceptSubscriptionOwnerTransfer

```solidity
function acceptSubscriptionOwnerTransfer(uint64 _subId) external pure
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | undefined |

### addConsumer

```solidity
function addConsumer(uint64 _subId, address _consumer) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | undefined |
| _consumer | address | undefined |

### cancelSubscription

```solidity
function cancelSubscription(uint64 _subId, address _to) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | undefined |
| _to | address | undefined |

### consumerIsAdded

```solidity
function consumerIsAdded(uint64 _subId, address _consumer) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | undefined |
| _consumer | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### createSubscription

```solidity
function createSubscription() external nonpayable returns (uint64 _subId)
```

Create a VRF subscription.

*You can manage the consumer set dynamically with addConsumer/removeConsumer.Note to fund the subscription, use transferAndCall. For exampleLINKTOKEN.transferAndCall(address(COORDINATOR),amount,abi.encode(subId));*


#### Returns

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | - A unique subscription id. |

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 _requestId, address _consumer) external nonpayable
```

fulfillRandomWords fulfills the given request, sending the random words to the suppliedconsumer.

*This mock uses a simplified formula for calculating payment amount and gas usage, and doesnot account for all edge cases handled in the real VRF coordinator. When making requestsagainst the real coordinator a small amount of additional LINK is required.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _requestId | uint256 | the request to fulfill |
| _consumer | address | the VRF randomness consumer to send the result to |

### fulfillRandomWordsWithOverride

```solidity
function fulfillRandomWordsWithOverride(uint256 _requestId, address _consumer, uint256[] _words) external nonpayable
```

fulfillRandomWordsWithOverride allows the user to pass in their own random words.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _requestId | uint256 | the request to fulfill |
| _consumer | address | the VRF randomness consumer to send the result to |
| _words | uint256[] | user-provided random words |

### fundSubscription

```solidity
function fundSubscription(uint64 _subId, uint96 _amount) external nonpayable
```

fundSubscription allows funding a subscription with an arbitrary amount for testing.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | the subscription to fund |
| _amount | uint96 | the amount to fund |

### getConfig

```solidity
function getConfig() external view returns (uint16 minimumRequestConfirmations, uint32 maxGasLimit, uint32 stalenessSeconds, uint32 gasAfterPaymentCalculation)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| minimumRequestConfirmations | uint16 | undefined |
| maxGasLimit | uint32 | undefined |
| stalenessSeconds | uint32 | undefined |
| gasAfterPaymentCalculation | uint32 | undefined |

### getFallbackWeiPerUnitLink

```solidity
function getFallbackWeiPerUnitLink() external view returns (int256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | int256 | undefined |

### getFeeConfig

```solidity
function getFeeConfig() external view returns (uint32 fulfillmentFlatFeeLinkPPMTier1, uint32 fulfillmentFlatFeeLinkPPMTier2, uint32 fulfillmentFlatFeeLinkPPMTier3, uint32 fulfillmentFlatFeeLinkPPMTier4, uint32 fulfillmentFlatFeeLinkPPMTier5, uint24 reqsForTier2, uint24 reqsForTier3, uint24 reqsForTier4, uint24 reqsForTier5)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| fulfillmentFlatFeeLinkPPMTier1 | uint32 | undefined |
| fulfillmentFlatFeeLinkPPMTier2 | uint32 | undefined |
| fulfillmentFlatFeeLinkPPMTier3 | uint32 | undefined |
| fulfillmentFlatFeeLinkPPMTier4 | uint32 | undefined |
| fulfillmentFlatFeeLinkPPMTier5 | uint32 | undefined |
| reqsForTier2 | uint24 | undefined |
| reqsForTier3 | uint24 | undefined |
| reqsForTier4 | uint24 | undefined |
| reqsForTier5 | uint24 | undefined |

### getRequestConfig

```solidity
function getRequestConfig() external pure returns (uint16, uint32, bytes32[])
```

Get configuration relevant for making requests




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | minimumRequestConfirmations global min for request confirmations |
| _1 | uint32 | maxGasLimit global max for request gas limit |
| _2 | bytes32[] | s_provingKeyHashes list of registered key hashes |

### getSubscription

```solidity
function getSubscription(uint64 _subId) external view returns (uint96 balance, uint64 reqCount, address owner, address[] consumers)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| balance | uint96 | undefined |
| reqCount | uint64 | undefined |
| owner | address | undefined |
| consumers | address[] | undefined |

### pendingRequestExists

```solidity
function pendingRequestExists(uint64 subId) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| subId | uint64 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### removeConsumer

```solidity
function removeConsumer(uint64 _subId, address _consumer) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | undefined |
| _consumer | address | undefined |

### requestRandomWords

```solidity
function requestRandomWords(bytes32 _keyHash, uint64 _subId, uint16 _minimumRequestConfirmations, uint32 _callbackGasLimit, uint32 _numWords) external nonpayable returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _keyHash | bytes32 | undefined |
| _subId | uint64 | undefined |
| _minimumRequestConfirmations | uint16 | undefined |
| _callbackGasLimit | uint32 | undefined |
| _numWords | uint32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### requestSubscriptionOwnerTransfer

```solidity
function requestSubscriptionOwnerTransfer(uint64 _subId, address _newOwner) external pure
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _subId | uint64 | undefined |
| _newOwner | address | undefined |



## Events

### ConsumerAdded

```solidity
event ConsumerAdded(uint64 indexed subId, address consumer)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| subId `indexed` | uint64 | undefined |
| consumer  | address | undefined |

### ConsumerRemoved

```solidity
event ConsumerRemoved(uint64 indexed subId, address consumer)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| subId `indexed` | uint64 | undefined |
| consumer  | address | undefined |

### RandomWordsFulfilled

```solidity
event RandomWordsFulfilled(uint256 indexed requestId, uint256 outputSeed, uint96 payment, bool success)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| requestId `indexed` | uint256 | undefined |
| outputSeed  | uint256 | undefined |
| payment  | uint96 | undefined |
| success  | bool | undefined |

### RandomWordsRequested

```solidity
event RandomWordsRequested(bytes32 indexed keyHash, uint256 requestId, uint256 preSeed, uint64 indexed subId, uint16 minimumRequestConfirmations, uint32 callbackGasLimit, uint32 numWords, address indexed sender)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| keyHash `indexed` | bytes32 | undefined |
| requestId  | uint256 | undefined |
| preSeed  | uint256 | undefined |
| subId `indexed` | uint64 | undefined |
| minimumRequestConfirmations  | uint16 | undefined |
| callbackGasLimit  | uint32 | undefined |
| numWords  | uint32 | undefined |
| sender `indexed` | address | undefined |

### SubscriptionCanceled

```solidity
event SubscriptionCanceled(uint64 indexed subId, address to, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| subId `indexed` | uint64 | undefined |
| to  | address | undefined |
| amount  | uint256 | undefined |

### SubscriptionCreated

```solidity
event SubscriptionCreated(uint64 indexed subId, address owner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| subId `indexed` | uint64 | undefined |
| owner  | address | undefined |

### SubscriptionFunded

```solidity
event SubscriptionFunded(uint64 indexed subId, uint256 oldBalance, uint256 newBalance)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| subId `indexed` | uint64 | undefined |
| oldBalance  | uint256 | undefined |
| newBalance  | uint256 | undefined |



## Errors

### InsufficientBalance

```solidity
error InsufficientBalance()
```






### InvalidConsumer

```solidity
error InvalidConsumer()
```






### InvalidRandomWords

```solidity
error InvalidRandomWords()
```






### InvalidSubscription

```solidity
error InvalidSubscription()
```






### MustBeSubOwner

```solidity
error MustBeSubOwner(address owner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

### TooManyConsumers

```solidity
error TooManyConsumers()
```







