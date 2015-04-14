//
//  BusinessTypeView.h
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EnumType24Hours,
    EnumType12Hours,
} BusinessType;

@class BusinessTypeView;
@protocol BusinessTypeViewDelegate <NSObject>

- (void) NotifyBusinessTypeChanged:(BusinessTypeView*) typeView;

@end

@interface BusinessTypeView : UIView
{
    UIButton *_btn24h;
    UIButton *_btn12h;
}

@property (nonatomic, assign) BusinessType businesstype;
@property (nonatomic, assign) id<BusinessTypeViewDelegate> delegate;

@end
