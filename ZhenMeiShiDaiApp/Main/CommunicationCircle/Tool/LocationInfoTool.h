//
//  LocationInfoTool.h
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/29.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^UserLocatBlock) (CLLocationCoordinate2D locationCorrrdinate);
typedef void (^UserLocationBlock) (NSString *location);
@interface LocationInfoTool : NSObject
@property (nonatomic ,strong) UserLocatBlock userLocatblock;
@property (nonatomic ,strong) UserLocationBlock userLocationblock;

- (void)locationInfoUpdate;
- (void)returnLocation:(UserLocationBlock)location;
- (void)returnLocat:(UserLocatBlock)locat;
@end
