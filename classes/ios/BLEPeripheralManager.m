//
//  BLEPeripheralManager.m
//  BLEPeripheralManager
//
//  Created by Nick Stevens on 3/6/14.
//
//

#import "BLEPeripheralManager.h"

@implementation BLEPeripheralManager
// I'm not sure, but I think you probably want to implement a Singleton class here  
// http://www.johnwordsworth.com/2010/04/iphone-code-snippet-the-singleton-pattern/

-(void)initPeripheralManager:(CDVInvokedUrlCommand *)command {
//instead of == nil, do if(!_peripheralManager || _peripheral... ! = ...)
    if(_peripheralManager == nil || _peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        // use the automatically generated getters and setters instead of the instance variable
        // eg self.peripheralManager = ..
        // However, I image with the singleton model, you wont need this line of code anyways 
        // See for singleton model http://www.johnwordsworth.com/2010/04/iphone-code-snippet-the-singleton-pattern/
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }

// This multiline style of method calls isn't recommended, read this https://github.com/raywenderlich/objective-c-style-guide 
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

    // Nice use of enumeration 
    for (NSArray *characteristicIndex in [command.arguments objectAtIndex:2]) {
        NSString *value = [characteristicIndex objectAtIndex:1];
        NSData *dataValue = [value dataUsingEncoding:NSUTF8StringEncoding];

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
    NSString *js = [NSString stringWithFormat:@"BLEPeripheralManager.publish('didAddService', %i)", peripheral.state];
    [self.commandDelegate evalJs:js];

    NSLog(@"did add service: %@", service.characteristics);
}



-(void)startAdvertising:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult;
    NSDictionary *jsonObj;

// This block is confusing with the dictionary decleration in the same line as the method call
// Put dictionary decleration on seperate line.
    if (_peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        [_peripheralManager startAdvertising:@{ CBAdvertisementDataLocalNameKey : [command.arguments objectAtIndex:0], CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]] }];

        if (_peripheralManager.isAdvertising) {
            jsonObj = [ [NSDictionary alloc]
                       initWithObjectsAndKeys :
                       @"true", @"success",
                       nil
                       ];

// Kill multiline method calls with fire!
            pluginResult = [ CDVPluginResult
                            resultWithStatus    : CDVCommandStatus_OK
                            messageAsDictionary : jsonObj
                            ];
        }
    } else {
// use dictionary literal here eg @{"false... 
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

// add pragma here
#pragma mark - Private

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"peripheral manager did start advertising: %@", peripheral);
}

-(void)removeAllServices:(CDVInvokedUrlCommand *)command {
    [_peripheralManager removeAllServices];
}

@end
