//
//  ViewController.h
//  AVPlayerDemo
//
//  Created by CaoJie on 14-5-5.
//  Copyright (c) 2014年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVideo.h"
@interface AVViewController : UIViewController
@property(nonatomic,copy)NSString *PlayUrl;
@property(nonatomic,strong)HomeVideo *audioPlayer;
@end
