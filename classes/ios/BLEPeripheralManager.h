//
//  BLEPeripheralManager.h
//  BLEPeripheralManager
//
//  Created by Nick Stevens on 3/6/14.
//
//

// Missing Unit Tests: at least one unit test for every public method
// Are all these methods accessed publicly? if not, they don't need to be in the header file. 

#import <Cordova/CDV.h>
#import <CoreBluetooth/CoreBluetooth.h>

// Every one of these methods need documentation comments
// See http://dadabeatnik.wordpress.com/2013/09/25/comment-docs-in-xcode-5/

@interface BLEPeripheralManager : CDVPlugin <CBPeripheralManagerDelegate>
// Is this property accessed outside of this class? If not, it needs to be a private instance variable
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

/**
 Summary of method here.
 Example usage:
 @code
 NSLog(@"Example code here.");
 @endcode
 @command 
        Description of param here
 */
-(void)initPeripheralManager:(CDVInvokedUrlCommand *)command;

-(void)startAdvertising:(CDVInvokedUrlCommand *)command;

-(void)stopAdvertising:(CDVInvokedUrlCommand *)command;

-(void)addService:(CDVInvokedUrlCommand *)command;

-(void)removeAllServices:(CDVInvokedUrlCommand *)command;

@end
