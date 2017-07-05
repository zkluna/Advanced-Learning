//
//  IBeaconsHelper.m
//  YoMoney
//
//  Created by ilovesunnie on 1/23/15.
//  Copyright (c) 2015 Accentrix. All rights reserved.
//

#import "IBeaconsHelper.h"
#import "PromptTextCollection.h"

@implementation IBeaconsHelper

static IBeaconsHelper *sharedSingleton;

static CLLocationManager *locationManager;
static CLBeaconRegion *myBeaconRegion;
static CBCentralManager *boothManager;


+ (IBeaconsHelper *)sharedSingleton{
    @synchronized(self){
        if (!sharedSingleton) {
            sharedSingleton = [[IBeaconsHelper alloc]init];
        }
        return sharedSingleton;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
        // Initialize location manager and set ourselves as the delegate
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        // Create a NSUUID with the same UUID as the broadcasting beacon
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"D942281C-59D7-5439-AC40-F2562CA48C9A"];
        
        // Setup a new region with that UUID and same identifier as the broadcasting beacon
        myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                 identifier:@"accentrix.Beacon"];
        
        myBeaconRegion.notifyEntryStateOnDisplay=YES;
        myBeaconRegion.notifyOnEntry=YES;
        
        // Tell location manager to start monitoring for the beacon region
        //    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
        if (isIOS8) {
            [locationManager requestAlwaysAuthorization];
        }
        
        
        boothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

//        NSLog(@"%d   %d %d   %d    %d",[CLLocationManager regionMonitoringEnabled],[CLLocationManager isRangingAvailable],[CLLocationManager regionMonitoringAvailable],[CLLocationManager significantLocationChangeMonitoringAvailable],[CLLocationManager headingAvailable]);
//        
        
        
    }
    return self;
    
}

+ (BOOL)isBlueToothOpen {
    [IBeaconsHelper sharedSingleton];
    [boothManager scanForPeripheralsWithServices:nil options:nil];
    [boothManager stopScan];
    NSLog(@"boothManager.state=%d",boothManager.state);
    
//    if (boothManager.state == CBCentralManagerStateUnknown) {
//        [NSThread sleepForTimeInterval:3];
//        [IBeaconsHelper isBlueToothOpen];
//    }
    
    return !(boothManager.state==CBCentralManagerStatePoweredOff);
}


+ (void)check {
    [IBeaconsHelper sharedSingleton];
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        [Global AlertView:@"请开启GPS定位服务" Message:@"请到设置-私隐-打开定位开关" ButtonName:@"知道了"];
    }
    else if(boothManager.state==CBCentralManagerStatePoweredOff)
    {
        [Global AlertView:@"蓝牙未开启" Message:@"请到设置-蓝牙-打开蓝牙开关" ButtonName:@"知道了"];
    }
}

+(void)start
{
    [IBeaconsHelper sharedSingleton];
//    if (iPhone4 && !iPhone4s) {
//        [Global AlertView:@"" Message:blueToothNotSupport ButtonName:@"确定"];
//        return;
//    }
    if ([CLLocationManager locationServicesEnabled] == NO) {
        [Global AlertView:@"定位服务未开启" Message:@"请到设置-私隐-打开定位开关" ButtonName:@"知道了"];
        return;
    }
    else if(boothManager.state==CBCentralManagerStatePoweredOff)
    {
        [Global AlertView:@"蓝牙未开启" Message:@"请到设置-蓝牙-打开蓝牙开关" ButtonName:@"知道了"];
        return;
    }
    
    if ([[[IBeaconsHelper sharedSingleton] delegate] respondsToSelector:@selector(iBeaconWillDetect)]) {
        [[[IBeaconsHelper sharedSingleton] delegate] iBeaconWillDetect];
    }
    [locationManager startRangingBeaconsInRegion:myBeaconRegion];
    
}

+(void)stop
{
    [locationManager stopRangingBeaconsInRegion:myBeaconRegion];
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    NSLog(@"didEnterRegion");
    
    [locationManager startRangingBeaconsInRegion:myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    NSLog(@"didExitRegion");
    
    [locationManager stopRangingBeaconsInRegion:myBeaconRegion];
    
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    //    NSLog(@"major=%d  rssi=%d  accuracy=%f",region.major,region.rssi,region.accuracy);
    
    NSLog(@"state=%ld",state);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"didStartMonitoringForRegion region=%@",region.identifier);
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error=%@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"didUpdateHeading");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateHeading");
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion");
    
}




-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    
//    NSLog(@"beacons=%@",beacons);
    
//    CLBeacon *foundBeacon = [beacons firstObject];
    
    [_delegate IBeaconsHelperDetectIbeaconsArray:beacons];
    
//    [IBeaconsHelper stop];
    
    //    NSLog(@"major=%d  minor=%d  accuracy=%f",foundBeacon.major,foundBeacon.minor,foundBeacon.accuracy);
    
    
    //    NSLog(@"major = %@  minor = %@    proximity=%d",foundBeacon.major,foundBeacon.minor,foundBeacon.proximity);
    
    
    // You can retrieve the beacon data from its properties
    //NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    //NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    //NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *message;
    switch (central.state) {
            
        case 0:
            message = @"初始化中，请稍后……";
            break;
        case 1:
            message = @"设备不支持状态，过会请重试……";
            break;
        case 2:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 3:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 4:
            message = @"尚未打开蓝牙，请在设置中打开……";
            break;
        case 5:
            message = @"蓝牙已经成功开启，稍后……";
            break;
        default:
            break;
    }
    
    NSLog(@"mes=%@",message);
}

@end
