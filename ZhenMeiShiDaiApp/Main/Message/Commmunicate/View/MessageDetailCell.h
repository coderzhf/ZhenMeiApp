//
//  Messagecell.h
//  QQ聊天布局
//
//  Created by 张锋 on 15/3/6.
//  Copyright (c) 2015年 张锋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFrame;
@interface MessageDetailCell: UITableViewCell
@property(nonatomic,strong)MessageFrame *messageFrame;
@property(nonatomic,strong)NSString *userImg;

+(instancetype)MessagecellWithTableview:(UITableView *)tableview;

@end
