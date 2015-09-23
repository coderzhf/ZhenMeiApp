//
//  HomeRecomendHeaderView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomeRecommendHeaderView.h"
#import "SDCycleScrollView.h"
#import "HttpTool.h"
#import "HomeRecResult.h"
#import "HomePicture.h"
#import "MJExtension.h"
@interface HomeRecommendHeaderView()<SDCycleScrollViewDelegate>
@property(nonatomic,weak)SDCycleScrollView *ScrollView;
@property(nonatomic,strong)NSArray *imagesURLStrings;
@property(nonatomic,strong)NSArray *addArray;
@end
@implementation HomeRecommendHeaderView
-(NSArray *)imagesURLStrings{
    if (!_imagesURLStrings) {
        _imagesURLStrings=[[NSArray alloc]init];
        
    }
    return _imagesURLStrings;
}
- (NSArray *)addArray {
    if (!_addArray) {
        _addArray = [[NSArray alloc]init];
    }
    return _addArray;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //1.初始化化滚动界面
        [self setupWebScrollView];
        //2.初始化选择界面
        [self setupReconmmendView];
    }
    
    return self;
}

-(void)setupWebScrollView{
    
    //加载网络图片实现
    NSLog(@"%@",KHomeAd);
    [HttpTool post:KHomeAd params:nil success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        NSMutableArray *addtemp = [NSMutableArray array];
        for (NSDictionary *dict in success) {
            NSString *fileName=dict[@"picPath"];
            NSString *filePath=[KShowPhoto stringByAppendingString:fileName];
            HomePicture *picture = [[HomePicture alloc]init];
            picture = [HomePicture objectWithKeyValues:dict];
            picture.ID = dict [@"id"];
            [temp addObject:filePath];
            [addtemp addObject:picture];
        }
        self.imagesURLStrings=temp;
        self.addArray = addtemp;
        //网络加载 --- 创建带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:self.imagesURLStrings];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.delegate = self;
        cycleScrollView.autoScrollTimeInterval = 4.0;
        //cycleScrollView.titlesGroup = titles;
        cycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
        cycleScrollView.placeholderImage = [UIImage imageNamed:@"zm_defalut_yp"];
        [self addSubview:cycleScrollView];
        self.ScrollView=cycleScrollView;

    } failure:^(NSError *error) {
    }];
    
}
-(void)setupReconmmendView{
    HomeRecommedButtonView *ButtonView=[[HomeRecommedButtonView alloc]init];
    [self addSubview:ButtonView];
    self.ButtonView=ButtonView;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.ScrollView.height=120;
    self.ScrollView.width=self.width;
    
    self.ButtonView.top=self.ScrollView.bottom;
    self.ButtonView.width=self.width;
    self.ButtonView.height=120;

}

#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    if ([self.delegate respondsToSelector:@selector(HomeRecommedHeaderViewWithpicture:)]) {
        [self.delegate HomeRecommedHeaderViewWithpicture:_addArray[index]];
    }
}
@end
