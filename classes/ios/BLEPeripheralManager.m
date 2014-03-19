//
//  BLEPeripheralManager.m
//  BLEPeripheralManager
//
//  Created by Nick Stevens on 3/6/14.
//
//

#import "BLEPeripheralManager.h"

@implementation BLEPeripheralManager



-(void)initPeripheralManager:(CDVInvokedUrlCommand *)command {
    if(_peripheralManager == nil || _peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }

    NSDictionary *jsonObj = [ [NSDictionary alloc]
                             initWithObjectsAndKeys :
                             @"true", @"success",
                             nil
                             ];

    CDVPluginResult *pluginResult = [ CDVPluginResult
                                     resultWithStatus    : CDVCommandStatus_OK
                                     messageAsDictionary : jsonObj
                                     ];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    // Execute publish event on 'peripheralManagerDidUpdateState' in JS
    NSString* js = [NSString stringWithFormat:@"BLEPeripheralManager.publish('peripheralManagerDidUpdateState', %i)", peripheral.state];
    [self.commandDelegate evalJs:js];

    NSLog(@"state: %i", peripheral.state);
}



-(void)addService:(CDVInvokedUrlCommand *)command {
    NSMutableArray *characteristics = [[NSMutableArray alloc] init];

    for (NSArray *characteristicIndex in [command.arguments objectAtIndex:2]) {
        NSString *value = [characteristicIndex objectAtIndex:1];
        NSData* dataValue = [value dataUsingEncoding:NSUTF8StringEncoding];

        CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:[characteristicIndex objectAtIndex:0]] properties:CBCharacteristicPropertyRead value:dataValue permissions:CBAttributePermissionsReadable];

        [characteristics addObject:characteristic];
    }

    CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:[command.arguments objectAtIndex:0]] primary:[command.arguments objectAtIndex:1]];

    NSLog(@"characteristics: %@", characteristics);

    NSArray *immutableCharacteristics = [characteristics copy];

    service.characteristics = immutableCharacteristics;

    [_peripheralManager addService:service];
}



-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    // Execute publish event on 'didAddService' in JS
    NSString* js = [NSString stringWithFormat:@"BLEPeripheralManager.publish('didAddService', %i)", peripheral.state];
    [self.commandDelegate evalJs:js];

    NSLog(@"did add service: %@", service.characteristics);
}



-(void)startAdvertising:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult;
    NSDictionary *jsonObj;

    if (_peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        [_peripheralManager startAdvertising:@{ CBAdvertisementDataLocalNameKey : [command.arguments objectAtIndex:0], CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]] }];

        if (_peripheralManager.isAdvertising) {
            jsonObj = [ [NSDictionary alloc]
                       initWithObjectsAndKeys :
                       @"true", @"success",
                       nil
                       ];

            pluginResult = [ CDVPluginResult
                            resultWithStatus    : CDVCommandStatus_OK
                            messageAsDictionary : jsonObj
                            ];
        }
    } else {
        jsonObj = [ [NSDictionary alloc]
                   initWithObjectsAndKeys :
                   @"false", @"error",
                   nil
                   ];

        pluginResult = [ CDVPluginResult
                        resultWithStatus    : CDVCommandStatus_ERROR
                        messageAsDictionary : jsonObj
                        ];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



-(void)stopAdvertising:(CDVInvokedUrlCommand *)command {
    [_peripheralManager stopAdvertising];
}



-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"peripheral manager did start advertising: %@", peripheral);
}



-(void)removeService:(CDVInvokedUrlCommand *)command {

}



-(void)removeAllServices:(CDVInvokedUrlCommand *)command {
    [_peripheralManager removeAllServices];
}

@end
