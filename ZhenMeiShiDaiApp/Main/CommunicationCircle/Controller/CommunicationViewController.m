//
//  CommunicationViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "CommunicationViewController.h"
#import "NewsModel.h"
#import "CommentModel.h"
#import "ChooseLabelViewController.h"
#import "CustomButton.h"
#import "MoreLabelTableViewController.h"
#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "TableViewCell3.h"
#import "AppDelegate.h"
#import "RepeatView.h"


@interface CommunicationViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *messageTableView;
    UIImageView *imageView;
    UIView *headerView;
    AppDelegate *appDelegate;
    NSMutableDictionary *tempDic;
    NSString *urlStr;
    NSNumber *idNumber;
    NSNumber *tagNumber;
    BOOL isRecall;
    NSMutableDictionary *mDic;
    UIImageView *bgView;
    UIButton *back;
}
@property(nonatomic,strong)RepeatView *RepeatView;
@property(nonatomic,strong)MJRefreshFooterView *refreshFootView;
@property(nonatomic,strong)MJRefreshHeaderView *refreshHeadView;
@property(nonatomic,strong)NSMutableDictionary *mutDic;

@property (nonatomic ,assign) BOOL isNewest;
@property (nonatomic ,assign) BOOL isSelect;//是否是筛选数据
@property (nonatomic ,assign) BOOL isUp;//是否是下拉出新数据
@property (nonatomic ,assign) BOOL isOperate;//是否是下拉出新数据

@property (nonatomic ,assign) NSInteger downCount;//上拉基数


@end

@implementation CommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     appDelegate = [UIApplication sharedApplication].delegate;
    [self initViews];
    [self initRefresh];
    _AllDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _AllCommentsArray = [[NSMutableArray alloc] initWithCapacity:0];
    _isAllContent = [[NSMutableArray alloc] initWithCapacity:0];
    _downCount = 1;
    _isNewest = YES;
    _isUp = YES;
    [self loadData:_isNewest];
}

- (void)initRefresh
{
    //初始化刷新脚视图
    _refreshFootView = [MJRefreshFooterView footer];
    _refreshFootView.scrollView = messageTableView;
    _refreshFootView.delegate = self;
    _refreshHeadView = [MJRefreshHeaderView header];
    _refreshHeadView.scrollView = messageTableView;
    _refreshHeadView.delegate = self;
}

- (void)initViews
{
    messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    messageTableView.delaysContentTouches = NO;
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:messageTableView];

    if (_isFocus) {
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"我的关注"];
    [self.view addSubview:customNav];
    messageTableView.frame = CGRectMake(0, KnavHeight, KScreenWidth, KScreenHeight-KnavHeight-KTarBarHeight);
  
    }else{
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:YES withTitle:@"交流圈"];
    customNav.userInteractionEnabled = YES;
    [self.view addSubview:customNav];
        
    UIButton *refreshBtn = [UQFactory buttonWithFrame:CGRectMake(18, KnavHeight - 28, 18, 18) backgroundImage:[UIImage imageNamed:@"zm_refresh_Btn"] image:nil];
    [customNav addSubview:refreshBtn];
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    UIButton *editBtn = [UQFactory buttonWithFrame:CGRectMake(KScreenWidth - 38, KnavHeight - 28, 18, 18) backgroundImage:[UIImage imageNamed:@"zm_editInfor_Btn"] image:nil];
    [customNav addSubview:editBtn];
    [editBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    
    bgView = [UQFactory imageViewWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, 42) image:nil];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
        
    back = [UQFactory buttonWithFrame:CGRectMake(15, 1, 25, 40) backgroundImage:[UIImage imageNamed:@"zm_detailReturn_Btn"] image:nil];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    back.hidden = YES;
    [bgView addSubview:back];
        
     imageView = [UQFactory imageViewWithFrame:CGRectMake((KScreenWidth-200)/2,5, 200, 30) image:[UIImage imageNamed:@"zm_near_Btn"]];
    [bgView addSubview:imageView];
    
    UIButton *nearBtn = [UQFactory buttonWithFrame:CGRectMake(0, 0, imageView.frame.size.width/2, imageView.height) image:nil ];
     nearBtn.tag = 10;
        nearBtn.enabled = NO;
    [nearBtn setTitle:@"最新" forState:UIControlStateNormal];
    [nearBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:nearBtn];
    
    UIButton *newBtn = [UQFactory buttonWithFrame:CGRectMake(nearBtn.right, 0, imageView.frame.size.width/2, imageView.height) image:nil];
    newBtn.tag = 20;
    [newBtn setTitle:@"附近" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:newBtn];
    
    UIImageView *lineImageView = [UQFactory imageViewWithFrame:CGRectMake(0, imageView.bottom+5, KScreenWidth, 1) image:[UIImage imageNamed:@"zm_selected_Line1"]];
    [bgView addSubview:lineImageView];
    
    headerView = [UQFactory viewWithFrame:CGRectMake(0, bgView.bottom, KScreenWidth, 65) backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:headerView];
        NSArray *imageArray = @[@"zm_label_one",@"zm_label_two",@"zm_label_three",@"zm_label_four",@"zm_label_five",@"zm_label_six"];
    for (int i = 0; i < 6; i ++) {
        NSString *title;
        if (i != 5) {
            title = [appDelegate.categoryArray[i] objectForKey:@"title"];
        }else{
            title = @"更多";
        }
        CustomButton *labelBtn = [[CustomButton alloc] initWithFrame:CGRectMake(KScreenWidth*i/6, 0, KScreenWidth/6, KScreenWidth/6+10) WithTitle:title withImage:[UIImage imageNamed:imageArray[i]] isLabel:YES];
        labelBtn.tag = 300+i ;
        [labelBtn addTarget:self action:@selector(labelAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:labelBtn];
    }
        messageTableView.frame = CGRectMake(0, headerView.bottom-3, KScreenWidth, KScreenHeight - KTarBarHeight-headerView.bottom+3) ;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
    
}

