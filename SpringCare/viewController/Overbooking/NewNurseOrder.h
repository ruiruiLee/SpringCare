//
//  NewNurseOrder.h
//  SpringCare
//
//  Created by LiuZach on 15/7/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NewOrderVC.h"

@interface NewNurseOrder : NewOrderVC
{
    UIImageView *_photoImage;
    UILabel *_lbName;
    UIButton *_btnCert;
    UIButton *_btnInfo;
    UIImageView *_imgvLogo;
    UILabel *_detailInfo;
    UIButton *_btnUnfold;
    
    NSArray *headerViewHeightConstraint;
}

@property (nonatomic, strong) NurseListInfoModel *nurseModel;
@property (nonatomic, strong) NSString *productId;

- (id) initWithNurseListInfoModel:(NurseListInfoModel *)model productId:(NSString *)productId;

@end
