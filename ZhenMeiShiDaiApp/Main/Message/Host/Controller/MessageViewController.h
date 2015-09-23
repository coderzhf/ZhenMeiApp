//
//  MessageViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/26.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController
@property(nonatomic,copy)void (^readMessageBlock)();

@end
