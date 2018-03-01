//
//  PwdView.h
//  PasswordTF
//
//  Created by zhaoke on 2018/2/28.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PwdView;

@protocol PwdViewDelegate<NSObject>
@optional
/** 监听输入开始 */
- (void)passwordInputBegin:(PwdView *)pwdView;
/** 监听输入的改变 */
- (void)passwordInputDidChange:(PwdView *)pwdView password:(NSString *)password;
/** 监听输入完成 */
- (void)passwordInputComplete:(PwdView *)pwdView password:(NSString *)password;

@end

IB_DESIGNABLE

@interface PwdView : UIView<UIKeyInput>

@property (assign, nonatomic) IBInspectable NSUInteger passwordLength; //密码长度
@property (assign, nonatomic) IBInspectable CGFloat squareWidth; //正方形大小
@property (assign, nonatomic) IBInspectable CGFloat pointRadius; // 黑点半径
@property (strong, nonatomic) IBInspectable UIColor *pointColor; // 黑点颜色
@property (strong, nonatomic) IBInspectable UIColor *borderColor; // 边框颜色
@property (weak, nonatomic) IBOutlet id<PwdViewDelegate> myDelegate;

@end
