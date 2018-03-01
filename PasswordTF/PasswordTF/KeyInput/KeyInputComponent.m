//
//  KeyInputComponent.m
//  PasswordTF
//
//  Created by zhaoke on 2018/2/28.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "KeyInputComponent.h"
#import "KeyInputPwdVC.h"

@implementation KeyInputComponent

- (UIViewController *)showInputPwdVCWithStr:(NSString *)testStr {
    KeyInputPwdVC *vc = [[KeyInputPwdVC alloc] init];
    return vc;
}

@end
