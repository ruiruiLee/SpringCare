//
//  CouponsListCell.h
//  SpringCare
//
//  Created by LiuZach on 15/5/27.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsDataModel.h"

@interface CouponsListCell : UITableViewCell
{
    UIImageView *couponBg;
    UILabel *_lbRMB;
    UILabel *_lbValue;
    UILabel *_lbEndTime;
    UILabel *_lbEndTimeTitle;
    UIView *_rightBg;
    UIView *_view1;
    UIView *_view2;
    
    UIView *_leftBg;
    UIView *_view3;
    UIView *_view4;
    
    NSArray *constraints;
    
    UIImageView *selectImageView;
}

@property (nonatomic, strong) UILabel *lbName;

- (void) SetContentWithModel:(CouponsDataModel *)model;

- (void) SetCellSelected:(BOOL) flag;

@end

