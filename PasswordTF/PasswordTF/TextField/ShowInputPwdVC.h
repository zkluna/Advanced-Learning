//
//  ShowInputPwdVC.h
//  PasswordTF
//
//  Created by zhaoke on 2018/2/27.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowInputPwdDelegate<NSObject>
- (void)inputPasswordCompleteWithPwd:(NSString *)pwd;
@end

@interface ShowInputPwdVC : UIViewController

@property (weak, nonatomic) id<ShowInputPwdDelegate> delegate;
@property (copy, nonatomic)NSString *strTest;

@end
