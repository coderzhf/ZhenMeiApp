//
//  PlaySlider.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/18.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaySlider : UIControl
@property (nonatomic, assign) CGFloat value;        /* From 0 to 1 */
@property (nonatomic, assign) CGFloat middleValue;  /* From 0 to 1 */

@property (nonatomic, strong) UIColor* thumbTintColor;
@property (nonatomic, strong) UIColor* minimumTrackTintColor;
@property (nonatomic, strong) UIColor* middleTrackTintColor;
@property (nonatomic, strong) UIColor* maximumTrackTintColor;

@property (nonatomic, readonly) UIImage* thumbImage;
@property (nonatomic, strong) UIImage* minimumTrackImage;
@property (nonatomic, strong) UIImage* middleTrackImage;
@property (nonatomic, strong) UIImage* maximumTrackImage;

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;
@end
