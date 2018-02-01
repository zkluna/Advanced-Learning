//
//  ShareViewController.m
//  whirlingShare
//
//  Created by apple on 2017/3/13.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vHeight;

@property (nonatomic, copy) NSMutableArray *titles;
@property (nonatomic, strong) NSUserDefaults *sharedUserDefault;
@property (nonatomic, strong) NSExtensionItem *inputItem;

@end

@implementation ShareViewController

static NSString *const AppGroupId = @"group.Whirling";
- (NSMutableArray *)titles{
    if(_titles){
        _titles = [NSMutableArray arrayWithCapacity:0];
    }
    return _titles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Whirling World";
    NSArray *arr = @[@"数据会说谎的真实例子",@"西部大开发啦",@"北上广深，还好吗",@"苹果禁止热更新了",@"如何用python做爬虫"];
    self.titles = [arr mutableCopy];
    for (UIView *subview in self.view.subviews) {
        if(subview != self.bgView){
            [subview removeFromSuperview];
        }
    }
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView reloadData];
    UIView *footer = [[UIView alloc] init];
    _tableView.tableFooterView = footer;
    
}
- (IBAction)cancelAction:(UIButton *)sender {
    [self cancel];
}
- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    NSExtensionItem *imageItem = [self.extensionContext.inputItems firstObject];
    if(!imageItem){
        return NO;
    }
    NSItemProvider *imageItemProvider = [[imageItem attachments] firstObject];
    if(!imageItemProvider){
        return NO;
    }
    if([imageItemProvider hasItemConformingToTypeIdentifier:@"public.url"] && self.contentText){
        return YES;
    }
    return YES;
}
- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}
- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    SLComposeSheetConfigurationItem *item1 = [[SLComposeSheetConfigurationItem alloc] init];
    item1.title = _titles[0];
    item1.tapHandler = ^(){
        NSLog(@"click");
    };
    
    return @[item1];
}
#pragma mark --z tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row%3]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.vHeight.constant < 330){
        self.vHeight.constant += 100;
    }
}
@end
