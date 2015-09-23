//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by CaoJie on 14-5-5.
//  Copyright (c) 2014年 yiban. All rights reserved.
//

#import "AVViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerView.h"
#import "HomeVideoCell.h"
#import "HomeVideo.h"
#import "AFNetworking.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "PlayerResult.h"
#import "VideoDetailView.h"
#import "MBProgressHUD.h"
#import "PlayerTool.h"
// http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA
NSString *const playerStatusNotification = @"playerStatusNotification";

@interface AVViewController()<UITableViewDelegate,UITableViewDataSource,VideoDetailViewDelegate> {
    BOOL _played;
    CGFloat _totalSecond;
    NSDateFormatter *_dateFormatter;
}

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,weak) IBOutlet PlayerView *playerView;
@property (nonatomic ,weak) IBOutlet UIButton *stateButton;
@property (nonatomic ,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic ,strong) id playbackTimeObserver;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)PlayerResult *result;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *StartButton;
@property (weak, nonatomic) IBOutlet UIView *VoiceBgView;
@property (weak, nonatomic) IBOutlet UIButton *VoiceSlider;
@property (weak, nonatomic) IBOutlet UIView *AudioBgView;
@property (weak, nonatomic) IBOutlet UIButton *AudioSlider;
@property (weak, nonatomic) IBOutlet UIView *AudioProgress;
@property (weak, nonatomic) IBOutlet VideoDetailView *detailView;
@property (weak, nonatomic) IBOutlet UIImageView *playbgView;
@property(nonatomic,strong) CustomNavBar *customNav;

- (IBAction)stateButtonTouched:(id)sender;

- (IBAction)VoiceChange:(UIPanGestureRecognizer *)sender;
- (IBAction)AudioChange:(UIPanGestureRecognizer *)sender;

@end

@implementation AVViewController

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSArray alloc]init];
    }
    return _dataArray;
}
#pragma mark cycle life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:NO withTitle:_audioPlayer.shortTitle];
    [self.view addSubview:self.customNav];
    //加载数据
    [self LoadTableViewData];
    [self LoadPlayerData];
    
   }

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"currentTime" context:nil];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
  
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"played"] =[NSString stringWithFormat:@"%d",_played];
    [[NSNotificationCenter defaultCenter] postNotificationName:playerStatusNotification object:nil userInfo:dict];

}
- (void)dealloc {

}
- (void)setAudioPlayer:(HomeVideo *)audioPlayer {
    _audioPlayer = audioPlayer;
    [PlayerTool sharedPlayerTool].playingModel = audioPlayer;
}

-(void)LoadPlayerData{
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"currentTime" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
    
    self.customNav.titleLabel.text = _audioPlayer.shortTitle;
    [self.playerView.player pause];
    _played = NO;
    self.AudioSlider.left=0;
    self.AudioProgress.width=0;
    NSString *imageUrl=[KShowPhoto stringByAppendingFormat:@"%@",self.audioPlayer.picPath];
     [self.playbgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"zm_yinpin_defalut"]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.playerView animated:YES];
    hud.labelText=@"正在加载音频";
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"articleId"]=_audioPlayer.ID;
    if([UserDefaults objectForKey:@"userId"]){
        dict[@"userId"]=[UserDefaults objectForKey:@"userId"];
    }
    [HttpTool post:KAudioDetail params:dict success:^(id json) {
        NSDictionary *success = json[@"obj"];
        if ([success isKindOfClass:[NSDictionary class]]) {
            self.result=[PlayerResult objectWithKeyValues:success];
            [self setupDataSource:self.result];
        }
    } failure:^(NSError * error) {

    }];
}
 
