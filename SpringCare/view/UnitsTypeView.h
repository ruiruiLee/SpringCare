//
//  UnitsTypeView.h
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyProductModel.h"

//typedef enum : NSUInteger {
//    EnumTypeDay,
//    EnumTypeWeek,
//    EnumTypeMounth,
//} UnitsType;

@class UnitsTypeView;
@protocol UnitsTypeViewDelegate <NSObject>

- (void) NotifyUnitsTypeChanged:(UnitsTypeView*) view  model:(PriceDataModel *)priceModel;

@end

@interface UnitsTypeView : UIView
{
//    UIButton *_btnDay;
//    UIButton *_btnWeek;
//    UIButton *_btnMounth;
    
    NSMutableArray *btnArray;
    NSArray *_priceList;
}

//@property (nonatomic, assign) UnitsType uniteType;
@property (nonatomic, assign) id<UnitsTypeViewDelegate>  delegate;
@property (nonatomic, strong) PriceDataModel *selectPriceModel;
@property (nonatomic, strong) NSArray *priseList;

- (void) setPriseList:(NSArray *)list;

@end
