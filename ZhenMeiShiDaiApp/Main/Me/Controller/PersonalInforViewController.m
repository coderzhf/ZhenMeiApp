//
//  PersonalInforViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "PersonalInforViewController.h"
#import "ChangePhotoViewController.h"
#import "UpDatePswViewController.h"
#import "UIButton+WebCache.h"
#import "ChooseTableView.h"

@interface PersonalInforViewController ()<UITextFieldDelegate>
{
    NSArray *array;
    UIView *bgView;
    UITextField *fieldName;
    ChooseTableView *messageTableView;
    UIButton *headerImg;
    UILabel *labelAge;
    UILabel *labelGender;
}

@end

@implementation PersonalInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZhenMeiRGB(240, 240, 240);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseImage :) name:@"chooseImage" object:nil];
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"个人信息"];
    [self.view addSubview:customNav];
    [self initViews];
}

- (void)initViews
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KnavHeight +15, KScreenWidth, 80)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    UILabel *label = [UQFactory labelWithFrame:CGRectMake(10, 35, 60, 20) text:@"头像" textColor:[UIColor blackColor] fontSize:16 center:NO];
    [imageView addSubview:label];
    headerImg = [UQFactory buttonWithFrame:CGRectMake(KScreenWidth - 90, 10, 60, 60) image:nil];
    [headerImg addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *str = [UserDefaults objectForKey:@"userImg"];
      if ([str hasPrefix:@"http"]) {
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[UserDefaults objectForKey:@"userImg"] ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
    }else{
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,str]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
    }
    headerImg.tag = 50;
    [imageView addSubview:headerImg];
    UIImageView *imageViewHeader = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth -25, 23, 25, 25)];
    imageViewHeader.image = [UIImage imageNamed:@"zm_more_Btn"];
    [imageView addSubview:imageViewHeader];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView.bottom +15, KScreenWidth, 40)];
    imageView1.backgroundColor = [UIColor whiteColor];
    imageView1.userInteractionEnabled = YES;
    [self.view addSubview:imageView1];
    UILabel *label1 = [UQFactory labelWithFrame:CGRectMake(10, 10, 60, 20) text:@"昵称" textColor:[UIColor blackColor] fontSize:16 center:NO];
    [imageView1 addSubview:label1];
    fieldName = [UQFactory textFieldWithFrame:CGRectMake(KScreenWidth-90, 5, 90, 30) placeholder:nil text:[UserDefaults objectForKey:@"nickName"] borderStyle:0 backgroundColor:[UIColor clearColor] delegate:self];
    fieldName.textColor = [UIColor lightGrayColor];
    fieldName.returnKeyType = UIReturnKeyDone;
    [imageView1 addSubview:fieldName];

    UIButton *gender = [UIButton buttonWithType:UIButtonTypeCustom];
    gender.backgroundColor = [UIColor whiteColor];
    [gender addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    gender.frame = CGRectMake(0, imageView1.bottom +15, KScreenWidth, 40);
    gender.tag = 51;
    [self.view addSubview:gender];
    UILabel *label2 = [UQFactory labelWithFrame:CGRectMake(10, 10, 60, 20) text:@"性别" textColor:[UIColor blackColor] fontSize:16 center:NO];
    [gender addSubview:label2];
    labelGender = [UQFactory labelWithFrame:CGRectMake(KScreenWidth-80, 5, 50, 30) text:nil textColor:[UIColor lightGrayColor]  fontSize:16 center:NO];
    if ([[UserDefaults objectForKey:@"gender"] intValue]) {
        labelGender.text = @"女";
    }else{
        labelGender.text = @"男";
    }
    [gender addSubview:labelGender];
    
    UIButton *age = [UIButton buttonWithType:UIButtonTypeCustom];
    age.backgroundColor = [UIColor whiteColor];
    [age addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    age.frame = CGRectMake(0, gender.bottom +15, KScreenWidth, 40);
    age.tag = 52;
    [self.view addSubview:age];
    UILabel *label3 = [UQFactory labelWithFrame:CGRectMake(10, 10, 60, 20) text:@"年龄" textColor:[UIColor blackColor] fontSize:16 center:NO];
    [age addSubview:label3];
    labelAge = [UQFactory labelWithFrame:CGRectMake(KScreenWidth-80, 5, 50, 30) text:[NSString stringWithFormat:@"%@岁",[UserDefaults objectForKey:@"age"]] textColor:[UIColor lightGrayColor]  fontSize:16 center:NO];
    [age addSubview:labelAge];
 
    UIButton *doneBtn = [UQFactory buttonWithFrame:CGRectMake(0, 0, KScreenWidth,40) title:@"修改" titleColor:ZhenMeiRGB(205, 173, 0) fontName:nil fontSize:16];
    doneBtn.backgroundColor = [UIColor whiteColor];
    [doneBtn addTarget:self action:@selector(changeInformation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    NSString *loginName = [UserDefaults objectForKey:@"loginName"];
    if (loginName.length == 11) {
        UIButton *psw = [UIButton buttonWithType:UIButtonTypeCustom];
        psw.backgroundColor = [UIColor whiteColor];
        [psw addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        psw.frame = CGRectMake(0, age.bottom +15, KScreenWidth, 40);
        psw.tag = 53;
        [self.view addSubview:psw];
        UILabel *label4 = [UQFactory labelWithFrame:CGRectMake(10, 10, 100, 20) text:@"密码修改" textColor:[UIColor blackColor]  fontSize:16 center:NO];
        [psw addSubview:label4];
        UIImageView *imageViewFoot = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth -25, 5, 25, 25)];
        imageViewFoot.image = [UIImage imageNamed:@"zm_more_Btn"];
        [psw addSubview:imageViewFoot];
        
        doneBtn.top = psw.bottom + 15;
        return;
    }
    doneBtn.top = age.bottom + 15;
}

- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 50) {
        //修改头像
        ChangePhotoViewController *changePhotoVC = [[ChangePhotoViewController alloc] init];
        [self.navigationController pushViewController:changePhotoVC animated:NO];
        return;
    }else if (button.tag == 53){
        //修改密码
        UpDatePswViewController *upDateVC = [[UpDatePswViewController alloc] init];
        [self.navigationController pushViewController:upDateVC animated:NO];
        return;
    }
    [fieldName resignFirstResponder];
    bgView = [UQFactory viewWithFrame:self.view.bounds backgroundColor:[UIColor blackColor]];
    bgView.alpha = .7;
    [AppWindow addSubview:bgView];
    
    messageTableView = [[ChooseTableView alloc] initWithFrame:CGRectZero];
    [bgView addSubview:messageTableView];
    if (button.tag == 52) {
        messageTableView.frame = CGRectMake(0, KScreenHeight-150, KScreenWidth, 150);
        messageTableView.array = @[@"16岁",@"17岁",@"18岁",@"19岁",@"20岁",@"21岁",@"22岁",@"23岁",@"24岁",@"25岁",@"26岁",@"27岁",@"28岁",@"29岁",@"30岁",@"31岁",@"32岁",@"33岁",@"34岁",@"35岁",@"36岁",@"37岁",@"38岁",@"39岁",@"40岁",@"41岁",@"42岁",@"43岁",@"44岁",@"45岁",@"46岁",@"47岁",@"48岁",@"49岁",@"50岁"];
        [messageTableView reloadData];
        [messageTableView chooseSuccess:^(NSString *text) {
            labelAge.text = text;
            [bgView removeFromSuperview];
        }];
        
    }else if(button.tag == 51){
        messageTableView.frame = CGRectMake(0, KScreenHeight-80, KScreenWidth, 80);
        messageTableView.array = @[@"男",@"女"];
        [messageTableView reloadData];
        [messageTableView chooseSuccess:^(NSString *text) {
            labelGender.text = text;
            [bgView removeFromSuperview];
        }];
    }
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

- (void)changeInformation
{
    if (fieldName.text.length == 0) {
        [Notifier UQToast:self.view text:@"修改内容不能为空" timeInterval:NyToastDuration];
            return;}
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    [Notifier showHud:self.view text:nil];
    [Utils post:KUpdateUser params:[NSDictionary dictionaryWithObjectsAndKeys:[self returnStr],@"json", nil] success:^(id json) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:@"信息修改失败" timeInterval:NyToastDuration];
            return ;
        }
        [Notifier UQToast:self.view text:@"信息修改成功" timeInterval:NyToastDuration];
        if (![fieldName.text isEqualToString: [UserDefaults objectForKey:@"nickName"]]) {
            [UserDefaults setObject:fieldName.text forKey:@"nickName"];
        }
        if (![[self getAgeCount] isEqualToString:[UserDefaults objectForKey:@"age"]]) {
            [UserDefaults setObject:[self getAgeCount] forKey:@"age"];
        }
        if ([self getGenderCount] != [UserDefaults objectForKey:@"gender"]) {
            [UserDefaults setObject:[self getGenderCount] forKey:@"gender"];
        }
        
    } failure:^(NSError *error) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view text:@"信息修改失败" timeInterval:NyToastDuration];
    }];
}

