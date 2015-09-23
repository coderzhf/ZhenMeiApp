//
//  ChangePhotoViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "ChangePhotoViewController.h"
#import "UploadImageViewController.h"

@interface ChangePhotoViewController ()
{
    UIImageView *headerImageView;
    UIImage *afterimage;
}
@end

@implementation ChangePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseImage:) name:@"chooseImage" object:nil];
    
    headerImageView = [UQFactory imageViewWithFrame:CGRectMake(0, 0, KScreenWidth, 300) image:nil contentMode:0 userInteractionEnabled:NO];
    NSString *str = [UserDefaults objectForKey:@"userImg"];
     if ([str hasPrefix:@"http"]) {
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserDefaults objectForKey:@"userImg"]]];
    }else{
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,str]]];
    }
    [self.view addSubview:headerImageView];
    
    UIButton *changeImage = [UQFactory buttonWithFrame:CGRectMake(20, headerImageView.bottom+30, KScreenWidth-2*20, 35) backgroundImage:[UIImage imageNamed:@"zm_getCode_Btn"] image:nil ];
    [changeImage setTitle:@"更换头像" forState:UIControlStateNormal];
    [changeImage addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeImage];
    
    UIButton *saveBtn = [UQFactory buttonWithFrame:CGRectMake(20, changeImage.bottom+10, KScreenWidth-2*20, 35) backgroundImage:[UIImage imageNamed:@"zm_getCode_Btn"] image:nil];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)changeAction
{
    UploadImageViewController *upLoadImageVC = [[UploadImageViewController alloc] init];
    [self.navigationController pushViewController:upLoadImageVC animated:NO];
}

- (void)saveAction
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)chooseImage:(NSNotification *)notification
{
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KShowPhoto,notification.object]]];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
