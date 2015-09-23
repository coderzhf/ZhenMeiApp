//
//  MyAudioViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/7/2.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MyAudioViewController.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "HomeVideo.h"
@interface MyAudioViewController ()

@end

@implementation MyAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)LoadNewData{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"tag"]=@(1);
    dict[@"userId"]=[UserDefaults objectForKey:@"userId"];
    [HttpTool post:KShowCollectionAct params:dict success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomeVideo *result=[HomeVideo objectWithKeyValues:dict];
            result.ID=dict[@"id"];
            [temp addObject:result];
        }
        self.dataArray=temp;
        //停止刷新
        [self.header endRefreshing];
        
    } failure:^(NSError *error) {
    }];
}


@end
