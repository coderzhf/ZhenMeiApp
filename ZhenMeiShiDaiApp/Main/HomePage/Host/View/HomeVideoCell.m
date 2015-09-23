//
//  HomeVideoCell.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeVideoCell.h"
#import "HomeVideo.h"
#import "UIImageView+WebCache.h"
@interface HomeVideoCell()
@property(nonatomic,weak)UIImageView *IconView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *Label1;
@property(nonatomic,weak)UILabel *Label2;
@property(nonatomic,weak)UIView *seperator;

@end
@implementation HomeVideoCell

#pragma mark init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化cell内部控件
        [self setupSubViews];
        
    }
    return self;
}
-(void)setupSubViews{
    //1.初始化图像
    UIImageView *IconView=[[UIImageView alloc]init];
    self.IconView=IconView;
    [self.contentView addSubview:IconView];
    //2.初始化标题
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel=titleLabel;
    [self.contentView addSubview:titleLabel];
    //3.初始化第一列
    UILabel *Label1=[[UILabel alloc]init];
    Label1.font=[UIFont systemFontOfSize:12];
    Label1.numberOfLines = 0;

    Label1.textAlignment=NSTextAlignmentLeft;
    Label1.textColor=[UIColor lightGrayColor];
    self.Label1=Label1;
    [self.contentView addSubview:Label1];
    //4.初始化第二列
    UILabel *Label2=[[UILabel alloc]init];
    Label2.font=[UIFont systemFontOfSize:12];
    Label2.numberOfLines = 0;
    Label2.textAlignment=NSTextAlignmentLeft;
    Label2.textColor=[UIColor lightGrayColor];
    self.Label2=Label2;
    [self.contentView addSubview:Label2];
    
    //5.分割线
    UIView *seperator = [[UIView alloc]init];
   
    seperator.backgroundColor = ZhenMeiRGBA(0, 0, 0, 0.2);
    [self.contentView addSubview:seperator];
    self.seperator = seperator;
}
-(void)setVideo:(HomeVideo *)video{
     _video=video;
    NSString *imageUrl=[KShowPhoto stringByAppendingFormat:@"%@",video.picPath];
    [self.IconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"zm_yinpin_defalut"]];
    
    self.titleLabel.text=video.shortTitle;
    NSString *name = [video.author stringByReplacingOccurrencesOfString:@";" withString:@"\r\n"];
    NSString *origin = [video.origin stringByReplacingOccurrencesOfString:@";" withString:@"\r\n"];

    self.Label1.text=name;
    self.Label2.text=origin;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.IconView.frame=CGRectMake(10, 5, 100, 72);
    
    self.titleLabel.top=5;
    self.titleLabel.left=self.IconView.right+10;
    self.titleLabel.width=self.contentView.width-self.IconView.width;
    self.titleLabel.height=15;
    NSArray *authorArray = [_video.author componentsSeparatedByString:@";"];

    self.Label1.top=self.titleLabel.bottom;
    self.Label1.left=self.titleLabel.left;
    self.Label1.width=45;
    
    self.Label2.top=self.Label1.top;
    self.Label2.left=self.Label1.right;
    self.Label2.width=KScreenWidth-70-70;
    if (authorArray.count ==1) {
        self.Label1.height= 15;
        self.Label2.height= 15;

    }else if (authorArray.count ==2){
        self.Label1.height=30;
        self.Label2.height= 30;

    }else if (authorArray.count ==3){
        self.Label1.height=45;
        self.Label2.height= 45;

    }else if (authorArray.count ==4){
        self.Label1.height=60;
        self.Label2.height= 60;

    }else if (authorArray.count ==5){
        self.Label1.height=75;
        self.Label2.height= 75;

    }else{
        self.Label1.height=90;
        self.Label2.height= 90;

    }

    self.seperator.height = 1;
    self.seperator.width = self.width;
    self.seperator.top = self.height -self.seperator.height;
    //[Utils getNameHeight:originArray.firstObject width:KScreenWidth-140]*authorArray.count;
}
@end
