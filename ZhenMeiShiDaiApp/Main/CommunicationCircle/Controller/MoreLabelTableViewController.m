//
//  MoreLabelTableViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/22.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "MoreLabelTableViewController.h"

@interface MoreLabelTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *labelTableView;
    UIImageView *imageView;
    UILabel *labelStr;
    NSArray *imageArray;
}
@end

@implementation MoreLabelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    imageArray = @[@"zm_label_one",@"zm_label_two",@"zm_label_three",@"zm_label_four",@"zm_label_five",@"zm_label_one",@"zm_label_two",@"zm_label_three",@"zm_label_four",@"zm_label_five",@"zm_label_one",@"zm_label_two",@"zm_label_three",@"zm_label_four",@"zm_label_five"];

    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:@"更多"];
    [self.view addSubview:customNav];
    
    labelTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KnavHeight, KScreenWidth, KScreenHeight - KnavHeight)];
    labelTableView.delegate = self;
    labelTableView.dataSource = self;
    [self.view addSubview:labelTableView];
    
}

- (void)returnNumber:(selectLabelBlock)selectLabelblock
{
    self.selectblock = selectLabelblock;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _Array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
        [cell.contentView addSubview:imageView];
        labelStr = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+5, 20, 120, 20)];
        [cell.contentView addSubview:labelStr];
    }

    imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    labelStr.text = [_Array[indexPath.row] objectForKey:@"title"];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectblock) {
      NSDictionary *dic = _Array[indexPath.row];
        _selectblock([dic objectForKey:@"id"]);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
