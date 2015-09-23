//
//  PlayerTool.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/7/28.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HMSingleton.h"
#import "HomeVideo.h"
@interface PlayerTool : NSObject
HMSingletonH(PlayerTool)

//音乐
+(AVPlayer *)playerWithitem:(AVPlayerItem *)item  Url:(NSString *)url;
+(void)PauseMusic;
+ (void)playeMusic;
+(BOOL)isPlayingMusic:(NSString *)url;
@property(nonatomic,strong)AVPlayer *AVplaying;
@property(nonatomic,strong)HomeVideo *playingModel;
@end
