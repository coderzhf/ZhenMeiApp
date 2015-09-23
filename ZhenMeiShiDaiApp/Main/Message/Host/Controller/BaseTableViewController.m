//
//  BaseTableViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/26.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BasicTableViewControllerCell.h"
@interface BaseTableViewController ()<MJRefreshBaseViewDelegate>

@end

@implementation BaseTableViewController

- (instancetype)init
{
    if (self = [super init]) {
        _refreshMode = BasicTableViewControllerRefeshModeNone;
        _sectionsNumber = 1;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:(245 / 255.0) green:(245 / 255.0) blue:(245 / 255.0) alpha:1];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:[self.cellClass description] bundle:nil] forCellReuseIdentifier:[self.cellClass description]];

    
    [self setupRefreshView];
  
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

//刷新控件
-(void)setupRefreshView{
    //顶部 下拉控件
    MJRefreshHeaderView *header=[MJRefreshHeaderView header];
    header.scrollView=self.tableView;
    header.delegate=self;
    self.header=header;
    //初次登陆加载数据
    [self LoadNewData];
    //底部 上拉控件
    MJRefreshFooterView *foot=[MJRefreshFooterView footer];
    foot.scrollView=self.tableView;
    foot.delegate=self;
    self.foot=foot;
    
}

-(void)dealloc{
    //释放上拉刷新控件
    [self.foot free];
    [self.header free];
}
#pragma mark MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {//加载更多数据 上拉
        [self LoadMoreData];
    }else{//加载更新数据 下拉
        [self LoadNewData];
    }
}
//上拉加载更多数据
-(void)LoadMoreData{
    [self.foot endRefreshing];
    
}
-(void)LoadNewData{
    
}

#pragma mark - data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = (self.sectionsNumber == 1) ? self.dataArray.count : [self.dataArray[section] count];
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasicTableViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.cellClass description]];
    if (!cell) {
        cell = [[self.cellClass alloc] init];
    }
    if (self.sectionsNumber == 1) {
        if (self.dataArray.count) {
            cell.model = self.dataArray[indexPath.row];

        }
    } else if (self.sectionsNumber > 1){
        cell.model = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - funcs for subControllers rewrite

- (void)pullDownRefreshOperation
{
    
}
@end
