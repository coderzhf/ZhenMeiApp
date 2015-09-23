//
//  TableViewCell2.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface TableViewCell2 : UITableViewCell
{
    
    UILabel *commentLabel;
    UILabel *timeLabel;
    UIImageView *locationImageView;
    UILabel *locationLabel;
    UIImageView *imageView;
}
@property (nonatomic ,strong) CommentModel *commentModel;
@property (nonatomic ,strong) UIButton *nameButton;

@end
