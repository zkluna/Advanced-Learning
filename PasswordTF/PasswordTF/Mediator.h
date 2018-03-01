//
//  Mediator.h
//  PasswordTF
//
//  Created by zhaoke on 2018/2/27.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Mediator : NSObject

+ (UIViewController *)showInputPwdVC:(NSString *)testStr;
+ (UIViewController *)showKeyInputPwdVC;

@end
