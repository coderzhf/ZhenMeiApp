//
//  LoginViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindPswViewController.h"
#import <ShareSDK/ShareSDK.h>
@interface LoginViewController ()
{
    UIView *bgView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
}

- (void)initViews
{
     bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];

    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"登录"];
    [self.view addSubview:customNav];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, KScreenHeight/2)];
    imageView.image = [UIImage imageNamed:@"zm_me_bg"];
    [bgView addSubview:imageView];
    
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageView.bottom + 10, KScreenWidth - 20*2, 35)];
    phoneImageView.userInteractionEnabled = YES;
    phoneImageView.image = [UIImage imageNamed:@"zm_textField_Bg"];
    [bgView addSubview:phoneImageView];

    self.phoneNumberTxtFiled = [UQFactory textFieldWithFrame:phoneImageView.bounds placeholder:@"输入手机号" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self];
    self.phoneNumberTxtFiled.textAlignment = NSTextAlignmentCenter;
    self.phoneNumberTxtFiled.clearsOnBeginEditing = YES;
    self.phoneNumberTxtFiled.keyboardType = UIKeyboardTypePhonePad;
    [phoneImageView addSubview:self.phoneNumberTxtFiled];
    
    UIImageView *pswImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, phoneImageView.bottom + 10, KScreenWidth - 20*2, 35)];
    pswImageView.userInteractionEnabled = YES;
    pswImageView.image = [UIImage imageNamed:@"zm_textField_Bg"];
    [bgView addSubview:pswImageView];
    
    self.pswTxtField = [UQFactory textFieldWithFrame:pswImageView.bounds placeholder:@"输入密码" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self];
    self.pswTxtField.textAlignment = NSTextAlignmentCenter;
    self.pswTxtField.clearsOnBeginEditing = YES;
    self.pswTxtField.secureTextEntry = YES;
     [pswImageView addSubview:self.pswTxtField];
    
    UIButton *loginBtn = [UQFactory buttonWithFrame:CGRectMake((KScreenWidth-60)/2, pswImageView.bottom + 10, 60, 60) title:@"登录" titleColor:[UIColor whiteColor] fontName:nil fontSize:16 ];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"zm_login_Btn"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginBtn];
    
    UIButton *registerBtn = [UQFactory buttonWithFrame:CGRectMake(pswImageView.left, pswImageView.bottom + 10, 80, 20) title:@"新用户注册" titleColor:ZhenMeiRGB(205, 173, 0) fontName:nil fontSize:16 ];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:registerBtn];
    
    UIButton *forgetPswBtn = [UQFactory buttonWithFrame:CGRectMake(loginBtn.right + 33, pswImageView.bottom + 10, 80, 20) title:@"忘记密码？" titleColor:ZhenMeiRGB(205, 173, 0) fontName:nil fontSize:16 ];
    [forgetPswBtn addTarget:self action:@selector(forgetPswAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:forgetPswBtn];
    UILabel *label = [UQFactory labelWithFrame:CGRectMake(20, loginBtn.bottom+ 15, KScreenWidth - 20*2, 10) text:@"-------------微信直接登录-------------"];
    label.textColor = [UIColor lightGrayColor];
    [bgView addSubview:label];
    UIButton *weChatBtn = [UQFactory buttonWithFrame:CGRectMake((KScreenWidth-35)/2, label.bottom+ 18, 30, 30) image:[UIImage imageNamed:@"zm_wechat"]];
    [weChatBtn addTarget:self action:@selector(weChatAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:weChatBtn];
}

- (void)loginAction
{
    [self.phoneNumberTxtFiled resignFirstResponder];
    [self.pswTxtField resignFirstResponder];
    [UIView animateWithDuration:.35 animations:^{
        bgView.top = 0;
        
    }];
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    if (![self checkInputIsValid]) {
        return;
    }
    [Notifier showHud:self.view text:@"正在登录……"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumberTxtFiled.text,@"loginName",_pswTxtField.text,@"pwd", nil];
    [Utils post:KLogin params:dic success:^(id json) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:@"账号或密码不正确" timeInterval:NyToastDuration];
            return ;
        }
        NSDictionary *dic = [json objectForKey:@"obj"];        
        [self saveUserInfor:dic];//保存用户数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginorLogout" object:nil];//发用户已经登陆成功的通知，更改我界面
        [self.navigationController popToRootViewControllerAnimated:NO];
    } failure:^(NSError *error) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view text:@"账号或密码不正确" timeInterval:NyToastDuration];
    }];
 }

