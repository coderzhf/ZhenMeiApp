//
//  AppDelegate.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationInfoTool.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,strong) NSString *locationInfor;
@property (nonatomic ,strong) NSMutableArray *categoryArray;//请求的类别项目
@property (nonatomic ,strong) NSArray *productArray;//请求的类别项目

@end

