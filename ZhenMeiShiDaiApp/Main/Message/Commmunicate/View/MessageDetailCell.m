//
//  Messagecell.m
//  QQ聊天布局
//
//  Created by 张锋 on 15/3/6.
//  Copyright (c) 2015年 张锋. All rights reserved.
//

#import"MessageDetailCell.h"
#import"MessageFrame.h"
#import"Extension.h"

@class Message;
@interface MessageDetailCell()
@property(nonatomic,weak)UILabel *time;
@property(nonatomic,weak)UIImageView *icon;
@property(nonatomic,weak)UIButton *text;


@end
@implementation MessageDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)MessagecellWithTableview:(UITableView *)tableview{
    
    static NSString *ID=@"message";
    MessageDetailCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[MessageDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //定义时间
        UILabel *time=[[UILabel alloc]init];
        [self.contentView addSubview:time];
        self.time=time;//weak弱指针，需要自定义一个指针，才能对象存在，指针存在。
        //定义图像
        UIImageView *icon=[[UIImageView alloc]init];
        [self.contentView addSubview:icon];
        self.icon=icon;
        //定义文本
        UIButton *text=[[UIButton alloc]init];
        [self.contentView addSubview:text];
        self.text=text;
        //清空背景
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(void)setMessageFrame:(MessageFrame *)messageFrame{
    _messageFrame=messageFrame;
    [self setQQDate];
    [self setQQFrame];
}
-(void)setQQDate{
    _time.text=_messageFrame.message.time;
    _time.textAlignment=NSTextAlignmentCenter;
    _time.textColor=[UIColor grayColor];
    _time.font=[UIFont systemFontOfSize:14];
    
    if (_messageFrame.message.userId==[UserDefaults objectForKey:@"userId"]||_messageFrame.message.userId==nil) {//自己
        NSString *str = [UserDefaults objectForKey:@"userImg"];
        if ([str hasPrefix:@"http"]) {
            [_icon sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
        }else{
            [_icon sd_setImageWithURL:[NSURL URLWithString:[KShowPhoto stringByAppendingFormat:@"%@",str]] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
        }

       }else{//别人
            if ([_userImg hasPrefix:@"http"]) {
               [_icon sd_setImageWithURL:[NSURL URLWithString:_userImg] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
           }else{
               [_icon sd_setImageWithURL:[NSURL URLWithString:[KShowPhoto stringByAppendingFormat:@"%@",_userImg]] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
           }
    }
    
    
    [_text setTitle:_messageFrame.message.content forState:UIControlStateNormal];
    [_text setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _text.titleLabel.font=TFond;
    _text.titleLabel.numberOfLines=0;
    _text.contentEdgeInsets=UIEdgeInsetsMake(TextPadding, TextPadding, TextPadding, TextPadding);
    if (_messageFrame.message.userId==[UserDefaults objectForKey:@"userId"]||_messageFrame.message.userId==nil) {

        [_text setBackgroundImage:[UIImage resizeableImage:@"zm_send_pic"] forState:UIControlStateNormal];
    }else{
        [_text setBackgroundImage:[UIImage resizeableImage:@"zm_recive_pic"] forState:UIControlStateNormal];
        
    }
    
    
}
-(void)setQQFrame{
    _time.frame=_messageFrame.timeF;
    _icon.frame=_messageFrame.iconF;
    _text.frame=_messageFrame.textF;
    
}

@end
