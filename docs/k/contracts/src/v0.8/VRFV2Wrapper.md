# VRFV2Wrapper





A wrapper for VRFCoordinatorV2 that provides an interface better suited to one-offrequests for randomness.



## Methods

### COORDINATOR

```solidity
function COORDINATOR() external view returns (contract ExtendedVRFCoordinatorV2Interface)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract ExtendedVRFCoordinatorV2Interface | undefined |

### LINK

```solidity
function LINK() external view returns (contract LinkTokenInterface)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract LinkTokenInterface | undefined |

### LINK_ETH_FEED

```solidity
function LINK_ETH_FEED() external view returns (contract AggregatorV3Interface)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract AggregatorV3Interface | undefined |

### SUBSCRIPTION_ID

```solidity
function SUBSCRIPTION_ID() external view returns (uint64)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint64 | undefined |

### acceptOwnership

```solidity
function acceptOwnership() external nonpayable
```

Allows an ownership transfer to be completed by the recipient.




### calculateRequestPrice

```solidity
function calculateRequestPrice(uint32 _callbackGasLimit) external view returns (uint256)
```

Calculates the price of a VRF request with the given callbackGasLimit at the currentblock.

*This function relies on the transaction gas price which is not automatically set duringsimulation. To estimate the price at a specific gas price, use the estimatePrice function.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _callbackGasLimit | uint32 | is the gas limit used to estimate the price. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### disable

```solidity
function disable() external nonpayable
```

disable this contract so that new requests will be rejected. When disabled, new requestswill revert but existing requests can still be fulfilled.




### enable

```solidity
function enable() external nonpayable
```

enable this contract so that new requests can be accepted.




### estimateRequestPrice

```solidity
function estimateRequestPrice(uint32 _callbackGasLimit, uint256 _requestGasPriceWei) external view returns (uint256)
```

Estimates the price of a VRF request with a specific gas limit and gas price.

*This is a convenience function that can be called in simulation to better understandpricing.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _callbackGasLimit | uint32 | is the gas limit used to estimate the price. |
| _requestGasPriceWei | uint256 | is the gas price in wei used for the estimation. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getConfig

```solidity
function getConfig() external view returns (int256 fallbackWeiPerUnitLink, uint32 stalenessSeconds, uint32 fulfillmentFlatFeeLinkPPM, uint32 wrapperGasOverhead, uint32 coordinatorGasOverhead, uint8 wrapperPremiumPercentage, bytes32 keyHash, uint8 maxNumWords)
```

getConfig returns the current VRFV2Wrapper configuration.




#### Returns

| Name | Type | Description |
|---|---|---|
| fallbackWeiPerUnitLink | int256 | is the backup LINK exchange rate used when the LINK/NATIVE feed         is stale. |
| stalenessSeconds | uint32 | is the number of seconds before we consider the feed price to be stale         and fallback to fallbackWeiPerUnitLink. |
| fulfillmentFlatFeeLinkPPM | uint32 | is the flat fee in millionths of LINK that VRFCoordinatorV2         charges. |
| wrapperGasOverhead | uint32 | reflects the gas overhead of the wrapper&#39;s fulfillRandomWords         function. The cost for this gas is passed to the user. |
| coordinatorGasOverhead | uint32 | reflects the gas overhead of the coordinator&#39;s         fulfillRandomWords function. |
| wrapperPremiumPercentage | uint8 | is the premium ratio in percentage. For example, a value of 0         indicates no premium. A value of 15 indicates a 15 percent premium. |
| keyHash | bytes32 | is the key hash to use when requesting randomness. Fees are paid based on         current gas fees, so this should be set to the highest gas lane on the network. |
| maxNumWords | uint8 | is the max number of words that can be requested in a single wrapped VRF         request. |

### lastRequestId

```solidity
function lastRequestId() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | the request ID of the most recent VRF V2 request made by this wrapper. This should only be relied option within the same transaction that the request was made. |

### onTokenTransfer

```solidity
function onTokenTransfer(address _sender, uint256 _amount, bytes _data) external nonpayable
```

onTokenTransfer is called by LinkToken upon payment for a VRF request.

*Reverts if payment is too low.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _sender | address | is the sender of the payment, and the address that will receive a VRF callback        upon fulfillment. |
| _amount | uint256 | is the amount of LINK paid in Juels. |
| _data | bytes | is the abi-encoded VRF request parameters: uint32 callbackGasLimit,        uint16 requestConfirmations, and uint32 numWords. |

### owner

```solidity
function owner() external view returns (address)
```

Get the current owner




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### rawFulfillRandomWords

```solidity
function rawFulfillRandomWords(uint256 requestId, uint256[] randomWords) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| requestId | uint256 | undefined |
| randomWords | uint256[] | undefined |

### s_callbacks

```solidity
function s_callbacks(uint256) external view returns (address callbackAddress, uint32 callbackGasLimit, uint256 requestGasPrice, int256 requestWeiPerUnitLink, uint256 juelsPaid)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| callbackAddress | address | undefined |
| callbackGasLimit | uint32 | undefined |
| requestGasPrice | uint256 | undefined |
| requestWeiPerUnitLink | int256 | undefined |
| juelsPaid | uint256 | undefined |

### s_configured

```solidity
function s_configured() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### s_disabled

```solidity
function s_disabled() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### setConfig

```solidity
function setConfig(uint32 _wrapperGasOverhead, uint32 _coordinatorGasOverhead, uint8 _wrapperPremiumPercentage, bytes32 _keyHash, uint8 _maxNumWords) external nonpayable
```

setConfig configures VRFV2Wrapper.

*Sets wrapper-specific configuration based on the given parameters, and fetches any neededVRFCoordinatorV2 configuration from the coordinator.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _wrapperGasOverhead | uint32 | reflects the gas overhead of the wrapper&#39;s fulfillRandomWords        function. |
| _coordinatorGasOverhead | uint32 | reflects the gas overhead of the coordinator&#39;s        fulfillRandomWords function. |
| _wrapperPremiumPercentage | uint8 | is the premium ratio in percentage for wrapper requests. |
| _keyHash | bytes32 | to use for requesting randomness. |
| _maxNumWords | uint8 | undefined |

### transferOwnership

```solidity
function transferOwnership(address to) external nonpayable
```

Allows an owner to begin transferring ownership to a new address, pending.



#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | undefined |

### typeAndVersion

```solidity
function typeAndVersion() external pure returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### withdraw

```solidity
function withdraw(address _recipient, uint256 _amount) external nonpayable
```

withdraw is used by the VRFV2Wrapper&#39;s owner to withdraw LINK revenue.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _recipient | address | is the address that should receive the LINK funds. |
| _amount | uint256 | is the amount of LINK in Juels that should be withdrawn. |



## Events

### OwnershipTransferRequested

```solidity
event OwnershipTransferRequested(address indexed from, address indexed to)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| from `indexed` | address | undefined |
| to `indexed` | address | undefined |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed from, address indexed to)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| from `indexed` | address | undefined |
| to `indexed` | address | undefined |

### WrapperFulfillmentFailed

```solidity
event WrapperFulfillmentFailed(uint256 indexed requestId, address indexed consumer)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| requestId `indexed` | uint256 | undefined |
| consumer `indexed` | address | undefined |



## Errors

### OnlyCoordinatorCanFulfill

```solidity
error OnlyCoordinatorCanFulfill(address have, address want)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| have | address | undefined |
| want | address | undefined |


