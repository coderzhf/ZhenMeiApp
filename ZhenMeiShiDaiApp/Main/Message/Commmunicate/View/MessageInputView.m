//
//  MessageInputView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MessageInputView.h"
@interface MessageInputView()

@end
@implementation MessageInputView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"MessageInputView"owner:self options:nil][0];
        [self.RepeatButton setBackgroundColor:ZhenMeiRGB(238, 209, 78)];
        self.RepeatButton.layer.cornerRadius=5;
    }
    return self;
}

@end
