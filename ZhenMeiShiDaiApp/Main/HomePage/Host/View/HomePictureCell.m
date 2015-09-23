//
//  HomePictureCell.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomePictureCell.h"
#import "PlayButton.h"
#import "HomePicture.h"
@interface HomePictureCell()
@property(nonatomic,weak)UIImageView *pictureView;
@property(nonatomic,weak)UIView *shadowView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)PlayButton *ReadNum;
@end
@implementation HomePictureCell
#pragma mark init
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
    [self.contentView addSubview:pictureView];
    self.pictureView=pictureView;
    //2.初始化view
    UIView *shadowView=[[UIView alloc]init];
   // shadowView.alpha=0.5;
    shadowView.userInteractionEnabled=NO;
    shadowView.backgroundColor=ZhenMeiRGBA(0,0, 0, 0.3);
    [pictureView addSubview:shadowView];
    self.shadowView=shadowView;
    //3.初始化标题
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor whiteColor];
    [shadowView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    //4.初始化阅读量
    PlayButton *ReadNum=[PlayButton buttonWithType:UIButtonTypeCustom];
    ReadNum.userInteractionEnabled=NO;
    [ReadNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shadowView addSubview:ReadNum];
    self.ReadNum=ReadNum;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.pictureView.width=self.width-6;
    self.pictureView.height=120;
    self.pictureView.left=3;

    self.shadowView.width=self.pictureView.width;
    self.shadowView.height=30;
    self.shadowView.top=self.height-self.shadowView.height-8;
    
    self.titleLabel.height=self.shadowView.height;
    self.titleLabel.width=250;
    self.titleLabel.left=10;
    
    self.ReadNum.width=55;
    self.ReadNum.height=self.shadowView.height;
    self.ReadNum.left=self.width-self.ReadNum.width;
    
}
-(void)setHomePic:(HomePicture *)homePic{
    _homePic=homePic;
    
    NSString *imageUrl=[KShowPhoto stringByAppendingFormat:@"%@",homePic.imgPatch];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"zm_defalut_yp"]];
    self.titleLabel.text=homePic.shortTitle;
    [self.ReadNum setTitle:[NSString stringWithFormat:@"%@",_homePic.visitTotal ] forState:UIControlStateNormal];
    [self.ReadNum setImage:[UIImage imageNamed:@"zm_readCount_Img"] forState:UIControlStateNormal];
}
-(void)setHighlighted:(BOOL)highlighted{
    
}
-(void)setSelected:(BOOL)selected{
    
}


@end
