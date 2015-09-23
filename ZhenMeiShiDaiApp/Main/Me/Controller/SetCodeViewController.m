//
//  SetCodeViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "SetCodeViewController.h"
#import "UploadImageViewController.h"
#import "LoginViewController.h"
#import "UIButton+WebCache.h"
#import "ChooseTableView.h"

@interface SetCodeViewController ()<UITextFieldDelegate>
{
    UIButton *loadImageBtn;
    UITextField *nickTextField;
    ChooseTableView *messageTableView;
    NSArray *array;
    UILabel *ageLabel;
    UILabel *genderLabel;
    UIView *bgView;
}
@end

@implementation SetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseImage:) name:@"chooseImage" object:nil];
    [self initViews];
}

- (void)initViews
{
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"注册"];
    [self.view addSubview:customNav];

    loadImageBtn = [UQFactory buttonWithFrame:CGRectMake((KScreenWidth-110)/2, KnavHeight+20, 110, 110) image:[UIImage imageNamed:@"zm_uploadImage_Btn"] ];
    [loadImageBtn addTarget:self action:@selector(loadAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadImageBtn];
    
    UIImageView *nickBg = [UQFactory imageViewWithFrame:CGRectMake(20, loadImageBtn.bottom +10, KScreenWidth-20*2, 40) image:[UIImage imageNamed:@"zm_textField_Bg"]];
    nickBg.userInteractionEnabled = YES;
    [self.view addSubview:nickBg];
    
    nickTextField = [UQFactory textFieldWithFrame:CGRectMake(0, 0, KScreenWidth-20*2, 40)  placeholder:@"输入昵称" text:nil borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self returnKeyType:9 keyboardType:0 fontName:nil fontSize:16 secure:NO];
    nickTextField.textAlignment = NSTextAlignmentCenter;
    [nickBg addSubview:nickTextField];
    
    UIImageView *ageBg = [UQFactory imageViewWithFrame:CGRectMake(20, nickBg.bottom +10, (KScreenWidth-20*2)/2, 40) image:[UIImage imageNamed:@"zm_choose_Bg"]];
    [self.view addSubview:ageBg];
    
    ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ageBg.frame.size.width*2/3, 40)];
    ageLabel.text = @"年龄";
    ageLabel.textAlignment = NSTextAlignmentCenter;
    [ageBg addSubview:ageLabel];
    
    UIButton *ageBtn = [UQFactory buttonWithFrame:CGRectMake(ageLabel.right, 0, ageBg.frame.size.width/3, 40) image:nil ];
    ageBtn.tag = 100;
    [ageBtn addTarget:self action:@selector(ageOrGenderAction:) forControlEvents:UIControlEventTouchUpInside];
    [ageBg addSubview:ageBtn];
    
    UIImageView *genderBg = [UQFactory imageViewWithFrame:CGRectMake(ageBg.right, nickBg.bottom +10, (KScreenWidth-20*2)/2, 40) image:[UIImage imageNamed:@"zm_choose_Bg"]];
    [self.view addSubview:genderBg];
    
    genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, genderBg.frame.size.width*2/3, 40)];
    genderLabel.text = @"性别";
    genderLabel.textAlignment = NSTextAlignmentCenter;
    [genderBg addSubview:genderLabel];
    
    UIButton *genderBtn = [UQFactory buttonWithFrame: CGRectMake(genderLabel.right, 0, genderBg.frame.size.width/3,40) image:nil ];
    genderBtn.tag = 200;
    [genderBtn addTarget:self action:@selector(ageOrGenderAction:) forControlEvents:UIControlEventTouchUpInside];
    [genderBg addSubview:genderBtn];
    
    UIButton *doneBtn = [UQFactory buttonWithFrame:CGRectMake(20, genderBg.bottom+10, KScreenWidth- 2*20,40)  backgroundImage:[UIImage imageNamed:@"zm_getCode_Btn"] image:nil];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];

}

- (void)loadAction
{
    UploadImageViewController *upLoadImageVC = [[UploadImageViewController alloc] init];
    [self.navigationController pushViewController:upLoadImageVC animated:NO];
    
}

