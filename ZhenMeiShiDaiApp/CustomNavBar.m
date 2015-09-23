//
//  CustomNavBar.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/12.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "CustomNavBar.h"
#import "UIView+Addition.h"


@implementation CustomNavBar

- (id)initWithFrame:(CGRect)frame isFirstPage:(BOOL)firstPage withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backGroundImageView=[[UIImageView alloc] initWithFrame:frame];
        _backGroundImageView.image=[UIImage imageNamed:@"zm_nav_Bg"];
        _backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backGroundImageView.userInteractionEnabled=YES;
        [self addSubview:_backGroundImageView];
        
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-190)/2, KnavHeight-35, 190, 30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:_titleLabel];
        if (!firstPage) {
            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backBtn.frame = CGRectMake(20, KnavHeight-28 , 13, 18);
            [backBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:backBtn];
 
        }
            }
    return self;
}

- (void)backAction
{
    [[self viewController].navigationController popViewControllerAnimated:NO];
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
