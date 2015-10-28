//
//  HealthRecordInfo.h
//  SpringCare
//
//  Created by LiuZach on 15/10/12.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBaseVC.h"
#import "HealthRecordModel.h"
#import "UserAttentionModel.h"

@interface HealthRecordInfo : LCBaseVC
{
    HealthRecordModel *_model;
    
    NSString *_loverId;
    
    NSString *_prevDateString;
}

@property (nonatomic, strong) UserAttentionModel *lover;

- (id) initWithLoverId:(NSString *)loverId;

@end
