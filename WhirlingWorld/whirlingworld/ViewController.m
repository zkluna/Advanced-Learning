//
//  ViewController.m
//  whirlingworld
//
//  Created by apple on 2017/3/9.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "ViewController.h"
#import "SocketVC.h"
#import "HHLayer.h"
#import "TitleTableCell.h"
#import <StoreKit/StoreKit.h>
#import "JDStatusBarNotification.h"

@interface ViewController ()<CALayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self shareData];
//    [self drawBackground:CGSizeMake(_kScreenWidth, _kScreenWidth)];
//    [self layerTestMethod];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [_dataArr addObjectsFromArray:@[@"change to icon2",@"change to default icon",@"show SKStoreReviewController",@"go to setting.app"]];
    [self.tableView reloadData];
    self.tableView.tableFooterView = [UIView new];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleTableCell"];
    cell.title.text = _dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        [[UIApplication sharedApplication] setAlternateIconName:@"AppIcon2" completionHandler:^(NSError * _Nullable error) {
            if(!error){
                [JDStatusBarNotification showWithStatus:@"has change app icon to AppIcon2" dismissAfter:1.5];
            } else {
                NSLog(@"--z %@",error);
            }
        }];
    }else if(indexPath.row == 1){
        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
            if(!error){
                [JDStatusBarNotification showWithStatus:@"has change app icon to default" dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
            } else {
                NSLog(@"--z %@",error);
            }
        }];
    }else if(indexPath.row == 2){
        if([UIDevice currentDevice].systemVersion.floatValue >= 10.3){
            [SKStoreReviewController requestReview];
        }
    }else if(indexPath.row == 3){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
#pragma mark  --z Layer 
- (void)layerTestMethod {
    /*
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (__bridge id)[UIImage imageNamed:@"Stream-"].CGImage;
    UIImage *img = [UIImage imageNamed:@"Steam-"];
    _tView.layer.contents = (__bridge id)img.CGImage;
//    _tView.contentMode = UIViewContentModeScaleAspectFit;
    _tView.layer.contentsGravity = kCAGravityCenter;
    _tView.layer.contentsScale = [UIScreen mainScreen].scale;
     */
    /*
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 0, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [_tView.layer addSublayer:blueLayer];
    [blueLayer display];
    */
    /*
    HHLayer *layer = [HHLayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(100, 60);
    [layer setNeedsDisplay];
    [self.tView.layer addSublayer:layer];
    
    _imgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _imgView.layer.shadowOffset = CGSizeMake(10, 10);
    _imgView.layer.shadowOpacity = 0.5;
    
    _imgView.layer.cornerRadius = 15;
    _imgView.layer.masksToBounds = YES;
    
    _imgView.layer.borderWidth = 5;
    _imgView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    _imgView.layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    [_imgView.layer addSublayer:shadowLayer];
    */
}
#pragma mark  --z Layer Delegate 
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    // draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}
#pragma mark  --z Today Extension
- (void)shareData {
    NSArray *titles = @[@"数据会说谎的真实例子",@"西部大开发啦",@"北上广深，还好吗",@"苹果禁止热更新了",@"如何用python做爬虫"];
    NSUserDefaults *shareData = [[NSUserDefaults alloc] initWithSuiteName:@"group.Whirling"];//group.Whirling
    [shareData setObject:titles forKey:@"Whirling"];
    [shareData synchronize];
}
#pragma mark  --z 棋盘
- (void)drawBackground:(CGSize)size {
    
    CGFloat gridW = (size.width-2*20)/16;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0.8f);
    for(int i=0;i<=16;i++){
        CGContextMoveToPoint(ctx, 20+i*gridW, 20);
        CGContextAddLineToPoint(ctx, 20+i*gridW, 20+gridW*16);
    }
    for(int i=0;i<=16;i++){
        CGContextMoveToPoint(ctx, 20, 20+i*gridW);
        CGContextAddLineToPoint(ctx, 20+gridW*16, 20+i*gridW);
    }
    CGContextStrokePath(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0,0, _kScreenWidth, _kScreenWidth);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, (_kScreenHeight-_kScreenWidth)/2-20, _kScreenWidth, _kScreenWidth)];
    bgView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:bgView];
    [bgView addSubview:imageView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
