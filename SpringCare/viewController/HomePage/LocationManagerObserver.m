//
//  LocationManagerObserver.m
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LocationManagerObserver.h"
#import "define.h"

@implementation LocationManagerObserver

- (id) init
{
    self = [super init];
    if(self)
        [self startUpdateLocation];
    return self;
}

- (void) startUpdateLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=100.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    //启动位置更新
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if([placemarks count] > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
//            [activityBtn setTitle:city forState:UIControlStateNormal];
            currentCity = city;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOCATION_GAINED object:nil userInfo:@{@"city": currentCity}];
        }
    }];
    [manager stopUpdatingLocation];
}

@end