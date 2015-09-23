//
//  MyCommunicationViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/7/1.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommunicationViewController : UIViewController
{
    //定义数组用于存储当前选中单元格的状态
    NSMutableArray *_isAllContent;
    NSMutableArray *_stateArr;//是否显示全文
}


//所有的帖子内容数组
@property (nonatomic ,strong) NSMutableArray *AllDataArray;

@end
