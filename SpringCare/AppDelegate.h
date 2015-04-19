//
//  AppDelegate.h
//  SpringCare
//
//  Created by forrestLee on 3/23/15.
//  Copyright (c) 2015 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManagerObserver.h"
#import "CityDataModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    LocationManagerObserver *_observer;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *sliderViewController;
@property (strong, nonatomic) CityDataModel *currentCityModel;

@property (strong, nonatomic) NSString *hospital_product_id;
@property (strong, nonatomic) NSString *defaultProductId;


@end

