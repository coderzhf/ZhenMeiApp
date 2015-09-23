//
//  HomePictureBaseController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomePictureBaseController.h"
#import "HomePictureCell.h"
#import "HomePicture.h"
#import "MJExtension.h"
#import "AFNetworking.h"
@interface HomePictureBaseController()<MJRefreshBaseViewDelegate>

@end
@implementation HomePictureBaseController
-(void)loadView{
    [super loadView];

    self.tableView.rowHeight=125;
    self.tableView.showsVerticalScrollIndicator=NO;
    [self setupRefreshView];
    
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
    
    static NSString *ID=@"picture";
    HomePictureCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[HomePictureCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    cell.homePic=self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    

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
        
}
//下拉更新数据
-(void)LoadNewData{

    
}
@end

