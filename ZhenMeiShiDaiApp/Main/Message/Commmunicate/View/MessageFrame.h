//
//  MessageFrame.h
//  
//
//  Created by 张锋 on 15/3/6.
//  Copyright (c) 2015年 张锋. All rights reserved.
//
//正文的字体
#define TFond [UIFont systemFontOfSize:15]
//正文的内边距
#define TextPadding 20
#import <UIKit/UIKit.h>
#import"Message.h"
@interface MessageFrame : NSObject
@property(nonatomic,assign,readonly)CGRect iconF;
@property(nonatomic,assign,readonly)CGRect timeF;
@property(nonatomic,assign,readonly)CGRect textF;
@property(nonatomic,assign,readonly)CGFloat cellHeight;
@property(nonatomic,strong)Message *message;

@end
