//
//  PlayerResult.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/26.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerResult : NSObject
@property(nonatomic,copy)NSString *attachment;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)NSInteger collectionTotal;//总收藏量
@property(nonatomic,assign)BOOL isCollections; //是否收藏
@property(nonatomic,copy)NSString *shortTitle;
@property(nonatomic,assign)NSInteger visitTotal;//观看量
@property(nonatomic,copy) NSString *ID;//编号
@end
/*
 {
 "code":0,"
 msg":"详情查看成功",
 "obj":
 {"attachment":"mp3/yb.mp3","author":"乔布斯","collectionTotal":1,"content":"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;雷克塞加入联盟时间不长，靠着凶悍的外表与凌厉的气势牢牢稳固住了自己的地位，可谓峡谷一霸，无人敢撩其虎须，这么霸道究竟随了谁？","id":1,"isCollections":0,"releaseSysTime":"2015-06-10","shortTitle":"乔布斯在斯坦福大学的演讲","visitTotal":57}
 }

 */