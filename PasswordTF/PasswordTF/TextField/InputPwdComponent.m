//
//  InputPwdComponent.m
//  PasswordTF
//
//  Created by zhaoke on 2018/2/27.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "InputPwdComponent.h"
#import "ShowInputPwdVC.h"

@implementation InputPwdComponent

- (UIViewController *)showInputPwdVCWithStr:(NSString *)testStr {
    ShowInputPwdVC *vc = [[ShowInputPwdVC alloc] init];
    vc.strTest = testStr;
    return vc;
}

@end
