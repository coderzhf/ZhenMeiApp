//
//  HomectivityCell.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/8/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomectivityCell.h"

@interface HomectivityCell ()
@property(nonatomic,strong)UILabel *shortTitle;//小标题

@property(nonatomic,strong)UIImageView *imgView;//图片来源
@property(nonatomic,strong)UIImageView *distanceImg;//图片来源
@property(nonatomic,strong)UIImageView *locationImg;//图片来源

@property(nonatomic ,strong)UILabel *time; //时间
@property (nonatomic ,strong)UILabel *address;//地址
@property (nonatomic ,strong)UILabel *sponsor;//主办方

@property(nonatomic,weak)UIView *seperator;

@end

@implementation HomectivityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化cell内部控件
        [self setupSubViews];
        self.backgroundColor =ZhenMeiRGBA(230, 230, 230, 1);
    }
    return self;
}

-(void)setupSubViews{
    //1.初始化图片
    UIImageView *pictureView=[[UIImageView alloc]init];
    self.imgView = pictureView;
    [self.contentView addSubview:pictureView];
     //2.初始化标题
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor=[UIColor blackColor];
    self.shortTitle = titleLabel;
    [self.contentView addSubview:titleLabel];
    //3.初始化内容
    UILabel *sponsor=[[UILabel alloc]init];
    sponsor.font=[UIFont systemFontOfSize:12];
    sponsor.textAlignment=NSTextAlignmentLeft;
    sponsor.textColor=[UIColor lightGrayColor];
    self.sponsor=sponsor;
    [self.contentView addSubview:sponsor];
    //3.初始化时间
    _distanceImg = [UQFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_clock"]];
    [self.contentView addSubview:_distanceImg];
    
    UILabel *time=[[UILabel alloc]init];
    time.font=[UIFont systemFontOfSize:10];
    time.textAlignment=NSTextAlignmentLeft;
    time.textColor=[UIColor lightGrayColor];
    self.time=time;
    [self.contentView addSubview:time];
    //3.初始化地址
    _locationImg = [UQFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_location_img"]];
    [self.contentView addSubview:_locationImg];
    
    UILabel *address=[[UILabel alloc]init];
    address.font=[UIFont systemFontOfSize:10];
    address.textAlignment=NSTextAlignmentLeft;
    address.textColor=[UIColor lightGrayColor];
    self.address=address;
    [self.contentView addSubview:address];
    //5.分割线
    UIView *seperator = [[UIView alloc]init];
    seperator.backgroundColor = ZhenMeiRGBA(0, 0, 0, 0.2);
    [self.contentView addSubview:seperator];
    self.seperator = seperator;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imgView.frame=CGRectMake(10, 7, 100, 72);
    
    self.shortTitle.top=7;
    self.shortTitle.left=self.imgView.right+15;
    self.shortTitle.width=self.contentView.width-self.imgView.width-20;
    
    self.sponsor.top = self.shortTitle.bottom+5;
    self.sponsor.height=15;
    self.sponsor.width=self.shortTitle.width;
    self.sponsor.left=self.shortTitle.left;
    
    self.distanceImg.frame = CGRectMake(self.shortTitle.left, 64, 13, 13);
    self.time.frame = CGRectMake(self.distanceImg.right+3, 64, 80, 15);
    
    self.locationImg.frame = CGRectMake(self.width-55, 64, 11, 15);
    self.address.frame = CGRectMake(self.locationImg.right+3, 64, 40, 15);
    
    self.seperator.height = 1;
    self.seperator.width = KScreenWidth;
    self.seperator.top = self.height -self.seperator.height;
}

- (void)setHomePicture:(HomePicture *)homePicture
{
    _homePicture = homePicture;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,_homePicture.imgPatch]] placeholderImage:[UIImage imageNamed:@"zm_yinpin_defalut"]];
    _shortTitle.text = _homePicture.shortTitle;
    self.shortTitle.height=[Utils getNameHeight:_homePicture.shortTitle width:KScreenWidth-120];
    _sponsor.text = [NSString stringWithFormat:@"主办: %@",_homePicture.sponsor];
    _address.text = _homePicture.address;
    _time.text = _homePicture.releaseSysTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