-(void)LoadTableViewData{
    [self.detailView.PlayNumButton setTitle:[NSString stringWithFormat:@"%@次",self.audioPlayer.visitTotal] forState:UIControlStateNormal];

    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"articleId"]=_audioPlayer.ID;
    [HttpTool post:KAudioLove params:dict success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count) return;
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomeVideo *result=[HomeVideo objectWithKeyValues:dict];
            result.ID = dict[@"id"];
            [temp addObject:result];
        }
        self.dataArray=temp;
        [self.detailTableView reloadData];
    } failure:^(NSError *error) {
    }];
}
#pragma mark init
-(void)setupDataSource:(PlayerResult *)result{
 
    self.PlayUrl=[KShowPhoto stringByAppendingString:result.attachment];
    [self setupAVPlayer];
    [self setupTableView];

}
-(void)setupAVPlayer{
    
    if (![PlayerTool isPlayingMusic:self.PlayUrl]) {
        NSURL *videoUrl = [NSURL URLWithString:[self.PlayUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.playerItem = nil;
        self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
        self.player = [PlayerTool playerWithitem:self.playerItem Url:self.PlayUrl];
        self.playerView.player = _player;
        self.stateButton.enabled = NO;
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
        [self.playerItem addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];

    }else {
        [MBProgressHUD hideHUDForView:self.playerView animated:YES];
        self.stateButton.enabled = YES;
        self.StartButton.hidden=NO;
        self.player =[[PlayerTool sharedPlayerTool] AVplaying];
        self.playerItem = [[PlayerTool sharedPlayerTool] AVplaying].currentItem;
   
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
        [self.playerItem addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        
        _totalSecond = self.playerItem.duration.value / self.playerItem.duration.timescale;// 转换成秒
        [self.detailView setVideoDetailWithplayNum:self.result.visitTotal shared:self.result.isCollections duration:[self convertTime:_totalSecond]];//设置信息栏
        [self monitoringPlayback:self.playerItem];// 监听播放状态

        [self stateButtonTouched:self.stateButton];
    }
    
  }
-(void)setupTableView{
    self.detailTableView.dataSource=self;
    self.detailTableView.delegate=self;
   // self.detailTableView.contentInset=UIEdgeInsetsMake(10, 0, 0, 0);
    self.detailTableView.height=KScreenHeight-self.timeLabel.bottom;
    self.detailTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.detailTableView];
    
    self.detailView.delegate=self;
    if (self.result.isCollections) {
        self.detailView.ShareButton.selected=YES;
    }
}
#pragma mark AVPlayer
// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            [MBProgressHUD hideHUDForView:self.playerView animated:YES];
            self.stateButton.enabled = YES;
            self.StartButton.hidden=NO;
            _totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            [self.detailView setVideoDetailWithplayNum:self.result.visitTotal shared:self.result.isCollections duration:[self convertTime:_totalSecond]];//设置信息栏
            [self monitoringPlayback:self.playerItem];// 监听播放状态

            [self stateButtonTouched:self.stateButton];
          
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            UQLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"currentTime"]) {

        NSLog(@"%@",change);
    }
}
//监听音频播放
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    self.playerView.player = self.player;
    self.playbackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒

        double progress=currentSecond/_totalSecond;
        CGFloat AudioMaxX=self.AudioBgView.width-self.AudioSlider.width;
        self.AudioSlider.left=AudioMaxX*progress;
        self.AudioProgress.width=self.AudioSlider.left;
        NSString *timeString = [self convertTime:currentSecond];
        NSString *totalTime=[self convertTime:_totalSecond];
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,totalTime];
    }];
}

//视频播放结束通知
- (void)moviePlayDidEnd:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        //     [weakSelf.videoSlider setValue:0.0 animated:YES];
        [weakSelf.stateButton setTitle:@"播放" forState:UIControlStateNormal];
        _played = NO;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"played"] =[NSString stringWithFormat:@"%d",_played];
        [[NSNotificationCenter defaultCenter] postNotificationName:playerStatusNotification object:nil userInfo:dict];
    }];
}
//转换成分秒 时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}
//时间格式
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
//计算缓存时间
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.playerView.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark action
//点击播放按钮
- (IBAction)stateButtonTouched:(UIButton *)sender {
    if (!_played) {
        [self.playerView.player play];
    } else {
        [self.playerView.player pause];

    }
    _played = !_played;
    self.stateButton.selected=_played;
    self.StartButton.hidden=_played;
}

