//
//  SendMessageViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/19.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "SendMessageViewController.h"
#import "AppDelegate.h"
@interface SendMessageViewController ()<UIAlertViewDelegate>
{
    UITextView *contentTextView;
    AppDelegate *appDelegate;

}
@property(nonatomic,strong)UILabel *textLabel;


@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    appDelegate = [UIApplication sharedApplication].delegate;
    [self initViews];
     
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [contentTextView becomeFirstResponder];
}

- (void)initViews
{
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:YES withTitle:@"发表说说"];
    customNav.userInteractionEnabled = YES;
    [self.view addSubview:customNav];
    
    UIButton *cancleBtn = [UQFactory buttonWithFrame:CGRectMake(10, KnavHeight - 40, 50, 40) title:@"取消" titleColor:[UIColor whiteColor] fontName:nil fontSize:18 ];
    [customNav addSubview:cancleBtn];
    [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sendBtn = [UQFactory buttonWithFrame:CGRectMake(KScreenWidth - 60, KnavHeight - 40, 50, 40) title:@"发送" titleColor:[UIColor whiteColor] fontName:nil fontSize:18 ];
    [customNav addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];

    contentTextView = [UQFactory textViewWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, KScreenHeight/2) text:nil font:[UIFont systemFontOfSize:16] isEditable:YES];
    contentTextView.backgroundColor = ZhenMeiRGB(230, 230, 230);
    [self.view addSubview:contentTextView];
    
    UIImageView *imageView = [UQFactory imageViewWithFrame:CGRectMake(20, contentTextView.bottom-140, 150, 40) image:[UIImage imageNamed:@"zm_location_blackBg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentTextView addSubview:imageView];
    
    UIImageView *image = [UQFactory imageViewWithFrame:CGRectMake(10, 9, 15, 20) image:[UIImage imageNamed:@"zm_dingwei_img"]];
    [imageView addSubview:image];
    
    NSString *text;
    if (!appDelegate.locationInfor) {
        text = @"位置未知";
    }else{
        text = appDelegate.locationInfor;
    }
    _textLabel = [UQFactory labelWithFrame:CGRectMake(image.right+5, 3, imageView.width- image.width, 30) text:text textColor:[UIColor lightGrayColor]  fontSize:14 center:NO];
    [imageView addSubview:_textLabel];
}


- (void)cancleAction
{
    [contentTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)sendAction
{
    if (!appDelegate.locationInfor) {
        UIAlertView *actionSheet = [[UIAlertView alloc] initWithTitle:@"定位失败!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet show];
        return;
    }
    if (![Utils isNetworkConnected]) {
    [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
    return;
     }

    if (contentTextView.text.length == 0) {
        [Notifier UQToast:self.view text:@"发送内容不能为空" timeInterval:NyToastDuration];
        return;
    }else if (contentTextView.text.length > 500){
        [Notifier UQToast:self.view text:@"发送内容不能超过500个字" timeInterval:NyToastDuration];
        return;
    }
    [Notifier showHud:self.view text:@"说说发送中"];

    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithObject:[self returnStr] forKey:@"json"];
    [Utils post:KAddTopicInfo params:mDic success:^(id json) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:@"说说发表失败" timeInterval:NyToastDuration];
            return ;
            
        }
        [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
        [self performSelector:@selector(returnCommunication) withObject:nil afterDelay:NyToastDuration];
        [contentTextView resignFirstResponder];

    } failure:^(NSError *error) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view text:@"说说发表失败" timeInterval:NyToastDuration];
    }];
}

- (NSString *)returnStr
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:[UserDefaults objectForKey:@"userId"] forKey:@"userId"];
    NSString *textStr = [contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [dic setObject:textStr forKey:@"content"];
    if (_smallLabel) {
        [dic setObject:_bigLabel forKey:@"category1"];
        [dic setObject:_smallLabel forKey:@"category2"];
    }
    [dic setObject:[NSNumber numberWithDouble:appDelegate.latitude]forKey:@"latitude"];
    [dic setObject:[NSNumber numberWithDouble:appDelegate.longitude]forKey:@"longitude"];
    [dic setObject:appDelegate.locationInfor forKey:@"memo"];
    return [dic JSONString];
}

- (void)returnCommunication
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
