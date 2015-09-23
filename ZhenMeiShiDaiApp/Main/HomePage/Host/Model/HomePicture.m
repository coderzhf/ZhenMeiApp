//
//  HomePicture.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomePicture.h"

@implementation HomePicture
- (id)initWithDic:(NSDictionary *)dic
{
    self =[super initWithDic:dic];
    if (self != Nil) {
        self.ID = dic[@"id"];
        if (self.releaseSysTime) {
            self.releaseSysTime = [self returnStr:dic[@"releaseSysTime"]];
        }
    }
    return self;
    
}
- (NSString *)returnStr:(NSString*)string
{
    NSString *str = [[string substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    
    [formater setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate* date = [formater dateFromString:string];
    NSDateComponents *weekComp = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekDayEnum = [weekComp weekday];
    NSString *weekDays = nil;
    switch (weekDayEnum) {
        case 1:
            weekDays = @"周日";
            break;
        case 2:
            weekDays = @"周一";
            break;
        case 3:
            weekDays = @"周二";
            break;
        case 4:
            weekDays = @"周三";
            break;
        case 5:
            weekDays = @"周四";
            break;
        case 6:
            weekDays = @"周五";
            break;
        case 7:
            weekDays = @"周六";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@%@",str,weekDays];
}

@end
