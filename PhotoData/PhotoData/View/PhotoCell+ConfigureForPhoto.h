//
//  PhotoCell+ConfigureForPhoto.h
//  PhotoData
//
//  Created by zhaoke on 2017/7/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "PhotoCell.h"

@class Photo;

@interface PhotoCell (ConfigureForPhoto)

- (void)configureForPhoto:(Photo *)photo;

@end
