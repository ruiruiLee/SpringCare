//
//  BusinessTypeView.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "BusinessTypeView.h"
#import "define.h"

@implementation BusinessTypeView
@synthesize businesstype;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.layer.cornerRadius = 12;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
        
        _btn24h = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btn24h];
        _btn24h.translatesAutoresizingMaskIntoConstraints = NO;
        _btn24h.titleLabel.font = _FONT(15);
        [_btn24h setTitle:@"24小时" forState:UIControlStateNormal];
        [_btn24h setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btn24h setTitleColor: _COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        [_btn24h addTarget:self action:@selector(doBtnSelectType24h:) forControlEvents:UIControlEventTouchUpInside];
        
        _btn12h = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btn12h];
        _btn12h.translatesAutoresizingMaskIntoConstraints = NO;
        _btn12h.titleLabel.font = _FONT(15);
        [_btn12h setTitle:@"12小时" forState:UIControlStateNormal];
        [_btn12h setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btn12h setTitleColor: _COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        [_btn12h addTarget:self action:@selector(doBtnSelectType12h:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btn24h, _btn12h);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_btn24h]-0-[_btn12h]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btn24h]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btn12h]-0-|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_btn24h attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
        
        [self doBtnSelectType24h:_btn24h];
    }
    return self;
}

- (void) doBtnSelectType24h:(UIButton*)sender
{
    _btn24h.selected = YES;
    _btn12h.selected = NO;
    _btn24h.backgroundColor = Abled_Color;
    _btn12h.backgroundColor = [UIColor clearColor];
    businesstype = EnumType24Hours;
}

- (void) doBtnSelectType12h:(UIButton*)sender
{
    _btn24h.selected = NO;
    _btn12h.selected = YES;
    _btn24h.backgroundColor = [UIColor clearColor];
    _btn12h.backgroundColor = Abled_Color;
    businesstype = EnumType12Hours;
}

@end
