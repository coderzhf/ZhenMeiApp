//
//  MyCommunicationViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/7/1.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MyCommunicationViewController.h"
#import "TableViewCell1.h"
#import "NewsModel.h"
#import "RepeatView.h"
#import "AppDelegate.h"

#define Kheight 40
@interface MyCommunicationViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    BOOL isMySender;
    UILabel *label;
    UIButton *mySender;
    UIButton *myFollow;
    UITableView *messageTableView;
    NSMutableDictionary *tempDic;
    NSString *urlStr;
    AppDelegate *appDelegate;
    UIButton *deleteBtn;
    UIImageView *bottom;
    NSMutableArray *ids;
    NSMutableArray *indexPaths;
    UIButton *allBtn;
}
@property(nonatomic,strong)MJRefreshFooterView *refreshFootView;
@property(nonatomic,strong)RepeatView *RepeatView;
@property(nonatomic,strong)NSMutableDictionary *mDic;
@property (nonatomic ,assign) BOOL isOperate;
@property (nonatomic ,assign) BOOL isUp;//是否是下拉出新数据
@property (nonatomic ,assign) NSInteger downCount;//上拉基数

@end

@implementation MyCommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"我的交流"];
    [self.view addSubview:customNav];
    appDelegate = [UIApplication sharedApplication].delegate;
    _AllDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _isAllContent = [[NSMutableArray alloc] initWithCapacity:0];
    _stateArr = [[NSMutableArray alloc] initWithCapacity:0];
    ids = [[NSMutableArray alloc] initWithCapacity:0];
    indexPaths = [[NSMutableArray alloc] initWithCapacity:0];
    _downCount = 1;
    _isUp = YES;
    [self initViews];
    [self initRefresh];
    [self loadData];
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

- (void)initViews
{
    mySender = [UQFactory buttonWithFrame:CGRectMake(0, KnavHeight, KScreenWidth/2, 30) title:@"我发布的帖子" titleColor:ZhenMeiRGB(205, 173, 0) fontName:nil fontSize:14];
    mySender.enabled = NO;
    mySender.tag = 10;
    [self.view addSubview:mySender];
    [mySender addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    myFollow = [UQFactory buttonWithFrame:CGRectMake(KScreenWidth/2, KnavHeight, KScreenWidth/2, 30) title:@"我的跟帖" titleColor:[UIColor blackColor] fontName:nil fontSize:14];
    myFollow.tag = 20;
    [myFollow addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myFollow];
    
    UILabel *lineLabel = [UQFactory labelWithFrame:CGRectMake(0, mySender.bottom,KScreenWidth , 1) text:nil];
    lineLabel.backgroundColor = ZhenMeiRGB(230, 230, 230);
    [self.view addSubview:lineLabel];
    
    label = [UQFactory labelWithFrame:CGRectMake(20, lineLabel.top-2,KScreenWidth/2-40 , 3) text:nil];
    label.backgroundColor = ZhenMeiRGB(205, 173, 0);
    [self.view addSubview:label];
    isMySender = YES;
    
    messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label.bottom, KScreenWidth, 0) style:UITableViewStylePlain];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    messageTableView.delaysContentTouches = NO;
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:messageTableView];
    
    bottom = [UQFactory imageViewWithFrame:CGRectMake(0, KScreenHeight-40, KScreenWidth, Kheight) image:nil];
    bottom.backgroundColor = ZhenMeiRGB(240, 240, 240);
    [self.view addSubview:bottom];
        
    allBtn = [UQFactory buttonWithFrame:CGRectMake(20, 5, 30, 30) image:[UIImage imageNamed:@"login_reme_unselcted"]];
    allBtn.tag = 1;
    [allBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:allBtn];
    UILabel *allLabel = [UQFactory labelWithFrame:CGRectMake(allBtn.right, 10, 40, 20) text:@"全选" textColor:[UIColor blackColor]fontSize:14 center:NO];
    [bottom addSubview:allLabel];
    deleteBtn = [UQFactory buttonWithFrame:CGRectMake(KScreenWidth-100, 7, 80, 25) title:@"删除" titleColor:[UIColor blackColor] fontName:nil fontSize:14];
    deleteBtn.tag = 2;
    [deleteBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"zm_zhuce_Btn"] forState:UIControlStateNormal];
    [bottom addSubview:deleteBtn];
    messageTableView.height = KScreenHeight - bottom.height-lineLabel.bottom;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([Notifier hasHud]) {
        [Notifier dismissHud:NotifyImmediately];
    }
}

