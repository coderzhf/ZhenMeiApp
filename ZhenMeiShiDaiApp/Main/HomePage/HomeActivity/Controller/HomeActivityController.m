//
//  HomeActivityController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeActivityController.h"
#import "HttpTool.h"
#import "HomePicture.h"

@interface HomeActivityController ()<MJRefreshBaseViewDelegate>
{
    UIButton *applyBtn;
}
@end

@implementation HomeActivityController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.backgroundColor = ZhenMeiRGB(205, 173, 0);
    applyBtn.frame = CGRectMake(KScreenWidth-60, KScreenHeight-26-KTarBarHeight, 60, 25);
    [applyBtn setTitle:@"发布活动" forState:UIControlStateNormal];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    [AppWindow addSubview:applyBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    applyBtn.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    applyBtn.hidden = YES;
    
}
-(void)LoadNewData{
    NSMutableDictionary *parmams=[NSMutableDictionary dictionary];
    self.pageNoStr=1;
    parmams[@"pageNoStr"]=[NSNumber numberWithInteger:self.pageNoStr];
    parmams[@"pageSizeStr"]=@5;
    [HttpTool post:KHomeActivity params:parmams success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomePicture *result=[[HomePicture alloc] initWithDic:dict];
            [temp addObject:result];
        }
        self.dataArray=temp;
        [self.tableView reloadData];
        //停止刷新
        [self.header endRefreshing];
        self.pageNoStr++;
    } failure:^(NSError *error) {
    }];
}
-(void)LoadMoreData{
    
    NSMutableDictionary *parmams=[NSMutableDictionary dictionary];
    parmams[@"pageNoStr"]=[NSNumber numberWithInteger:self.pageNoStr];
    parmams[@"pageSizeStr"]=@5;
    [HttpTool post:KHomeActivity params:parmams success:^(id json) {
        int msg=[json[@"code"]intValue];
        if (msg==-1) {
            [Notifier UQToast:self.view text:@"没有更多数据了..." timeInterval:NyToastDuration];
            [self.foot endRefreshing];
            return ;
        }
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomePicture *result=[[HomePicture alloc] initWithDic:dict];
            [temp addObject:result];
        }
        [self.dataArray addObjectsFromArray:temp];
        //停止刷新
        [self.foot endRefreshing];
        self.pageNoStr++;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.foot endRefreshing];
        
    }];
}

- (void)applyAction:(UIButton *)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"发布活动请发送信息至618@chuangyes.cn,经审核后显示到这里。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
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

@end
