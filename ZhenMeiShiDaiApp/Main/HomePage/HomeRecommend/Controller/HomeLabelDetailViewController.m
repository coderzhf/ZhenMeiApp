//
//  HomeLabelDetailViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/7/4.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeLabelDetailViewController.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "HomeVideo.h"
@interface HomeLabelDetailViewController ()

@end

@implementation HomeLabelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)LoadNewData{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"articleId"]=_label.ID;
    [HttpTool post:KHomeRecLabelDetail params:dict success:^(id json) {
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