- (void)ageOrGenderAction:(UIButton *)button
{
    [nickTextField resignFirstResponder];
    [self.view endEditing:YES];
    
    bgView = [UQFactory viewWithFrame:self.view.bounds backgroundColor:[UIColor blackColor]];
    bgView.alpha = .7;
    [AppWindow addSubview:bgView];
    
    messageTableView = [[ChooseTableView alloc] initWithFrame:CGRectZero];
    [bgView addSubview:messageTableView];
    if (button.tag == 100) {
        messageTableView.frame = CGRectMake(0, KScreenHeight-150, KScreenWidth, 150);
        messageTableView.array = @[@"16岁",@"17岁",@"18岁",@"19岁",@"20岁",@"21岁",@"22岁",@"23岁",@"24岁",@"25岁",@"26岁",@"27岁",@"28岁",@"29岁",@"30岁",@"31岁",@"32岁",@"33岁",@"34岁",@"35岁",@"36岁",@"37岁",@"38岁",@"39岁",@"40岁",@"41岁",@"42岁",@"43岁",@"44岁",@"45岁",@"46岁",@"47岁",@"48岁",@"49岁",@"50岁"];
        [messageTableView reloadData];
        [messageTableView chooseSuccess:^(NSString *text) {
            ageLabel.text = text;
            [bgView removeFromSuperview];
        }];
        
    }else{
        messageTableView.frame = CGRectMake(0, KScreenHeight-80, KScreenWidth, 80);
        messageTableView.array = @[@"男",@"女"];
        [messageTableView reloadData];
        [messageTableView chooseSuccess:^(NSString *text) {
            genderLabel.text = text;
            [bgView removeFromSuperview];
        }];
    }
}

- (void)doneAction
{
    [nickTextField resignFirstResponder];
    
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    if (![self checkInputIsValid]) {
        return;
    }
    [Notifier showHud:self.view text:nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[self returnStr],@"json", nil];
    

    [Utils post:KRegister params:dic success:^(id json) {
        [UQLogger log:@"%@",json];
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if (_imageUrl.length == 0) {
            UIAlertView *actionSheet = [[UIAlertView alloc] initWithTitle:@"注册成功，请上传头像" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [actionSheet show];
        }else{
            [Notifier UQToast:self.view  text:@"注册成功" timeInterval:NyToastDuration];
            //[self performSelector:@selector(jumpToLoginVC) withObject:nil afterDelay:NyToastDuration];
            NSDictionary *dic = [json objectForKey:@"obj"];
            [self saveUserInfor:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginorLogout" object:nil];//发用户已经登陆成功的通知，更改我界面
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    } failure:^(NSError *error) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view  text:@"注册失败" timeInterval:NyToastDuration];
    }];
}

- (void)saveUserInfor:(NSDictionary *)dic
{
    [UserDefaults setObject:[dic objectForKey:@"userId"] forKey:@"userId"];
    [UserDefaults setObject:[dic objectForKey:@"loginName"] forKey:@"loginName"];
    [UserDefaults setObject:_pswStr forKey:@"password"];
    [UserDefaults setObject:[dic objectForKey:@"age"] forKey:@"age"];
    [UserDefaults setObject:[dic objectForKey:@"nickName"] forKey:@"nickName"];
    [UserDefaults setObject:[dic objectForKey:@"gender"] forKey:@"gender"];
    [UserDefaults setObject:[dic objectForKey:@"userImg"] forKey:@"userImg"];
    [UserDefaults setBool:YES  forKey:@"isLogin"];
    [UserDefaults synchronize];
}

- (void)jumpToLoginVC
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (vc && [vc isMemberOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            return;
         }
      }
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (NSString *)returnStr
{
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [mutDic setObject:_loginNameString forKey:@"loginName"];
    [mutDic setObject:_pswStr forKey:@"pwd"];
    [mutDic setObject:nickTextField.text forKey:@"nickName"];
    [mutDic setObject:[self getAgeCount] forKey:@"age"];
    if (_imageUrl) {
        [mutDic setObject:_imageUrl forKey:@"userImg"];
    }
    [mutDic setObject:[self getGenderCount] forKey:@"gender"];
    return  [mutDic JSONString];
}

- (NSString *)getAgeCount
{
    NSString *str = [ageLabel.text substringToIndex:2];
    return str;
}

- (NSString *)getGenderCount
{
    if ([genderLabel.text isEqualToString: @"男"]) {
        return @"0";
    }
    return @"1";
}

- (BOOL)checkInputIsValid
{
    NSString *nickName = nickTextField.text;
    if (nickName.length == 0) {
        [Notifier UQToast:self.view text:@"昵称为空，请输入昵称" timeInterval:NyToastDuration];
        return NO;
    }
     if (![ageLabel.text hasSuffix:@"岁"] ) {
        [Notifier UQToast:self.view text:@"请选择年龄" timeInterval:NyToastDuration];
        return NO;
    }
    if ([genderLabel.text hasSuffix:@"别"]) {
        [Notifier UQToast:self.view text:@"请选择性别" timeInterval:NyToastDuration];
        return NO;
    }
    return YES;
    
}

- (void)chooseImage:(NSNotification *)notification
{
    [loadImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,notification.object]] forState:UIControlStateNormal];
    _imageUrl = notification.object;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [bgView removeFromSuperview];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loadAction];
    }else if (buttonIndex == 0){
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
