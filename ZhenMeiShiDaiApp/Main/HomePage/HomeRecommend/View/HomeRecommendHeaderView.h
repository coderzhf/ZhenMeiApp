//
//  HomeRecomendHeaderView.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecommedButtonView.h"
@class HomePicture;
@protocol HomeRecommedHeaderViewDelegate<NSObject>
@optional
-(void)HomeRecommedHeaderViewWithpicture:(HomePicture *)picture;
@end
@interface HomeRecommendHeaderView : UIView
@property(nonatomic,strong)HomeRecommedButtonView *ButtonView;
@property(nonatomic,weak)id<HomeRecommedHeaderViewDelegate>delegate;

@end
