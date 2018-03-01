//
//  PwdView.m
//  PasswordTF
//
//  Created by zhaoke on 2018/2/28.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "PwdView.h"

@interface PwdView()

@property (strong, nonatomic) NSMutableString *textStore; //保存密码的字符串

@end

@implementation PwdView
static NSString * const MONEYNUMBERS = @"0123456789";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        self.textStore = [NSMutableString string];
        self.squareWidth = 45;
        self.passwordLength = 6;
        self.pointRadius = 6;
        self.borderColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        self.pointColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
        [self becomeFirstResponder];
    }
    return self;
}
- (void)setSquareWidth:(CGFloat)squareWidth {
    _squareWidth = squareWidth;
    [self setNeedsDisplay];
}
- (void)setPasswordLength:(NSUInteger)passwordLength {
    _passwordLength = passwordLength;
    [self setNeedsDisplay];
}
// 键盘类型
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}
- (BOOL)becomeFirstResponder {
    if([self.myDelegate respondsToSelector:@selector(passwordInputBegin:)]){
        [self.myDelegate passwordInputBegin:self];
    }
    return [super becomeFirstResponder];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canBecomeFocused {
    return YES;
}
- (BOOL)canResignFirstResponder {
    return YES;
}
#pragma mark  --  UIKeyInput
// 显示的文本对象是否有任何文本
- (BOOL)hasText {
    return self.textStore.length > 0;
}
// 插入文本
- (void)insertText:(NSString *)text {
    if(self.textStore.length < self.passwordLength){
        // 判断是否是数字
        NSCharacterSet *character = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString *filter = [[text componentsSeparatedByCharactersInSet:character] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filter];
        if(basicTest){
            [self.textStore appendString:text];
            if([self.myDelegate respondsToSelector:@selector(passwordInputDidChange:password:)]){
                [self.myDelegate passwordInputDidChange:self password:self.textStore];
            }
            if(self.textStore.length == self.passwordLength){
                if([self.myDelegate respondsToSelector:@selector(passwordInputComplete:password:)]){
                    [self.myDelegate passwordInputComplete:self password:self.textStore];
                }
            }
            [self setNeedsDisplay];
        }
    }
}
// 删除文本
- (void)deleteBackward {
    if(self.textStore.length > 0){
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length-1, 1)];
        if([self.myDelegate respondsToSelector:@selector(passwordInputDidChange:password:)]){
            [self.myDelegate passwordInputDidChange:self password:self.textStore];
        }
    }
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat x = (width-self.squareWidth*self.passwordLength)/2.0;
    CGFloat y = (height - self.squareWidth)/2.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画外框
    CGContextAddRect(context, CGRectMake( x, y, self.squareWidth*self.passwordLength, self.squareWidth));
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //画竖条
    for (int i = 1; i <= self.passwordLength; i++) {
        CGContextMoveToPoint(context, x+i*self.squareWidth, y);
        CGContextAddLineToPoint(context, x+i*self.squareWidth, y+self.squareWidth);
        CGContextClosePath(context);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    //画黑点
    for (int i = 1; i <= self.textStore.length; i++) {
        CGContextAddArc(context,  x+i*self.squareWidth - self.squareWidth/2.0, y+self.squareWidth/2, self.pointRadius, 0, M_PI*2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(![self isFirstResponder]){
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}


@end
