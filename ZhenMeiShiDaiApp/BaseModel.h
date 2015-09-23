//
//  BaseModel.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/21.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//自定义初始化方法
- (id)initWithDic:(NSDictionary *)dic;

//设置映射关系的字典
- (NSDictionary *)keyToArr:(NSDictionary *)dic;
@end
