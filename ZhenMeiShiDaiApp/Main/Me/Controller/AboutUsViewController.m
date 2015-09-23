
//
//  AbountUsViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<UIWebViewDelegate>

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"关于我们"];
    [self.view addSubview:customNav];
    
    UIImageView *image = [UQFactory imageViewWithFrame:CGRectMake((KScreenWidth-60)/2, KnavHeight+10, 60, 60) image:[UIImage imageNamed:@"Icon-@3x"]];
    [self.view addSubview:image];
    
    UILabel *textLabel = [UQFactory labelWithFrame:CGRectMake((KScreenWidth-140)/2, image.bottom,140, 30) text:@"创业说"];
    textLabel.textColor = [UIColor blackColor];
    [self.view addSubview:textLabel];
    
    UILabel *versionLabel = [UQFactory labelWithFrame:CGRectMake(image.left, textLabel.bottom, 60, 30) text:[NSString stringWithFormat:@"版本%@",[UserDefaults objectForKey:@"version"]]];
    versionLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:versionLabel];
    
    UILabel *lineLabel = [UQFactory labelWithFrame:CGRectMake(0, versionLabel.bottom+5, KScreenWidth, 1) text:nil];
    lineLabel.backgroundColor = ZhenMeiRGB(240, 240, 240);
    [self.view addSubview:lineLabel];
    
    UIWebView *web=[UQFactory webViewWithFrame:CGRectMake(0, lineLabel.bottom+10, KScreenWidth, KScreenHeight-lineLabel.bottom)];
    [self.view addSubview:web];
    web.scrollView.showsVerticalScrollIndicator = NO;
    web.delegate=self;
    NSURL *url=[NSURL URLWithString:KAbout];
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
