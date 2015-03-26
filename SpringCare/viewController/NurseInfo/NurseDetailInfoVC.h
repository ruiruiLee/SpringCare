//
//  NurseDetailInfoVC.h
//  SpringCare
//
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "NurseListInfoModel.h"

@interface NurseDetailInfoVC : LCBaseVC

@property (nonatomic, strong) NurseListInfoModel *nurseInfo;

- (id)initWithModel:(NurseListInfoModel*)model;

@end
