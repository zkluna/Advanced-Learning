//
//  TodayViewController.m
//  Whirling
//
//  Created by apple on 2017/3/10.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSMutableArray *titleArr;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TECell"];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self getData];
}
- (NSMutableArray *)titleArr {
    if(!_titleArr){
        _titleArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleArr;
}
- (void)getData {
    NSUserDefaults *shareData = [[NSUserDefaults alloc] initWithSuiteName:@"group.Whirling"];
    NSArray *titles = [shareData objectForKey:@"Whirling"];
    if(titles != nil && titles.count != 0){
        self.titleArr = [titles mutableCopy];
    } else {
//        [NetWorking getWithURL:@"http://cloud.bmob.cn/f8bb56aa119e68ee/news_list_2_0" paramaters:@{@"limit":@20,@"skip":@0} success:^(id responseObject) {
//            NSLog(@"--z %@",responseObject);
//        } failure:^(NSError *error) {
//            NSLog(@"--z %@",error);
//        }];
        NSLog(@"no data from mainapp");
    }
    [_tableView reloadData];
}
#pragma mark --z tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TECell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TECell"];
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row % 3]];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor darkTextColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self jumpToMainAPP];
}
- (void)jumpToMainAPP {
    [self.extensionContext openURL:[NSURL URLWithString:@"WhirlingWorld://action=GoSomePage"] completionHandler:^(BOOL success) {
        NSLog(@"open url result: %d",success);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --z
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if(activeDisplayMode == NCWidgetDisplayModeCompact){
        self.preferredContentSize = CGSizeMake(0, 200);
    } else {
        self.preferredContentSize = CGSizeMake(0, 260);
    }
}

@end
