//
//  ArticleActViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/25.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePicture.h"
@interface ArticleActViewController : UIViewController
@property(nonatomic,strong) HomePicture *picture;
@property(nonatomic,strong) NSNumber *tag;
@property(nonatomic,strong) NSString *titleName;

@end
