//
//  PersonalInforViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^changeNickNameBlock) (NSString * nickNameStr);
@interface PersonalInforViewController : UIViewController
@property (nonatomic ,strong)changeNickNameBlock nickNameblock;
- (void)changeSuccessBlock:(changeNickNameBlock)nickNameblock;

@end
