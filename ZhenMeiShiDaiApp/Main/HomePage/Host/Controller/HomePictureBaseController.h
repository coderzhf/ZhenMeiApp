//
//  HomePictureBaseController.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleActViewController.h"

@interface HomePictureBaseController : UITableViewController
@property (nonatomic, strong) NSMutableArray *dataArray;//数据数组
@property(nonatomic,strong)MJRefreshFooterView *foot;
@property(nonatomic,strong)MJRefreshHeaderView *header;
@property(nonatomic,assign)NSInteger pageNoStr;
//上拉加载更多数据
-(void)LoadMoreData;
//下拉更新数据
-(void)LoadNewData;
    
@end
