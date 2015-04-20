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


@implementation LocationManagerObserver
@synthesize lat;
@synthesize lon;
@synthesize currentCity;
@synthesize locationManager;


+ (LocationManagerObserver *)sharedInstance
{
    static dispatch_once_t once;
    static LocationManagerObserver *instance = nil;
    dispatch_once( &once, ^{
        instance = [[LocationManagerObserver alloc] init]; } );
    return instance;
}

- (id)init
{
    NSLog(@"[%@] init:", NSStringFromClass([self class]));
    
    if (self = [super init]) {
        geocoder = [[CLGeocoder alloc] init];
        lat = 30.64544373194747;
        lon = 104.05582188638304;
        locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        locationManager.delegate=(id)self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=100.0f;

    }
    
    return self;
}
- (void) startUpdateLocation {
    //启动位置更新
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
      [self.locationManager startUpdatingLocation];
//        dispatch_async(dispatch_get_main_queue(), ^{
//        [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
//          
//        });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"didChangeAuthorizationStatus---%u",status);
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    currentCity = CityName;
    CityDataModel *model = [CityDataModel modelWithName:CityName];
    if(model != nil){
        delegate.currentCityModel = model;
      }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didChangeAuthorizationStatus----%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    lat = newLocation.coordinate.latitude;
    lon = newLocation.coordinate.longitude;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //if (delegate.currentCityModel == nil) {
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if([placemarks count] > 0){
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                NSLog(@"name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n locality:%@\n subLocality:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
//                                                 placemark.name,
//                                                    placemark.country,
//                                                   placemark.postalCode,
//                                                  placemark.ISOcountryCode,
//                                                   placemark.ocean,
//                                                 placemark.inlandWater,
//                                                 placemark.administrativeArea,
//                                                   placemark.subAdministrativeArea,
//                                                  placemark.locality,
//                                                 placemark.subLocality,
//                                                   placemark.thoroughfare,
//                                                   placemark.subThoroughfare);
                
                 currentCity= !placemark.locality?placemark.administrativeArea:placemark.locality;
                _currentDetailAdrress =[NSString stringWithFormat:@"%@%@%@%@%@%@", placemark.administrativeArea,
                  !placemark.subAdministrativeArea?@"":placemark.subAdministrativeArea,
                  !placemark.locality?@"":placemark.locality,
                  !placemark.subLocality?@"":placemark.subLocality,
                  !placemark.thoroughfare?@"":placemark.thoroughfare,
                 !placemark.subThoroughfare?@"":placemark.subThoroughfare];
                CityDataModel *model = [CityDataModel modelWithName:currentCity];
                if(model != nil){
                    delegate.currentCityModel = model;
                }
            }
        }];
    //}
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"[%@] locationManager:didEnterRegion:%@ at %@", NSStringFromClass([self class]), region.identifier, [NSDate date]);
    
  }


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"[%@] locationManager:didExitRegion:%@ at %@", NSStringFromClass([self class]), region.identifier, [NSDate date]);
    
   }
@end
