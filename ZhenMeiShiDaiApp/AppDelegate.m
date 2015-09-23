//
//  AppDelegate.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/QZoneConnection.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "MobClick.h"

@interface AppDelegate ()
@property(nonatomic,strong)LocationInfoTool *tool;
@property(nonatomic,strong)ViewController *mainVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mainVC = [[ViewController alloc] init];
    self.window.rootViewController = _mainVC;
    [self.window makeKeyAndVisible];
    //获取当前应用版本号
    [self getVersion];
    
    //获取类别项目
    [self LoadCategory];

    //程序启动就获取地理位置
    _tool = [[LocationInfoTool alloc] init];
    [_tool locationInfoUpdate];
    [_tool returnLocat:^(CLLocationCoordinate2D locationCorrrdinate) {
        _latitude = locationCorrrdinate.latitude;
        _longitude = locationCorrrdinate.longitude;
    }];
    [_tool returnLocation:^(NSString *location) {
            _locationInfor = location;
             }];
    
      [ShareSDK registerApp:@"7b8f42726909"];
    [self initSharePlat];
    //开启QQ空间网页授权开关(optional)
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    
    //集成友盟统计
    [MobClick startWithAppkey:@"55a5b61067e58e5efd005f5a" reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:NO];
    return YES;
}

- (void)getVersion
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    if ([UserDefaults boolForKey:@"isLogin"]) {
        dict [@"userId"]=[UserDefaults objectForKey:@"userId"];
    }
    [Utils post:KShowParams params:dict success:^(id json) {
        if ([[json objectForKey:@"code"] intValue] ) {
            return ;
        }
        id obj = [json objectForKey: @"obj"];
        NSLog(@"%@",obj);
        _mainVC.number= [NSString stringWithFormat:@"%@",[obj objectForKey: @"count"]];
        NSLog(@"number%@",_mainVC.number);
        _mainVC.isNewMessage=[[obj objectForKey: @"isNewMessage"]boolValue];
        [UserDefaults setObject:[obj objectForKey: @"paramValue"] forKey:@"version"];
     } failure:^(NSError *error) {
        
    }];
}

- (void)LoadCategory
{
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:AppWindow text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    [Utils post:KShowAll params:nil success:^(id json) {
        if ([[json objectForKey:@"code"] intValue] ) {
            return ;
        }
        _productArray = [json objectForKey:@"project"];
        _categoryArray = [json objectForKey:@"category"];
        
    } failure:^(NSError *error) {
    }];
    
    
}
#pragma mark---初始化社交平台
-(void)initSharePlat
{
    // wx3550ba31d894f565  61137eef857d8ffa565a2b8664c54108
    [ShareSDK connectWeChatWithAppId:@"wx5cd9c7cd2e46fc76"
                           appSecret:@"6702cc846481570d6fc27cf07c0fcb6c"
                           wechatCls:[WXApi class]];
    
    /**
     
     1104546543  PD8McRnhFEjoOpdc
     **/
    [ShareSDK connectQZoneWithAppKey:@"1104735700"
                           appSecret:@"jC8cfppdMfvgzsYf"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1104735700"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
 }

#pragma mark - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

//iOS 4.2+
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    UIBackgroundTaskIdentifier identifier = [application beginBackgroundTaskWithExpirationHandler:^{
//        NSLog(@"back");
//    }  ];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //获取当前应用版本号
    [self getVersion];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
