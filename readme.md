# BLE Peripheral Manager Plugin for PhoneGap

This is my first PhoneGap plugin and first experience with Objective-C. It's a rough start, so I greatly appreciate any feedback for improving the code. There's a lot left to do to get this plugin up to par.

This plugin is only for Bluetooth Peripheral Manager functionality. If you're looking for Central Manager functionality check out https://github.com/randdusing/BluetoothLE.

## Upcoming Improvements

- ability to update a characteristic's value when Central Manager subscribes
- improved error handling

## Installation

    phonegap local plugin add https://github.com/2WheelCoder/ble-peripheral-manager.git

## Methods

### BLEPeripheralManager.addService(service, successCallback)

Creates a service from an object you pass. All object parameters are required. You may call this multiple times to add multiple services, but all services must be added before you start advertising. This method is asynchronous, so pass a function to the success callback for any code you may need to run after the service has been added, which includes the startAdvertising method.

#### Parameters:

- UUID: A UUID string. Create by running 'uuidgen' on the command line.
- primary: True or false as to whether this is the primary service for your app. True if you are only running one service.
- characteristics: An array of characteristics for this service. Each characteristic has two parameters, UUID and value, that are both strings. Characteristic values must be a string, not null, an array or an object. See example.

### BLEPeripheralManager.startAdvertising('deviceName', successCallback)

Begin advertising. This must be called after at least one service has been created, so make sure to run this in the callback of the addService method. Pass in any string to represent the name of your device. This method is asynchronous, so pass a function to the success callback for any code you may need to run after advertising has begun.

### BLEPeripheralManager.stopAdvertising()

Stops all advertising.

### BLEPeripheralManager.removeAllServices()

Removes all services from a class. Editing services is not yet possible, so you may need to run this to start from scratch if you need to update a service.

## Example Usage

	// Setup a service object. Generate your own UUIDs by running 'uuidgen' on the command line.
	var service = {
		UUID: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX',
		primary: true,
		characteristics: [
			{
				UUID: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX',
				value: 'characteristic1Value'
			},
			{
				UUID: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX',
				value: 'characteristic2Value'
			}
		]
	};

	// Add your service
	BLEPeripheralManager.addService(service, function success() {
		// Start advertising services
		BLEPeripheralManager.startAdvertising('aNameForYourDevice', function success() {
			console.log('Advertising!');
		});
	}

	// Stop advertising when finished
	BLEPeripheralManager.stopAdvertising();

	// Remove all services
	BLEPeripheralManager.removeAllServices();