- (void)saveUserInfor:(NSDictionary *)dic
{
    [UserDefaults setObject:[dic objectForKey:@"userId"] forKey:@"userId"];
    [UserDefaults setObject:[dic objectForKey:@"loginName"] forKey:@"loginName"];
    [UserDefaults setObject:_pswTxtField.text forKey:@"password"];
    [UserDefaults setObject:[dic objectForKey:@"age"] forKey:@"age"];
    [UserDefaults setObject:[dic objectForKey:@"nickName"] forKey:@"nickName"];
    [UserDefaults setObject:[dic objectForKey:@"gender"] forKey:@"gender"];
    [UserDefaults setObject:[dic objectForKey:@"userImg"] forKey:@"userImg"];
    [UserDefaults setBool:YES  forKey:@"isLogin"];
    [UserDefaults synchronize];
}

- (void)registerAction
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:NO];
    
}

- (void) forgetPswAction
{
    
    FindPswViewController *findPswVC = [[FindPswViewController alloc] init];
    [self.navigationController pushViewController:findPswVC animated:NO];
}

- (void)weChatAction
{
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         if (result){
             NSDictionary *sourceDic = [userInfo sourceData];
             NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[sourceDic objectForKey:@"nickname"],@"nickName",[sourceDic objectForKey:@"openid"],@"loginName", nil] ;
             [Utils post:KWXLogin params:dic1 success:^(id json) {
                 if ([[json objectForKey:@"code"] intValue] ) return ;
                 NSDictionary *dic = [json objectForKey:@"user"];
                 if (dic) {
                     [UserDefaults setObject:[dic objectForKey:@"userId"] forKey:@"userId"];
                     //[UserDefaults setObject:[dic objectForKey:@"age"] forKey:@"age"];
                     [UserDefaults setObject:[dic objectForKey:@"nickName"] forKey:@"nickName"];
                     //[UserDefaults setObject:[dic objectForKey:@"gender"] forKey:@"gender"];
                     [UserDefaults setObject:[dic objectForKey:@"userImg"] forKey:@"userImg"];
                     [UserDefaults setBool:YES  forKey:@"isLogin"];
                     [UserDefaults synchronize];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginorLogout" object:nil];//发用户已经登陆成功的通知，更改我界面
                     [self.navigationController popToRootViewControllerAnimated:NO];
                 }
             } failure:^(NSError *errorInfor) {
                 [Notifier UQToast:self.view text:@"用户信息获取失败" timeInterval:NyToastDuration];
             }];
             
         }else{
             [Notifier UQToast:self.view text:[error errorDescription] timeInterval:NyToastDuration];}
              }];
}

- (BOOL)checkInputIsValid
{
    NSString *phoneNumber = self.phoneNumberTxtFiled.text;
    NSString *password = self.pswTxtField.text;
    if (phoneNumber.length == 0) {
        [Notifier UQToast:self.view text:@"手机号为空，请输入手机号" timeInterval:NyToastDuration];
        return NO;
    }
    if (password.length == 0) {
        [Notifier UQToast:self.view text:@"密码为空，请输入密码" timeInterval:NyToastDuration];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNumberTxtFiled) {
        [self.pswTxtField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (bgView.top == 0) {
        [UIView animateWithDuration:.35 animations:^{
            bgView.top = -KScreenHeight/2+45;
        }];
    }
    if (textField == self.pswTxtField) {
        textField.returnKeyType = UIReturnKeyDone;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.pswTxtField) {
        [UIView animateWithDuration:.35 animations:^{
            bgView.top = 0;
        }];
    }
    [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pswTxtField resignFirstResponder];
    [self.phoneNumberTxtFiled resignFirstResponder];

    [UIView animateWithDuration:.35 animations:^{
        bgView.top = 0;
    }];

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
