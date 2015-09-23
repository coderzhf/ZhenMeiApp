//
//  TableViewCell1.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "YLLabel.h"

@interface TableViewCell1 : UITableViewCell
{
    UIImageView *headerImg;
    UILabel *name;
    UILabel *distanceLabel;
    UIButton *bigLabel;
    UIButton *smallLabel;
    UILabel *locationLabel;
    YLLabel *contentLabel;
    UILabel *timeLabel;
    UILabel *readerLabel;
    UILabel *replyLabel;
    UILabel *allLabel;
    UILabel *reader;
    UILabel *reply;
    UILabel *sixinLabel;
    UIImageView*	m_checkImageView;
}

@property (nonatomic,strong) NewsModel *newsModel;
@property (nonatomic,strong) UIButton *readerBtn;
@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UIButton *sixinBtn;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIButton *allContentBtn;
@property (nonatomic,assign) BOOL flag;

@property (nonatomic,assign) BOOL isAll;//是否全部展开
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier flag:(BOOL)flag;
- (void)setChecked:(BOOL)checked;

@end