//调整声音按钮
- (IBAction)VoiceChange:(UIPanGestureRecognizer *)sender {
    
    CGPoint tran=[sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    self.VoiceSlider.left+=tran.x;
    CGFloat SliderMaxX=self.VoiceBgView.width-self.VoiceSlider.width;
    if (self.VoiceSlider.left<0) {
        self.VoiceSlider.left=0;
    }else if (self.VoiceSlider.left>SliderMaxX){
        self.VoiceSlider.left=SliderMaxX;
    }
    
    self.player.volume=self.VoiceSlider.left/SliderMaxX;
}
//播放进度
- (IBAction)AudioChange:(UIPanGestureRecognizer *)sender {
    CGPoint tran=[sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    self.AudioSlider.left+=tran.x;
    CGFloat SliderMaxX=self.AudioBgView.width-self.AudioSlider.width;
    if (self.AudioSlider.left<0) {
        self.AudioSlider.left=0;
    }else if (self.AudioSlider.left>SliderMaxX){
        self.AudioSlider.left=SliderMaxX;
    }
    if (sender.state==UIGestureRecognizerStateBegan) {
        [self.playerView.player pause];
    }else if (sender.state==UIGestureRecognizerStateEnded){
        double value =self.AudioSlider.left/SliderMaxX;
        CGFloat seconds=_totalSecond*value;
        CMTime changedTime = CMTimeMakeWithSeconds(seconds, 1);
        __weak typeof(self) weakSelf = self;
        [self.playerView.player seekToTime:changedTime completionHandler:^(BOOL finished) {
            [weakSelf.playerView.player play];
        }];
        self.stateButton.selected=YES;
        self.StartButton.hidden=YES;
        _played=YES;
        }
}
#pragma mark tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (section==0)?1:self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"detail";
    
    HomeVideoCell *cell=[[HomeVideoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    if (indexPath.section==1) {
        cell.video=self.dataArray[indexPath.row];

    }else{
        
        cell.detailTextLabel.text=self.result.content;
        cell.detailTextLabel.numberOfLines=0;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return (section==0)?@"内容简介":@"猜你想听";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return [Utils getContentStrHeight:self.result.content]+10;
    }else{
        HomeVideo *video=self.dataArray[indexPath.row];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *authorArray = (NSMutableArray*)[video.author componentsSeparatedByString:@";"];
        for (NSString *str in authorArray) {
            if (![str isEqualToString:@""]) {
                [tempArray addObject:str];}
        }
        
        if (tempArray.count ==0||tempArray.count ==1||tempArray.count ==2||tempArray.count ==3) {
            return 82;
        }else if (tempArray.count ==4){
            return 85;

        }else if (tempArray.count ==5){
            return 97;
        }else if (tempArray.count ==6){
            return 112;}
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.stateButton.selected = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.audioPlayer = self.dataArray[indexPath.row];
    [self LoadPlayerData];

}
#pragma mark VideoDetailViewDelegate
//分享
-(void)VideoDetailViewButtonClick:(UIButton *)btn{
    
    if(![UserDefaults objectForKey:@"userId"]){
        [Notifier UQToast:self.view text:@"需要注册/登录后才能收藏" timeInterval:NyToastDuration];
        return;
    }
    if (btn.selected) {
        [Notifier UQToast:self.view text:@"您已收藏" timeInterval:NyToastDuration];
        return;
    }
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict [@"tag"]=@1;
    dict [@"articleId"]=_audioPlayer.ID;
    dict [@"userId"]=[UserDefaults objectForKey:@"userId"];
    [HttpTool post:KAddCollectionsAct params:dict success:^(id json) {
        [Notifier UQToast:self.view text:@"收藏成功" timeInterval:NyToastDuration];
    } failure:^(NSError *error) {
    }];
    
    btn.selected=YES;
}

@end
