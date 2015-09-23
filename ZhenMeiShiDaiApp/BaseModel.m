
//
//  BaseModel.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/21.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

//抽出一个类，来填充数据

//自定义初始化方法
- (id)initWithDic:(NSDictionary *)dic
{
    self =[super init];
    if (self != Nil) {
        //填充数据
        [self _dicToObject:dic];
    }
    return self;
    
}

//设置映射关系的字典
- (NSDictionary *)keyToArr:(NSDictionary *)dic
{
    //创建映射关系的字典
    NSMutableDictionary *keyArr=[NSMutableDictionary dictionary ];
    for (NSString *key in dic) {
        [keyArr setObject:key forKey:key];
    }
    return keyArr;
}
//得到set方法
-(SEL)settingModelName:(NSString *)modelName
{
    //取出首字母然后变为大写字母
    NSString *firstName=[[modelName substringToIndex:1] uppercaseString];
    //取出剩余的部分
    NSString *endName=[modelName substringFromIndex:1];
    NSString *setName=[NSString stringWithFormat:@"set%@%@:",firstName,endName];
    //返回一个方法
    SEL setAction = NSSelectorFromString(setName);
    return  setAction;
    
}
//把字典中的内容写入到model中的属性里

-(void)_dicToObject:(NSDictionary *)dic
{
    //获取到映射关系字典
    NSDictionary *keyArr=[self keyToArr:dic];
    for (NSString *key in keyArr) {
        //获取映射关系字典中的value->model的属性
        NSString *modelName = [keyArr objectForKey:key];
        SEL setAction=[self settingModelName:modelName];
        if ([self respondsToSelector:setAction])
        {
            id value=[dic objectForKey:key];
            [self performSelector:setAction withObject:value];
            
        }
        
    }
    
    
    
}


@end
