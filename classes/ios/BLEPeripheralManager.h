//
//  BLEPeripheralManager.h
//  BLEPeripheralManager
//
//  Created by Nick Stevens on 3/6/14.
//
//

#import <Cordova/CDV.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEPeripheralManager : CDVPlugin <CBPeripheralManagerDelegate>

@property CBPeripheralManager *peripheralManager;

-(void)initPeripheralManager:(CDVInvokedUrlCommand *)command;

-(void)startAdvertising:(CDVInvokedUrlCommand *)command;

-(void)stopAdvertising:(CDVInvokedUrlCommand *)command;

-(void)addService:(CDVInvokedUrlCommand *)command;

-(void)removeService:(CDVInvokedUrlCommand *)command;

-(void)removeAllServices:(CDVInvokedUrlCommand *)command;

@end