- (void)initRefresh
{
     //初始化刷新脚视图
    MJRefreshFooterView *foot = [MJRefreshFooterView footer];
    self.refreshFootView = foot;
    _refreshFootView.scrollView = messageTableView;
    _refreshFootView.delegate = self;
}


- (void)buttonAction:(UIButton *)button
{
    _isUp = YES;
    [_AllDataArray removeAllObjects];
    [messageTableView reloadData];
    _downCount = 1;
    label.left = button.left+20;
    if (button.tag == 20) {//我的跟帖
        [bottom removeFromSuperview];
        messageTableView.height = KScreenHeight - (KnavHeight+31);
        [myFollow setTitleColor: ZhenMeiRGB(205, 173, 0) forState:UIControlStateNormal];
        [mySender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        mySender.enabled = YES;
        myFollow.enabled = NO;
        isMySender = NO;
    }else{//我的发帖
        [self.view addSubview:bottom];
        messageTableView.height = KScreenHeight - bottom.height-(KnavHeight+31);
        [mySender setTitleColor:ZhenMeiRGB(205, 173, 0) forState:UIControlStateNormal];
        [myFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        mySender.enabled = NO;
        myFollow.enabled = YES;
        isMySender = YES;
    }
    if (!button.enabled) {
        [self loadData];
    }
 }

- (void)loadData{
    
    NSString *urlString = isMySender?KNewTopicInfo:KMyCommentTopic;
    NSDictionary *dic;
    if (_isOperate) {
          dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"pageNoStr",[NSNumber numberWithInteger:_AllDataArray.count],@"pageSizeStr",[UserDefaults objectForKey:@"userId"],@"userId",[NSNumber numberWithDouble:appDelegate.longitude],@"lng1",[NSNumber numberWithDouble:appDelegate.latitude],@"lat1",nil];
    }else{
         dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_downCount],@"pageNoStr",@"5",@"pageSizeStr",[UserDefaults objectForKey:@"userId"],@"userId",[NSNumber numberWithDouble:appDelegate.longitude],@"lng1",[NSNumber numberWithDouble:appDelegate.latitude],@"lat1",nil];
    }
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    [Notifier showHud:self.view text:@"数据请求中……"];
    [Utils post:urlString params:dic success:^(id json) {
        if (_refreshFootView) {
            [_refreshFootView endRefreshing];
        }
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            return ;
        }
        _isOperate = NO;
         NSArray *statusArr = [json objectForKey:@"list"];
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in statusArr) {
            NewsModel *newModel = [[NewsModel alloc] initWithDic:dic];
             [dataArray addObject:newModel];
        }
        if (_isUp) {
            [_AllDataArray removeAllObjects];
            _AllDataArray = dataArray;
            if (isMySender) {
                [_isAllContent removeAllObjects];
                for (int i=0; i<_AllDataArray.count; i++) {
                    [_isAllContent addObject:@"No"]; //将基本数据类型转换为对象
                }
            }
            for (int i=0; i<_AllDataArray.count; i++) {
                [_stateArr addObject:@"No"]; //将基本数据类型转换为对象
            }

        }else{
            [_AllDataArray addObjectsFromArray:dataArray];
            for (int i=0; i<dataArray.count; i++) {
                [_isAllContent addObject:@"No"]; //将基本数据类型转换为对象
            }
            for (int i=0; i<dataArray.count; i++) {
                [_stateArr addObject:@"No"]; //将基本数据类型转换为对象
               }
        }
          [messageTableView reloadData];
    } failure:^(NSError *error) {
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view text:@"数据请求失败" timeInterval:NyToastDuration];
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return _AllDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *identifier1 = @"identifier1";
        static NSString *identifier2 = @"identifier2";
        TableViewCell1 *cell;
        if (isMySender) {
           cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        } else{
          cell = [tableView dequeueReusableCellWithIdentifier:identifier1];}

        if (cell == nil) {
            if (isMySender) {
                cell = [[TableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2 flag:YES];
            }else{
                cell = [[TableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1 flag:NO];}
        }
        if (isMySender) {
            NSNumber *state = [_isAllContent objectAtIndex:indexPath.row];
            if (![state boolValue]) {
                [_isAllContent replaceObjectAtIndex:indexPath.row withObject:@"No"];
                [cell setChecked:NO];
                
            }else {
                [_isAllContent replaceObjectAtIndex:indexPath.row withObject:@"Yes"];
                [cell setChecked:YES];
            }
       }
        cell.readerBtn.tag = (indexPath.row+1)*4;
        cell.replyBtn.tag = (indexPath.row+1)*4+1;
        cell.sixinBtn.tag = (indexPath.row+1)*4+2;
        cell.allContentBtn.tag = (indexPath.row+1)*4+3;
        [cell.allContentBtn addTarget:self action:@selector(buttonActionOne:) forControlEvents:UIControlEventTouchUpInside];
        [cell.readerBtn addTarget:self action:@selector(buttonActionOne:) forControlEvents:UIControlEventTouchUpInside];
        [cell.replyBtn addTarget:self action:@selector(buttonActionOne:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sixinBtn addTarget:self action:@selector(buttonActionOne:) forControlEvents:UIControlEventTouchUpInside];
        cell.newsModel = _AllDataArray[indexPath.row];
        cell.isAll = [_stateArr[indexPath.row] boolValue];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *newsModel = _AllDataArray[indexPath.row];
    CGFloat height = [Utils getContentStrHeight:newsModel.content]+105;
    if (![_stateArr[indexPath.row] boolValue]) {// 打开
        if (height>235) {
            return 2335;
        }else{
            return height;}
    }else{
        return height;}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsModel *newsModel = _AllDataArray[indexPath.row];

    TableViewCell1 *cell = (TableViewCell1*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSUInteger row = [indexPath row];
    NSNumber *state = _isAllContent[row];
    if (![state boolValue]) {
        [_isAllContent replaceObjectAtIndex:row withObject:@"Yes"];
        [ids addObject:newsModel.topicInfoId];
        [indexPaths addObject:indexPath];
        [cell setChecked:YES];
    }else {
        [_isAllContent replaceObjectAtIndex:row withObject:@"No"];
        [ids removeObjectAtIndex:row];
        [indexPaths removeObjectAtIndex:row];
        [cell setChecked:NO];
    }
}

- (void)action:(BOOL)isSelect
{
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[messageTableView indexPathsForVisibleRows]];
    for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
        NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
        TableViewCell1 *cell = (TableViewCell1*)[messageTableView cellForRowAtIndexPath:indexPath];
        NSUInteger row = [indexPath row];
        if (isSelect) {
            [_isAllContent replaceObjectAtIndex:row withObject:@"No"];
            [cell setChecked:NO];
            
        }else {
            [_isAllContent replaceObjectAtIndex:row withObject:@"Yes"];
            [cell setChecked:YES];
        }
    }
    if (isSelect){
        for (int i=0; i<_AllDataArray.count; i++) {
            [_isAllContent replaceObjectAtIndex:i withObject:@"No"]; //将基本数据类型转换为对象
        }
        [ids removeAllObjects];
        [indexPaths removeAllObjects];
        
    }else{
        for (int i=0; i<_AllDataArray.count; i++) {
            [_isAllContent replaceObjectAtIndex:i withObject:@"Yes"]; //将基本数据类型转换为对象
            NewsModel *model = _AllDataArray[i];
            [ids addObject:model.topicInfoId];
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
}
- (void)comfirmAction:(UIButton *)button
{
    if (button.tag == 1) {
        [self action:button.selected];
        button.selected = !button.selected;
        NSString *image = button.selected? @"login_reme_selcted":@"login_reme_unselcted";
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        
    }else{//删除,判断是否有被选中的
        if (ids.count==0) return;
        NSString *idsStr = [ids componentsJoinedByString:@","];
        [Utils post:KDeleteMyTopic params:[NSDictionary dictionaryWithObjectsAndKeys:idsStr,@"ids", nil] success:^(id json) {
            if ([[json objectForKey:@"code"] intValue] ) {
                [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
                return ;}
            [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            [ids removeAllObjects];
            
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            NSSet *set = [NSSet setWithArray: indexPaths];
            for (NSIndexPath *path in [set allObjects]) {
                [indexSet addIndex:path.row];
            }
            [_AllDataArray removeObjectsAtIndexes:indexSet];
            [messageTableView deleteRowsAtIndexPaths:[set allObjects] withRowAnimation:UITableViewRowAnimationFade];
            [messageTableView reloadData];
            [indexPaths removeAllObjects];
        } failure:^(NSError *error) {
            [Notifier UQToast:self.view text:@"删除帖子失败"timeInterval:NyToastDuration];
        }];
    }
}

- (void)buttonActionOne:(UIButton *)button
{
    TableViewCell1 *cell;
    if (iOS8) {
        cell = (TableViewCell1 *) button.superview.superview;
    }else{
        cell = (TableViewCell1 *) button.superview.superview.superview;
    }
    NSIndexPath *indexPath = [messageTableView indexPathForCell:cell];
    NewsModel *newsModel = _AllDataArray[indexPath.row];
    if (button.tag == (indexPath.row+1)*4) {
        //关注
        urlStr = KAddUserAttention;
        tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:@"userId"],@"userId",newsModel.topicInfoId,@"topicId", nil];
        [self commmentAction];
    }else if (button.tag == (indexPath.row+1)*4+1) {
        //评论,插入表格中
        [self.RepeatView.textView becomeFirstResponder];
        [_RepeatView.button addTarget:self action:@selector(commmentAction) forControlEvents:UIControlEventTouchUpInside];
        [AppWindow addSubview:_RepeatView];
        urlStr = KAddComment;
        [self returnStr:newsModel];
        
    }else if (button.tag == (indexPath.row+1)*4+2) {
        //私信
        [self.RepeatView.textView becomeFirstResponder];
        [_RepeatView.button addTarget:self action:@selector(commmentAction) forControlEvents:UIControlEventTouchUpInside];
        [AppWindow addSubview:_RepeatView];
        urlStr = KAddPrivateMessage;
        tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:@"userId"],@"senderId",newsModel.userId,@"receiverId", nil];
    }else if (button.tag == (indexPath.row+1)*4+3){
        //查看全文
        NSNumber *state = _stateArr[indexPath.row];
        BOOL isShow = ![state boolValue];
        NSNumber *stateNum = [NSNumber numberWithBool:isShow];
        [_stateArr replaceObjectAtIndex:indexPath.row withObject:stateNum];
        [messageTableView reloadData];
    }
}

//评论调用
- (void )returnStr:(NewsModel *)newsModel
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:[UserDefaults objectForKey:@"userId"] forKey:@"userId"];
    [dic setObject:newsModel.topicInfoId forKey:@"topicInfoId"];
    if (appDelegate.locationInfor) {
        [dic setObject:appDelegate.locationInfor forKey:@"city"];
    }else{
        [dic setObject:@"位置未知" forKey:@"city"];
    }
        [dic setObject:@"1"forKey:@"commentType"];
    self.mDic = dic;
}

