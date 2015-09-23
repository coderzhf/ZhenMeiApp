//
//  BaseTableViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/26.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    BasicTableViewControllerRefeshModeNone                    = 0,
    BasicTableViewControllerRefeshModeHeaderRefresh           = 1 << 0,
    BasicTableViewControllerRefeshModeFooterRefresh           = 1 << 1
} BasicTableViewControllerRefeshMode;


@interface BaseTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger sectionsNumber;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) Class cellClass;
@property (nonatomic, copy) Class cellModelClass;
@property (nonatomic, assign) BasicTableViewControllerRefeshMode refreshMode;

@property(nonatomic,strong)MJRefreshFooterView *foot;
@property(nonatomic,strong)MJRefreshHeaderView *header;
//上拉加载更多数据
-(void)LoadMoreData;
//下拉更新数据
-(void)LoadNewData;
// 如果需要刷新，子类须重写此方法
- (void)pullDownRefreshOperation;
@end
