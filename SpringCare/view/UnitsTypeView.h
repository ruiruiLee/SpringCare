//
//  UnitsTypeView.h
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EnumTypeDay,
    EnumTypeWeek,
    EnumTypeMounth,
} UnitsType;

@class UnitsTypeView;
@protocol UnitsTypeViewDelegate <NSObject>

- (void) NotifyUnitsTypeChanged:(UnitsTypeView*) view;

@end

@interface UnitsTypeView : UIView
{
    UIButton *_btnDay;
    UIButton *_btnWeek;
    UIButton *_btnMounth;
}

@property (nonatomic, assign) UnitsType uniteType;
@property (nonatomic, assign) id<UnitsTypeViewDelegate>  delegate;

@end
