//
//  CommentModel.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/21.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *answerName;
@property (nonatomic ,strong) NSString *time;
@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) NSString *city;
@property (nonatomic ,strong) NSNumber *userId;
@property (nonatomic ,strong) NSNumber *answerUserId;//回复的用户的id
@property (nonatomic ,strong) NSNumber *commentId;
@property (nonatomic ,strong) NSNumber *topicInfoId;//帖子编号
@property (nonatomic ,strong) NSNumber *commentType;

- (id)initWithDic:(NSDictionary *)dic;


@end
