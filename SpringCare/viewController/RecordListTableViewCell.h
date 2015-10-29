//
//  RecordListTableViewCell.h
//  SpringCare
//
//  Created by LiuZach on 15/10/12.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthRecordModel.h"

@interface RecordListTableViewCell : UITableViewCell
{
    UILabel *_lbTime;
    UILabel *_lbSBP;
    UILabel *_lbDBP;
    UILabel *_lbHeartRate;
    UILabel *_lbLine;
}

- (void)SetContentWithModel:(HealthRecordItemDataModel*) model;

@end
