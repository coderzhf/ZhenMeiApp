//
//  HomeVideo.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeVideo : NSObject
@property(nonatomic,copy)NSString *author;//作者
@property(nonatomic,copy)NSString *origin;//来源
@property(nonatomic,copy)NSString *shortTitle;//短标题

@property(nonatomic,copy)NSString *picPath;//小图标
@property(nonatomic,copy)NSString *imgPatch;//大图标
@property(nonatomic,assign)BOOL isCollections;
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSNumber *visitTotal;

@end
/*
 
 {"code":0,"list":[{"author":"吴翠兰","collectionTotal":1,"commentTotal":0,"content":"日日特瑞特瑞特sdfsdfsfddfsdfsdfsdfsdfsdfsdfsdfsddfgdfgghj法国就恢复恢复规划","id":28,"imgPatch":"","isCollections":0,"picPath":"","shortTitle":"再回首","visitTotal":5},{"author":"伍思凯","collectionTotal":2,"commentTotal":0,"content":"啥地方法规和对他个人个人个人各地人个人个人规定热热热斯蒂芬斯蒂芬斯蒂芬斯蒂芬斯蒂芬斯蒂芬斯蒂芬的发生的第三方斯蒂芬发生的斯蒂芬斯蒂芬第三方第三方","id":39,"imgPatch":"upload/images/1435635028573_1432521095977.png","isCollections":0,"picPath":"upload/images/1435635028573_1432521095977.png","shortTitle":"特别的爱给特别的你","visitTotal":3},{"author":"江珊","collectionTotal":3,"commentTotal":0,"content":"法规和的范甘迪发鬼地方","id":40,"imgPatch":"","isCollections":0,"picPath":"","shortTitle":"梦里水乡","visitTotal":2},{"author":"范玮琪","collectionTotal":1,"commentTotal":0,"content":"范玮琪&mdash;那些花儿专辑","id":38,"imgPatch":"upload/images/1435634759821_1432521095977.png","isCollections":0,"picPath":"upload/images/1435634759821_1432521095977.png","shortTitle":"那些花儿","visitTotal":1}],"msg":"查询成功"}
 */