//
//  PlayerTool.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/7/28.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "PlayerTool.h"
@interface PlayerTool()
@end
@implementation PlayerTool
HMSingletonM(PlayerTool)

static AVPlayer *_player;
static NSString *_playingUrl;
+(AVPlayer *)playerWithitem:(AVPlayerItem *)item Url:(NSString *)url {
    if (_player) {
        [self PauseMusic];
    }
    _player =[AVPlayer playerWithPlayerItem:item];
    
    _playingUrl = url;
    return _player;
}
+ (void)PauseMusic {
    
    return [_player pause];
}
+ (void)playeMusic {
    
    return [_player play];
}
+ (BOOL)isPlayingMusic:(NSString *)url {
    if (!url) return NO;
    if ([_playingUrl isEqualToString:url]) {
        return YES;
    }else {
        return NO;
    }
}
- (AVPlayer *)AVplaying {
    
    return _player;
}
- (void)setPlayingModel:(HomeVideo *)playingModel {
    _playingModel = playingModel;
}
@end
