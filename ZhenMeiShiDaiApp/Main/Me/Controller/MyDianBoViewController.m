//
//  MyDianBoViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MyDianBoViewController.h"
#import "HistoryVideoViewController.h"
@interface MyDianBoViewController ()

@end

@implementation MyDianBoViewController

- (void)viewDidLoad {
    //初始化HeaderView
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"我的点播"];
    [self.view addSubview:customNav];

    [super viewDidLoad];
    [self setupTableView];

}



-(void)setupTableView{
    
    
    HistoryVideoViewController *audio=[[HistoryVideoViewController alloc]init];
    [self addChildViewController:audio];
    audio.tableView.frame=CGRectMake(0, KnavHeight, KScreenWidth,KScreenHeight-KnavHeight);
    [self.view addSubview:audio.tableView];
}


@end
