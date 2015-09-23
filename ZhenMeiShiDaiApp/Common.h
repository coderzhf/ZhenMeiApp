//
//  Common.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#ifndef ZhenMeiShiDaiApp_Common_h
#define ZhenMeiShiDaiApp_Common_h


#define KnavHeight ([UIScreen mainScreen].bounds.size.height==736? 77: 50)
#define KTarBarHeight ([UIScreen mainScreen].bounds.size.height==736? 64: 40)

//获得窗口
#define AppWindow ((UIWindow *)[[UIApplication sharedApplication].windows firstObject])

//获取物理屏幕的大小
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)

//判断系统版本
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7 [[UIDevice currentDevice].systemVersion floatValue] == 7.0
#define IOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#define UserDefaults [NSUserDefaults standardUserDefaults]

//RGB获取颜色
#define ZhenMeiRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0  alpha:1.0]
#define ZhenMeiRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



#endif
