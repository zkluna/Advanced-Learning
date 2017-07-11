//
//  BeaconHelper.m
//  LifeTouch
//
//  Created by Accentrix on 2017/7/4.
//  Copyright © 2017年 Accentrix. All rights reserved.
//

#import "BeaconHelper.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AIBBeaconRegionAny.h"
//#import "CustomAlertView.h"

#define iBeaconFindNotification @"iBeaconFindNotification"

@interface BeaconHelper()<CLLocationManagerDelegate,CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *bluetoothManager;
@property (nonatomic, strong) AIBBeaconRegionAny *beaconRegion;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation BeaconHelper

static NSString *beaconUUID = @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825";

+ (void)startMonitorBeacon {
    // 判断设备是否支持iBeacon
    if(![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]){
        // 设备不支持iBeacon发现
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"你的设备暂时不支持iBaecon发现" preferredStyle:UIAlertControllerStyleAlert];
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    // 获取权限
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [[BeaconHelper share].locationManager requestAlwaysAuthorization];
    }
    if(![BeaconHelper checkBlueTooth]){
        return;
    }
    if(![[BeaconHelper share] checkLocation]){
        return;
    }
    [BeaconHelper startMonitorBeaconWithoutCheck];
}
+ (void)startMonitorBeaconWithoutCheck {
    [[BeaconHelper share].locationManager startMonitoringVisits];
    [[BeaconHelper share].locationManager startRangingBeaconsInRegion:[BeaconHelper share].beaconRegion];
}
+ (void)stopMonitorBeacon {
    [[BeaconHelper share].locationManager stopMonitoringVisits];
    [[BeaconHelper share].locationManager stopMonitoringForRegion:[BeaconHelper share].beaconRegion];
}
+ (BeaconHelper *)share {
    static dispatch_once_t onceToken;
    static BeaconHelper *_shareBeaconHelper = nil;
    dispatch_once(&onceToken, ^{
        _shareBeaconHelper = [[BeaconHelper alloc] init];
    });
    return _shareBeaconHelper;
}
- (id)init {
    if([super init]){
        // 初始化
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        self.beaconRegion = [[AIBBeaconRegionAny alloc] initWithIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
        
        self.beaconRegion.notifyEntryStateOnDisplay = YES;
        self.beaconRegion.notifyOnExit = YES;
    }
    return self;
}
#pragma mark --
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    }
}
// 发现有iBeacon进入监测范围
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    // 开始搜索iBeacon
    if([region isKindOfClass:[CLBeaconRegion class]]){
        if([CLLocationManager isRangingAvailable]){
            [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
        }
    }
}
// 有iBeacon超出范围
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if([region isKindOfClass:[CLBeaconRegion class]]){
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:_beaconRegion];
    }
}
// 找到iBeacon后扫描它的信息
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        NSLog(@"----------------");
        NSLog(@"accuracy : %0.4f",beacon.accuracy);
        NSLog(@"rssi is: %ld",(long)beacon.rssi);
        NSLog(@"beacon.proximity %ld",(long)beacon.proximity);
        NSLog(@"region id: %@, %@, %@",beacon.proximityUUID.UUIDString,beacon.major, beacon.minor);
        NSLog(@"--------end---------");
    }
    NSDictionary *infoDic = @{@"find_iBeacons":beacons};
    // 添加通知
    [NSNotificationCenter.defaultCenter postNotificationName:iBeaconFindNotification object:self userInfo:infoDic];
}
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if(state == CLRegionStateInside){
        NSLog(@"a iBaecon inside range");
    } else if(state == CLRegionStateOutside){
        NSLog(@"a Ibeacon outside range");
    } else {
        NSLog(@"a unkonwn iBaecon");
    }
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"did start monitor for region : %@",region.identifier);
}
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region:%@",error);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed:%@",error);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    NSLog(@"did update heading");
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"did update locations");
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
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
            // 打开蓝牙 后 继续 检测
            if([self checkLocation]){
                [BeaconHelper startMonitorBeaconWithoutCheck];
            }
            break;
        default:
            break;
    }
    NSLog(@"mes : %@",message);
}

#pragma mark -- check
- (BOOL)checkLocation {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    if([CLLocationManager locationServicesEnabled] == NO){
        // 提示打开定位功能
//        [CustomAlertView showAlertViewWithViewController:vc title:@"提示" message:@"请打定位功能来允许连接到配件" leftButtonTitle:@"设置" rightButtonTitle:@"知道了" leftButtonAction:^(TYAlertView *alertView) {
//            // 跳转到定位的设置页面
//            [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
//        } andRightButtonAction:nil];
        return NO;
    } else {
        return YES;
    }
}
+ (BOOL)checkBlueTooth {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    if([BeaconHelper share].bluetoothManager.state == CBManagerStatePoweredOff){
        // 提示打开定位
//        [CustomAlertView showAlertViewWithViewController:vc title:@"提示" message:@"请打蓝牙来允许连接到配件" leftButtonTitle:@"设置" rightButtonTitle:@"知道了" leftButtonAction:^(TYAlertView *alertView) {
//            // 跳转到定位的设置页面
//            [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"prefs:root=General&path=Bluetooth"]];
//        } andRightButtonAction:nil];
        return NO;
    } else {
        return YES;
    }
}

@end
