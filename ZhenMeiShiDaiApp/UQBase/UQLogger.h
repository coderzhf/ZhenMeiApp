//
//  UQLog.h
//  UQPlatformSDK
//
//  Created by Dyfei on 14/10/22.
//  Copyright (c) 2014年 UQ Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UQLogger : NSObject

/**
 *	@brief  调试日志
 *	@param 	formatString  格式化字符串
 *	@param 	...           参数列表
 */
FOUNDATION_EXTERN void UQLog(NSString *formatString, ...);

/**
 *	@brief	调试日志
 *	@param 	formatString  格式化字符串
 *	@param 	...           参数列表
 */
+ (void)log:(NSString *)formatString, ...;

@end
