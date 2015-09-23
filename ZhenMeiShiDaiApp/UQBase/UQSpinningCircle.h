//
//  UQSpinningCircle.h
//  UQPlatformSDK
//
//  Created by Dyfei on 14/11/4.
//  Copyright (c) 2014年 UQ Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UQSpinningCircleSizeDefault,
    UQSpinningCircleSizeLarge,
    UQSpinningCircleSizeSmall
} UQSpinningCircleSize;

@interface UQSpinningCircle : UIView
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL hasGlow;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) UQSpinningCircleSize circleSize;

+ (UQSpinningCircle *)circleWithSize:(UQSpinningCircleSize)size andColor:(UIColor*)color;

@end
