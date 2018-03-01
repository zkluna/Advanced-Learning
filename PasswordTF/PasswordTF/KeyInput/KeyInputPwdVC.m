//
//  KeyInputPwdVC.m
//  PasswordTF
//
//  Created by zhaoke on 2018/2/28.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "KeyInputPwdVC.h"
#import "PwdView.h"
#import "Mediator.h"
@interface KeyInputPwdVC ()<PwdViewDelegate>
@property (weak, nonatomic) IBOutlet PwdView *pwdView;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@end

@implementation KeyInputPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"KeyInput";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStylePlain target:self action:@selector(showAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)showAction:(id)sender {
    UIViewController *vc = [Mediator showInputPwdVC:@"呼呼哈嘿"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)passwordInputBegin:(PwdView *)pwdView{
    
}
- (void)passwordInputDidChange:(PwdView *)pwdView password:(NSString *)password {
    self.infoLab.text = [NSString stringWithFormat:@"输入的密码是:%@",password];
}
- (void)passwordInputComplete:(PwdView *)pwdView password:(NSString *)password {
    self.infoLab.text = [NSString stringWithFormat:@"输入的密码是:%@",password];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
