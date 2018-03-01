//
//  ShowInputPwdVC.m
//  PasswordTF
//
//  Created by zhaoke on 2018/2/27.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "ShowInputPwdVC.h"
#import "PwdTF.h"
#import "Mediator.h"

@interface ShowInputPwdVC ()

@property (weak, nonatomic) IBOutlet PwdTF *pwdTF;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;

@end

@implementation ShowInputPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"TextField";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:nil];
    self.promptLab.text = @"请输入密码";
    self.pwdTF.pwdInputComplete = ^(NSString *pwd) {
        self.promptLab.text = [NSString stringWithFormat:@"输入的密码是:%@",pwd];
    };
    self.pwdTF.pwdInputChange = ^(NSString *currentPwd) {
        self.promptLab.text = [NSString stringWithFormat:@"输入的密码是:%@",currentPwd];
    };
    if(self.strTest){
        NSLog(@"_____%@",_strTest);
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStylePlain target:self action:@selector(showAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)showAction:(id)sender {
    UIViewController *vc = [Mediator showKeyInputPwdVC];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.pwdTF resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.pwdTF becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.pwdTF resignFirstResponder];
}

@end
