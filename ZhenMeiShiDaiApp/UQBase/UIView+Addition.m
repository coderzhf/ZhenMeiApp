//
//  UIView+Addition.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/12.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)
-(UIViewController *)viewController
{
    
    UIResponder *nextResponder = [self nextResponder];
    while (nextResponder) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    }
    return Nil;

}

@end
