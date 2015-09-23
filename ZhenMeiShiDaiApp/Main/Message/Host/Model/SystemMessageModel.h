//
//  SystemMessageModel.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/29.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessageModel : NSObject
@property(nonatomic,strong)NSNumber *bulletinId;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *sendTime;
@property(nonatomic,copy)NSString *title;

@end
/*
 {"code":0,"list":[{"bulletinId":1,"content":"sdffffffff","sendTime":"3天前","title":"公告提醒"},{"bulletinId":4,"content":"<p>\r\n	65655665656</p>\r\n","sendTime":"3天前","title":"撒旦法撒旦"},{"bulletinId":5,"content":"<p>\r\n	65655665656</p>\r\n","sendTime":"3天前","title":"撒旦法撒旦"},{"bulletinId":6,"content":"","sendTime":"13分钟前","title":"珍惜对方水电费"}],"msg":"系统公告查看成功"}
 
 */