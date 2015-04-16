//
//  CityDataModel.m
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CityDataModel.h"
#import "LocationManagerObserver.h"
#import "AppDelegate.h"

static NSMutableArray *cityDataArray = nil;

@implementation CityDataModel
@synthesize city_id;
@synthesize city_name;
@synthesize latitude;
@synthesize longitude;
@synthesize short_name;

+ (NSArray*) getCityData
{
    if(!cityDataArray){
        cityDataArray = [[NSMutableArray alloc] init];
    }
    
    return cityDataArray;
}

+ (void) SetCityDataWithArray:(NSArray*) list
{
    if(!cityDataArray){
        cityDataArray = [[NSMutableArray alloc] init];
    }else{
        [cityDataArray removeAllObjects];
    }
    
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *dic = [list objectAtIndex:i];
        if([dic isKindOfClass:[NSDictionary class]]){
            CityDataModel *model = [[CityDataModel alloc] init];
            model.city_id = [dic objectForKey:@"id"];
            model.city_name = [dic objectForKey:@"city_name"];
            model.latitude = [[dic objectForKey:@"latitude"] doubleValue];
            model.longitude = [[dic objectForKey:@"longitude"] doubleValue];
            model.short_name = [dic objectForKey:@"short_name"];
            
            [cityDataArray addObject:model];
        }
    }
    
    if(currentCity != nil){
        CityDataModel *model = [CityDataModel modelWithName:currentCity];
        if(model){
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            delegate.currentCityModel = model;
        }
    }
}

+ (CityDataModel*) modelWithName:(NSString*) name
{
    if(cityDataArray != nil){
        for (int i = 0; i < [cityDataArray count]; i++) {
            CityDataModel *model = [cityDataArray objectAtIndex:i];
            if([name isEqualToString:model.city_name]){
                return model;
            }
        }
    }
    
    return nil;
}

@end
