//
//  MessageViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/26.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MessageViewController.h"
#import "HomeSegmentView.h"
#import "PrivateMessageViewController.h"
#import "SystemMessageViewController.h"
@interface MessageViewController ()<HomeSegementViewDelegate>
@property(nonatomic,weak)HomeSegmentView *HeaderView;
@property(nonatomic,assign)NSInteger selectedTag;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化HeaderView
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:YES withTitle:@"消息"];
    [self.view addSubview:customNav];
    
    [self setupHeaderView];
    [self setupChildrenControllers];
    [self HomeSegementWithTag:MessageButtonPrivateMessage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self HomeSegementWithTag:MessageButtonPrivateMessage];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
#pragma mark init
-(void)setupHeaderView{
    NSArray *titles=@[@"私信",@"系统信息"];
    NSArray *types=@[@(MessageButtonPrivateMessage),@(MessageButtonSystemMessage)];
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
    //私信页面
    PrivateMessageViewController *Private=[[PrivateMessageViewController alloc]init];
    [self addChildViewController:Private];
    [self HomeSegementWithTag:MessageButtonPrivateMessage];
    
    //系统信息页面
    SystemMessageViewController *System=[[SystemMessageViewController alloc]init];
    [self addChildViewController:System];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
#pragma mark HomeSegementViewDelegate
-(void)HomeSegementWithTag:(NSInteger)tag{
    UITableViewController *Oldcontroller=self.childViewControllers[self.selectedTag];
    [Oldcontroller.tableView removeFromSuperview];
    UITableViewController *controller=self.childViewControllers[tag-4];
    if ([controller isKindOfClass:[PrivateMessageViewController class]]) {
        if (self.readMessageBlock) {
            self.readMessageBlock();
        }
    }
    controller.tableView.frame=CGRectMake(0, self.HeaderView.bottom, KScreenWidth,self.view.height-self.HeaderView.height-30);
    [self.view addSubview:controller.tableView];
    self.selectedTag=tag-4;
    
}
@end