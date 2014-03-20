# BLE Peripheral Manager Plugin for PhoneGap

## Methods

### BLEPeripheralManager.init()

Creates a peripheral manager.

### BLEPeripheralManager.addService(serviceUUIDString, servicePrimary, characteristics)

Creates a service with a UUID string you specify. servicePrimary is a boolean. Set to true if this is the main service for your app. Characteristics is an array of characteristic arrays (ideally the characteristic arrays would be objects, but passing objects into Objective-C via PhoneGap is a bit tedious).

    BLEPeripheralManager.addService('yourServiceUUID', true, [['characteristic1UUID', 'characteristic2UUID'], ['characteristic1UUID', 'characteristic2UUID']])

You may call this multiple times to add multiple services, but all services must be added before you start advertising.

### BLEPeripheralManager.startAdvertising('deviceName')

Begin advertising. This must be called after at least one service has been created. Pass in any string to represent the name of your device.

### BLEPeripheralManager.stopAdvertising()

Stops all advertising.
