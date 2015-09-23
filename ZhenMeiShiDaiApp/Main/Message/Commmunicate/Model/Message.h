//
//  Message.h
//  
//
//  Created by 张锋 on 15/3/6.
//  Copyright (c) 2015年 张锋. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    Messagetypeme=0,//自己
    Messagetypeother=1 //别人
    
}Messagetype;
@interface Message : NSObject
@property(nonatomic,copy)NSString *content;
@property(nonatomic ,strong)NSNumber *ID;
@property(nonatomic ,strong)NSNumber *parentId;
@property(nonatomic ,strong)NSNumber *receiverId;
@property(nonatomic ,strong)NSNumber *userId;

@property(nonatomic,copy)NSString *time;
@property(nonatomic,assign) Messagetype type;
@property(nonatomic,assign)BOOL HidenTime;//是否隐藏时间

@end
/*
 content = fasdf;
 id = 47;
 parentId = 13;
 receiverId = 0;
 userId = 20;
 userImg = "upload/images/1435733477762.20150701145508.png";
 userName = we;
 */