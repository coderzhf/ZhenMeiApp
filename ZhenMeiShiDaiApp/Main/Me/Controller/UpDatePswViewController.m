
//
//  UpDatePswViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "UpDatePswViewController.h"
#import "LoginViewController.h"

@interface UpDatePswViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *oldPswTextField;
    UITextField *newPswTextField;
    UIButton *comFirmBtn;
}
@end

@implementation UpDatePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"修改密码"];
    [self.view addSubview:customNav];
    
    UIImageView *oldPswBg = [UQFactory imageViewWithFrame:CGRectMake(20, KnavHeight +20, KScreenWidth-20*2, 40) image:[UIImage imageNamed:@"zm_textField_Bg"]];
    [self.view addSubview:oldPswBg];
    
    oldPswTextField = [UQFactory textFieldWithFrame:CGRectMake(0, 0, KScreenWidth-20*2, 40)  placeholder:@"输入旧密码" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self returnKeyType:4 keyboardType:0 fontName:nil fontSize:16 secure:YES];
    oldPswTextField.textAlignment = NSTextAlignmentCenter;
    [oldPswBg addSubview:oldPswTextField];
    
    UIImageView *newPswBg = [UQFactory imageViewWithFrame:CGRectMake(20, oldPswBg.bottom +20, KScreenWidth-20*2, 40) image:[UIImage imageNamed:@"zm_textField_Bg"]];
    [self.view addSubview:newPswBg];
    
    newPswTextField = [UQFactory textFieldWithFrame:CGRectMake(0, 0, KScreenWidth-20*2, 40)  placeholder:@"输入新密码" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self returnKeyType:4 keyboardType:0 fontName:nil fontSize:16 secure:YES];
    newPswTextField.textAlignment = NSTextAlignmentCenter;
    [newPswBg addSubview:newPswTextField];
    
    comFirmBtn = [UQFactory buttonWithFrame:CGRectMake(20, newPswBg.bottom+20, KScreenWidth- 2*20,40) title:@"确定" titleColor:[UIColor whiteColor] fontName:nil fontSize:16];
    [comFirmBtn setBackgroundImage:[UIImage imageNamed:@"zm_getCode_Btn"] forState:UIControlStateNormal];
    [comFirmBtn addTarget:self action:@selector(comFirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comFirmBtn];
    
}

- (void)comFirmAction
{
    [newPswTextField resignFirstResponder];
    [oldPswTextField resignFirstResponder];
    
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    if (![self checkInputIsValid]) {
        return;
    }
    [Notifier showHud:self.view text:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:@"userId"],@"userId",newPswTextField.text,@"pwd", nil];
    [Utils post:KUpdatePsw params:dic success:^(id json) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:@"密码修改不成功" timeInterval:NyToastDuration];
            return ;
        }
        UIAlertView *actionSheet = [[UIAlertView alloc] initWithTitle:@"密码修改成功，请重新登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet show];
  
    } failure:^(NSError *eror) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view text:@"密码修改不成功" timeInterval:NyToastDuration];

    }];
}

- (void)jumpToLoginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (BOOL)checkInputIsValid
{
    NSString *checkCode = oldPswTextField.text;
    NSString *password = newPswTextField.text;

    if (checkCode.length == 0) {
        [Notifier UQToast:self.view text:@"旧密码为空，请输入旧密码" timeInterval:NyToastDuration];
        return NO;
    }
    if (![checkCode isEqualToString:[UserDefaults objectForKey:@"password"]]) {
        [Notifier UQToast:self.view text:@"旧密码输入有误" timeInterval:NyToastDuration];
        return NO;
    }
    if (password.length == 0) {
        [Notifier UQToast:self.view text:@"新密码为空，请输入新密码" timeInterval:NyToastDuration];
        return NO;
    }
    return YES;
    
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == oldPswTextField) {
        [newPswTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self jumpToLoginVC];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
