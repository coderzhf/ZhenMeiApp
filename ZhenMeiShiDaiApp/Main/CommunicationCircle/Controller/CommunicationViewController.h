//
//  CommunicationViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunicationViewController : UIViewController
{
    //定义数组用于存储当前选中单元格的状态
    NSMutableArray *_stateArr;
    NSMutableArray *_isAllContent;

}
@property (nonatomic ,assign)  BOOL isFocus;


//所有的帖子内容数组
@property (nonatomic ,strong) NSMutableArray *AllDataArray;
//所有的帖子评论数组
@property (nonatomic ,strong) NSMutableArray *AllCommentsArray;



@end
