//
//  HomeRecommedButtonView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeRecommedButtonView.h"
#import "HttpTool.h"
@interface HomeRecommedButtonView()
@property(nonatomic,strong)NSArray *buttonDetails;
@end
@implementation HomeRecommedButtonView
-(NSArray *)buttonDetails{
    if (!_buttonDetails) {
        _buttonDetails=[[NSArray alloc]init];
    }
    
    return _buttonDetails;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self setupButtons];
        [self loadData];
        
        //初始化按钮
       
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)loadData{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    //sysType=AUDIO_CATEGORY
    dict[@"sysType"]=@"AUDIO_CATEGORY";
    
    [HttpTool post:KHomeRecLabel params:dict success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomeRecLabel *result=[[HomeRecLabel alloc]init];
            result.ID=dict[@"id"];
            result.title=dict[@"title"];
            [temp addObject:result];
        }
        self.buttonDetails=temp;
        [self setupTitles];
    } failure:^(NSError *error) {
    }];

}
-(void)setupButtons{
    for (int i=0; i<8; i++) {
      
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled=YES;
        btn.tag=i;
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        NSString *fileName=[NSString stringWithFormat:@"zm_class%d_Btn",i+1];
        [btn setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(BttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
-(void)setupTitles{
    for (int i=0; i<self.buttonDetails.count; i++) {
        UIButton *btn=self.subviews[i];
        HomeRecLabel *label=self.buttonDetails[i];
        [btn setTitle:label.title forState:UIControlStateNormal];

    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat marginW=25;
    CGFloat marginH=10;
    for (int j=0; j<2; j++) {
        for (int i=0; i<4; i++) {
            UIButton *btn=self.subviews[j*4+i];
            btn.width=(self.width-marginW*5)/4;
            btn.height=btn.width;
            btn.left=marginW+(marginW+btn.width)*i;
            btn.top=marginH+(marginH+btn.width)*j;
            
        }
    }
}
#pragma mark action
-(void)BttonClick:(UIButton *)btn{

    HomeRecLabel *label=self.buttonDetails[btn.tag];
    if ([self.delegate respondsToSelector:@selector(HomeRecommedButtonClickWithLabel:)]) {
        [self.delegate HomeRecommedButtonClickWithLabel:label];
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}
@end
