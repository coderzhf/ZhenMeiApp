//
//  UQSpinningCircle.m
//  UQPlatformSDK
//
//  Created by Dyfei on 14/11/4.
//  Copyright (c) 2014年 UQ Interactive. All rights reserved.
//

#import "UQSpinningCircle.h"
#import <QuartzCore/QuartzCore.h>

@interface UQSpinningCircle ()
{
    float _progress;
}
@end

@implementation UQSpinningCircle



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return self;
}

+ (UQSpinningCircle *)circleWithSize:(UQSpinningCircleSize)size andColor:(UIColor *)color
{
    float width;
    switch (size)
    {
        case UQSpinningCircleSizeDefault:
            width = 40;
            break;
        case UQSpinningCircleSizeLarge:
            width = 50;
            break;
        case UQSpinningCircleSizeSmall:
            width = 10;
            break;
    }
    UQSpinningCircle *circle = [[UQSpinningCircle alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    circle.isAnimating = YES;
    circle.color = color;
    return circle;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *view in self.subviews)
    {
        if ([view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

- (void)setIsAnimating:(BOOL)animating
{
    _isAnimating = animating;
    if(animating) {
        [UIView animateWithDuration:0.9 animations:^{
            self.alpha = 1.0;
        }];
        [self addRotationAnimation];
    } else {
        [self hide];
    }
}

- (void)hide
{
    [UIView animateWithDuration:0.45 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.layer removeAllAnimations];
    }];
}

-(void)drawAnnular
{
    _progress += 0.05;
    if(_progress > M_PI) _progress = 0;
    CGFloat lineWidth = 3.25f;
    if(_circleSize == UQSpinningCircleSizeDefault)
        lineWidth = 2.0f;
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - 16 - lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI/2 - _progress*2);
    
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] set];
    
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapSquare;
    processPath.lineWidth = lineWidth;
    CGFloat endAngle = ((float)M_PI + startAngle);
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if(_hasGlow) {
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 0), 6, _color.CGColor);
    }
    [_color set];
    [processPath stroke];
    CGContextRestoreGState(context);
    
    if(_isAnimating) [self addRotationAnimation];
}

- (void)addRotationAnimation
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimation.duration = _speed;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.cumulative = YES;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)drawRect:(CGRect)rect
{
    [self drawAnnular];
}

@end
