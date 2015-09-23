//
//  PrivateMessageModel.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/7/1.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateMessageModel : UICollectionViewFlowLayout
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *userImg;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSNumber *parentId;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSNumber *receiverId;




@end
/*
 {"code":0,"list":
 [{"content":"hi个啊","id":12,"parentId":12,"receiverId":0,"time":"","userId":0,"userImg":"upload/images/1435721468971.png","userName":"刘帆"},
 {"content":"你会后悔","id":11,"parentId":11,"receiverId":0,"time":"","userId":0,"userImg":"upload/images/1435721468971.png","userName":"刘帆"},
 {"content":"看见了","id":10,"parentId":10,"receiverId":0,"time":"1小时前","userId":0,"userImg":"upload/images/1435721468971.png","userName":"刘帆"},
 {"content":"呵呵哒","id":5,"parentId":5,"receiverId":0,"time":"1天前","userId":0,"userImg":"upload/images/1435721468971.png","userName":"刘帆"}],
 "msg":"查看私信成功"
 */