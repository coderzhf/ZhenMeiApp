//
//  WebBottomView.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/27.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayButton.h"
@interface WebBottomView : UIView
@property (weak, nonatomic)PlayButton *SharedButton;
@property (weak, nonatomic)PlayButton *SavedButton;
@property (weak, nonatomic)UILabel *ReadNumLabel;


@end
