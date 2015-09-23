//
//  TableViewCell3.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/24.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell3 : UITableViewCell
{
    UILabel *allLabel;
    
}
@property (nonatomic ,strong) UIButton *upBtn;

- (void)refresh:(NSInteger)Count open:(BOOL)isOpen;

@end
