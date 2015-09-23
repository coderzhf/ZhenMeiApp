//
//  ViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

{
    UIImageView *_tabbarView;   //tabbarView的背景
    
}

@property (nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,assign)BOOL isNewMessage;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)UIButton *badgeButton;


@end

