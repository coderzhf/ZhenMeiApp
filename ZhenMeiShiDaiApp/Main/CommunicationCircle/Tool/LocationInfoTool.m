//
//  LocationInfoTool.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/29.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "LocationInfoTool.h"

@interface LocationInfoTool()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *localMaganar;
@property(nonatomic,strong)CLGeocoder *geocoder;
@end
@implementation LocationInfoTool
-(CLLocationManager *)localMaganar{
    if (_localMaganar==nil) {
        self.localMaganar=[[CLLocationManager alloc]init];
        _localMaganar.delegate=self;
        //精准度
        _localMaganar.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        //每隔多少定位一次
        _localMaganar.distanceFilter=kCLDistanceFilterNone;
        
    }
    return _localMaganar;
}

- (void)returnLocation:(UserLocationBlock)location
{
    self.userLocationblock = [location copy];
}

- (void)returnLocat:(UserLocatBlock)locat
{
    self.userLocatblock = [locat copy];

}
-(CLGeocoder *)geocoder{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(void)locationInfoUpdate{
    if (iOS8) {
        [self.localMaganar requestAlwaysAuthorization];
    }
    //开始更新地理位置
    [self.localMaganar startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //一个location代表一个位置
    CLLocation *location=[locations lastObject];
    
    NSLog(@"维度=%f 经度=%f",location.coordinate.latitude,location.coordinate.longitude);//30,80
    CLLocationCoordinate2D Coordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude ,location.coordinate.longitude );
    if (_userLocatblock) {
        _userLocatblock(Coordinate2D);
        _userLocatblock = nil;
    }
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0) {
            NSLog(@"没有找到合适的地理位置");
        }else{
            for (CLPlacemark *place in placemarks) {
                NSLog(@"name=%@,province=%@,locality=%@",place.name,place.administrativeArea,place.locality);
                NSString *administrativeArea=[place.administrativeArea substringToIndex:place.administrativeArea.length-1];//省
                NSString *city=[place.locality substringToIndex:place.locality.length-1];
                if (!city) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法获得
                    city=place.administrativeArea;
                }
                if ([place.locality hasSuffix:@"州"]) {
                    city = @"";
                }else if ([place.locality hasSuffix:@"区"]||[place.administrativeArea hasSuffix:@"区"]){
                    administrativeArea = @"";
                    city = place.locality;
                }
                if (_userLocationblock) {
                    _userLocationblock([NSString stringWithFormat:@"%@ %@",administrativeArea,city]);
                    _userLocationblock = nil;
                }
            }
        }
    }];
    //更新一个位置应马上停止 耗电
    [self.localMaganar stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}

@end
