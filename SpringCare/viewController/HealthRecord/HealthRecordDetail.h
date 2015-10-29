//
//  HealthRecordDetail.h
//  SpringCare
//
//  Created by LiuZach on 15/10/12.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LCBaseVC.h"
#import "MainBaseVC.h"
#import "MSSimpleGauge.h"
#import "HealthRecordItemDataModel.h"

@interface HealthRecordData : NSObject

@property (nonatomic, assign) CGFloat ChartStartValue;

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) CGFloat bmpmin;
@property (nonatomic, assign) CGFloat bmpmax;

@property (nonatomic, assign) CGFloat sbpmin;
@property (nonatomic, assign) CGFloat sbpmax;

@end

@interface HealthRecordDetail : MainBaseVC
{
    UIView *_headerView;
    
    UIImageView *_photoImagv;
    UILabel *_lbLover;
    
    UILabel *_lbSBP;
    UILabel *_lbDBP;
    UILabel *_lbHeartRate;
    
    UILabel *_lbSBPText;
    UILabel *_lbDBPText;
    UILabel *_lbHeartRateText;
    
    UIImageView *_dateImgv;
    UILabel *_lbDate;
    
    UIImageView *_timeImgv;
    UILabel *_lbTime;
    
    UILabel *_detailInfo;
    
    MSSimpleGauge *_gauge;
    
    UILabel *_lbStatus;
    UILabel *_lbdatas;
    UIImageView *_rateImgv;
    UILabel *_lbRate;
}

@property (nonatomic, strong) HealthRecordItemDataModel *data;
@property (nonatomic, strong) UserAttentionModel *lover;

@end
