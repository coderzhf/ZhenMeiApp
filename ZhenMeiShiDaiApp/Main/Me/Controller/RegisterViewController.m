//
//  RegisterViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "RegisterViewController.h"
#import "IdentifyViewController.h"
#import "UserProtolViewController.h"

@interface RegisterViewController () 

@property (nonatomic,assign ) BOOL isSelected;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];    
}

- (void)initViews
{
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"注册"];
    [self.view addSubview:customNav];

    UIImageView *codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, KnavHeight + 40, KScreenWidth - 20*2, 35)];
    codeImageView.userInteractionEnabled = YES;
    codeImageView.image = [UIImage imageNamed:@"zm_textField_Bg"];
    [self.view addSubview:codeImageView];
    
    self.phoneNumberTxtFiled = [UQFactory textFieldWithFrame:codeImageView.bounds placeholder:@"请输入手机号" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self];
    self.phoneNumberTxtFiled.keyboardType = UIKeyboardTypePhonePad;
    self.phoneNumberTxtFiled.textAlignment = NSTextAlignmentCenter;
    [codeImageView addSubview:self.phoneNumberTxtFiled];
    
    UIButton *getIdentifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getIdentifyBtn.frame = CGRectMake(codeImageView.left, codeImageView.bottom + 10, KScreenWidth - 20*2, 35);
    [getIdentifyBtn setBackgroundImage:[UIImage imageNamed:@"zm_getCode_Btn"] forState:UIControlStateNormal];
    [getIdentifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getIdentifyBtn addTarget:self action:@selector(getIdentifyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getIdentifyBtn];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.isSelected = YES;
    chooseBtn.frame = CGRectMake(codeImageView.left+20, getIdentifyBtn.bottom + 10, 20, 20);
    [chooseBtn setBackgroundImage:[UIImage imageNamed:@"zm_yes_Btn"] forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(chooseBtn.right, getIdentifyBtn.bottom+10, 120, 20)];
    label.text = @"我已阅读并同意";
    [self.view addSubview:label];
    
    UIButton *protocolBtn = [UQFactory buttonWithFrame:CGRectMake(label.right-3, getIdentifyBtn.bottom + 12, 110, 17) title:@"用户服务协议" titleColor:ZhenMeiRGB(205, 173, 0) fontName:nil fontSize:17 ];
    [protocolBtn addTarget:self action:@selector(protocolAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocolBtn];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(protocolBtn.left+3, protocolBtn.bottom, protocolBtn.width-6, 1)];
    lineLabel.backgroundColor = ZhenMeiRGB(205, 173, 0);
    [self.view addSubview:lineLabel];

}

- (void)getIdentifyAction
{
    [self.phoneNumberTxtFiled resignFirstResponder];
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    if (![self checkInputIsValid]) {
        return;
    }
    [Notifier showHud:self.view text:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumberTxtFiled.text,@"loginName", nil];
    [Utils post:KIdentify params:dic success:^(id json) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:@"用户名已存在" timeInterval:NyToastDuration];
            return ;
        }
        [Utils post:KGetCode params:[NSDictionary dictionaryWithObjectsAndKeys:_phoneNumberTxtFiled.text,@"phone", nil] success:^(id obj) {
            if ([[obj objectForKey:@"code"] intValue] ) {
                [Notifier UQToast:self.view text:@"验证码发送失败" timeInterval:NyToastDuration];
                return ;
            }
            IdentifyViewController *identifyVC = [[IdentifyViewController alloc] init];
            identifyVC.forgetPsw = NO;
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
        [Notifier UQToast:self.view text:@"用户名已存在" timeInterval:NyToastDuration];

    }];
}

- (BOOL)checkInputIsValid
{
    NSString *phoneNumber = self.phoneNumberTxtFiled.text;
    if (phoneNumber.length == 0) {
        [Notifier UQToast:self.view text:@"手机号为空，请输入手机号" timeInterval:NyToastDuration];
        return NO;
    }
    if (phoneNumber.length != 11) {
        [Notifier UQToast:self.view text:@"手机号不符合规范，请重新输入" timeInterval:NyToastDuration];
        return NO;
    }
    if (!self.isSelected) {
        [Notifier UQToast:self.view text:@"请选择同意用户协议" timeInterval:NyToastDuration];
        return NO;
    }
    return YES;
}

- (void)chooseAction:(UIButton *)button
{
    UIImage *image = self.isSelected? [UIImage imageNamed:@"zm_no_Btn"]:[UIImage imageNamed:@"zm_yes_Btn"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    self.isSelected = self.isSelected? NO: YES;

}

- (void)protocolAction
{
    UserProtolViewController *userProtocolVC = [[UserProtolViewController alloc] init];
    [self.navigationController pushViewController:userProtocolVC animated:NO];

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
