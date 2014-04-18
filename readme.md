# BLE Peripheral Manager Plugin for PhoneGap

This is my first PhoneGap plugin and first experience with Objective-C. It's a rough start, so I greatly appreciate any feedback for improving the code. There's a lot left to do to get this plugin up to par.

This plugin is only for Bluetooth Peripheral Manager functionality. If you're looking for Central Manager functionality check out https://github.com/randdusing/BluetoothLE.

## Upcoming Improvements

- improved documentation
- success and error callbacks for asynchronous methods
- ability to update a characteristic's value

## Installation

    phonegap local plugin add https://github.com/2WheelCoder/ble-peripheral-manager.git

## Methods

### BLEPeripheralManager.addService(service)

Creates a service from an object you pass. All object parameters are required. You may call this multiple times to add multiple services, but all services must be added before you start advertising.

#### Parameters:

- UUID: A UUID string. Create by running 'uuidgen' on the command line.
- primary: True or false as to whether this is the primary service for your app. True if you are only running one service.
- characteristics: An array of characteristics for this service. Each characteristic has two parameters, UUID and value, that are both strings. Characteristic values must be a string, not null, an array or an object. See example.

### BLEPeripheralManager.removeAllServices()

Removes all services from a class.

### BLEPeripheralManager.startAdvertising('deviceName')

Begin advertising. This must be called after at least one service has been created. Pass in any string to represent the name of your device.

### BLEPeripheralManager.stopAdvertising()

Stops all advertising.

## Example Usage

	// Setup a service object. You should create your own UUIDs for the service characteristic by running 'uuidgen' on the command line.
	var service = {
		UUID: '4A1CD3FC-40FF-40D3-8B59-1F3D89A7C5CE',
		primary: true,
		characteristics: [
			{
				UUID: '7EFB9DB8-CDD7-4989-90C8-F45CEB07133F',
				value: 'characteristic1Value'
			},
			{
				UUID: '558A7EBE-8429-442F-9782-E71A6FDCA9C5',
				value: 'characteristic2Value'
			}
		]
	};

	// Add your service
	BLEPeripheralManager.addService(service)

	// Start advertising services
	BLEPeripheralManager.startAdvertising('aNameForYourDevice');

	// Stop advertising when finished
	BLEPeripheralManager.stopAdvertising();

	// Remove all services (Run this if you want to add more services later)
	BLEPeripheralManager.removeAllServices();