- (NSString *)getAgeCount
{
    NSString *str = [labelAge.text substringToIndex:2];
    return str;
}

- (NSNumber *)getGenderCount
{
    if ([labelGender.text isEqualToString: @"男"]) {
        return [NSNumber numberWithInt:0];
    }
    return [NSNumber numberWithInt:1];
}

- (NSString *)returnStr
{
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [mutDic setObject:[UserDefaults objectForKey:@"userId"] forKey:@"userId"];
    if (![fieldName.text isEqualToString: [UserDefaults objectForKey:@"nickName"]]) {
        [mutDic setObject:fieldName.text forKey:@"nickName"];
        if (_nickNameblock) {
            _nickNameblock(fieldName.text);
            _nickNameblock = nil;}
        }
    if (![[self getAgeCount] isEqualToString:[UserDefaults objectForKey:@"age"]]) {
        [mutDic setObject:[self getAgeCount] forKey:@"age"];
    }
    if ( [self getGenderCount] != [UserDefaults objectForKey:@"gender"]) {
        [mutDic setObject:[self getGenderCount] forKey:@"gender"];
    }
    return  [mutDic JSONString];
}

- (void)changeSuccessBlock:(changeNickNameBlock)nickNameblock
{
    self.nickNameblock = nickNameblock;
}

- (void)chooseImage:(NSNotification *)notification
{
    [headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,notification.object]] forState:UIControlStateNormal];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
