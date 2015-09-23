//
//  HomeRecommedButtonView.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecLabel.h"
@protocol HomeRecommedButtonViewDelegate<NSObject>
@optional
-(void)HomeRecommedButtonClickWithLabel:(HomeRecLabel *)label;
@end
@interface HomeRecommedButtonView : UIView
@property(nonatomic,weak)id<HomeRecommedButtonViewDelegate>delegate;
@end
