//
//  HttpTool.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/29.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject
+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
