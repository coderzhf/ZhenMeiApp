//
//  MyActivityViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/7/2.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MyActivityViewController.h"
#import "HttpTool.h"
#import "HomePicture.h"
@interface MyActivityViewController ()

@end

@implementation MyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 }

-(void)LoadNewData{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"tag"]=@(3);
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
        [self.tableView reloadData];
        //停止刷新
        [self.header endRefreshing];
        
    } failure:^(NSError *error) {
    }];
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    ArticleActViewController *vc = [[ArticleActViewController alloc] init];
//    vc.picture=self.dataArray[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
//}
@end
