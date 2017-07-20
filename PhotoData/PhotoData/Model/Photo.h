//
//  Photo.h
//  PhotoData
//
//  Created by zhaoke on 2017/7/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Photo : NSObject <NSCoding>

@property (nonatomic) int64_t identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic) double rating;

@property (nonatomic, weak) User *user;

- (NSString *)authorFullName;
- (double)adjustedRating;

@end
