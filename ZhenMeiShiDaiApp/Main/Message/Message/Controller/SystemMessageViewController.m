//
//  SystemMessageViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/25.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageCell.h"
#import "AFNetworking.h"
#import "HttpTool.h"
#import "SystemMessageModel.h"
#import "MJExtension.h"
@interface SystemMessageViewController ()<UIAlertViewDelegate>

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {    

    self.tableView.rowHeight=75;
    
    self.cellClass=[SystemMessageCell class];
    self.cellModelClass=[SystemMessageModel class];
    [super viewDidLoad];
    
    
 }

-(void)LoadNewData{

    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"userId"]=@20;
   [HttpTool post: KSystemMessageList params:dict success:^(id json) {
       NSArray *list=json[@"list"];
       NSMutableArray *temp=[NSMutableArray array];
       for (NSDictionary *dict in list) {
           SystemMessageModel *system=[SystemMessageModel objectWithKeyValues:dict];
           [temp addObject:system];
       }
       self.dataArray=temp;
       [self.header endRefreshing];
   } failure:^(NSError *error) {
       
    }];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self deleteDataWithIndexPath:indexPath];
     }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SystemMessageModel *messageModel=self.dataArray[indexPath.row];
    NSLog(@"%@",[UserDefaults objectForKey:@"userId"]);
    [Utils post:KReadBulletin params:[NSDictionary dictionaryWithObjectsAndKeys:messageModel.bulletinId,@"bulletinId",[UserDefaults objectForKey:@"userId"],@"userId", nil] success:^(id json) {
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            return ;}
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"公告" message:messageModel.content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readMessage" object:nil];
        
    } failure:^(NSError *error) {
    }];
}

-(void)deleteDataWithIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *temp=[NSMutableArray array];
    [temp addObjectsFromArray:self.dataArray];
    [temp removeObjectAtIndex:indexPath.row];
    
    SystemMessageModel *deleteMessage=self.dataArray[indexPath.row];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"bulletinId"]=deleteMessage.bulletinId;
    [HttpTool post:KSystemMessageDelete params:dict success:^(id json) {
    } failure:^(NSError *error) {

    }];
    
     self.dataArray=temp;
}
@end
