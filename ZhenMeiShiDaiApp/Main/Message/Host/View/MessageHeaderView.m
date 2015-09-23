//
//  MessageHeaderView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/23.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MessageHeaderView.h"
#import "HomeSegementButton.h"
@implementation MessageHeaderView

#pragma mark cycle life
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame] ) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        //1.初始化buttons
        [self AddButtonWithTitle:@"我收到的私信" Type:MessageButtonRecieve];
        [self AddButtonWithTitle:@"我发出的私信" Type:MessageButtonSend];
        
    }
    
    return self;
}
-(void)layoutSubviews{
    NSInteger count=self.subviews.count;
    for (int i=0; i<count; i++) {
        UIButton *btn=self.subviews[i];
        btn.width=self.width/count;
        btn.left=i*btn.width;
        btn.height=self.height;
        btn.top=0;
        
    }
}
//初始化Button
-(void)AddButtonWithTitle:(NSString *)title Type:(MessageButtonType)type{
    
    HomeSegementButton *btn=[HomeSegementButton buttonWithType:UIButtonTypeCustom];
   // btn.tag=type;
    [btn setTitle:title forState:UIControlStateNormal];
    //[btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
  
    
}
@end
