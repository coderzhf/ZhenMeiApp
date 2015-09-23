//
//  HomeVideoTableViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeRecommendController.h"
#import "HomeRecommendHeaderView.h"
#import "HomeLabelViewController.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "HomeRecResult.h"
#import "ArticleActViewController.h"
#import "HomePicture.h"
@interface HomeRecommendController()<HomeRecommedButtonViewDelegate,HomeRecommedHeaderViewDelegate>
@end
@implementation HomeRecommendController
-(void)viewDidLoad{
    [super viewDidLoad];
    HomeRecommendHeaderView *header=[[HomeRecommendHeaderView alloc]init];
    header.delegate = self;
    header.frame=CGRectMake(0, 0, KScreenWidth, 245);
    header.ButtonView.delegate=self;
    self.tableView.tableHeaderView=header;
}

-(void)LoadNewData{
    NSMutableDictionary *parmams=[NSMutableDictionary dictionary];
    self.pageNoStr=1;
    parmams[@"pageNoStr"]=[NSNumber numberWithInteger:self.pageNoStr];
    parmams[@"pageSizeStr"]=@5;

    [HttpTool post:KHomeRecom params:parmams success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomeRecResult *result=[HomeRecResult objectWithKeyValues:dict];
            result.ID=dict[@"id"];
            [temp addObject:result];
        }
        self.dataArray=temp;
        //停止刷新
        [self.header endRefreshing];
        self.pageNoStr++;

    } failure:^(NSError *error) {
        [self.header endRefreshing];
    }];
}
-(void)LoadMoreData{
    NSMutableDictionary *parmams=[NSMutableDictionary dictionary];
    parmams[@"pageNoStr"]=[NSNumber numberWithInteger:self.pageNoStr];
    parmams[@"pageSizeStr"]=@5;
    [HttpTool post:KHomeRecom params:parmams success:^(id json) {
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
            HomeRecResult *result=[HomeRecResult objectWithKeyValues:dict];
            result.ID=dict[@"id"];
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
- (void)HomeRecommedHeaderViewWithpicture:(HomePicture *)picture {
    ArticleActViewController *vc = [[ArticleActViewController alloc] init];
   
    vc.picture=picture;
    vc.tag=@(3);
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark HomeRecommedButtonViewDelegate
-(void)HomeRecommedButtonClickWithLabel:(HomeRecLabel *)label{
    
    HomeLabelViewController *labelVc=[[HomeLabelViewController alloc]init];
    labelVc.label=label;
    [self.navigationController pushViewController:labelVc animated:YES];

}
@end
