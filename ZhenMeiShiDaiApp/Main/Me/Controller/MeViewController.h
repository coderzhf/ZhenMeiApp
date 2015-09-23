//
//  MeViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^readSuccessBlock)(void);
@interface MeViewController :UIViewController
@property (nonatomic ,strong) readSuccessBlock readblock;

- (void)readSuccess:(readSuccessBlock)block;
@end
