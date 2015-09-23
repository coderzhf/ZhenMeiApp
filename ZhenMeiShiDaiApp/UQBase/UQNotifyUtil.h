//
//  UQNotifyUtil.h
//  UQPlatformSDK
//
//  Created by Dyfei on 14/11/5.
//  Copyright (c) 2014年 UQ Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define NotifyImmediately 0.0
#define NotifyDuration    0.5
#define NyToastDuration   1.2

#define Notifier [UQNotifyUtil defaultNotify]

@class UQSpinningCircle;
@interface UQNotifyUtil : NSObject <MBProgressHUDDelegate>
{
    MBProgressHUD *_progressHUD;
    UQSpinningCircle *_spinningCircle;
}
@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, retain) UQSpinningCircle *spinningCircle;

+ (UQNotifyUtil *)defaultNotify;


/**
 *	@brief	是否存在Hud
 *	@return	Boolean
 */
- (BOOL)hasHud;

/**
 *	@brief	显示Hud
 *	@param 	view 	父视图
 *	@param 	text 	文本
 *	@return progressHUD
 */
- (MBProgressHUD *)showHud:(UIView *)view text:(NSString *)text;

/**
 *	@brief	显示Hud
 *	@param 	view        父视图
 *	@param 	text        文本
 *	@param 	detailsText 详细文本
 *	@return progressHUD
 */
- (MBProgressHUD *)showHud:(UIView *)view
                      text:(NSString *)text
               detailsText:(NSString *)detailsText;

/**
 *	@brief	显示Hud
 *	@param 	view         父视图
 *	@param 	text         文本
 *	@param 	detailsText  详细文本
 *	@param 	opacity 	 透明度
 *	@param 	cornerRadius 圆角半径
 *	@param 	animation 	 动画类型
 *	@param 	customView 	 自定义视图
 *	@return progressHUD
 */
- (MBProgressHUD *)showHud:(UIView *)view
                      text:(NSString *)text
               detailsText:(NSString *)detailsText
                   opacity:(float)opacity
              cornerRadius:(float)cornerRadius
                 animation:(MBProgressHUDAnimation)animation
                customView:(UIView *)customView;

/**
 *	@brief	显示Hud
 *	@param 	view         父视图
 *	@param 	text         文本
 *	@param 	detailsText  详细文本
 *	@param 	opacity 	 透明度
 *	@param 	cornerRadius 圆角半径
 *	@param 	mode         指示器类型
 *	@param 	animation 	 动画类型
 *	@param 	customView 	 自定义视图
 *	@return progressHUD
 */
- (MBProgressHUD *)showHud:(UIView *)view
                      text:(NSString *)text
               detailsText:(NSString *)detailsText
                   opacity:(float)opacity
              cornerRadius:(float)cornerRadius
                      mode:(MBProgressHUDMode)mode
                 animation:(MBProgressHUDAnimation)animation
                customView:(UIView *)customView;

/**
 *	@brief	显示弹窗信息
 *	@param 	view 	父视图
 *	@param 	text 	文本
 *	@param 	timeInterval 显示时间
 *	@return	progressHUD
 */
- (MBProgressHUD *)UQToast:(UIView *)view
                      text:(NSString *)text
              timeInterval:(NSTimeInterval)timeInterval;


/**
 *	@brief	消失Hud
 *	@param 	timeInterval  时间
 */
- (void)dismissHud:(NSTimeInterval)timeInterval;

@end
