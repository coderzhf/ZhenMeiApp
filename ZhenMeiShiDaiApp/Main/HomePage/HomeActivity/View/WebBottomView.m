//
//  WebBottomView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/27.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "WebBottomView.h"
@interface WebBottomView()

@end
@implementation WebBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=ZhenMeiRGB(236, 236, 236);
        [self setupSubViews];
    }
    
    return self;
}
-(void)setupSubViews{
    
    UILabel *ReadNumLabel=[[UILabel alloc]init];
    ReadNumLabel.textAlignment=NSTextAlignmentCenter;
    ReadNumLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:ReadNumLabel];
    self.ReadNumLabel=ReadNumLabel;
    
    PlayButton *SharedButton=[[PlayButton alloc]init];
    [SharedButton setTitle:@"分享" forState:UIControlStateNormal];
    [SharedButton setImage:[UIImage imageNamed:@"zm_share_Btn"] forState:UIControlStateNormal];
    SharedButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [self addSubview:SharedButton];
    self.SharedButton=SharedButton;
    
    PlayButton *SavedButton=[[PlayButton alloc]init];
    [SavedButton setImage:[UIImage imageNamed:@"zm_unSelected_Btn"] forState:UIControlStateNormal];
    [SavedButton setImage:[UIImage imageNamed:@"zm_shoucang1_Btn"] forState:UIControlStateSelected];
    [SavedButton setTitle:@"已收藏" forState:UIControlStateSelected];

    [self addSubview:SavedButton];
    self.SavedButton=SavedButton;
    
    
  
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat Labelwidth=self.width/3;
    CGFloat Topmargin=5;
    CGFloat Widthmargin=20;
    CGFloat ButtonWidth=Labelwidth-2*Widthmargin;
    self.ReadNumLabel.width=Labelwidth;
    self.ReadNumLabel.height=self.height;
    self.ReadNumLabel.left=0;
    
    self.SavedButton.left=self.ReadNumLabel.right+2*Widthmargin;
    self.SavedButton.top=Topmargin;
    self.SavedButton.width=ButtonWidth;
    self.SavedButton.height=self.height;
    
    
    self.SharedButton.left=self.SavedButton.right+2*Widthmargin;
    self.SharedButton.top=Topmargin;
    self.SharedButton.width=ButtonWidth;
    self.SharedButton.height=self.height;
}
@end
