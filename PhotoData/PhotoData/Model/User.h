//
//  User.h
//  PhotoData
//
//  Created by zhaoke on 2017/7/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) int64_t identifier;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSArray *photos;

- (NSString *)fullName;
- (NSUInteger)numberOfPhotosTaken;

@end