-(RepeatView *)RepeatView{
    if (!_RepeatView) {
        
        _RepeatView=[[RepeatView alloc]init];
        _RepeatView.frame=self.view.bounds;
    }else{
        _RepeatView.textView.text = nil;
    }
    return _RepeatView;
}

- (void)loadData:(BOOL)isLatest
{
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    if (_isOperate) {
           mDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"pageNoStr",[NSNumber numberWithInteger:_AllCommentsArray.count],@"pageSizeStr",[NSNumber numberWithDouble:appDelegate.longitude],@"lng1",[NSNumber numberWithDouble:appDelegate.latitude],@"lat1", nil];
    }else{
        mDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_downCount],@"pageNoStr",@"5",@"pageSizeStr",[NSNumber numberWithDouble:appDelegate.longitude],@"lng1",[NSNumber numberWithDouble:appDelegate.latitude],@"lat1", nil];}
    NSString *string = isLatest? KNewTopicInfo:KNearTopicInfo;
    if (_isFocus) {//我的关注
        string = KShowMyAttention;
        [mDic removeObjectsForKeys:@[@"lng1",@"lat1"]];
        [mDic setObject:[UserDefaults objectForKey:@"userId"] forKey:@"userId"];

    }
    if (_isSelect) {//筛选帖子
        string = KShowByOther;
        [mDic removeObjectsForKeys:@[@"lng1",@"lat1"]];
        if (idNumber) {
            [mDic setObject:tagNumber forKey:@"tag"];
            [mDic setObject:idNumber forKey:@"categoryId"];
        }
      }
    
    [Notifier showHud:self.view text:@"数据加载中……"];
    [Utils post:string params:mDic success:^(id json) {
        if (_refreshHeadView) {
            [_refreshHeadView endRefreshing];
        }
        if (_refreshFootView) {
            [_refreshFootView endRefreshing];
        }
            if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
              [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            return ;}
        _isOperate = NO;
        NSArray *statusArr = [json objectForKey:@"list"];
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *commentsArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in statusArr) {
            NewsModel *newModel = [[NewsModel alloc] initWithDic:dic];
            NSArray *commentArraylist = [dic objectForKey:@"commentlist"];
            NSMutableArray *_commentArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *commentDic in commentArraylist) {
                CommentModel *commetModel = [[CommentModel alloc] initWithDic:commentDic];
                [_commentArray addObject:commetModel];
            }
            [commentsArray addObject:_commentArray];
            [dataArray addObject:newModel];
        }
        if (_isUp) {
            if (_AllDataArray.count>0) {
                [_AllDataArray removeAllObjects];
            }
            _AllDataArray = dataArray;
            [_AllCommentsArray removeAllObjects];
            _AllCommentsArray = commentsArray;
            [_isAllContent removeAllObjects];
            for (int i=0; i<_AllDataArray.count; i++) {
                [_isAllContent addObject:@"No"]; //将基本数据类型转换为对象
            }
            
        }else{
            [_AllDataArray addObjectsFromArray:dataArray];
            [_AllCommentsArray addObjectsFromArray:commentsArray];
            for (int i=0; i<dataArray.count; i++) {
                [_isAllContent addObject:@"No"]; //将基本数据类型转换为对象
            }
        }
          //创建状态数组
        _stateArr = [[NSMutableArray alloc] initWithCapacity:_AllDataArray.count];
        for (int i=0; i<_AllDataArray.count; i++) {
            [_stateArr addObject:@"No"]; //将基本数据类型转换为对象
        }
        [messageTableView reloadData];
    } failure:^(NSError *error) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if (_refreshHeadView) {
            [_refreshHeadView endRefreshing];
        }
        if (_refreshFootView) {
            [_refreshFootView endRefreshing];
        }
        [Notifier UQToast:self.view text:@"数据加载失败" timeInterval:NyToastDuration];
    }];
}
- (void)refreshAction
{
    //刷新相当于下拉
    _downCount = 1;
    _isUp = YES;
     [self loadData:_isNewest];
}

