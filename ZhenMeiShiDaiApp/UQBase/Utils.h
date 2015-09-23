//
//  Utils.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
@interface Utils : NSObject
@property (nonatomic,strong) ViewController *viewVC;

/**
 *	@brief	判断网络是否已连接
 *	@return Boolean
 */
+ (BOOL)isNetworkConnected;

+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+(NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr;

/**
 *  计算帖子内容的高度
 *
 *  @param newsModel 内容model
 *
 *  @return 高度
 */
+ (CGFloat)getContentStrHeight:(NSString*)news;
/**
 *  计算评论的高度
 *
 *  @param commentModel 评论model
 *
 *  @return 高度
 */

+ (CGFloat)getContentHeight:(NSString *)comment;

+ (CGFloat)getNameHeight:(NSString *)str width:(CGFloat)width;

@end
