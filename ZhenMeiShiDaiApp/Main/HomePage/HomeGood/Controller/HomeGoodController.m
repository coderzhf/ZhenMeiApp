//
//  HomeGoodController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeGoodController.h"
#import "HttpTool.h"
#import "HomeGoodResult.h"
#import "MJExtension.h"
#import "ArticleActViewController.h"
@implementation HomeGoodController
-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)LoadNewData{
    
    NSMutableDictionary *parmams=[NSMutableDictionary dictionary];
    self.pageNoStr=1;
    parmams[@"pageNoStr"]=[NSNumber numberWithInteger:self.pageNoStr];
    parmams[@"pageSizeStr"]=@5;
 
    [HttpTool post:KHomeGood params:parmams success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomePicture *result=[[HomePicture alloc] initWithDic:dict];
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
    [HttpTool post:KHomeGood params:parmams success:^(id json) {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    ArticleActViewController *vc = [[ArticleActViewController alloc] init];
    vc.titleName = @"干货";
    vc.picture=self.dataArray[indexPath.row];
    vc.tag=@(2);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
