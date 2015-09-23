
//
//  IdentifyViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "IdentifyViewController.h"
#import "SetCodeViewController.h"
#import "LoginViewController.h"

@interface IdentifyViewController () <UITextFieldDelegate,UIAlertViewDelegate>
{
    UILabel *timeLabel;
    UITextField *checkCodeTextField;
    UITextField *pswTextField;
    NSTimer *timer;
    int count;
}

@end

@implementation IdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];

    [self initViews];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [timer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
    
}

- (void)initViews
{    CustomNavBar *customNav;
     customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"注册"];
    if (_forgetPsw) {
    customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"重置密码"];

    }
    [self.view addSubview:customNav];
    
    UIImageView *timerBg = [UQFactory imageViewWithFrame:CGRectMake(20, KnavHeight +20, KScreenWidth-20*2, 40) image:[UIImage imageNamed:@"zm_new_Btn"]];
    timerBg.userInteractionEnabled = YES;
    [self.view addSubview:timerBg];
    
    checkCodeTextField = [UQFactory textFieldWithFrame:CGRectMake(0, 0, timerBg.frame.size.width/2, 40) placeholder:@"请输入验证码" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self];
    checkCodeTextField.textAlignment = NSTextAlignmentCenter;
    checkCodeTextField.returnKeyType = UIReturnKeyNext;
    checkCodeTextField.keyboardType = UIKeyboardTypePhonePad;
    [timerBg addSubview:checkCodeTextField];
    
    count = 60;
    timeLabel = [UQFactory labelWithFrame:CGRectMake(checkCodeTextField.right, 2, timerBg.frame.size.width/2, 35) text:[NSString stringWithFormat:@"%ld秒后重新获取",(long)count] textColor:[UIColor whiteColor] fontSize:14 center:YES];
    [timerBg addSubview:timeLabel];
    
    UIImageView *pswBg = [UQFactory imageViewWithFrame:CGRectMake(20, timerBg.bottom +10, KScreenWidth-20*2, 40) image:[UIImage imageNamed:@"zm_textField_Bg"]];
    pswBg.userInteractionEnabled = YES;
    [self.view addSubview:pswBg];
    
    pswTextField = [UQFactory textFieldWithFrame:CGRectMake(20, 0, KScreenWidth-20*2, 40)  placeholder:@"请输入密码" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self returnKeyType:9 keyboardType:0 fontName:nil fontSize:16 secure:YES];
    if (_forgetPsw) {
        pswTextField.placeholder = @"输入新密码";
    }
    pswTextField.textAlignment = NSTextAlignmentLeft;
    [pswBg addSubview:pswTextField];
    
    UIButton *nextBtn = [UQFactory buttonWithFrame:CGRectMake(20, pswBg.bottom+10, KScreenWidth- 2*20,40) backgroundImage:[UIImage imageNamed:@"zm_getCode_Btn"] image:nil];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)timerCount
{
    if (count == 1) {
        count = 60;
        [Utils post:KGetCode params:[NSDictionary dictionaryWithObjectsAndKeys:_loginNameStr,@"phone", nil] success:^(id obj) {
            if ([[obj objectForKey:@"code"] intValue] ) {
                [Notifier UQToast:self.view text:@"验证码发送失败" timeInterval:NyToastDuration];
                return ;
            }
            _codeStr = [obj objectForKey:@"msg"];
        } failure:^(NSError *error) {
            [Notifier UQToast:self.view text:@"验证码发送失败" timeInterval:NyToastDuration];
        }];
    }
    count--;
    timeLabel.text = [NSString stringWithFormat:@"%d秒后重新获取",count];
}

- (void)checkInputIsValid
{
    NSString *checkCode = checkCodeTextField.text;
    NSString *password = pswTextField.text;
    if (checkCode.length == 0 || ![checkCode isEqualToString:_codeStr]) {
        [Notifier UQToast:self.view text:@"验证码输入有误，请重新输入" timeInterval:NyToastDuration];
        return;
    }
    if (password.length == 0) {
        [Notifier UQToast:self.view text:@"密码为空，请输入密码" timeInterval:NyToastDuration];
        return;
    }
}

- (void)nextAction
{
    [checkCodeTextField resignFirstResponder];
    [pswTextField resignFirstResponder];
    [self checkInputIsValid];
    if (_forgetPsw) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_loginNameStr,@"loginName",pswTextField.text,@"pwd", nil];
        [Utils post:KFindPsw params:dic success:^(id json) {
             if ([[json objectForKey:@"code"] intValue] ) {
                [Notifier UQToast:self.view text:@"密码重置失败" timeInterval:NyToastDuration];
                return ;
            }
            UIAlertView *actionSheet = [[UIAlertView alloc] initWithTitle:@"密码重置成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [actionSheet show];
            return;
 
        } failure:^(NSError *error) {
            [Notifier UQToast:self.view text:@"密码重置失败" timeInterval:NyToastDuration];

        }];
        
    }else{
        SetCodeViewController *setCodeVC = [[SetCodeViewController alloc] init];
        setCodeVC.loginNameString = self.loginNameStr;
        setCodeVC.pswStr = pswTextField.text;
        [self.navigationController pushViewController:setCodeVC animated:NO];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == checkCodeTextField) {
        [pswTextField becomeFirstResponder];
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
        for (ViewController *vc in self.navigationController.viewControllers) {
            if ([vc isMemberOfClass:[LoginViewController class]]) {
                [self.navigationController popToViewController:vc animated:NO];

            }
        }
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
