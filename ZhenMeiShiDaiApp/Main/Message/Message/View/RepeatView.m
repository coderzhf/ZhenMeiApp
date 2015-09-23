//
//  RepeatView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//
#define KBoardWH 5
#define KRepeatBGViewH 200
#import "RepeatView.h"
#import "AppDelegate.h"
@interface RepeatView()<UITextViewDelegate>
@property(nonatomic,weak)UIView *BgView;
@end
@implementation RepeatView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=ZhenMeiRGBA(0, 0, 0, 0.3);
        //初始化背景
        [self setupBackground];
        //初始化文本
        [self setupTextView];
        //初始化地理位置和发送按钮
        [self setupButtons];
        
    }
    return self;
}
-(void)setupBackground{
    UIView *BgView=[[UIView alloc]init];
    BgView.backgroundColor=[UIColor whiteColor];
    [self addSubview:BgView];
    self.BgView=BgView;
}
-(void)setupTextView{
    UITextView *textView=[[UITextView alloc]init];
    textView.font=[UIFont systemFontOfSize:15];
    textView.backgroundColor=ZhenMeiRGB(239, 239, 239);
    //竖直方向可以拖拽
    textView.alwaysBounceVertical=YES;
    textView.delegate=self;
    textView.text=nil;
    [self.BgView addSubview:textView];
    self.textView=textView;

    //设置键盘监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
-(void)setupButtons{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  
    PlayButton *location=[[PlayButton alloc]init];
    if (appDelegate.locationInfor) {
        [location setTitle:appDelegate.locationInfor forState:UIControlStateNormal];
    }else{
        [location setTitle:@"位置未知" forState:UIControlStateNormal];
    }
    [location setBackgroundColor:ZhenMeiRGB(239, 239, 239)];
    [self.BgView addSubview:location];
    self.location=location;
    
    _button=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"发送" forState:UIControlStateNormal];
    _button.titleLabel.font=[UIFont systemFontOfSize:14];
    [_button setBackgroundColor:ZhenMeiRGB(223, 189, 60)];
    [self.BgView addSubview:_button];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.BgView.height=KRepeatBGViewH;
    self.BgView.width=KScreenWidth;
    
    self.textView.top=50;
    self.textView.height=120;
    self.textView.left=KBoardWH;
    self.textView.width=KScreenWidth-2*KBoardWH;
    
    
    self.location.top = KBoardWH;
    self.location.left = KBoardWH;
    self.location.width=200;
    self.location.height=30;
    
    _button.top=KBoardWH;
    _button.height=self.location.height;
    _button.width=50;
    _button.right=KScreenWidth-KBoardWH;
    
}
#pragma mark 键盘将要弹出
-(void)UIKeyboardWillShow:(NSNotification *)note{
 
    //获取键盘改变的frame
    CGRect EndFrame =[note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat boardY=EndFrame.origin.y;
    self.BgView.transform=CGAffineTransformMakeTranslation(0, boardY-KRepeatBGViewH);
    
}
#pragma mark 键盘将要隐藏
-(void)UIKeyboardWillHide:(NSNotification *)note{
    //回归原来的值
    self.BgView.transform=CGAffineTransformIdentity;
}
#pragma mark UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView endEditing:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];

}
@end
