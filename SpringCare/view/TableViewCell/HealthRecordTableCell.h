//
//  HealthRecordTableCell.h
//  SpringCare
//
//  Created by LiuZach on 15/6/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthRecordItemDataModel.h"

@interface HealthRecordTableCell : UITableViewCell
{
    UILabel *_lbhp;
    UILabel *_lblp;
    UILabel *_lbPulse;
    UILabel *_lbUpTime;
    
    UIView *_spaceView1;
    UIView *_spaceView2;
    UIView *_spaceView3;
}

- (void) SetContentWithModel:(HealthRecordItemDataModel *)model;

@end
