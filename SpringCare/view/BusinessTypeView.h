//
//  BusinessTypeView.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BusinessTypeView;
@class PriceDataModel;

@protocol BusinessTypeViewDelegate <NSObject>

- (void) NotifyBusinessTypeChanged:(BusinessTypeView*) typeView model:(PriceDataModel *)priceModel;

@end

@interface BusinessTypeView : UIView
{
    NSMutableArray *btnArray;
    NSArray *_priceList;
}

@property (nonatomic, assign) id<BusinessTypeViewDelegate> delegate;
@property (nonatomic, strong) PriceDataModel *selectPriceModel;
@property (nonatomic, strong) NSArray *priseList;

- (id)initWithPriceList:(NSArray*) priceList;

@end
