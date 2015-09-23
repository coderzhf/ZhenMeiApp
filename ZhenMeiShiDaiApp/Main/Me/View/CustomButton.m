//
//  CustomButton.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/18.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title withImage:(UIImage *)image isLabel:(BOOL)label
{
    if(self = [super initWithFrame:frame]){
        
             UIImageView *button = [UQFactory imageViewWithFrame:CGRectMake((self.width-50)/2, 0, 50, 50) image:image];
            button.userInteractionEnabled = NO;
            [self addSubview:button];
        
            UILabel *label1 = [UQFactory labelWithFrame:CGRectMake(button.left-15, button.bottom+2, 80, 20) text:title textColor:[UIColor darkGrayColor]  fontSize:14 center:YES];
            [self addSubview:label1];

        if (label) {
            button.frame = CGRectMake(15/2, 0, self.width-15, self.width-15);
            label1.frame = CGRectMake(2, button.bottom, self.width, 20);
            label1.font = [UIFont systemFontOfSize:12];
            label1.textColor = [UIColor blackColor];
             }
    }
    return self;

}
@end
