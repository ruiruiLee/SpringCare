//
//  CouponsVC.h
//  SpringCare
//
//  Created by LiuZach on 15/5/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "CouponsDataModel.h"

typedef enum : NSUInteger {
    EnumCouponsVCTypeMine,
    EnumCouponsVCTypeSelect,
} EnumCouponsVCType;

@protocol CouponsVCDelegate <NSObject>

- (void)NotifySelectCouponsWithModel:(CouponsDataModel *)model;

@end

@interface CouponsVC : LCBaseVC
{
//    NSIndexPath *selectIndexPath;
    CouponsDataModel *selectModel;
    UIImageView *backgroundImageView;
}

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) EnumCouponsVCType type;
@property (nonatomic, assign) id<CouponsVCDelegate> delegate;
@property (nonatomic, strong) CouponsDataModel *selectModel;

@end
