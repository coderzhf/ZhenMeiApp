//
//  HomeSegmentView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeSegmentView.h"
#import "HomeSegementButton.h"
@interface HomeSegmentView()
@property(nonatomic,weak)UIButton *selectedButton;
@end
@implementation HomeSegmentView
static NSArray *_titles;
static NSArray *_types;
#pragma mark cycle life
+(void)initialize{
    _titles=[[NSArray alloc]init];
    _types=[[NSArray alloc]init];

}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame] ) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
       //1.初始化buttons
        
        NSInteger count=_titles.count;
        
        for (int i=0; i<count; i++) {
            
            [self AddButtonWithTitle:_titles[i] Type:[_types[i] intValue]];
        }
    
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
+(instancetype)initButtonWithTitleArray:(NSArray *)titles type:(NSArray *)types{

    _titles=titles;
    _types=types;
    return [[self alloc]init];
}
//初始化Button
-(void)AddButtonWithTitle:(NSString *)title Type:(HomeSegmentButtonType)type{
  
    HomeSegementButton *btn=[HomeSegementButton buttonWithType:UIButtonTypeCustom];
    btn.tag=type;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if(type==HomeSegmentButtonReconmend||
       type==MessageButtonPrivateMessage||
       type==MyCollectionButtonAudio){
        [self BtnClick:btn];
    }
    if (type==HomeSegmentButtonReconmend) {
        self.firstBtn = btn;
    }
}
//点击Button
-(void)BtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(HomeSegementWithTag:)]) {
        [self.delegate HomeSegementWithTag:btn.tag];
    }
    self.selectedButton.selected=NO;
    btn.selected=YES;
    self.selectedButton=btn;
}

@end
