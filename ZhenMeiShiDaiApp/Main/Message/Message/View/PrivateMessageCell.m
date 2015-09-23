//
//  PrivateMessageCell.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/26.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "PrivateMessageCell.h"
#import "PrivateMessageModel.h"
#import "UIImageView+WebCache.h"
@interface PrivateMessageCell()
@property (weak, nonatomic) IBOutlet UIImageView *IconImage;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *MessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;

@end
@implementation PrivateMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    PrivateMessageCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PrivateMessageCell" owner:nil options:nil] lastObject];
   
    return cell;
}

-(void)setModel:(NSObject *)model{
    
    PrivateMessageModel *private=(PrivateMessageModel *)model;
    NSString *imageUrl=[KShowPhoto stringByAppendingFormat:@"%@",private.userImg];
    if ([private.userImg hasPrefix:@"http"]) {
        [self.IconImage sd_setImageWithURL:[NSURL URLWithString:private.userImg] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
    }else{
        [self.IconImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
    }
    self.NameLabel.text=private.userName;
    self.TimeLabel.text=private.time;
    self.MessageLabel.text=private.content;
    
}

@end
