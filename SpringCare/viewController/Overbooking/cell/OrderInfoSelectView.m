//
//  OrderInfoSelectView.m
//  SpringCare
//
//  Created by LiuZach on 15/7/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderInfoSelectView.h"
#import "define.h"

@implementation OrderInfoSelectView
@synthesize line = _line;
@synthesize lbTitle = _lbTitle;
@synthesize logoImageView = _logoImageView;
@synthesize control;

- (UIImageView*) createImageViewWithimageName:(NSString*) name
{
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:imagev];
    imagev.translatesAutoresizingMaskIntoConstraints = NO;
    imagev.image = [UIImage imageNamed:name];
    return imagev;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        
        _logoImageView = [[UIButton alloc] initWithFrame:CGRectZero];
        _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_logoImageView];
        _logoImageView.userInteractionEnabled = NO;
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_lbTitle];
        _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _lbTitle.font = _FONT(14);
        _lbTitle.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.numberOfLines = 2;
        
        _unfoldStaus = [self createImageViewWithimageName:@"usercentershutgray"];
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_line];
        _line.backgroundColor = SeparatorLineColor;
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        control = [[UIControl alloc] initWithFrame:CGRectZero];
        [self addSubview:control];
        control.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_logoImageView, _lbTitle, _unfoldStaus, _line, control);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_logoImageView(26)]-20-[_lbTitle]->=10-[_unfoldStaus(9)]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbTitle]->=0-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_unfoldStaus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_line]-0-|" options:0 metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[control]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[control]-0-|" options:0 metrics:nil views:views]];
    }
    
    return self;
}

@end
