//
//  DetailVC.m
//  iBeaconDemo
//
//  Created by zhaoke on 2017/7/5.
//  Copyright © 2017年 zk. All rights reserved.
//

#import "DetailVC.h"

@interface DetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (weak, nonatomic) IBOutlet UILabel *major;
@property (weak, nonatomic) IBOutlet UILabel *minor;
@property (weak, nonatomic) IBOutlet UILabel *proximity;
@property (weak, nonatomic) IBOutlet UILabel *rssi;
@property (weak, nonatomic) IBOutlet UILabel *accury;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.uuid.text = [NSString stringWithFormat:@"prosimityUUID: %@",_beacon.proximityUUID.UUIDString];
    self.major.text = [NSString stringWithFormat:@"major: %@",[_beacon.major stringValue]];
    self.minor.text = [NSString stringWithFormat:@"minor: %@",[_beacon.minor stringValue]];
    self.proximity.text = [NSString stringWithFormat:@"proximity: %ld",(long)_beacon.proximity];
    self.rssi.text = [NSString stringWithFormat:@"rssi: %ld",(long)_beacon.rssi];
    self.accury.text = [NSString stringWithFormat:@"accury: %0.4f",_beacon.accuracy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
