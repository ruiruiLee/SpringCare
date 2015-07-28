//
//  CouponsSelectView.m
//  SpringCare
//
//  Created by LiuZach on 15/5/29.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CouponsSelectView.h"
#import "define.h"

@implementation CouponsSelectView
@synthesize lbCounponsCount;
@synthesize lbCouponsSelected;
@synthesize lbTitle;
@synthesize logoImageView;
@synthesize control;

- (id) initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if(self){
        logoImageView = [[UIButton alloc] initWithFrame:CGRectZero];
        logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:logoImageView];
        logoImageView.userInteractionEnabled = NO;
        [logoImageView setImage:[UIImage imageNamed:@"placeordercoupon"] forState:UIControlStateNormal];
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:lbTitle];
        lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        lbTitle.font = _FONT(16);
        lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.text = @"优惠券";
        
        lbCounponsCount = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:lbCounponsCount];
        lbCounponsCount.translatesAutoresizingMaskIntoConstraints = NO;
        lbCounponsCount.font = _FONT(11);
        lbCounponsCount.textColor = [UIColor whiteColor];
        lbCounponsCount.backgroundColor = _COLOR(0xf1, 0x15, 0x39);
        lbCounponsCount.layer.cornerRadius = 5;
        lbCounponsCount.clipsToBounds = YES;
        
        lbCouponsSelected = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:lbCouponsSelected];
        lbCouponsSelected.translatesAutoresizingMaskIntoConstraints = NO;
        lbCouponsSelected.font = _FONT(14);
        lbCouponsSelected.textColor = _COLOR(0x66, 0x66, 0x66);
        lbCouponsSelected.backgroundColor = [UIColor clearColor];
        lbCouponsSelected.text = @"未使用";
        
        _unfoldStaus = [self createImageViewWithimageName:@"usercentershutgray"];
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_line];
        _line.backgroundColor = SeparatorLineColor;
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        control = [[UIControl alloc] initWithFrame:CGRectZero];
        [self addSubview:control];
        control.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(logoImageView, lbTitle, _unfoldStaus, _line, lbCounponsCount, lbCouponsSelected, control);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[logoImageView(26)]-20-[lbTitle]-4-[lbCounponsCount]->=10-[lbCouponsSelected]-4-[_unfoldStaus(9)]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbCounponsCount(18)]->=0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbTitle(20)]->=0-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[control]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[control]-0-|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:lbTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_unfoldStaus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_line]-0-|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:lbCounponsCount attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:lbCouponsSelected attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    
    return self;
}

- (UIImageView*) createImageViewWithimageName:(NSString*) name
{
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:imagev];
    imagev.translatesAutoresizingMaskIntoConstraints = NO;
    imagev.image = [UIImage imageNamed:name];
    return imagev;
}



@end
