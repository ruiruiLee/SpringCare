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
#import "AppDelegate.h"

//static NSString *currentCity = nil;

@implementation LocationManagerObserver
@synthesize lat;
@synthesize lon;
@synthesize currentCity;


+ (LocationManagerObserver *)sharedInstance
{
    static dispatch_once_t once;
    static LocationManagerObserver *instance = nil;
    dispatch_once( &once, ^{
        instance = [[LocationManagerObserver alloc] init];
        instance.lat = 30.222;
        instance.lon = 100.444;
        instance.locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        instance.locationManager.delegate=(id)self;
        instance.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        instance.locationManager.distanceFilter=100.0f;
    } );
    return instance;
}


- (void) startUpdateLocation {
    CLAuthorizationStatus status =[CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        CityDataModel *model = [CityDataModel modelWithName:CityName];
        currentCity = CityName;
        CityDataModel *model = [CityDataModel modelWithName:CityName];
        if(model != nil){
            delegate.currentCityModel = model;
        }
    }
    else{
    //启动位置更新
        dispatch_async(dispatch_get_main_queue(), ^{
             //  [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
            [self.locationManager startUpdatingLocation];
        });

      }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"didChangeAuthorizationStatus---%u",status);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didChangeAuthorizationStatus----%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    lat = newLocation.coordinate.latitude;
    lon = newLocation.coordinate.longitude;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (delegate.currentCityModel == nil) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if([placemarks count] > 0){
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                NSString *city = placemark.locality;
                if (!city) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea;
                }
                currentCity = city;
                CityDataModel *model = [CityDataModel modelWithName:city];
                if(model != nil){
                    delegate.currentCityModel = model;
                }
            }
        }];
    }
    [manager stopUpdatingLocation];
}

@end
