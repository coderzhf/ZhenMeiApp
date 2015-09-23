//
//  HomePicture.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "BaseModel.h"

@interface HomePicture : BaseModel
@property(nonatomic,copy)NSString *content;//内容
@property(nonatomic,copy)NSString *shortTitle;//小标题

@property(nonatomic,copy)NSString *imgPatch;//图片来源
@property(nonatomic,strong)NSNumber *visitTotal;//阅读量
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,copy)NSString *collectionTotal;//收藏
@property(nonatomic,strong)NSNumber *commentTotal;//评论
@property(nonatomic,assign)BOOL isCollections;//是否已经收藏
@property(nonatomic ,strong)NSString *releaseSysTime; //时间
@property (nonatomic ,strong)NSString *address;//地址
@property(nonatomic,copy)NSString *sponsor;//主办方

@end
/*
 {"code":0,"list":[{"author":"乔布斯","collectionTotal":10,"commentTotal":0,"content":"仔细研究了一下女王的背景故事：“雷克塞是她族群中体型最大,脾气最暴的.”等等,这残暴的性子似曾相识,大龙貌似也是体型大且残暴,“纳什男爵位于这里食物链的顶端,长期在暗影岛这块充满能量的土地上生长,让它拥有了巨大的身体和无穷的力量……”","id":3,"imgPatch":"images/touImg.jpg","isCollections":0,"picPath":"images/touImg.jpg","shortTitle":"活动活动","visitTotal":61},{"author":"地方","collectionTotal":1,"commentTotal":0,"content":"地方","id":9,"imgPatch":"","isCollections":0,"picPath":"","shortTitle":"梯恩特价房了撒","visitTotal":15},{"author":"乔布斯","collectionTotal":2,"commentTotal":0,"content":"雷克塞加入联盟时间不长,靠着凶悍的外表与凌厉的气势牢牢稳固住了自己的地位,可谓峡谷一霸,无人敢撩其虎须,这么霸道究竟随了谁？","id":1,"imgPatch":"","isCollections":0,"origin":"苹果CEO","picPath":"","shortTitle":"乔布斯在斯坦福大学的演讲乔","visitTotal":69},{"author":"水电费","collectionTotal":0,"commentTotal":0,"content":"水电费","id":37,"imgPatch":"","isCollections":0,"picPath":"","shortTitle":"水电费","visitTotal":1},{"author":"水电费","collectionTotal":0,"commentTotal":0,"content":"水电费速度","id":24,"imgPatch":"","isCollections":0,"picPath":"","shortTitle":"实施水电费","visitTotal":0}],"msg":"查询成功"}
 
 */
