//
//  Store.h
//  PhotoData
//
//  Created by zhaoke on 2017/7/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

@property (readonly, nonatomic, strong) NSArray *photos;
@property (readonly, nonatomic, strong) NSArray *users;

+ (instancetype)shareStore;
- (NSArray *)sortedPhotos;

@end
