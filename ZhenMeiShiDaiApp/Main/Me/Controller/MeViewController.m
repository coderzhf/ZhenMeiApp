//
//  MeViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MeViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PersonalInforViewController.h"
#import "SettingViewController.h"
#import "BeTeacherViewController.h"
#import "AboutUsViewController.h"
#import "MyCommunicationViewController.h"
#import "CustomButton.h"
#import "RepeatView.h"
#import "CommunicationViewController.h"
#import "MyDianBoViewController.h"
#import "MyCollectionViewController.h"


@interface MeViewController () <UIAlertViewDelegate>
{
    UIImageView *imageView ;
    UIImageView *headImageView;
    UILabel *nickName;
    CustomNavBar *customNav;
    UIButton *setBtn;
    UIScrollView *scroller;
}
@property(nonatomic,strong)RepeatView *RepeatView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUI) name:@"LoginorLogout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseImage:) name:@"chooseImage" object:nil];
    [self initViews];
    BOOL hasUser =  [UserDefaults boolForKey:@"isLogin"];
    if (hasUser) {
        //如果本地有用户的登录信息，进入个人中心页面
        [self initLoginPage];
        [self initPersonalCenter];
    }else{
        //如果本地没有用户信息，引导用户去登录注册页面
        [self initPersonalCenter];
        [self initLoginPage];
    }
}

- (void)initViews
{
    customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:YES withTitle:@"我"];
    [self.view addSubview:customNav];
    
    setBtn = [UQFactory buttonWithFrame:CGRectMake(KScreenWidth - 38, KnavHeight-28, 18, 18) image:[UIImage imageNamed:@"zm_set_Btn"] ];
    [setBtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    [customNav addSubview:setBtn];

    imageView = [UQFactory imageViewWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, 140) image:nil];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    //初始化用户个人中心
     //初始化用户未登陆界面
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, imageView.bottom, KScreenWidth, KScreenHeight-imageView.bottom)];
    scroller.contentSize = CGSizeMake(KScreenWidth, KScreenHeight*2/3);
    [self.view addSubview:scroller];

    NSArray  *titleArray = @[@"我的点播",@"我的收藏",@"我的交流",@"我的关注",@"我要做讲师",@"我的建议",@"1",@"关于我们",@"2"];
    NSArray *imageArray = @[@"zm_dianbo_Btn",@"zm_shoucang_Btn",@"zm_jiaoliu_Btn",@"zm_guanzhu_Btn",@"zm_jiangshi_Btn",@"zm_jianyi_Btn",@"1",@"zm_aboutus_Btn",@"2"];
    int k = 0;
    for (int i = 0; i <  3; i ++) {
        for (int j = 0; j <  3; j ++) {
            CustomButton *imageBtn = [[CustomButton alloc] initWithFrame:CGRectMake(KScreenWidth*j/3,10+(KScreenWidth-20)*i/3, KScreenWidth/3, KScreenWidth/3-20) WithTitle:titleArray[k] withImage:[UIImage imageNamed:imageArray[k]] isLabel:NO];
            imageBtn.tag = 200 + k;
            [scroller addSubview:imageBtn];
            [imageBtn addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 2 && (j == 0 || j == 2)) {
                imageBtn.hidden = YES;
            }
            k ++;
        }
    }
}

- (void)initPersonalCenter
{
    UIImageView  *pImageView = [UQFactory imageViewWithFrame:imageView.bounds image:nil];
    pImageView.backgroundColor = ZhenMeiRGB(200,200,200);
    pImageView.userInteractionEnabled = YES;
    [imageView addSubview:pImageView];
    
    headImageView = [UQFactory imageViewWithFrame:CGRectMake((KScreenWidth-100)/2, 10, 100, 100) image:nil];
    NSString *str = [UserDefaults objectForKey:@"userImg"];
    if ([str hasPrefix:@"http"]) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[UserDefaults objectForKey:@"userImg"]] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
    }else{
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,str]] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
    }
    [pImageView addSubview:headImageView];
    UIButton *editBtn = [UQFactory buttonWithFrame:CGRectMake(headImageView.right-15,headImageView.bottom-15,30,30 )image:[UIImage imageNamed:@"zm_edtingBtn"] ];
    [editBtn addTarget:self action:@selector(editInforAction) forControlEvents:UIControlEventTouchUpInside];
    [pImageView addSubview:editBtn];
    
    nickName = [UQFactory labelWithFrame:CGRectMake(headImageView.left, headImageView.bottom+10, 110, 20) text:[UserDefaults objectForKey:@"nickName"] textColor:[UIColor lightGrayColor] fontSize:14 center:YES];
    [pImageView addSubview:nickName];
}

