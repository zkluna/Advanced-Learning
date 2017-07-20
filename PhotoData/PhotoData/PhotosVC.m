//
//  PhotosVC.m
//  PhotoData
//
//  Created by zhaoke on 2017/7/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "PhotosVC.h"
#import "Photo.h"
#import "PhotoCell.h"
#import "ArrayDataSource.h"
#import "PhotoCell+ConfigureForPhoto.h"
#import "Store.h"
#import "AppDelegate.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface PhotosVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ArrayDataSource *photosArrDataSource;

@end

@implementation PhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"photos";
    [self setupTableView];
}
- (void)setupTableView {
    TableViewCellConfigureBlock configureCell = ^(PhotoCell *cell, Photo *photo) {
        [cell configureForPhoto:photo];
    };
    NSArray *photos = [Store shareStore].sortedPhotos;
    self.photosArrDataSource = [[ArrayDataSource alloc] initWithItems:photos cellIdentifier:PhotoCellIdentifier configureCellBlock:configureCell];
    self.tableView.dataSource = self.photosArrDataSource;
    [self.tableView registerNib:[PhotoCell nib] forCellReuseIdentifier:PhotoCellIdentifier];
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Photo *photo = [self.photosArrDataSource itemAtIndexPath:indexPath];
    NSLog(@"%@ |  | %g",photo.name, photo.rating);
}


@end
