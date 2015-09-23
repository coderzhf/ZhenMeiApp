//
//  HomeLabelViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/7/4.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeLabelViewController.h"
#import "HomeLabelDetailViewController.h"
@interface HomeLabelViewController ()

@end

@implementation HomeLabelViewController

- (void)viewDidLoad {
    //初始化HeaderView
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:_label.title];
    [self.view addSubview:customNav];
    
    [super viewDidLoad];
    [self setupTableView];
    
}



-(void)setupTableView{
    
    HomeLabelDetailViewController *audio=[[HomeLabelDetailViewController alloc]init];
    audio.label=_label;
    [self addChildViewController:audio];
    audio.tableView.frame=CGRectMake(0, 64, KScreenWidth,KScreenHeight-64);
    [self.view addSubview:audio.tableView];
}




@end