- (void)initLoginPage
{
    UIImageView  *LImageView = [UQFactory imageViewWithFrame:imageView.bounds image:nil];
    LImageView.backgroundColor = ZhenMeiRGB(200,200,200);
    LImageView.userInteractionEnabled = YES;
    [imageView addSubview:LImageView];
    UIImageView *headImageViewNo = [UQFactory imageViewWithFrame:CGRectMake(20, 40, 70, 70) image:[UIImage imageNamed:@"zm_moren_Btn"]];
    [LImageView addSubview:headImageViewNo];
    
    UIButton *registerBtn = [UQFactory buttonWithFrame:CGRectMake(headImageViewNo.right+70, headImageViewNo.top, 120, 30) backgroundImage:[UIImage imageNamed:@"zm_zhuce_Btn"] image:nil];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [LImageView addSubview:registerBtn];
    
   UIButton *loginBtn = [UQFactory buttonWithFrame:CGRectMake(registerBtn.left, registerBtn.bottom+10, 120, 30) backgroundImage:[UIImage imageNamed:@"zm_zhuce_Btn"] image:nil];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [LImageView addSubview:loginBtn];
}

-(RepeatView *)RepeatView{
    if (!_RepeatView) {
        
        _RepeatView=[[RepeatView alloc]init];
        _RepeatView.frame=self.view.bounds;
    }else{
        _RepeatView.textView.text = nil;
    }
    
    return _RepeatView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"change" object:nil];
    
}
- (void)chooseImage:(NSNotification *)notification
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,notification.object]]];
}
- (void)readSuccess:(readSuccessBlock)block
{
    self.readblock = block;
}

- (void)changeUI
{
    [imageView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    if ([UserDefaults boolForKey:@"isLogin"]) {
        NSString *str = [UserDefaults objectForKey:@"userImg"];
        if ([str hasPrefix:@"http"]) {
            [headImageView sd_setImageWithURL:[NSURL URLWithString:[UserDefaults objectForKey:@"userImg"]]];
        }else{
            [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,str]]];
        }
        nickName.text = [UserDefaults objectForKey:@"nickName"];
    }else{
        if (self.readblock) {
            self.readblock();
        }
    }
}

#pragma mark - 用户未注册登陆

- (void)registerAction
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:NO];
}

- (void)loginAction
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:NO];
}

#pragma mark -已经登陆，设置页

- (void)setAction
{
    SettingViewController *setVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:NO];
}

- (void)editInforAction
{
    PersonalInforViewController *personalVC = [[PersonalInforViewController alloc] init];
    [personalVC changeSuccessBlock:^(NSString *nickNameStr) {
        nickName.text = nickNameStr;
    }];
    [self.navigationController pushViewController:personalVC animated:NO];
}

- (void)myAction:(CustomButton *)sender
{
    if (sender.tag == 204) {
        BeTeacherViewController *beTeacherVC = [[BeTeacherViewController alloc] init];
        [self.navigationController pushViewController:beTeacherVC animated:NO];
        return;
    }
    if (sender.tag == 207) {
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:NO];
 
        return;
    }
    if (![UserDefaults boolForKey:@"isLogin"]) {
        UIAlertView *actionSheet = [[UIAlertView alloc] initWithTitle:@"需要注册/登录后查看我的状态" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet show];
            return;
    }
    else{
        switch (sender.tag) {
            case 200:
            {
                MyDianBoViewController *dianboVC = [[MyDianBoViewController alloc] init];
                [self.navigationController pushViewController:dianboVC animated:NO];
            }
                break;
            case 201:
            {
                MyCollectionViewController *collectionVC = [[MyCollectionViewController alloc] init];
                [self.navigationController pushViewController:collectionVC animated:NO];
            }
                break;
            case 202:
            {
                MyCommunicationViewController *communicationVC = [[MyCommunicationViewController alloc] init];
                [self.navigationController pushViewController:communicationVC animated:NO];
            }
                break;
            case 203:
            {
                CommunicationViewController *focusVC = [[CommunicationViewController alloc] init];
                focusVC.isFocus = YES;
                [self.navigationController pushViewController:focusVC animated:NO];
            }
                break;
            case 205:
            {
              //弹出一个框
                [self.RepeatView.textView becomeFirstResponder];
                [_RepeatView.location setTitle:@"期待您的宝贵意见和建议" forState:UIControlStateNormal];
                [_RepeatView.location setBackgroundColor:[UIColor whiteColor]];
                _RepeatView.location.titleLabel.font = [UIFont systemFontOfSize:14];
                [_RepeatView.button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
                [AppWindow addSubview:_RepeatView];
            }
                break;
            default:
                break;
        }
    }
}

- (void)buttonAction
{
    [_RepeatView removeFromSuperview];
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    if (_RepeatView.textView.text .length == 0) {
        [Notifier UQToast:self.view text:@"反馈内容不能为空" timeInterval:NyToastDuration];
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:@"userId"],@"userId",_RepeatView.textView.text,@"content", nil];
    [Notifier showHud:self.view text:nil];
    [Utils post:KfeedBack_url params:dic success:^(id json) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            return ;
        }
        [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
    } failure:^(NSError *error) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view text:@"发表失败" timeInterval:NyToastDuration];

    }];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIActionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self loginAction];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
