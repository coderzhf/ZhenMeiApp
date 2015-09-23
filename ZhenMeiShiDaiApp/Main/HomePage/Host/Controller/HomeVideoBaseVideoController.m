//
//  HomeVideoBaseVideoController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//
extern NSString *const playerVideoNotification;

#import "HomeVideoBaseVideoController.h"
#include "HomeVideoCell.h"
#import "HomeVideo.h"
#import "AVViewController.h"
#import "AFNetworking.h"
#import "HomeHotPlayResult.h"
#import "MJExtension.h"
#import "HttpTool.h"
#import "PlayerTool.h"
@interface HomeVideoBaseVideoController()<MJRefreshBaseViewDelegate>

@end
@implementation HomeVideoBaseVideoController
-(void)viewDidLoad{
    [super viewDidLoad];
    //self.tableView.rowHeight=8;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:(245 / 255.0) green:(245 / 255.0) blue:(245 / 255.0) alpha:1];
    self.dataArray=[NSMutableArray array];
    [self setupRefreshView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAudioController) name:playerVideoNotification object:nil];
}
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.tableView reloadData];
   // [self.tableView registerClass:self.cellClass forCellReuseIdentifier:[self.cellClass description]];
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"video";
    HomeVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[HomeVideoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    HomeVideo *video=self.dataArray[indexPath.row];
    cell.video=video;
    return cell;
}
#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeVideo *video=self.dataArray[indexPath.row];
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *authorArray = (NSMutableArray*)[video.author componentsSeparatedByString:@";"];
    for (NSString *str in authorArray) {
        if (![str isEqualToString:@""]) {
            [tempArray addObject:str];}
    }
    
    if (tempArray.count ==0||tempArray.count ==1||tempArray.count ==2||tempArray.count ==3) {
        return 82;
    }else if (tempArray.count ==4){
        return 85;
    }else if (tempArray.count ==5){
        return 97;
    }else if (tempArray.count ==6){
        return 112;}
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"AVPlayerView" bundle:nil];
    
    AVViewController *vc =[storyboard instantiateViewControllerWithIdentifier:@"AVView"];
    HomeVideo *video=self.dataArray[indexPath.row];
    vc.audioPlayer=video;
    vc.title=video.shortTitle;
    [self.navigationController pushViewController:vc animated:YES];
    
    if (![UserDefaults objectForKey:@"userId"])  return;
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"userId"]=[UserDefaults objectForKey:@"userId"];
    dict[@"articleId"]=video.ID;
    [HttpTool post:KAddAudio params:dict success:^(id json) {
        
    } failure:^(NSError *error) {
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.navigationController.view endEditing:YES];
}
//刷新控件
-(void)setupRefreshView{
    //顶部 下拉控件
    MJRefreshHeaderView *header=[MJRefreshHeaderView header];
    header.scrollView=self.tableView;
    header.delegate=self;
    self.header=header;
    //初次登陆加载数据
    [self LoadNewData];
    //底部 上拉控件
    MJRefreshFooterView *foot=[MJRefreshFooterView footer];
    foot.scrollView=self.tableView;
    foot.delegate=self;
    self.foot=foot;
    
}
-(void)dealloc{
    //释放上拉刷新控件
    [self.foot free];
    [self.header free];
}
#pragma mark MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {//加载更多数据 上拉
        [self LoadMoreData];
    }else{//加载更新数据 下拉
        [self LoadNewData];
    }
}
//上拉加载更多数据
-(void)LoadMoreData{
    [self.foot endRefreshing];

}
-(void)LoadNewData{
    
}
- (void)pushAudioController {

    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"AVPlayerView" bundle:nil];
    
    AVViewController *vc =[storyboard instantiateViewControllerWithIdentifier:@"AVView"];
    HomeVideo *video=[PlayerTool sharedPlayerTool].playingModel;
    vc.audioPlayer=video;
    vc.title=video.shortTitle;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
