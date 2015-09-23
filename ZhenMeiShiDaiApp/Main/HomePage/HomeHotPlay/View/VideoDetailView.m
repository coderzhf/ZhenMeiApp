//
//  VideoDetailView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/18.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "VideoDetailView.h"
#import "PlayButton.h"
#import "HttpTool.h"
@interface VideoDetailView()

@property(nonatomic,weak)UIButton *TimeButton;
@end
@implementation VideoDetailView

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self setupButtons];
    }
    return self;
}
-(void)setupButtons {
    //1.观看次数
    PlayButton *PlayNumButton=[PlayButton buttonWithType:UIButtonTypeCustom];
    [PlayNumButton setImage:[UIImage imageNamed:@"zm_listen_Btn"] forState:UIControlStateNormal];
    [self addSubview:PlayNumButton];
    self.PlayNumButton=PlayNumButton;
    //2.分享
    PlayButton *ShareButton=[PlayButton buttonWithType:UIButtonTypeCustom];
    [ShareButton setTitle:@"收藏" forState:UIControlStateNormal];
    [ShareButton setTitle:@"已收藏" forState:UIControlStateSelected];
    [ShareButton setImage:[UIImage imageNamed:@"zm_unSelected_Btn"] forState:UIControlStateNormal];
    [ShareButton setImage:[UIImage imageNamed:@"zm_shoucang1_Btn"] forState:UIControlStateSelected];
    [ShareButton addTarget:self action:@selector(ClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    ShareButton.enabled = NO;
    [self addSubview:ShareButton];
    self.ShareButton=ShareButton;
    //3.视频时间
    PlayButton *TimeButton=[PlayButton buttonWithType:UIButtonTypeCustom];
    [TimeButton setTitle:@"10:00" forState:UIControlStateNormal];
    [TimeButton setImage:[UIImage imageNamed:@"zm_timeLength_Btn"] forState:UIControlStateNormal];
    [self addSubview:TimeButton];
    self.TimeButton=TimeButton;

}
-(void)setVideoDetailWithplayNum:(NSInteger)num shared:(BOOL)shared duration:(NSString *)duration{
    
    //[self.PlayNumButton setTitle:[NSString stringWithFormat:@"%ld次",(long)num] forState:UIControlStateNormal];
    [self.TimeButton setTitle:duration forState:UIControlStateNormal];
    self.ShareButton.enabled = YES;
    self.ShareButton.selected=shared;
   


}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width=self.width/3;
    self.PlayNumButton.left=10;
    self.PlayNumButton.top=5;
    self.PlayNumButton.width=width;
    self.PlayNumButton.height=self.height;
    
    self.ShareButton.left=self.PlayNumButton.right;
    self.ShareButton.top=5;
    self.ShareButton.width=width;
    self.ShareButton.height=self.height;
    
    self.TimeButton.left=self.ShareButton.right;
    self.TimeButton.top=5;
    self.TimeButton.width=width;
    self.TimeButton.height=self.height;
    
}

-(void)ClickShareButton:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(VideoDetailViewButtonClick:)]) {
        [self.delegate VideoDetailViewButtonClick:btn];
    }

}
@end
