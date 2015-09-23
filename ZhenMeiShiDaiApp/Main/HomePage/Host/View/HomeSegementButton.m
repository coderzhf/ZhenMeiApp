//
//  HomeSegementButton.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/19.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#define KSegementLineH 2
#import "HomeSegementButton.h"

@implementation HomeSegementButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"zm_selected_Line"] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 0, self.width, self.height-KSegementLineH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageH=KSegementLineH;
    CGFloat imageW=self.width;
    CGFloat imageY=self.height-KSegementLineH;
    
    return CGRectMake(0, imageY, imageW, imageH);
}
-(void)setHighlighted:(BOOL)highlighted{
}
@end
