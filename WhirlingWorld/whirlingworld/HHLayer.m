//
//  HHLayer.m
//  whirlingworld
//
//  Created by apple on 2017/3/16.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "HHLayer.h"

@implementation HHLayer

- (void)drawInContext:(CGContextRef)ctx {
    //[super drawInContext:ctx];
//    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
//    CGContextMoveToPoint(ctx, 50, 0);
//    CGContextAddLineToPoint(ctx, 0, 100);
//    CGContextAddLineToPoint(ctx, 100, 100);
//    CGContextClosePath(ctx);
//    CGContextFillPath(ctx);
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    CGContextSetLineWidth(ctx, 10);
    CGContextAddRect(ctx, self.bounds);
    CGContextStrokePath(ctx);
}

@end
