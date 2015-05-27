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

@property (nonatomic, strong) NSString *lbName;

- (void) SetContentWithModel:(CouponsDataModel *)model;

@end

