
//
//  FindPswViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "FindPswViewController.h"
#import "IdentifyViewController.h"
@interface FindPswViewController ()<UITextFieldDelegate>

@end

@implementation FindPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    self.view.backgroundColor = ZhenMeiRGB(200,200,200);
}

- (void)initViews
{
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"找回密码"];
    [self.view addSubview:customNav];
    
    UIImageView *Bg = [UQFactory imageViewWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, 200) image:nil];
    Bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:Bg];
    
    UIImageView *phoneNumberBg = [UQFactory imageViewWithFrame:CGRectMake(20, 20, KScreenWidth-20*2, 40) image:[UIImage imageNamed:@"zm_textField_Bg"]];
    phoneNumberBg.userInteractionEnabled = YES;
    [Bg addSubview:phoneNumberBg];
    
    self.phoneNumberTxtFiled = [UQFactory textFieldWithFrame:CGRectMake(0, 0, KScreenWidth-20*2, 40)  placeholder:@"输入手机号" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self returnKeyType:9 keyboardType:5 fontName:nil fontSize:16 secure:YES];
    self.phoneNumberTxtFiled.textAlignment = NSTextAlignmentCenter;
    [phoneNumberBg addSubview:self.phoneNumberTxtFiled];
    
     UIButton *findPswBtn = [UQFactory buttonWithFrame:CGRectMake(20, phoneNumberBg.bottom+20, KScreenWidth-2*20, 40) backgroundImage:[UIImage imageNamed:@"zm_getCode_Btn"] image:nil];
    [findPswBtn setTitle:@"立即找回" forState:UIControlStateNormal];
    [Bg addSubview:findPswBtn];
    [findPswBtn addTarget:self action:@selector(findPswAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)findPswAction
{
    [self.phoneNumberTxtFiled resignFirstResponder];
    if (self.phoneNumberTxtFiled.text.length == 0) {
        [Notifier UQToast:self.view text:@"手机号为空，请输入手机号" timeInterval:NyToastDuration];
        return;
    }
    if (self.phoneNumberTxtFiled.text.length != 11) {
        [Notifier UQToast:self.view text:@"手机号不符合规范，请重新输入" timeInterval:NyToastDuration];
        return;
    }
    [Utils post:KIdentifier params:[NSDictionary dictionaryWithObjectsAndKeys:_phoneNumberTxtFiled.text,@"loginName", nil] success:^(id json) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            return ;
        }
        [Utils post:KGetCode params:[NSDictionary dictionaryWithObjectsAndKeys:_phoneNumberTxtFiled.text,@"phone", nil] success:^(id obj) {
            if ([[json objectForKey:@"code"] intValue] ) {
                [Notifier UQToast:self.view text:@"验证码发送失败" timeInterval:NyToastDuration];
                return ;
            }
            IdentifyViewController *identifyVC = [[IdentifyViewController alloc] init];
            identifyVC.forgetPsw = YES;
            identifyVC.loginNameStr = self.phoneNumberTxtFiled.text;
            identifyVC.codeStr = [obj objectForKey:@"msg"];
            [self.navigationController pushViewController:identifyVC animated:NO];
            
        } failure:^(NSError *error) {
            [Notifier UQToast:self.view text:@"验证码发送失败" timeInterval:NyToastDuration];
        }];
        
    } failure:^(NSError *error) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view text:@"用户名不可用" timeInterval:NyToastDuration];
        
    }];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [textField resignFirstResponder];
     return YES;
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
