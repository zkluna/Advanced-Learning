//
//  ViewController.m
//  MainProject
//
//  Created by zhaoke on 2018/3/15.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "ViewController.h"
#import <CTMediator/CTMediator.h>
#import <A_Category/CTMediator+A.h>
#import <B_Category/CTMediator+B.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *titleArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"MainProject";
    self.titleArr = @[@"Porject_A",@"Project_B",@"Local_PageC"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = nil;
    if(indexPath.row == 0){
        vc = [[CTMediator sharedInstance] A_aViewController];
    } else if(indexPath.row == 1){
        vc = [[CTMediator sharedInstance] B_viewControllerWithContentText:@"push B vc"];
    } else if(indexPath.row == 2){
        vc = [[CTMediator sharedInstance] performTarget:@"C" action:@"cViewController" params:nil shouldCacheTarget:NO];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
