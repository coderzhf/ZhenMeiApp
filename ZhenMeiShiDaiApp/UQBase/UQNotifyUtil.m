//
//  UQNotifyUtil.m
//  UQPlatformSDK
//
//  Created by Dyfei on 14/11/5.
//  Copyright (c) 2014年 UQ Interactive. All rights reserved.
//

#import "UQNotifyUtil.h"
#import "Common.h"
#import "UQSpinningCircle.h"

@implementation UQNotifyUtil
@synthesize progressHUD = _progressHUD;
@synthesize spinningCircle = _spinningCircle;

+ (UQNotifyUtil *)defaultNotify
{
    static UQNotifyUtil *notifyUtil = nil;
    @synchronized (self) {
        if (notifyUtil == nil) {
            notifyUtil = [[[self class] alloc] init];
        }
        return notifyUtil;
    }
}

- (BOOL)hasHud
{
    return self.progressHUD ? YES : NO;
}

- (MBProgressHUD *)showHud:(UIView *)view text:(NSString *)text
{
    return [self showHud:view text:text detailsText:nil];
}

- (MBProgressHUD *)showHud:(UIView *)view text:(NSString *)text detailsText:(NSString *)detailsText
{
    UIColor *circleColor= ZhenMeiRGB(50, 155, 255);
    self.spinningCircle = [UQSpinningCircle circleWithSize:UQSpinningCircleSizeLarge andColor:circleColor];
    return [self showHud:view text:text detailsText:detailsText opacity:0.7f cornerRadius:5.0f animation:MBProgressHUDAnimationFade customView:self.spinningCircle];
}

- (MBProgressHUD *)showHud:(UIView *)view text:(NSString *)text detailsText:(NSString *)detailsText opacity:(float)opacity cornerRadius:(float)cornerRadius animation:(MBProgressHUDAnimation)animation customView:(UIView *)customView
{
    return [self showHud:view text:text detailsText:detailsText opacity:opacity cornerRadius:cornerRadius mode:MBProgressHUDModeCustomView animation:animation customView:customView];
}

- (MBProgressHUD *)showHud:(UIView *)view text:(NSString *)text detailsText:(NSString *)detailsText opacity:(float)opacity cornerRadius:(float)cornerRadius mode:(MBProgressHUDMode)mode animation:(MBProgressHUDAnimation)animation customView:(UIView *)customView
{
    self.progressHUD = ([[MBProgressHUD alloc] initWithView:view]);
    [view addSubview:self.progressHUD];
    self.progressHUD.labelText = text;
    self.progressHUD.detailsLabelText = detailsText;
    self.progressHUD.delegate = self;
    self.progressHUD.opacity = opacity;
    self.progressHUD.cornerRadius = cornerRadius;
    self.progressHUD.mode = mode;
    self.progressHUD.animationType = animation;
    self.progressHUD.customView = customView;
    [self.progressHUD show:YES];
    return self.progressHUD;
}

- (MBProgressHUD *)UQToast:(UIView *)view text:(NSString *)text timeInterval:(NSTimeInterval)timeInterval
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.opacity = 0.6f;
    progressHUD.cornerRadius = 5.0f;
    progressHUD.margin = 5.0f;
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.animationType = MBProgressHUDAnimationFade;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = text;
    textLabel.frame = CGRectMake(0, 0, 200, 30);
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = ZhenMeiRGB(255, 255, 255);
    textLabel.numberOfLines = 1;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.adjustsFontSizeToFitWidth = YES;
    progressHUD.customView = textLabel;
    CGFloat offset = 55;
        progressHUD.yOffset = KScreenHeight/2 - textLabel.frame.size.height - offset;
    progressHUD.removeFromSuperViewOnHide = YES;
    [progressHUD hide:YES afterDelay:timeInterval];
    return progressHUD;
}

- (void)dismissHud:(NSTimeInterval)timeInterval
{
    if (timeInterval > 0) {
        [self performSelector:@selector(hideHud)
                   withObject:nil
                   afterDelay:timeInterval];
    } else {
        [self hideHud];
    }
}

- (void)hideHud
{
    [self.progressHUD hide:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (self.progressHUD == hud) {
        [self.progressHUD removeFromSuperview];
        self.progressHUD = nil;
        self.spinningCircle = nil;
    }
}

@end
