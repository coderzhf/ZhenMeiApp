//
//  PlayButton.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/18.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "PlayButton.h"

@implementation PlayButton

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.titleLabel.shadowColor=[UIColor clearColor];
        self.titleLabel.font=[UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 5, 15, 15);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat width=contentRect.size.width-self.imageView.width;
    return CGRectMake(20, 5, width, 15);
}
-(void)setHighlighted:(BOOL)highlighted{
    
}
@end
