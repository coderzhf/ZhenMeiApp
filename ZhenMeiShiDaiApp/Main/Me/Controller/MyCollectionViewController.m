//
//  MyCollectionViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyAudioViewController.h"
#import "MyGoodViewController.h"
#import "MyActivityViewController.h"
#import "HomeSegmentView.h"
@interface MyCollectionViewController ()<HomeSegementViewDelegate>
@property(nonatomic,weak)HomeSegmentView *HeaderView;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化HeaderView
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"我的收藏"];
    [self.view addSubview:customNav];
    
    self.view.bounds=CGRectMake(0, 0, KScreenWidth, KScreenHeight-49);
    [self setupHeaderView];
    [self setupChildrenControllers];
    [self HomeSegementWithTag:MyCollectionButtonAudio];
}

#pragma mark init
-(void)setupHeaderView{
    NSArray *titles=@[@"音频",@"干货",@"活动"];
    NSArray *types=@[@(MyCollectionButtonAudio),@(MyCollectionButtonGood),@(MyCollectionButtonActivity)];
    HomeSegmentView *HeaderView=[HomeSegmentView initButtonWithTitleArray:titles type:types];
    HeaderView.width=KScreenWidth;
    HeaderView.height=30;
    HeaderView.left=0;
    HeaderView.top=KnavHeight;
    [self.view addSubview:HeaderView];
    self.HeaderView=HeaderView;
    self.HeaderView.delegate=self;
    
    
}
//初始化tableview
-(void)setupChildrenControllers{
   //音频
    MyAudioViewController *audio=[[MyAudioViewController alloc]init];
    [self addChildViewController:audio];
    
    //干货
    MyGoodViewController *good=[[MyGoodViewController alloc]init];
    [self addChildViewController:good];
    
    //活动
    MyActivityViewController *activity=[[MyActivityViewController alloc]init];
    [self addChildViewController:activity];
    
}

#pragma mark HomeSegementViewDelegate
-(void)HomeSegementWithTag:(NSInteger)tag{
    
    UITableViewController *controller=self.childViewControllers[tag-6];
    controller.tableView.frame=CGRectMake(0, self.HeaderView.bottom, KScreenWidth,KScreenHeight-self.HeaderView.bottom);
    [self.view addSubview:controller.tableView];
    
    
}

@end
