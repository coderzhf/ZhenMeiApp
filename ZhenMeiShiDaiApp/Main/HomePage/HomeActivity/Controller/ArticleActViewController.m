//
//  ArticleActViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/25.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "ArticleActViewController.h"
#import "MBProgressHUD.h"
#import "WebBottomView.h"
#import "HttpTool.h"
#import <ShareSDK/ShareSDK.h>
@interface ArticleActViewController ()<UIWebViewDelegate>{
    NSString *UrlStr;
}
@property(nonatomic,assign)BOOL isCollections;
@property(nonatomic,strong)WebBottomView *BottomView;
@end

@implementation ArticleActViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:self.picture.shortTitle];
    [self.view addSubview:customNav];
    //初始化web
    [self setupWebView];
    [self setupWebBottomView];
    [self LoadNewData];
}

-(void)LoadNewData{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"articleId"]=_picture.ID;
    if ([UserDefaults boolForKey:@"isLogin"]) {
        dict[@"userId"]=[UserDefaults objectForKey:@"userId"];
    }
    [HttpTool post:KAudioDetail params:dict success:^(id json) {
        if ([json[@"code"] intValue]==0) {
            NSDictionary *success = json[@"obj"];
            NSLog(@"%@",KAudioDetail);
            _isCollections=[success[@"isCollections"] boolValue];
            [self updatebBottomView];
        }
  
    } failure:^(NSError *error) {
    }];
}
-(void)setupWebView{
    UIWebView *web=[UQFactory webViewWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, KScreenHeight-35-KnavHeight)];
    [self.view addSubview:web];
    web.delegate=self;
    web.scrollView.showsVerticalScrollIndicator = NO;
    UrlStr=[KActivityDetail stringByAppendingFormat:@"&articleId=%@",_picture.ID];
    NSURL *url=[NSURL URLWithString:UrlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    
}
-(void)setupWebBottomView{
    
    WebBottomView *BottomView=[[WebBottomView alloc]init];
    BottomView.height=35;
    BottomView.top=KScreenHeight-BottomView.height;
    BottomView.width=KScreenWidth;
    [BottomView.SharedButton addTarget:self action:@selector(sharedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [BottomView.SavedButton addTarget:self action:@selector(shouCangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    BottomView.ReadNumLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:BottomView];
    self.BottomView=BottomView;
}
-(void)updatebBottomView{
    self.BottomView.ReadNumLabel.text=[NSString stringWithFormat:@"阅读:%@",_picture.visitTotal];
    [self.BottomView.SavedButton setTitle:[NSString stringWithFormat:@"收藏"] forState:UIControlStateNormal];
    if(_isCollections){
        self.BottomView.SavedButton.selected=YES;
    }
}
#pragma mark target
//收藏
-(void)shouCangButtonClick:(UIButton *)btn{
    
    if(![UserDefaults objectForKey:@"userId"]){
        [Notifier UQToast:self.view text:@"需要注册/登录后才能收藏" timeInterval:NyToastDuration];
        return;
    }
    if (_isCollections ||btn.selected) {
        [Notifier UQToast:self.view text:@"您已收藏" timeInterval:NyToastDuration];
        return;
    }
    btn.selected=YES;
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict [@"tag"]=self.tag;
    dict [@"articleId"]=_picture.ID;
    dict [@"userId"]=[UserDefaults objectForKey:@"userId"];
    [HttpTool post:KAddCollectionsAct params:dict success:^(id json) {
        [Notifier UQToast:self.view text:@"收藏成功" timeInterval:NyToastDuration];
    } failure:^(NSError *error) {
    }];
    
}
//分享

-(void)sharedButtonClick{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon-@3x.png" ofType:nil];//放分享的ICON图标
    
    //构造分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:@""
                                       defaultContent:@"音频类的 APP"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"创业说"
                                                  url:UrlStr
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
      //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                           targets:@[@"统计标识1", @"统计标识2"]        //可设置需要的统计的标识，如以分类名称、标题等信息作为标识。
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
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

@end
