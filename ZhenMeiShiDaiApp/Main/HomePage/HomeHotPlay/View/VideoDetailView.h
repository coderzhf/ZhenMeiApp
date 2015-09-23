//
//  VideoDetailView.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/18.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VideoDetailViewDelegate<NSObject>
@optional
-(void)VideoDetailViewButtonClick:(UIButton *)btn;
@end
@interface VideoDetailView : UIView
-(void)setVideoDetailWithplayNum:(NSInteger)num shared:(BOOL)shared duration:(NSString *)duration;
@property(nonatomic,weak)id<VideoDetailViewDelegate>delegate;
@property(nonatomic,weak)UIButton *PlayNumButton;
@property(nonatomic,weak)UIButton *ShareButton;
@end
