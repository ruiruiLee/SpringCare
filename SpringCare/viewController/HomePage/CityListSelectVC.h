//
//  CityListSelectVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@protocol CityListSelectVCDelegate <NSObject>

- (void) NotifyCitySelectedWithData:(NSString*) data;

@end

@interface CityListSelectVC : LCBaseVC<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableview;
}

@property (nonatomic, assign) id<CityListSelectVCDelegate> delegate;

@end
