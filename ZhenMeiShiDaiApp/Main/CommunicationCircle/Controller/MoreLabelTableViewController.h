//
//  MoreLabelTableViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/22.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectLabelBlock) (NSNumber *number);
@interface MoreLabelTableViewController : UIViewController
@property (nonatomic ,strong) NSArray *Array;//请求的类别项目
@property (nonatomic,strong) selectLabelBlock selectblock;

- (void)returnNumber:(selectLabelBlock)selectLabelblock;
@end
