
//
//  TableViewCell1.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "TableViewCell1.h"
@implementation TableViewCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier flag:(BOOL)flag
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 8)];
        colorLabel.backgroundColor = ZhenMeiRGB(240,240,240);
        [self addSubview:colorLabel];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _flag = flag;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    headerImg = [UQFactory imageViewWithFrame:CGRectMake(5, 15, 50, 50) image:nil];
    [self.contentView addSubview:headerImg];
    if (_flag) {//我的帖子
        headerImg.left =20;
        m_checkImageView = [UQFactory imageViewWithFrame:CGRectMake(3, 10, 15, 15) image:[UIImage imageNamed:@"login_reme_unselcted"]];
        [self addSubview:m_checkImageView];
      }
    
    name = [UQFactory labelWithFrame:CGRectMake(headerImg.right+5, headerImg.top, 0, 20) text:nil textColor:[UIColor blackColor] fontSize:14 center:YES];
    [self.contentView addSubview:name];
    
    bigLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    bigLabel.frame = CGRectMake(name.left, name.bottom+10, 70, 20);
    bigLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [bigLabel setBackgroundImage:[UIImage imageNamed:@"zm_label_Bg"] forState:UIControlStateNormal];
    [self.contentView addSubview:bigLabel];
    
    smallLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    smallLabel.frame = CGRectMake(bigLabel.right+3, name.bottom+10, 70, 20);
    [smallLabel setTitleColor:ZhenMeiRGB(205, 173, 0) forState:UIControlStateNormal];
    smallLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [smallLabel setBackgroundImage:[UIImage imageNamed:@"zm_smallLabel_Img"] forState:UIControlStateNormal];
    [self.contentView addSubview:smallLabel];
    
    UIImageView *distanceImg = [UQFactory imageViewWithFrame:CGRectMake(KScreenWidth - 60, headerImg.top+5, 15, 15) image:[UIImage imageNamed:@"zm_distance_img"]];
    [self.contentView addSubview:distanceImg];
        
    distanceLabel = [UQFactory labelWithFrame:CGRectMake(distanceImg.right+2, distanceImg.top, 50, 20) text:nil textColor:ZhenMeiRGB(205, 173, 0)  fontSize:12 center:NO];
    [self.contentView addSubview:distanceLabel];
    
    UIImageView *locationImg = [UQFactory imageViewWithFrame:CGRectMake(KScreenWidth - 75, smallLabel.bottom-15, 12, 17) image:[UIImage imageNamed:@"zm_location_img"]];
    [self.contentView addSubview:locationImg];
    
    locationLabel = [UQFactory labelWithFrame:CGRectMake(locationImg.right, locationImg.top, 70, 20) text:nil textColor:ZhenMeiRGB(205, 173, 0)  fontSize:12 center:NO];
    [self.contentView addSubview:locationLabel];
    
    contentLabel = [[YLLabel alloc] initWithFrame:CGRectZero];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:contentLabel];
    
    for (int i = 0; i < 3; i ++) {
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        lineLabel.tag = i+1;
        lineLabel.backgroundColor = ZhenMeiRGB(220, 220, 220);
        [self.contentView addSubview:lineLabel];
    }

    timeLabel = [UQFactory labelWithFrame:CGRectZero text:nil textColor:ZhenMeiRGB(200, 200, 200)  fontSize:12 center:YES];
    [self.contentView addSubview:timeLabel];
    
    reader = [UQFactory labelWithFrame:CGRectZero text:@"关注" textColor:[UIColor lightGrayColor] fontSize:12 center:NO];
    [self.contentView addSubview:reader];
    
    _readerBtn = [UQFactory buttonWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_readCount_Btn"] ];
    [self.contentView addSubview:_readerBtn];
    
    readerLabel = [UQFactory labelWithFrame:CGRectZero text:nil textColor:[UIColor lightGrayColor]  fontSize:12 center:YES];
    [self.contentView addSubview:readerLabel];
    
    reply = [UQFactory labelWithFrame:CGRectZero text:@"回复" textColor:[UIColor lightGrayColor] fontSize:12 center:NO];
    [self.contentView addSubview:reply];
    
    _replyBtn = [UQFactory buttonWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_replyCount_Btn"] ];
    [self.contentView addSubview:_replyBtn];
    
    replyLabel = [UQFactory labelWithFrame:CGRectZero text:nil textColor:[UIColor lightGrayColor] fontSize:12 center:YES];
    [self.contentView addSubview:replyLabel];
    
    _sixinBtn = [UQFactory buttonWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_sixin_Img"]];
    _sixinBtn.tag = 25;
    [self.contentView addSubview:_sixinBtn];
    
    sixinLabel = [UQFactory labelWithFrame:CGRectZero text:@"私信" textColor:[UIColor lightGrayColor] fontSize:12 center:NO];
    [self.contentView addSubview:sixinLabel];
    
    _allContentBtn = [UQFactory buttonWithFrame:CGRectZero title:nil titleColor:ZhenMeiRGB(205, 173, 0) fontName:nil fontSize:14];
    _allContentBtn.hidden = YES;
    [self.contentView addSubview:_allContentBtn];
 }

- (void)setNewsModel:(NewsModel *)newsModel
{
    if (_newsModel != newsModel) {
        _newsModel = newsModel;
      }
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    if ([_newsModel.userImg hasPrefix:@"http"]) {
        [headerImg sd_setImageWithURL:[NSURL URLWithString:_newsModel.userImg] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];
    }else{
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,_newsModel.userImg]] placeholderImage:[UIImage imageNamed:@"yx_moren_Img"]];}
    
    name.text = _newsModel.userName ;
    name.width = [_newsModel.userName boundingRectWithSize:CGSizeMake(KScreenWidth-30, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    [bigLabel setTitle:_newsModel.category1  forState:UIControlStateNormal];
    [smallLabel setTitle:_newsModel.category2  forState:UIControlStateNormal];
    locationLabel.text = _newsModel.memo;
    if ([_newsModel.distance integerValue]>=1000) {
        distanceLabel.text = [NSString stringWithFormat:@"%d.%dkm", [_newsModel.distance intValue]/1000,[_newsModel.distance intValue]%1000/100];
        
    }else{
        distanceLabel.text = [NSString stringWithFormat:@"%@m", _newsModel.distance];
    }
    [contentLabel setText:_newsModel.content];
    timeLabel.text = _newsModel.issueTime;
    readerLabel.text = [NSString stringWithFormat:@"%@", _newsModel.focusCount];
    replyLabel.text = [NSString stringWithFormat:@"%@", _newsModel.commentCount];
    CGFloat height = [Utils getContentStrHeight:_newsModel.content];
    if (height>125) {
        _allContentBtn.hidden = NO;
    }else{
        _allContentBtn.hidden = YES;}
    
    NSString *title = _isAll?@"[收起]":@"[全文...]";
    [_allContentBtn setTitle:title forState:UIControlStateNormal];
    if (!_isAll) {//收起
        if (height>125) {
            height = 125;
        }else{
            height = height;
        }
    }else{
        height = height;
    }
    contentLabel.frame = CGRectMake(5, headerImg.bottom+8, KScreenWidth-10, height);
    _allContentBtn.frame = CGRectMake(KScreenWidth-65, contentLabel.bottom-8, 50, 15);
    UILabel *label1 =  (UILabel *)[self.contentView viewWithTag:1];
    label1.frame = CGRectMake(KScreenWidth/4, contentLabel.bottom+14, 1, 12);
    UILabel *label2 =  (UILabel *)[self.contentView viewWithTag:2];
    label2.frame = CGRectMake(KScreenWidth*2/4, contentLabel.bottom+14, 1, 12);
    UILabel *label3 =  (UILabel *)[self.contentView viewWithTag:3];
    label3.frame = CGRectMake(KScreenWidth*3/4, contentLabel.bottom+14, 1, 12);
    timeLabel.frame = CGRectMake(5, contentLabel.bottom+10, KScreenWidth/4, 20);
    
    reader.frame = CGRectMake(KScreenWidth/4+10, timeLabel.top, 30, 20);
    _readerBtn.frame = CGRectMake(reader.right, reader.top+3, 15, 16);
    readerLabel.frame = CGRectMake(_readerBtn.right, timeLabel.top, 20, 20);
    
    reply.frame = CGRectMake(KScreenWidth*2/4+10, timeLabel.top, 30, 20);
    _replyBtn.frame = CGRectMake(reply.right, reply.top+3, 18, 16);
    replyLabel.frame = CGRectMake(_replyBtn.right, timeLabel.top, 20, 20);
    
    _sixinBtn.frame = CGRectMake(KScreenWidth*3/4+25, contentLabel.bottom+10, 20, 20);
    sixinLabel.frame = CGRectMake(_sixinBtn.right, _sixinBtn.top, 40, 20);

}
- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        m_checkImageView.image = [UIImage imageNamed:@"login_reme_selcted.png"];
    }
    else
    {
        m_checkImageView.image = [UIImage imageNamed:@"login_reme_unselcted.png"];
    }
}

- (void)setIsAll:(BOOL)all
{
    if (_isAll != all) {
        _isAll = all;}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
