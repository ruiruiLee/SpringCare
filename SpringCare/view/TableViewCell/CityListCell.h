//
//  CityListCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/4.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityDataModel.h"
@interface CityListCell : UITableViewCell

@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, retain) CityDataModel * CityModel;
@property (nonatomic, strong) UIImageView *imgSelectFlag;

@end
