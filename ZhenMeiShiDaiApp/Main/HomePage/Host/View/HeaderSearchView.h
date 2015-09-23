//
//  HeaderSearchView.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/15.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderSearchView : UIView<UITextFieldDelegate>
@property (nonatomic, copy) NSString *placeholderText;
@property(nonatomic,strong)UITextField *textField;
@end
