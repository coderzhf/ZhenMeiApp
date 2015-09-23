//
//  CustomNavBar.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/12.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavBar : UIView

@property(nonatomic,strong)UIImageView *backGroundImageView;
@property(nonatomic,strong)UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame isFirstPage:(BOOL)firstPage withTitle:(NSString *)title;

@end
