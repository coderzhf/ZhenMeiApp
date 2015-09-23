//
//  NSString+Extension.m
//  QQ聊天布局
//
//  Created by 张锋 on 15/3/8.
//  Copyright (c) 2015年 张锋. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString(Extension)
-(CGSize )sizeWithFont:(UIFont *)font Maxsize:(CGSize)maxsize{
    NSDictionary *arrt=@{NSFontAttributeName:font};
    
    return [self boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:arrt context:nil].size;
    
}
@end
