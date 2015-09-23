//
//  SettingViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/16.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "SettingViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *array;
    UILabel *versionLabel;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = ZhenMeiRGB(240, 240, 240);
    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"设置"];
    [self.view addSubview:customNav];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, 220) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    [self.view addSubview:tableView];
    array = [[NSMutableArray alloc] initWithObjects:@"版本信息",@"勿扰模式",@"退出登录", nil];
    if (![UserDefaults boolForKey:@"isLogin"]) {
        [array removeLastObject];
        tableView.height = 140;
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = array[indexPath.section];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    switch (indexPath.section) {
        case 0:{
           cell.textLabel.textAlignment = NSTextAlignmentLeft;
            versionLabel = [UQFactory labelWithFrame:CGRectMake(KScreenWidth - 120, 8, 120, 30) text:nil];
            versionLabel.textColor = [UIColor lightGrayColor];
            versionLabel.text = [NSString stringWithFormat:@"当前版本%@",[UserDefaults objectForKey: @"version"]];
            versionLabel.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:versionLabel];
        }
            break;
        case 1:{
          cell.textLabel.textAlignment = NSTextAlignmentLeft;
          UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(KScreenWidth-60, 7, 30, 15)];
         [switchBtn setOnTintColor:ZhenMeiRGB(255, 215, 0)];
         switchBtn.on = [UserDefaults boolForKey:@"isOpen"];
         [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
         [cell.contentView addSubview:switchBtn];
        }
            break;
        case 2:{
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = ZhenMeiRGB(205, 173, 0);

        }
            break;

        default:
            break;
    }
    return cell;
}

- (void)switchAction:(UISwitch *)switchItem
{
    [UserDefaults setBool:switchItem.on forKey:@"isOpen"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 40;
    } else if (section == 0) {
        return 30;
    }
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[UserDefaults objectForKey:@"userId"]);
    if ([UserDefaults boolForKey:@"isLogin"]) {
          if (indexPath.section == 2) {
            if (![UserDefaults objectForKey:@"password"]) {
                [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
            }else{
                [UserDefaults removeObjectForKey:@"password"];
            }
            [UserDefaults removeObjectForKey:@"userId"];
            [UserDefaults removeObjectForKey:@"loginName"];
            [UserDefaults removeObjectForKey:@"age"];
            [UserDefaults removeObjectForKey:@"gender"];
            [UserDefaults removeObjectForKey:@"nickName"];
            [UserDefaults removeObjectForKey:@"userImg"];
            [UserDefaults removeObjectForKey:@"isLogin"];
            [UserDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginorLogout" object:nil];//发用户已经退出的通知，更改我界面
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
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