- (void)commmentAction
{
    _isOperate = YES;
    if ([urlStr isEqualToString: KAddComment]) {
        [self.mDic setObject:[_RepeatView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"content"];
        tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.mDic JSONString],@"json", nil];
    }
    if ([urlStr isEqualToString:KAddPrivateMessage]) {
        [tempDic setObject:[_RepeatView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"content"];
        _isOperate = NO;
    }
    [Utils post:urlStr params:tempDic success:^(id json) {
        if (self.RepeatView) {
            [self.RepeatView removeFromSuperview];
        }
            [_refreshFootView endRefreshing];
        if ([[json objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            return ;
        }
        if (urlStr == KAddPrivateMessage) {
            [Notifier UQToast:self.view text:@"私信成功" timeInterval:NyToastDuration];
            return;
        }
        _isUp = YES;
        [self loadData];
        
    } failure:^(NSError *error) {
        if (self.RepeatView) {
            [self.RepeatView removeFromSuperview];}
            [_refreshFootView endRefreshing];
        [Notifier UQToast:self.view text:@"操作失败" timeInterval:NyToastDuration];
    }];
}
#pragma mark -MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
        //上拉加载之前的数据
        _downCount++;
        _isUp = NO;

    [self loadData];
}

- (void)dealloc
{
    [self.refreshFootView free];
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
