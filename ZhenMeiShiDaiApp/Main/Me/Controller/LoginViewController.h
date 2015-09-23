//
//  LoginViewController.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic)  UITextField *phoneNumberTxtFiled;

@property (strong, nonatomic)  UITextField *pswTxtField;

@end
