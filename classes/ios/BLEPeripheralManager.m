//
//  BLEPeripheralManager.m
//  BLEPeripheralManager
//
//  Created by Nick Stevens on 3/6/14.
//
//

#import "BLEPeripheralManager.h"

@implementation BLEPeripheralManager {
    CBPeripheralManager *_peripheralManager;
}

- (void)pluginInitialize {
    [super pluginInitialize];
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}



- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    // Execute publish event on 'peripheralManagerDidUpdateState' in JS
    NSString *js = [NSString stringWithFormat:@"BLEPeripheralManager.publish('peripheralManagerDidUpdateState', %i);", peripheral.state];
    
    [self.commandDelegate evalJs:js];
    
    NSLog(@"state: %i", peripheral.state);
}



- (void)addService:(CDVInvokedUrlCommand *)command {
    NSMutableArray *characteristics = [[NSMutableArray alloc] init];
    
    for (NSArray *characteristicIndex in [command.arguments objectAtIndex:2]) {
        NSString *value = [characteristicIndex objectAtIndex:1];
        NSData *dataValue = [value dataUsingEncoding:NSUTF8StringEncoding];
        
        CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:[characteristicIndex objectAtIndex:0]] properties:CBCharacteristicPropertyRead value:dataValue permissions:CBAttributePermissionsReadable];
        
        [characteristics addObject:characteristic];
    }
    
    CBUUID *uuid = [CBUUID UUIDWithString:[command.arguments objectAtIndex:0]];
    BOOL boolArgument = [[NSNumber numberWithInt:(NSInteger)command.arguments[1]] boolValue];
    
    CBMutableService *service = [[CBMutableService alloc] initWithType:uuid primary:boolArgument];
    
    NSLog(@"characteristics: %@", characteristics);
    
    NSArray *immutableCharacteristics = [characteristics copy];
    
    service.characteristics = immutableCharacteristics;
    
    [_peripheralManager addService:service];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



- (void)startAdvertising:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult;
    
    if (_peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey: [command.arguments objectAtIndex:0], CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]]};
        
        [_peripheralManager startAdvertising:advertisingData];
        
        pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



- (void)stopAdvertising:(CDVInvokedUrlCommand *)command {
    [_peripheralManager stopAdvertising];
}



- (void)removeAllServices:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult;
    
    pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
    
    [_peripheralManager removeAllServices];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    // Execute publish event on 'didAddService' in JS
    NSString *js = [NSString stringWithFormat:@"BLEPeripheralManager.publish('didAddService');"];
    [self.commandDelegate evalJs:js];
    
    NSLog(@"did add service: %@", service.characteristics);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"peripheral manager did start advertising: %@", peripheral);
    NSString *js = [NSString stringWithFormat:@"BLEPeripheralManager.publish('didStartAdvertising');"];
    [self.commandDelegate evalJs:js];
}

@end