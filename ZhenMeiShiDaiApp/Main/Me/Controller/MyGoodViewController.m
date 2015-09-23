//
//  MyGoodViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/7/2.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MyGoodViewController.h"
#import "HttpTool.h"
#import "HomePicture.h"
@interface MyGoodViewController ()

@end

@implementation MyGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)LoadNewData{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"tag"]=@(2);
    dict[@"userId"]=[UserDefaults objectForKey:@"userId"];
    [HttpTool post:KShowCollectionAct params:dict success:^(id json) {
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
        
    } failure:^(NSError *error) {
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    ArticleActViewController *vc = [[ArticleActViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
