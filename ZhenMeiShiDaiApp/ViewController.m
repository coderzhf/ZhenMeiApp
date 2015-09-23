//
//  ViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "ViewController.h"
#import "HomePageViewController.h"
#import "CommunicationViewController.h"
#import "MessageViewController.h"
#import "MeViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SettingViewController.h"
#import "PlayerTool.h"
#import "AVViewController.h"
NSString *const playerVideoNotification = @"playerVideoNotification";
extern NSString *const playerStatusNotification;
@interface ViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *allView;
    UIPageControl *_pageCtr;
    SystemSoundID soundID;
    UIButton *_playButton;
}
@property(nonatomic,strong)CADisplayLink *timer;
@end

@implementation ViewController
- (CADisplayLink *)timer {
    if (!_timer) {
        _timer=[CADisplayLink displayLinkWithTarget:self selector:@selector(Rotating:)];
        //添加到主线程中
        [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    }
    return _timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:1.5];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badHidden) name:@"readMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerButtonSatues:) name:playerStatusNotification object:nil];

    [self initTabbarView];
    [self initViewControllers];
    [self initWelcomePage];
}

- (void) initViewControllers
{
    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
    CommunicationViewController *communicationVC = [[CommunicationViewController alloc]init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    messageVC.readMessageBlock=^{
        _badgeButton.hidden=YES;
    };
    MeViewController *meVC = [[MeViewController alloc] init];
    [meVC readSuccess:^{
        _badgeButton.hidden=YES;
    }];
     NSArray *controllers = @[homePageVC,communicationVC,messageVC,meVC];
    
    for (UIViewController *vc in controllers) {
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        navVC.navigationBarHidden = YES;
        navVC.delegate = self;
        [self addChildViewController:navVC];
        //重置导航控制器的坐标
        navVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight -KTarBarHeight);
    }
    UIViewController *firstVC = [self.childViewControllers objectAtIndex:0];
    
    //最开始时使首页显示出来
    [self.view insertSubview:firstVC.view belowSubview:_tabbarView];
}

- (void)initTabbarView
{
    float height = 40;
    float y = KScreenHeight - height;
    if ([UIScreen mainScreen].bounds.size.height==736 && [UIScreen mainScreen].bounds.size.width==414) {
        height = 64;
        y = KScreenHeight - height;

    }
    _tabbarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, KScreenWidth, height)];
    _tabbarView.image = [UIImage imageNamed:@"zm_tabBar_back"];
    _tabbarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabbarView];
    
    float itemWidth = KScreenWidth/4;
    NSArray *itemsNormal = @[@"zm_homePage_befor",
                           @"zm_communication_befor",
                           @"zm_message_befor",
                           @"zm_me_befor"];

    NSArray *itemsHighLight =   @[@"zm_homePage_after",
                                 @"zm_communication_after",
                                 @"zm_message_after",
                                 @"zm_me_after"];
    
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*itemWidth, 3, itemWidth-10, KTarBarHeight-6);
        [button setBackgroundImage:[UIImage imageNamed:itemsNormal[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:itemsHighLight[i]] forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage imageNamed:itemsNormal[i]] forState:UIControlStateHighlighted];
        if (i == 0) {
            button.enabled = NO;
        }
        button.tag = 100 + i;
        [button addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
       }
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"zm_playButton"] forState:UIControlStateNormal];
    _playButton.frame = CGRectMake(KScreenWidth*0.5-20, KTarBarHeight*0.5-20, 40, 40);
    [_playButton addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_playButton];
    //提示按钮
   _badgeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _badgeButton.frame = CGRectMake(itemWidth*2+45, 0, 20, 20);
    _badgeButton.hidden = YES;
    [_badgeButton setBackgroundImage:[UIImage imageNamed:@"home_badge"] forState:UIControlStateNormal];
    [_tabbarView addSubview:_badgeButton];
    
}
- (void)playOrPause {
    HomeVideo * audioPlayer =[PlayerTool sharedPlayerTool].playingModel;
    
    if (!audioPlayer.shortTitle)return;
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:playerVideoNotification object:nil];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"AVPlayerView" bundle:nil];
    
    AVViewController *vc =[storyboard instantiateViewControllerWithIdentifier:@"AVView"];
    HomeVideo *video=[PlayerTool sharedPlayerTool].playingModel;
    vc.audioPlayer=video;
    vc.title=video.shortTitle;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)playerButtonSatues:(NSNotification *)note {
    
    if ([note.userInfo[@"played"] boolValue]) {
        [self StartRotate];
    }else {
        [self PauseRotate];
    }
}
#pragma mark 开始旋转
-(void)StartRotate{
    
    self.timer.paused = NO;

}
#pragma mark 正在旋转
-(void)Rotating:(CADisplayLink *)timer{
    //时间*速度=角度
    CGFloat angel = timer.duration*M_PI_4;
    _playButton.transform=CGAffineTransformRotate(_playButton.transform, angel);
}
#pragma mark 暂停旋转
-(void)PauseRotate{
    
    self.timer.paused=YES;
    _playButton.transform=CGAffineTransformIdentity;

    
}
#pragma mark 停止旋转
-(void)StopRotate{
    [self.timer invalidate];
    self.timer=nil;
    _playButton.transform=CGAffineTransformIdentity;

}

