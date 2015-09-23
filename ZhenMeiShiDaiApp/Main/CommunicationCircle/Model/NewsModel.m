//
//  NewsModel.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/17.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "NewsModel.h"
@implementation NewsModel
- (id)initWithDic:(NSDictionary *)dic
{
    self =[super initWithDic:dic];
    if (self != Nil) {
        //填充数据
        self.topicInfoId = [dic objectForKey:@"id"];
    }
    return self;
    
}

@end
