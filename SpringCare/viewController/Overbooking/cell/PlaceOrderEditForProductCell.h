//
//  PlaceOrderEditForProductCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateCountSelectView.h"
#import "UnitsTypeView.h"
#import "ZHPickView.h"
#import "FamilyProductModel.h"

@protocol PlaceOrderEditForProductCellDelegate <NSObject>

- (void) NotifyToSelectAddr;

@end

@interface PlaceOrderEditForProductCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate, ZHPickViewDelegate, UnitsTypeViewDelegate, DateCountSelectViewDelegate>
{
    UITableView *_tableview;
    UILabel *line;
    
    UnitsTypeView *businessTypeView;//24或12小时
    DateCountSelectView *dateSelectView;//多少天
    UILabel *lbUnitPrice;//单价
    UILabel *lbAmountPrice;//总价
    
    ZHPickView *_pickview;
    
    FamilyProductModel *_nurseData;
}

@property (nonatomic, assign) id<PlaceOrderEditForProductCellDelegate> delegate;
@property (nonatomic, strong) UITableView *_tableview;
@property (nonatomic, strong) UnitsTypeView *businessTypeView;
@property (nonatomic, strong) DateCountSelectView *dateSelectView;

- (void) setNurseListInfo:(FamilyProductModel*) model;

@end
