//
//  ChooseTableView.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/7/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chooseDoneBlock) (NSString *text);

@interface ChooseTableView : UITableView<UITableViewDelegate ,UITableViewDataSource>
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)chooseDoneBlock chooseDoneblock;
- (void)chooseSuccess:(chooseDoneBlock)block;
@end
