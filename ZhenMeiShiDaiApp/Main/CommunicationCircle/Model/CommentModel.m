//
//  CommentModel.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/21.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "CommentModel.h"
@implementation CommentModel
- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.name = dic[@"userName"];
        self.answerName = dic[@"answerUser"];
        self.content = dic[@"content"];
        self.time = dic[@"issueTime"];
        self.city = dic[@"city"];
        self.userId = dic[@"userId"];
        self.answerUserId = dic[@"answerUserId"];
        self.commentId = dic[@"commentId"];
        self.topicInfoId = dic[@"topicInfoId"];
        self.commentType = dic[@"commentType"];
    }
    return self;
}

@end
