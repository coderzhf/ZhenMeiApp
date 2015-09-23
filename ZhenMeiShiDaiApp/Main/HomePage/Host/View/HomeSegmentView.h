//
//  HomeSegmentView.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    HomeSegmentButtonReconmend,//推荐0
    HomeSegmentButtonHotPlay,//热播1
    HomeSegmentButtonGood,//干货2
    HomeSegmentButtonActivity,//活动3
    MessageButtonPrivateMessage,//私信4
    MessageButtonSystemMessage,//系统消息5
    MyCollectionButtonAudio,//音频6
    MyCollectionButtonGood,//干货7
    MyCollectionButtonActivity//活动8

}HomeSegmentButtonType;

@protocol HomeSegementViewDelegate <NSObject>

@optional
-(void)HomeSegementWithTag:(NSInteger)tag;

@end
@interface HomeSegmentView : UIView
@property(nonatomic,weak)id<HomeSegementViewDelegate>delegate;
-(void)AddButtonWithTitle:(NSString *)title Type:(HomeSegmentButtonType)type;
+(instancetype)initButtonWithTitleArray:(NSArray *)titles type:(NSArray *)types;
-(void)BtnClick:(UIButton *)btn;
@property(nonatomic,strong)UIButton *firstBtn;
@end
