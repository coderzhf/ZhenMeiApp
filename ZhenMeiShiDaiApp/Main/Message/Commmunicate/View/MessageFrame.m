//
//  MessageFrame.m
//  
//
//  Created by 张锋 on 15/3/6.
//  Copyright (c) 2015年 张锋. All rights reserved.
//


#import "MessageFrame.h"
#import "NSString+Extension.h"
@implementation MessageFrame
-(void)setMessage:(Message *)message{
    _message=message;
    
    CGFloat padding=10;
    CGFloat MaxWeight=[UIScreen mainScreen].bounds.size.width;
    //时间
    if(_message.HidenTime==NO){
    CGFloat timeX=0;
    CGFloat timeY=0;
    CGFloat timeW=MaxWeight;
    CGFloat timeH=40;
    _timeF=CGRectMake(timeX, timeY, timeW, timeH);
    }
    //头像
    CGFloat iconWH=40;
    CGFloat iconY=CGRectGetMaxY(_timeF)+padding;
    CGFloat iconX;
    if (_message.userId==[UserDefaults objectForKey:@"userId"]||_message.userId==nil) {
        iconX=MaxWeight-padding-iconWH;

    }else{//别人
        
        iconX=padding;
        
    }
     _iconF=CGRectMake(iconX, iconY, iconWH, iconWH);
   
    //文字
    
    CGFloat textY=iconY;
    CGSize maxsize=CGSizeMake(150, MAXFLOAT);
    CGSize  textSize = [_message.content sizeWithFont:TFond Maxsize:maxsize];
    CGSize textBtnSize=CGSizeMake(textSize.width+TextPadding*2, textSize.height+TextPadding*1.5);
    CGFloat textX;
    if (_message.userId==[UserDefaults objectForKey:@"userId"]||_message.userId==nil) {
        textX=iconX-padding-textBtnSize.width;
    }else{//别人
        textX=CGRectGetMaxX(_iconF)+padding;
    }
    _textF=CGRectMake(textX, textY, textBtnSize.width, textBtnSize.height);
    //返回高度
    //CGFloat textMaxY=CGRectGetMaxY(_textF);
    //CGFloat iconMaxY=CGRectGetMaxY(_iconF);
    _cellHeight=textBtnSize.height+padding*3;
}

@end
