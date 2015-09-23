//
//  ChooseLabelViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/19.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "ChooseLabelViewController.h"
#import "SendMessageViewController.h"
#import "AppDelegate.h"
@interface ChooseLabelViewController ()
{
    UIImageView *selectimageView1;
    UIImageView *selectimageView2;
    NSNumber *productId;
    NSNumber *categoryId;
    AppDelegate *appDelegate;

}

@end

@implementation ChooseLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    appDelegate = [UIApplication sharedApplication].delegate;
    [self initViews];
}

- (void)initViews
{
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"说说"];
    [self.view addSubview:customNav];
    
    UIImageView *imageView = [UQFactory imageViewWithFrame:CGRectMake(10, KnavHeight +10, 20, 20) image:[UIImage imageNamed:@"zm_Theme_img"]];
    [self.view addSubview:imageView];
    
    UILabel *label = [UQFactory labelWithFrame:CGRectMake(imageView.right+10, imageView.top-5, 250, 30) text:@"请选择主题标签（各选一个）"textColor:[UIColor blackColor] fontSize:16 center:NO];
    [self.view addSubview:label];
    
    UIImageView *imageView1 = [UQFactory imageViewWithFrame:CGRectMake(10, imageView.bottom +20, 20, 20) image:[UIImage imageNamed:@"zm_cycle_img"]];
    [self.view addSubview:imageView1];
    
    UILabel *productLabel = [UQFactory labelWithFrame:CGRectMake(imageView1.right+10, imageView1.top-5, 80, 30) text:@"按项目" textColor:[UIColor lightGrayColor] fontSize:16 center:NO];
    [self.view addSubview:productLabel];
    
    int k = 0;
    for (int i = 0; i < 3; i ++) {
         for (int j = 0; j < 5; j ++) {
            NSDictionary *dic = appDelegate.productArray[k];
            UIButton *button = [UQFactory buttonWithFrame:CGRectMake(5+j *((KScreenWidth-30)/5+5), 50*i+10+imageView1.bottom, (KScreenWidth-30)/5,  35) title:[dic objectForKey:@"title"] titleColor:ZhenMeiRGB(200, 200, 200) fontName:nil fontSize:14 ];
                    [button setBackgroundImage:[UIImage imageNamed:@"zm_labelSelected_Btn"] forState:UIControlStateNormal];
            [self.view addSubview:button];
            button.tag = k;
            [button addTarget:self action:@selector(chooseProductAction:) forControlEvents:UIControlEventTouchUpInside];
            k ++;
        }
    }
    UIImageView *imageView2 = [UQFactory imageViewWithFrame:CGRectMake(10, KnavHeight + 240, 20, 20) image:[UIImage imageNamed:@"zm_cycle_img"]];
    [self.view addSubview:imageView2];
    
    UILabel *classLabel = [UQFactory labelWithFrame:CGRectMake(imageView2.right+10, imageView2.top-5, 80, 30) text:@"按类别" textColor:[UIColor lightGrayColor]  fontSize:14 center:NO];
    [self.view addSubview:classLabel];
    for (int j = 0; j < 5; j ++) {
        NSDictionary *dic = appDelegate.categoryArray[j];
        UIButton *button = [UQFactory buttonWithFrame:CGRectMake(5+j *((KScreenWidth-30)/5+5), classLabel.bottom+10, (KScreenWidth-5*6)/5,  35) title:[dic objectForKey:@"title"] titleColor:ZhenMeiRGB(200, 200, 200) fontName:nil fontSize:16 ];
        [button setBackgroundImage:[UIImage imageNamed:@"zm_labelSelected_Btn"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.tag = 30+j ;
        [button addTarget:self action:@selector(chooseCategoryAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    selectimageView1 = [UQFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_selected_img"]];
    [self.view addSubview:selectimageView1];
    
    selectimageView2 = [UQFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_selected_img"]];
    [self.view addSubview:selectimageView2];
     
    UIButton *comfirmBtn = [UQFactory buttonWithFrame:CGRectMake(0, 400, KScreenWidth, 40) backgroundImage:[UIImage imageNamed:@"zm_nav_Bg"] image:nil];
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmBtn addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comfirmBtn];
}

- (void)chooseProductAction:(UIButton *)button
{
    selectimageView1.frame = button.frame;
//   NSDictionary *dic = appDelegate.productArray[button.tag];
//   productId = [dic objectForKey:@"id"];

}

- (void)chooseCategoryAction:(UIButton *)button
{
    selectimageView2.frame = button.frame;
    NSDictionary *dic = appDelegate.categoryArray[button.tag-30];
    categoryId = [dic objectForKey:@"id"];
    
}

- (void)comfirmAction
{
    if (selectimageView1.height== 0 || selectimageView2.height == 0 ) {
        return;
    }
    SendMessageViewController *sendVC = [[SendMessageViewController alloc] init];
    sendVC.bigLabel = [NSNumber numberWithInt:4];
    sendVC.smallLabel = categoryId;
    [self.navigationController pushViewController:sendVC animated:NO];

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
