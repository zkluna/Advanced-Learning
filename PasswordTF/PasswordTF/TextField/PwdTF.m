//
//  PwdTF.m
//  PasswordTF
//
//  Created by zhaoke on 2018/2/27.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "PwdTF.h"

@interface PwdTF()<UITextFieldDelegate>

@end

static NSInteger const count = 6;

@implementation PwdTF
- (void)awakeFromNib {
    [super awakeFromNib];
    self.delegate = self;
    self.tintColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:36];
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.secureTextEntry = YES;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGFloat fontWidth = self.font.pointSize;
    CGFloat padding = (CGRectGetWidth(self.bounds)/count - fontWidth);
    CGRect rect = CGRectMake(bounds.origin.x+padding, bounds.origin.y, bounds.size.width+padding, bounds.size.height);
    return rect;
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctf, 0.5);
    CGContextSetStrokeColorWithColor(ctf, [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0].CGColor);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0.5, 0.5) cornerRadius:10];
    CGContextAddPath(ctf, bezierPath.CGPath);
    [bezierPath stroke];

    CGFloat elementWidth = CGRectGetWidth(rect)/count;
    CGFloat lineWidth = 1;
    CGFloat lineHeight = CGRectGetHeight(rect);
//    CGContextSetLineCap(ctf, kCGLineCapRound);
    CGContextSetLineWidth(ctf, lineWidth);
//    CGContextSetAllowsAntialiasing(ctf, true);
    CGContextSetRGBStrokeColor(ctf, 153.0/255.0, 153.0/255.0, 153.0/255.0, 1.0);
    CGContextBeginPath(ctf);
    for(int i=0; i < count-1; i++){
        CGContextMoveToPoint(ctf, (i+1)*elementWidth-lineWidth/2, 0);
        CGContextAddLineToPoint(ctf, (i+1)*elementWidth-lineWidth/2, lineHeight);
    }
    CGContextStrokePath(ctf);
}

#pragma mark -- TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([text length] > count){
        return NO;
    }
    CGFloat fontWidth = self.font.pointSize;
    CGFloat padding = (CGRectGetWidth(self.bounds)/count-fontWidth);
    static NSDictionary *attrsDic = nil;
    if(!attrsDic){
        attrsDic = @{NSFontAttributeName:self.font, NSKernAttributeName:[NSNumber numberWithFloat:2*padding+0.5*2]};
    }
    [self setAttributedText:[[NSAttributedString alloc] initWithString:text attributes:attrsDic]];
    if([text length] == 6 && self.pwdInputComplete){
        self.pwdInputComplete(text);
    } else {
        if(self.pwdInputChange){
            self.pwdInputChange(text);
        }
    }
    return NO;
}

@end
