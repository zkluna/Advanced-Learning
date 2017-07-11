//
//  ViewController.m
//  iBeaconDemo
//
//  Created by zhaoke on 2017/6/4.
//  Copyright © 2017年 zk. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AIBBeaconRegionAny.h"
#import "DetailVC.h"

/**
 *  这个UUID需要和你要查找的iBeacon的UUID一样，要不然查不到的😭😭😭
 *  设置好奇怪啊，应该有办法匹配应该有办法匹配所有的iBeacon,还要在研究下😓😓😓
 */
#define BEACONUUID @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, CBCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *ibeaconArr;
@property (nonatomic, strong) NSMutableDictionary *rangedRegions;
@property (nonatomic, strong) CBCentralManager *bluetoothManager;
@property (nonatomic, strong) AIBBeaconRegionAny *ibeacon1;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isInsideRegion;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.ibeaconArr = [NSMutableArray array];
    self.rangedRegions = [NSMutableDictionary dictionary];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // 初始化
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.ibeacon1 = [[AIBBeaconRegionAny alloc] initWithIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
    
    self.ibeacon1.notifyEntryStateOnDisplay = YES;
    self.ibeacon1.notifyOnExit = YES;
//    [self.locationManager requestStateForRegion:_ibeacon1];
    
}
- (BOOL)checkBluetooth {
    if(self.bluetoothManager.state == CBManagerStatePoweredOff){
        // 提示打开蓝牙
        [self showAlertWithMessage:@"请打开蓝牙来连接iBeacon" action:^{
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"prefs:root=General&path=Bluetooth"] options:@{} completionHandler:nil];
        }];
        return NO;
    } else {
        return YES;
    }
}
// 一般定位功能都应该是打开的
- (BOOL)checkLocation {
    if([CLLocationManager locationServicesEnabled] == NO){
        // 提示打开定位功能
        [self showAlertWithMessage:@"请打开定位功能来连接iBeacon" action:^{
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"] options:@{} completionHandler:nil];
            
        }];
        return NO;
    } else {
        return YES;
    }
}
- (void)start {
    // 获取权限
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestAlwaysAuthorization];
    }
    // 判断设备是否支持iBeacon
    if(![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]){
        // 设备不支持iBeacon发现
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"你的设备暂时不支持iBaecon发现" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if(![self checkLocation]){
        return;
    }
    if(![self checkBluetooth]){
        return;
    }
    [self startWithOutCheck];
}
- (void)startWithOutCheck {
    // 开始扫描
    [self.locationManager startMonitoringForRegion:_ibeacon1];
    [self.locationManager startRangingBeaconsInRegion:_ibeacon1];
}
- (IBAction)otherAction:(UIBarButtonItem *)sender {
    NSLog(@"----- click start Monitor");
    [self start];
}
#pragma mark --
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startMonitoringForRegion:self.ibeacon1];
        [self.locationManager startRangingBeaconsInRegion:self.ibeacon1];
    }
}
// 发现有iBeacon进入监测范围
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if(self.isInsideRegion){ return; }
    // 开始搜索iBeacon
    if([region isKindOfClass:[CLBeaconRegion class]]){
        if([CLLocationManager isRangingAvailable]){
            [self.locationManager startRangingBeaconsInRegion:self.ibeacon1];
//            [_ibeaconArr addObject:(CLBeaconRegion *)region];
        }
    }
}
// 有iBeacon超出范围
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if(!self.isInsideRegion) return;
    if([region isKindOfClass:[CLBeaconRegion class]]){
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:_ibeacon1];
    }
}
// 找到iBeacon后扫描它的信息
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
//    for (CLBeacon *beacon in beacons) {
//        NSLog(@"----------------");
//        NSLog(@"accuracy : %0.4f",beacon.accuracy);
//        NSLog(@"rssi is: %ld",(long)beacon.rssi);
//        NSLog(@"beacon.proximity %ld",(long)beacon.proximity);
//        NSLog(@"region id: %@, %@, %@",beacon.proximityUUID.UUIDString,beacon.major, beacon.minor);
//        NSLog(@"--------end---------");
//    }
    self.ibeaconArr = [NSMutableArray arrayWithArray:beacons];
    [self.tableView reloadData];
}
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if(state == CLRegionStateInside){
        _isInsideRegion = YES;
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
            [self startWithOutCheck];
            break;
        default:
            break;
    }
    NSLog(@"mes : %@",message);
}
#pragma mark -- table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ibeaconArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    CLBeacon *beacon = [self.ibeaconArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [beacon.proximityUUID UUIDString];
    NSString *str;
    switch (beacon.proximity) {
        case CLProximityNear:
            str = @"近";
            break;
        case CLProximityImmediate:
            str = @"超近";
            break;
        case CLProximityFar:
            str = @"远";
            break;
        case CLProximityUnknown:
            str = @"无效";
            break;
        default:
            break;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %ld %@ %@",str,beacon.rssi,beacon.major,beacon.minor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLBeacon *beacon = [self.ibeaconArr objectAtIndex:indexPath.row];
    DetailVC *vc = [[DetailVC alloc] initWithNibName:@"DetailVC" bundle:nil];
    vc.beacon = beacon;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)showAlertWithMessage:(NSString *)message action:(void(^)())setAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *set = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(setAction)setAction();
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:set];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
