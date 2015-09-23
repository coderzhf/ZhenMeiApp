//
//  NewsModel.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/17.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "BaseModel.h"

@interface NewsModel : BaseModel
@property (nonatomic ,strong) NSString *userImg;
@property (nonatomic ,strong) NSString *userName;
@property (nonatomic ,strong) NSString *category2;
@property (nonatomic ,strong) NSString *category1;
@property (nonatomic ,strong) NSNumber *distance;
@property (nonatomic ,strong) NSString *memo;
@property (nonatomic ,strong) NSNumber *userId;
@property (nonatomic ,strong) NSNumber *topicInfoId;

@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) NSString *subContent;
@property (nonatomic ,strong) NSString *issueTime;
@property (nonatomic ,strong) NSNumber *focusCount;
@property (nonatomic ,strong) NSNumber *commentCount;





@end
