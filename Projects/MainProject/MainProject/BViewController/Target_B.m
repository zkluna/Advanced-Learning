//
//  Target_B.m
//  MainProject
//
//  Created by zhaoke on 2017/11/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "Target_B.h"
#import "BViewController.h"

@implementation Target_B

- (UIViewController *)Action_viewController:(NSDictionary *)params {
    NSString *contentText = params[@"contentText"];
    BViewController *vc = [[BViewController alloc] initWithContentText:contentText];
    return vc;
}

@end
