
//
//  TableViewCell3.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "TableViewCell3.h"

@implementation TableViewCell3

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageView = [UQFactory imageViewWithFrame:CGRectMake(10, 0, KScreenWidth-20, self.height) image:[UIImage imageNamed:@"zm_cell_Bg"]];
        [self.contentView addSubview:imageView];
        
        allLabel  = [[UILabel alloc] initWithFrame:CGRectMake((self.width-140)/2,5, 140, 20)];
        allLabel.textColor = ZhenMeiRGB(205, 173, 0);
        allLabel.font = [UIFont systemFontOfSize:14];
        allLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:allLabel];
        
        _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _upBtn.frame = CGRectMake((self.width-10)/2, allLabel.bottom , 20, 15);
        [self.contentView addSubview:_upBtn];
        //[self bringSubviewToFront:_upBtn];

    }
    return self;
}

- (void)refresh:(NSInteger)Count open:(BOOL)isOpen
{
    if (isOpen) {
        
        allLabel.text = [NSString stringWithFormat:@"收起评论"];
        [_upBtn setImage:[UIImage imageNamed:@"zm_down_Btn"] forState:UIControlStateNormal];
        
        
    }else{
        allLabel.text = [NSString stringWithFormat:@"查看全部%ld条评论",(long)Count];
        [_upBtn setImage:[UIImage imageNamed:@"zm_up_Btn"] forState:UIControlStateNormal];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
