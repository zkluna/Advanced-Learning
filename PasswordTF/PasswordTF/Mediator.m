//
//  Mediator.m
//  PasswordTF
//
//  Created by zhaoke on 2018/2/27.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "Mediator.h"
#import <objc/runtime.h>
//#import "InputPwdComponent.h"

@implementation Mediator

+ (UIViewController *)showInputPwdVC:(NSString *)testStr {
//    return [InputPwdComponent showInputPwdVCWithStr:testStr];
    // 使用runtime解耦
    Class cls = NSClassFromString(@"InputPwdComponent");
    id obj = [[cls alloc] init];
    return [obj performSelector:NSSelectorFromString(@"showInputPwdVCWithStr:") withObject:testStr];
}
+ (UIViewController *)showKeyInputPwdVC {
    Class cls = NSClassFromString(@"KeyInputComponent");
    id obj = [[cls alloc] init];
    return [obj performSelector:NSSelectorFromString(@"showInputPwdVCWithStr:") withObject:nil];
}

@end