-(void)setIsNewMessage:(BOOL)isNewMessage
{
    _isNewMessage=isNewMessage;
    if ([UserDefaults objectForKey:@"isLogin"]) {
        if ([_number intValue]  >= 1) {
            [_badgeButton setTitle:_number forState:UIControlStateNormal];
            _badgeButton.titleLabel.font = [UIFont systemFontOfSize:10];
            if ([UserDefaults boolForKey:@"isOpen"]) {
                AudioServicesRemoveSystemSoundCompletion(soundID);//移除
                AudioServicesDisposeSystemSoundID(soundID);//释放
            }else{
                [self registerSound];}
        }
        _badgeButton.hidden=!_isNewMessage;
    }
}

- (void)badHidden
{
    _badgeButton.hidden=YES;
}

- (void)registerSound
{
    //注册系统声音并播放
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
      //注册
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    //播放
    AudioServicesPlaySystemSound(soundID);

}
- (void)changeVC:(UIButton *)item
{
    self.selectedIndex = item.tag - 100;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    UIButton *button = (UIButton *)[self.view viewWithTag:selectedIndex + 100];
    button.enabled = NO;
    UIButton *Prebutton = (UIButton *)[self.view viewWithTag:_selectedIndex + 100];
    if (selectedIndex != _selectedIndex) {
   
        Prebutton.enabled = YES;
        //获取点击之前显示的控制器
        UIViewController *previousVC = [self.childViewControllers objectAtIndex:self.selectedIndex];
        UIViewController *currentVC = [self.childViewControllers objectAtIndex:selectedIndex];
        [self.view insertSubview:currentVC.view belowSubview:_tabbarView];
        [UIView transitionFromView:previousVC.view toView:currentVC.view duration:.35 options:UIViewAnimationOptionTransitionNone completion:^(BOOL finished) {
            //之前显示的控制器从父视图移除
            [previousVC.view removeFromSuperview];
        }];
    }
    _selectedIndex = selectedIndex;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[HomePageViewController class]]|| [viewController isKindOfClass:[CommunicationViewController class]] || [viewController isKindOfClass:[MessageViewController class]] || [viewController isKindOfClass:[MeViewController class]]) {
        navigationController.view.height = KScreenHeight-KTarBarHeight;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5];
        [self.view addSubview:_tabbarView];
        [UIView commitAnimations];

    }else {
        navigationController.view.height = KScreenHeight;
        [UIView beginAnimations:Nil context:Nil];
        [UIView setAnimationDuration:.5];
        [_tabbarView removeFromSuperview];
        [UIView commitAnimations];
    }
}

- (void)initWelcomePage
{
   NSString *value = [UserDefaults objectForKey:@"isFirstLogin"];
    if (value == nil) {
        _tabbarView.hidden = YES;
        allView = [UQFactory viewWithFrame:self.view.bounds backgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:allView];
        _scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_scrollView];
        _scrollView.contentSize=CGSizeMake(KScreenWidth*3, KScreenHeight);
        for (int i=0; i<3; i++) {
            NSString *imageName=[NSString stringWithFormat:@"guide%d",i+1];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.width*i, 0, self.view.width, self.view.height) ];
            imageView.image=[UIImage imageNamed:imageName];
            [_scrollView addSubview:imageView];
        }
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.delegate=self;
        
        _pageCtr=[[UIPageControl alloc] init];
        _pageCtr.pageIndicatorTintColor = ZhenMeiRGB(240, 240, 240);
        _pageCtr.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageCtr.center = self.view.center;
        _pageCtr.bottom = KScreenHeight - 60;
        _pageCtr.numberOfPages = 3;
        [self.view addSubview:_pageCtr];
           [UserDefaults setObject:@"YES" forKey:@"isFirstLogin"];
    }
    return;
}
#pragma AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *url = @"";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else if (buttonIndex == 2){
        return;
    }
}
#pragma - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/self.view.width;
    _pageCtr.currentPage = index;
 
    if (index >1) {
        _scrollView.scrollEnabled=NO;
        UIButton *experence = [UIButton buttonWithType:UIButtonTypeCustom];
        experence.frame = CGRectMake((KScreenWidth-120)/2,KScreenHeight -KTarBarHeight-95, 120, 40);
        [experence addTarget:self action:@selector(removeFromSuperviewTwo:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:experence];
        return;
    }
}

- (void)removeFromSuperviewTwo:(UIButton *)button
{
    [allView removeFromSuperview];
    [_scrollView removeFromSuperview];
    [_pageCtr removeFromSuperview];
    _tabbarView.hidden = NO;
    [button removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
