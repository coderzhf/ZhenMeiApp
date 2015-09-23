//
//  HttpTool.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/29.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
@implementation HttpTool
+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 设置超时时间
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 60.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
     mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];//设置相应内容类型
    //2.发送Post请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary*responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            
            
        }
    }];
}
@end
