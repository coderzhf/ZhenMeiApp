//
//  SystemMessageCell.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/26.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "SystemMessageCell.h"
#import "SystemMessageModel.h"
@interface SystemMessageCell()
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *MessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@end
@implementation SystemMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    SystemMessageCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemMessageCell" owner:nil options:nil] lastObject];
    
    return cell;
}
-(void)setModel:(NSObject *)model{
 
    SystemMessageModel *system=(SystemMessageModel *)model;
    self.NameLabel.text=system.title;
    self.MessageLabel.text=system.content;
    self.TimeLabel.text=system.sendTime;
}

@end
