//
//  PhotoCell+ConfigureForPhoto.m
//  PhotoData
//
//  Created by zhaoke on 2017/7/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "PhotoCell+ConfigureForPhoto.h"
#import "Photo.h"

@implementation PhotoCell (ConfigureForPhoto)

- (void)configureForPhoto:(Photo *)photo {
    self.photoTitleLabel.text = photo.name;
    self.photoDateLabel.text = [[self dateFormatter] stringFromDate:photo.creationDate];
    
}
- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return dateFormatter;
}

@end