- (void)backAction
{
    back.hidden = YES;
    _downCount = 1;
    _isUp = YES;
    _isSelect = NO;
    headerView.hidden = NO;
    messageTableView.top = headerView.bottom-3;
    messageTableView.height = KScreenHeight - KTarBarHeight-headerView.bottom+3;
    [self loadData:_isNewest];
}

- (void)editAction
{
    if (![UserDefaults boolForKey:@"isLogin"]) {
        UIAlertView *actionSheet = [[UIAlertView alloc] initWithTitle:@"需要注册/登录后才能发表说说" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet show];
        return;
    }
    ChooseLabelViewController *chooseVC = [[ChooseLabelViewController alloc] init];
    [self.navigationController pushViewController:chooseVC animated:NO];
}

- (void)labelAction:(UIButton *)button
{
     if (button.tag == 305) {
        MoreLabelTableViewController *moreVC = [[MoreLabelTableViewController alloc] init];
        [moreVC returnNumber:^(NSNumber *number) {
            [self common];
            idNumber = number;
            tagNumber = [NSNumber numberWithInt:1];
            [self loadData:_isNewest];
        }];
        moreVC.Array = appDelegate.productArray;
        [self.navigationController pushViewController:moreVC animated:NO];
        return;
    }
    [self common];
    NSInteger number = button.tag - 300;
    tagNumber = [NSNumber numberWithInt:2];
    NSDictionary *dic = [appDelegate.categoryArray objectAtIndex:number];
    if (dic) {
        idNumber =  [dic objectForKey:@"id"];
    }
    //筛选数据
    [self loadData:_isNewest];
}
- (void)common
{
    back.hidden = NO;
    _downCount = 1;
    _isUp = YES;
    _isSelect = YES;
    headerView.hidden = YES;
    messageTableView.top = bgView.bottom-3;
    messageTableView.height = KScreenHeight-KTarBarHeight-bgView.bottom+3;
}
#pragma mark -MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {//加载更多数据 上拉
        //上拉加载之前的数据
        _isUp = NO;
        _downCount++;
        
    }else{//加载更新数据 下拉
        _isUp = YES;
        if (_downCount>1) {
            _downCount--;
        }else{
            _downCount =1;}
    }
    [self loadData:_isNewest];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return _AllDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _AllCommentsArray[section];
    if (array.count == 0) {
        return 1;
    }else if (array.count <= 3){
        return array.count+1;
    }else if (array.count > 3){
        NSNumber *state = _stateArr[section];
        if (![state boolValue]) {
            return 5;
        }
        return array.count + 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identifier = @"identifier1";
        TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[TableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier flag:NO];
        }
        cell.readerBtn.tag = (indexPath.section+1)*4;
        cell.replyBtn.tag = (indexPath.section+1)*4+1;
        cell.sixinBtn.tag = (indexPath.section+1)*4+2;
        cell.allContentBtn.tag = (indexPath.section+1)*4+3;
        [cell.allContentBtn addTarget:self action:@selector(buttonActionTwo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.readerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.replyBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sixinBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.newsModel = _AllDataArray[indexPath.section];
        cell.isAll = [_isAllContent[indexPath.section] boolValue];
        return cell;
    }
    NSArray *array =  _AllCommentsArray[indexPath.section];
    if (array.count <= 3) {
        static NSString *identifier2 = @"identifier4";
        TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[TableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        cell.nameButton.tag = indexPath.row;
        [cell.nameButton addTarget:self action:@selector(buttonActionTwo:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentModel = array[indexPath.row-1];
        return cell;
    }
    
     NSNumber *state = _stateArr[indexPath.section];
     NSInteger count = [state boolValue]?array.count+1:4;
        if (indexPath.row != count){
            static NSString *identifier2 = @"identifier4";
            TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (cell == nil) {
                cell = [[TableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            }
            cell.nameButton.tag = indexPath.row;
            [cell.nameButton addTarget:self action:@selector(buttonActionTwo:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentModel = array[indexPath.row-1];
            return cell;
        }else{
            TableViewCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:@"identifier3"];
            if (cell3 == nil) {
                cell3 = [[TableViewCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier3"];
            }
            cell3.upBtn.tag = indexPath.row;
            [cell3.upBtn addTarget:self action:@selector(buttonActionTwo:) forControlEvents:UIControlEventTouchUpInside];
            [cell3 refresh:array.count open:[_stateArr[indexPath.section] boolValue]];
            return cell3;
        }
       return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *commentArray = _AllCommentsArray[indexPath.section];
    NewsModel *newsModel = _AllDataArray[indexPath.section];
    if (indexPath.row == 0) {
        CGFloat height = [Utils getContentStrHeight:newsModel.content]+105;
        if (![_isAllContent[indexPath.section] boolValue]) {// 打开
            if (height>235) {
                return 235;
            }else{
                return height;
            }
        }else{
            return height;
        }
    }
    NSNumber *state = _stateArr[indexPath.section];
    NSInteger count = [state boolValue]?commentArray.count+1:4;
    if (indexPath.row != count){
        CommentModel *model = commentArray[indexPath.row-1];
        return [Utils getContentHeight:model.content]+35;
    }else{
       return  46;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)buttonAction:(UIButton *)button
{
    if (![UserDefaults boolForKey:@"isLogin"]) {
        UIAlertView *actionSheet = [[UIAlertView alloc] initWithTitle:@"需要注册/登录后才能操作" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet show];
        return;
    }
    TableViewCell1 *cell;
    if (iOS8) {
        cell = (TableViewCell1 *) button.superview.superview;
    }else{
        cell = (TableViewCell1 *) button.superview.superview.superview;
    }
    NSIndexPath *indexPath = [messageTableView indexPathForCell:cell];
    NewsModel *newsModel = _AllDataArray[indexPath.section];
    if (button.tag == (indexPath.section+1)*4) {
        //关注
        urlStr = KAddUserAttention;
        tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:@"userId"],@"userId",newsModel.topicInfoId,@"topicId", nil];
        [self commmentAction];
    }else if (button.tag == (indexPath.section+1)*4+1) {
        //评论
        isRecall = NO;
        [self.RepeatView.textView becomeFirstResponder];
        [_RepeatView.button addTarget:self action:@selector(commmentAction) forControlEvents:UIControlEventTouchUpInside];
        [AppWindow addSubview:_RepeatView];
        urlStr = KAddComment;
        [self returnStr:nil newsModel:newsModel];

    }else if (button.tag == (indexPath.section+1)*4+2) {
        //私信
        [self.RepeatView.textView becomeFirstResponder];
        [_RepeatView.button addTarget:self action:@selector(commmentAction) forControlEvents:UIControlEventTouchUpInside];
        [AppWindow addSubview:_RepeatView];
        urlStr = KAddPrivateMessage;
        tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:@"userId"],@"senderId",newsModel.userId,@"receiverId", nil];
    }
}

- (void)buttonActionTwo:(UIButton *)button
{
    UITableViewCell *cell;
    if (iOS8) {
        cell = (UITableViewCell *) button.superview.superview;
    }else{
        cell = (UITableViewCell *) button.superview.superview.superview;
    }
    NSIndexPath *indexPath = [messageTableView indexPathForCell:cell];
    NSInteger count = [messageTableView numberOfRowsInSection:indexPath.section];
    if (button.tag == count-1 && count>4) {
        //是否看全部评论
        NSNumber *state = _stateArr[indexPath.section];
        BOOL isShow = ![state boolValue];
        NSNumber *stateNum = [NSNumber numberWithBool:isShow];
        [_stateArr replaceObjectAtIndex:indexPath.section withObject:stateNum];
        [messageTableView reloadData];
        return;
    }else if (button.tag == (indexPath.section+1)*4+3) {
        //查看全文
        NSNumber *state = _isAllContent[indexPath.section];
        BOOL isShow = ![state boolValue];
        NSNumber *stateNum = [NSNumber numberWithBool:isShow];
        [_isAllContent replaceObjectAtIndex:indexPath.section withObject:stateNum];
        [messageTableView reloadData];
        return;
    }
    if (![UserDefaults boolForKey:@"isLogin"]) {
        UIAlertView *actionSheet = [[UIAlertView alloc] initWithTitle:@"需要注册/登录后才能操作" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet show];
        return;
    }
    //回复
    isRecall = YES;
    NSArray *array = _AllCommentsArray[indexPath.section];
    NewsModel *newsModel = _AllDataArray[indexPath.section];
    [self.RepeatView.textView becomeFirstResponder];
    [AppWindow addSubview:_RepeatView];
    [_RepeatView.button addTarget:self action:@selector(commmentAction) forControlEvents:UIControlEventTouchUpInside];
    urlStr = KAddComment;
    CommentModel *commentModel = array[indexPath.row - 1];
    [self returnStr:commentModel newsModel:newsModel];
}

- (void)commmentAction
{
    _isOperate = YES;
    if ([urlStr isEqualToString: KAddComment]) {
        NSString *content;

        content = [NSString stringWithFormat:@"%@",[_RepeatView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [_mutDic setObject:content forKey:@"content"];
        tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_mutDic JSONString],@"json", nil];
    }
    if ([urlStr isEqualToString:KAddPrivateMessage]) {
        _isOperate = NO;
        [tempDic setObject:[_RepeatView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"content"];
    }

    [Utils post:urlStr params:tempDic success:^(id json) {
        if (self.RepeatView) {
            [self.RepeatView removeFromSuperview];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            return ;
        }
        if (urlStr == KAddPrivateMessage) {
            [Notifier UQToast:self.view text:@"私信成功" timeInterval:NyToastDuration];
            return;
        }
        _isUp = YES;
         [self loadData:_isNewest];
    } failure:^(NSError *error) {
        if (self.RepeatView) {
            [self.RepeatView removeFromSuperview];
        }
        [Notifier UQToast:self.view text:@"操作失败" timeInterval:NyToastDuration];
    }];
}
//回复评论调用
- (void )returnStr:(CommentModel *)model newsModel:(NewsModel *)newsModel
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:[UserDefaults objectForKey:@"userId"] forKey:@"userId"];
    [dic setObject:newsModel.topicInfoId forKey:@"topicInfoId"];
    if (appDelegate.locationInfor) {  
        [dic setObject:appDelegate.locationInfor forKey:@"city"];
    }else{
         [dic setObject:@"位置未知" forKey:@"city"];
    }
    if (model) {
        [dic setObject:@"2"forKey:@"commentType"];
        [dic setObject:model.userId forKey:@"answerUserId"];
        [dic setObject:model.commentId forKey:@"commentId"];
    }else{
        [dic setObject:@"1"forKey:@"commentType"];
    }
    _mutDic = dic;
}

- (void)showAction:(UIButton *)button
{
    _downCount = 1;
    [_AllCommentsArray removeAllObjects];
    [_AllDataArray removeAllObjects];
    [messageTableView reloadData];
    UIButton *new =  (UIButton *)[imageView viewWithTag:10];
    UIButton *near =  (UIButton *)[imageView viewWithTag:20];
    _isUp = YES;
    _isNewest = button.tag == 10? YES:NO;
    if (_isNewest) {
        imageView.image = [UIImage imageNamed:@"zm_near_Btn"];
        [new setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [near setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        new.enabled = NO;
        near.enabled = YES;

    }else{
        imageView.image = [UIImage imageNamed:@"zm_new_Btn"];
        [new setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [near setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        near.enabled = NO;
        new.enabled = YES;
    }
    if (!button.enabled) {
        [self loadData:_isNewest];
    }
}

-(void)dealloc{
    //释放上拉刷新控件
    [_refreshFootView free];
    if (_isFocus) {
        [_refreshHeadView free];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
