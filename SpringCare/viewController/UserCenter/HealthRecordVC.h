//
//  HealthRecordVC.h
//  SpringCare
//
//  Created by LiuZach on 15/6/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"
#import "HealthRecordModel.h"

@interface HealthRecordVC : LCBaseVC
{
    HealthRecordModel *_model;
    NSString *_loverId;
}

@property (nonatomic, strong) PullTableView *tableview;

- (id) initWithLoverId:(NSString *)loverId;

@end
