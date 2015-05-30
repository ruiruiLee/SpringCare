//
//  CouponsSelectView.h
//  SpringCare
//
//  Created by LiuZach on 15/5/29.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponsSelectView : UIView
{
    UIImageView *_unfoldStaus;
    UILabel *_line;
}

@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIButton *logoImageView;
@property (nonatomic, strong) UILabel *lbCounponsCount;
@property (nonatomic, strong) UILabel *lbCouponsSelected;
@property (nonatomic, strong) UIControl *control;

@end
