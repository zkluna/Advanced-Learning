//
//  ArrayDataSource.h
//  PhotoData
//
//  Created by zhaoke on 2017/7/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
