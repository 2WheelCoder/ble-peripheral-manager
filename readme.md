# BLE Peripheral Manager Plugin for PhoneGap

This is my first PhoneGap plugin and first experience with Objective-C. It's a rough start, so I greatly appreciate any feedback for improving the code. There's a lot left to do to get this plugin up to par.

This plugin is only for Bluetooth Peripheral Manager functionality. If you're looking for Central Manager functionality check out https://github.com/randdusing/BluetoothLE.

## Upcoming Improvements

- improved documentation
- success and error callbacks for asynchronous methods
- adding characteristics as objects instead of arrays
- ability to update a characteristic's value

## Installation

    phonegap local plugin add https://github.com/2WheelCoder/ble-peripheral-manager.git

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
