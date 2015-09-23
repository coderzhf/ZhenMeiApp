//
//  UQLog.m
//  UQPlatformSDK
//
//  Created by Dyfei on 14/10/22.
//  Copyright (c) 2014年 UQ Interactive. All rights reserved.
//

#import "UQLogger.h"

@implementation UQLogger

+ (void)log:(NSString *)formatString, ...
{
    if (!formatString) {
        return;
    }
#ifdef DEBUG
    va_list arglist;
    va_start(arglist, formatString);
#if __has_feature(objc_arc)
    NSString *output = [[NSString alloc] initWithFormat:formatString arguments:arglist];
#else
    NSString *output = [[[NSString alloc] initWithFormat:formatString arguments:arglist] autorelease];
#endif
    va_end(arglist);
    NSLog(@"%@", output);
#endif
}

void UQLog(NSString *formatString, ...)
{
    if (!formatString) {
        return;
    }
#ifdef DEBUG
    va_list arglist;
    va_start(arglist, formatString);
#if __has_feature(objc_arc)
    NSString *output = [[NSString alloc] initWithFormat:formatString arguments:arglist];
#else
    NSString *output = [[[NSString alloc] initWithFormat:formatString arguments:arglist] autorelease];
#endif
    va_end(arglist);
    NSLog(@"%@", output);
#endif
}


@end
