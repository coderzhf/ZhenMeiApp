//
//  PrivateMessageViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/25.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "PrivateMessageViewController.h"
#import "CommunicateViewController.h"
#import "PrivateMessageCell.h"
#import "HttpTool.h"
#import "PrivateMessageModel.h"
#import "MJExtension.h"
@interface PrivateMessageViewController ()

@end

@implementation PrivateMessageViewController

- (void)viewDidLoad {
    
    self.tableView.rowHeight=75;
    self.cellClass=[PrivateMessageCell class];
    self.cellModelClass=[PrivateMessageModel class];
    
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
-(void)LoadNewData{
    
    if (![UserDefaults objectForKey:@"userId"]) {
        [self.header endRefreshing];
        return;
    }
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"userId"]=[UserDefaults objectForKey:@"userId"];
    [HttpTool post:KPrivateMessageList params:dict success:^(id json) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readMessage" object:nil];
        NSArray *list=json[@"list"];
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in list) {
            PrivateMessageModel *private=[PrivateMessageModel objectWithKeyValues:dict];
            private.ID=dict[@"id"];
            [temp addObject:private];
        }
        self.dataArray=temp;
        [self.header endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunicateViewController *communicate=[[CommunicateViewController alloc]init];
    communicate.privateMessage=self.dataArray[indexPath.row];
    [self.navigationController pushViewController:communicate animated:YES];
}
//设置编辑文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//启用编辑模式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self deleteDataWithIndexPath:indexPath];
    
    }
}
-(void)deleteDataWithIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *temp=[NSMutableArray array];
    [temp addObjectsFromArray:self.dataArray];
    [temp removeObjectAtIndex:indexPath.row];
    
    PrivateMessageModel *deleteMessage=self.dataArray[indexPath.row];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"id"]=deleteMessage.ID;
    [HttpTool post:KPrivateMessageDelete params:dict success:^(id json) {
    } failure:^(NSError *error) {
        
    }];
    
    self.dataArray=temp;
}
@end
