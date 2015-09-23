//
//  CommunicateViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "CommunicateViewController.h"
#import "MessageInputView.h"
#import "Message.h"
#import "MessageFrame.h"
#import "MessageDetailCell.h"
#import "HttpTool.h"
#import "MJExtension.h"
@interface CommunicateViewController()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *taleView;
@property(nonatomic,weak)MessageInputView *inputView;
@property(nonatomic,strong)NSMutableArray *messages;

@end

@implementation CommunicateViewController
-(NSArray *)messages{
    if (_messages==nil) {
        _messages=[NSMutableArray array];
    }
    return _messages;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"私信"];
    [self.view addSubview:customNav];
    [self setupInputView];
    [self setupTableView];
    
    [self loadData];
 
 }

-(void)setupInputView{

   // MessageInputView *inputView=[[NSBundle mainBundle]loadNibNamed:@"MessageInputView"owner:self options:nil][0];
    MessageInputView *inputView=[[MessageInputView alloc]init];
    [self.view addSubview:inputView];
    inputView.frame=CGRectMake(0, KScreenHeight-44, KScreenWidth, 44);
    //添加监听器
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //设置文本框左边显示的view
    inputView.textfieldView.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //永远显示
    inputView.textfieldView.leftViewMode=UITextFieldViewModeAlways;
    inputView.textfieldView.returnKeyType=UIReturnKeySend;
    [inputView.RepeatButton addTarget:self action:@selector(repeatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //设置编辑文本的代理
    inputView.textfieldView.delegate=self;
    self.inputView=inputView;
}
-(void)setupTableView{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, KScreenHeight-KnavHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    //去除tableview的分割线
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //设置背景色
    tableView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    //tableview不可选中
    tableView.allowsSelection=NO;
    tableView.dataSource=self;
    tableView.delegate=self;
    self.taleView=tableView;
}
-(void)loadData{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"parentId"]=_privateMessage.parentId;
    [HttpTool post:KPrivateMessageShow params:dict success:^(id json) {
        NSArray *lists=json[@"list"];
        for (NSDictionary *dict in lists) {
            MessageFrame *frame=[[MessageFrame alloc]init];
            frame.message=[Message objectWithKeyValues:dict];
    
            [self.messages addObject:frame];
            [self.taleView reloadData];
            [self.taleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    } failure:^(NSError *error) {
        
    }];
}
//当键盘改变frame时调用
-(void)UIKeyboardWillChangeFrameNotification:(NSNotification *)note{
    
    //设置window的颜色
    self.view.window.backgroundColor=self.taleView.backgroundColor;
    //提取动画时间
    CGFloat duration= [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //提取键盘的最终位置
    CGRect EndFrame=[note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //算出位移大小
    CGFloat tram=EndFrame.origin.y-self.view.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        //改变
        self.view.transform=CGAffineTransformMakeTranslation(0, tram);
    }];
    
    }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messages.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageDetailCell *cell=[MessageDetailCell MessagecellWithTableview:tableView];
    cell.userImg = self.privateMessage.userImg;
    cell.messageFrame=self.messages[indexPath.row];
    
    return cell;
}
#pragma mark 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.messages[indexPath.row] cellHeight];
}
//开始拖拽表格的时候会调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}
#pragma mark 文本框代理
//点击了return就可以调用
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self repeatServer:textField.text];
    self.inputView.textfieldView.text=nil;
    return YES;
}
-(void)repeatButtonClick{
    
    [self repeatServer:self.inputView.textfieldView.text];
    self.inputView.textfieldView.text=nil;

}
-(void)repeatServer:(NSString *)text{
    if (text.length==0) {
        return;
    }
    MessageFrame *messageFrame=[[MessageFrame alloc]init];
    Message *message=[[Message alloc]init];
    message.content=text;
    message.time=[self stringWithNowTime];
    messageFrame.message=message;
    

    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"id"]=_privateMessage.ID;
    dict[@"senderId"]=[UserDefaults objectForKey:@"userId"];
    dict[@"receiverId"]=_privateMessage.userId;
    dict[@"parentId"]=_privateMessage.parentId;
    dict[@"content"]=text;
    
    [HttpTool post:KPrivateMessageAdd params:dict success:^(id json) {
    } failure:^(NSError *error) {
        
    }];

    [self.messages addObject:messageFrame];
    [self.taleView reloadData];
    [self.taleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(NSString *)stringWithNowTime{
    NSDate *date=[NSDate date];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"hh:mm";
    
   return [formatter stringFromDate:date];
}


@end
