//
//  TableViewCell2.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "TableViewCell2.h"

@implementation TableViewCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageView = [UQFactory imageViewWithFrame:CGRectMake(8, 0, KScreenWidth-16, 0) image:[UIImage imageNamed:@"zm_cell_Bg"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imageView];
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    _nameButton = [UQFactory buttonWithFrame:CGRectMake(12, 2, 0, 25) title:nil titleColor:ZhenMeiRGB(205, 173, 0) fontName:nil fontSize:14];
    _nameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameButton];
    
    commentLabel = [UQFactory labelWithFrame:CGRectZero text:nil textColor:[UIColor lightGrayColor] fontSize:14 center:NO];
    commentLabel.numberOfLines = 0;
    [self.contentView addSubview:commentLabel];
    
    timeLabel = [UQFactory labelWithFrame:CGRectZero text:nil textColor:[UIColor lightGrayColor]  fontSize:12 center:NO];
    [self.contentView addSubview:timeLabel];
    
    locationImageView = [UQFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_dingwei_img"]];
    [self.contentView addSubview:locationImageView];
    
    locationLabel = [UQFactory labelWithFrame:CGRectZero text:nil textColor:[UIColor lightGrayColor]  fontSize:12 center:NO];
    [self.contentView addSubview:locationLabel];
}

- (void)setCommentModel:(CommentModel *)commentModel
{
    if (_commentModel != commentModel) {
        _commentModel = commentModel;
        if ([_commentModel.answerUserId intValue]!=0) {//回复某人
            NSString *str = [NSString stringWithFormat:@"%@@%@",_commentModel.name,_commentModel.answerName];
                [_nameButton setTitle:str forState:UIControlStateNormal];
                _nameButton.width = [self returnLength:str];
            
        }else{//回复楼主
            [_nameButton setTitle:_commentModel.name forState:UIControlStateNormal];
            _nameButton.width = [self returnLength:_commentModel.name];
        }
        commentLabel.text = [NSString stringWithFormat:@": %@",_commentModel.content];
        imageView.height = [Utils getContentHeight:_commentModel.content] +33;
        commentLabel.frame = CGRectMake(_nameButton.right, 5, KScreenWidth - _nameButton.right, [Utils getContentHeight:_commentModel.content]);
        timeLabel.frame = CGRectMake(17, commentLabel.bottom+10, 120, 20);
        locationImageView.frame = CGRectMake(KScreenWidth - 85, timeLabel.top, 10, 15);
        locationLabel.frame = CGRectMake(locationImageView.right , locationImageView.top, 80, 20);
         timeLabel.text = _commentModel.time;
        locationLabel.text = _commentModel.city;
        if (!_commentModel.city) {
            locationLabel.text = @"湖北武汉";
        }
    }
}

- (CGFloat)returnLength:(NSString *)str
{
  return [str boundingRectWithSize:CGSizeMake(KScreenWidth-90, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
