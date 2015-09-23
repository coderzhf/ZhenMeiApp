//
//  HomeHotPlayController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeHotPlayController.h"
#import "HttpTool.h"
#import "HomeHotPlayResult.h"
#import "MJExtension.h"
@interface HomeHotPlayController()
@end
@implementation HomeHotPlayController
-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)LoadNewData{
    
    NSMutableDictionary *parmams=[NSMutableDictionary dictionary];
    self.pageNoStr=1;
    parmams[@"pageNoStr"]=[NSNumber numberWithInteger:self.pageNoStr];
    parmams[@"pageSizeStr"]=@5;
   if([UserDefaults objectForKey:@"userId"]){
       parmams[@"userId"]=[UserDefaults objectForKey:@"userId"];
   }
    [HttpTool post:KHomeHotPlay params:parmams success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomeHotPlayResult *result=[HomeHotPlayResult objectWithKeyValues:dict];
            result.ID=dict[@"id"];
            [temp addObject:result];
        }
        self.dataArray=temp;
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
    [HttpTool post:KHomeHotPlay params:parmams success:^(id json) {
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
            HomeHotPlayResult *result=[HomeHotPlayResult objectWithKeyValues:dict];
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

@end
