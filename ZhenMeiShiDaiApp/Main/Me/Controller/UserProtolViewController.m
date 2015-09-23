
//
//  UserProtolViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "UserProtolViewController.h"

@interface UserProtolViewController ()<UIWebViewDelegate>

@end

@implementation UserProtolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
}

- (void)initViews
{
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"服务协议"];
    [self.view addSubview:customNav];
    
    UIWebView *web=[UQFactory webViewWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, KScreenHeight-KnavHeight)];
    web.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:web];
    web.delegate=self;
    NSURL *url= [NSURL URLWithString:KProcol];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [web loadRequest:request];
}

#pragma mark UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText=@"正在加载中....";
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Notifier UQToast:self.view text:@"加载失败" timeInterval:NyToastDuration];
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
