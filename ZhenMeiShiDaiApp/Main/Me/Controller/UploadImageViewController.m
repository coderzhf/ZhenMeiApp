
//
//  UploadImageViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/11.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "UploadImageViewController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "UIImage+fixOrientation.h"


@interface UploadImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDelegate>
{
    UIImageView *maskImageView;
}
@property (nonatomic ,strong) UIImage *currentImage;
@property (nonatomic,strong) UIButton *comfirmBtn;
@end

@implementation UploadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZhenMeiRGB(230,230,230);
    [self initViews];
}

- (void)initViews
{
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"选择头像"];
    [self.view addSubview:customNav];

   UIImageView *imageViewup = [UQFactory imageViewWithFrame:CGRectMake(0, KnavHeight+10, KScreenWidth, 40) image:[UIImage imageNamed:@"zm_upLoad_Bg"]];
    [self.view addSubview:imageViewup];

    UILabel *upLabel = [UQFactory labelWithFrame:CGRectMake(30, 0, 100, 40) text:@"选择常用头像" textColor:[UIColor blackColor]  fontSize:16 center:NO];
    upLabel.textAlignment = NSTextAlignmentLeft;
    [imageViewup addSubview:upLabel];
    
    UIView *bgView = [UQFactory viewWithFrame:CGRectMake(0, imageViewup.bottom+10, KScreenWidth, KScreenWidth*2/4) backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    int k = 0;
    for (int i = 0; i <  2; i ++) {
        for (int j = 0; j <  4; j ++) {
             UIButton *imageBtn = [UQFactory buttonWithFrame:CGRectMake(10+((KScreenWidth-50)/4+10)*j ,imageViewup.bottom+10+ KScreenWidth*i/4+5, (KScreenWidth-50)/4, (KScreenWidth-50)/4) image:[UIImage imageNamed:[NSString stringWithFormat:@"1%d",k]] ];
            imageBtn.tag = 10 + k;
            [self.view addSubview:imageBtn];
            [imageBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
            k ++;
        }
    }
    maskImageView = [UQFactory imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"zm_headSelect_Bg"]];
    [self.view addSubview:maskImageView];
    
    UIImageView *imageViewdown = [UQFactory imageViewWithFrame:CGRectMake(0,imageViewup.bottom+2*KScreenWidth/4+20 , KScreenWidth, 40) image:[UIImage imageNamed:@"zm_upLoad_Bg"]];
    [self.view addSubview:imageViewdown];

    UILabel *downLabel = [UQFactory labelWithFrame:CGRectMake(30,0 , 100, 40) text:@"上传本地照片" textColor:[UIColor blackColor]  fontSize:16 center:NO];
    downLabel.textAlignment = NSTextAlignmentLeft;
    [imageViewdown addSubview:downLabel];
    
    UIButton *chooseImgBtn = [UQFactory buttonWithFrame:CGRectMake(KScreenWidth - 40, imageViewdown.top+5, 30, 30) image:[UIImage imageNamed:@"zm_local_Btn"]];
    [self.view addSubview:chooseImgBtn];
    [chooseImgBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    
    _comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _comfirmBtn.frame = CGRectMake(0, imageViewdown.bottom+30, KScreenWidth, 40);
    [_comfirmBtn setBackgroundImage:[UIImage imageNamed:@"zm_nav_Bg"] forState:UIControlStateNormal];
    [_comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:_comfirmBtn];
    [_comfirmBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)imageAction:(UIButton *)button
{
    maskImageView.frame = button.frame;
    NSInteger tag = button.tag;
    _currentImage = [UIImage imageNamed:[NSString stringWithFormat:@"zm_head%ld",(long)tag]];
    
}

- (void)chooseAction
{
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //        设置图像选取控制器的类型为静态图像
    pickVC.mediaTypes=[[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
    //        允许用户编辑
    pickVC.allowsEditing=YES;
    pickVC.editing = YES;
    pickVC.delegate = self;
    
    [self presentViewController:pickVC animated:YES completion:NULL];

}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _currentImage = [image fixOrientation];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (void)comfirmAction:(UIButton *)button
{
    if (![Utils isNetworkConnected]) {
        [Notifier UQToast:self.view text:@"网络连接有问题" timeInterval:NyToastDuration];
        return;
    }
    if (!_currentImage) {
        [Notifier UQToast:self.view text:@"请选择图片" timeInterval:NyToastDuration];
        return;
    }
    [Notifier showHud:self.view text:@"图片上传中……"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //        设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
    NSData *data = UIImagePNGRepresentation(_currentImage);
 
    [manager POST:KIMAGEURL parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData){
        
        /*
         //         32          此方法参数
         //         33          1. 要上传的[二进制数据]
         //         34          2. 对应网站上[upload.php中]处理文件的[字段"file"]
         //         35          3. 要保存在服务器上的[文件名]
         //         36          4. 上传文件的[mimeType]
         //         37          */
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject){
 
        if ([[responseObject objectForKey:@"code"] intValue] ) {
            [Notifier UQToast:self.view text:@"图片上传失败" timeInterval:NyToastDuration];
            return ;
        }
        NSString *str = [responseObject objectForKey:@"obj"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseImage" object:str];
        if ([UserDefaults boolForKey:@"isLogin"]) {
            //修改图片
            NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:@"userId"],@"userId",str,@"userImg" ,nil];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[tempDic JSONString],@"json",nil];
            [Utils post:KUpdateUser params:dic success:^(id json) {
                if ([Notifier hasHud]) {
                    [Notifier dismissHud:NotifyImmediately];
                }
                if ([[json objectForKey:@"code"] intValue] ) {
                    [Notifier UQToast:self.view text:@"用户信息修改失败" timeInterval:NyToastDuration];
                    return ;
                }
                [UserDefaults setObject:str forKey:@"userImg"];
                [UserDefaults synchronize];
                [self.navigationController popViewControllerAnimated:NO];
            } failure:^(NSError *error) {
                if ([Notifier hasHud]) {
                    [Notifier dismissHud:NotifyImmediately];
                }
                [Notifier UQToast:self.view text:@"用户信息修改失败" timeInterval:NyToastDuration];

            }];
        }else{
            [self.navigationController popViewControllerAnimated:NO];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"---失败了--%@",error);
        if ([Notifier hasHud]) {
            [Notifier dismissHud:NotifyImmediately];
        }
        [Notifier UQToast:self.view text:@"图片上传失败" timeInterval:NyToastDuration];
  
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
