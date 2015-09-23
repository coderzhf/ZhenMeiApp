
//
//  BeTeacherViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "BeTeacherViewController.h"

@interface BeTeacherViewController ()
{
    UILabel *label;
    UILabel *aboutUs;
}
@end

@implementation BeTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"我要做讲师"];
    [self.view addSubview:customNav];
    
    UIImageView *imageView = [UQFactory imageViewWithFrame:CGRectMake((KScreenWidth-100)/2, KnavHeight +30, 100, 60) image:[UIImage imageNamed:@"zm_jiangshi_Img"]];
    [self.view addSubview:imageView];
    
    aboutUs = [UQFactory labelWithFrame:CGRectMake((KScreenWidth -280)/2, imageView.bottom +5, 280, KScreenHeight/2-imageView.bottom-5) text:nil textColor:[UIColor blackColor]  fontSize:14 center:NO];
    [self.view addSubview:aboutUs];
    
    UIImageView *lineImageView = [UQFactory imageViewWithFrame:CGRectMake(0, KScreenHeight/2, KScreenWidth, 8) image:nil];
    lineImageView.backgroundColor = ZhenMeiRGB(240, 240, 240);
    [self.view addSubview:lineImageView];
    
    UIImageView *emailImageView = [UQFactory imageViewWithFrame:CGRectMake((KScreenWidth-80)/2, lineImageView.bottom +20, 80, 80) image:[UIImage imageNamed:@"zm_email_Img"]];
    [self.view addSubview:emailImageView];
    
    label = [UQFactory labelWithFrame:CGRectMake((KScreenWidth -250)/2, emailImageView.bottom +20, 250, 40) text:nil textColor:[UIColor blackColor]  fontSize:14 center:YES];
    [self.view addSubview:label];
    [self loadData];
}

- (void)loadData
{
    [Utils post:KShowByType params:nil success:^(id json) {
        if ([[json objectForKey:@"code"] intValue] ) {
            return ;
        }
        id obj = [json objectForKey: @"obj"];
        aboutUs.text = [obj objectForKey:@"join"];
        label.text = [NSString stringWithFormat:@"投稿邮箱:%@",[obj objectForKey:@"email"]];
    } failure:^(NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
