//
//  UnitsTypeView.m
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UnitsTypeView.h"
#import "define.h"

@implementation UnitsTypeView
@synthesize uniteType;
@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
        
        _btnDay = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btnDay];
        _btnDay.translatesAutoresizingMaskIntoConstraints = NO;
        _btnDay.titleLabel.font = _FONT(15);
        [_btnDay setTitle:@"日" forState:UIControlStateNormal];
        [_btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnDay setTitleColor: _COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        [_btnDay addTarget:self action:@selector(doBtnSelectTypeDay:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnWeek = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btnWeek];
        _btnWeek.translatesAutoresizingMaskIntoConstraints = NO;
        _btnWeek.titleLabel.font = _FONT(15);
        [_btnWeek setTitle:@"周" forState:UIControlStateNormal];
        [_btnWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnWeek setTitleColor: _COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        [_btnWeek addTarget:self action:@selector(doBtnSelectTypeWeek:) forControlEvents:UIControlEventTouchUpInside];
        _btnWeek.layer.borderWidth = 1;
        _btnWeek.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
        
        _btnMounth = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btnMounth];
        _btnMounth.translatesAutoresizingMaskIntoConstraints = NO;
        _btnMounth.titleLabel.font = _FONT(15);
        [_btnMounth setTitle:@"月" forState:UIControlStateNormal];
        [_btnMounth setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnMounth setTitleColor: _COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        [_btnMounth addTarget:self action:@selector(doBtnSelectTypeMounth:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btnDay, _btnWeek, _btnMounth);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_btnDay]-0-[_btnWeek]-0-[_btnMounth]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnDay]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnWeek]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnMounth]-0-|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_btnDay attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.333 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_btnWeek attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.333 constant:0]];
        
        [self doBtnSelectTypeDay:_btnDay];
    }
    return self;
}

- (void) doBtnSelectTypeDay:(UIButton*)sender
{
    if(sender.selected == YES)
        return;
    _btnDay.selected = YES;
    _btnWeek.selected = NO;
    _btnMounth.selected = NO;
    _btnDay.backgroundColor = Abled_Color;
    _btnWeek.backgroundColor = [UIColor clearColor];
    _btnMounth.backgroundColor = [UIColor clearColor];
    uniteType = EnumTypeDay;
    
    if(delegate && [delegate respondsToSelector:@selector(NotifyUnitsTypeChanged:)]){
        [delegate NotifyUnitsTypeChanged:self];
    }
}

- (void) doBtnSelectTypeWeek:(UIButton*)sender
{
    if(sender.selected == YES)
        return;
    _btnDay.selected = NO;
    _btnWeek.selected = YES;
    _btnMounth.selected = NO;
    _btnDay.backgroundColor = [UIColor clearColor];
    _btnWeek.backgroundColor = Abled_Color;
    _btnMounth.backgroundColor = [UIColor clearColor];
    uniteType = EnumTypeWeek;
    
    if(delegate && [delegate respondsToSelector:@selector(NotifyUnitsTypeChanged:)]){
        [delegate NotifyUnitsTypeChanged:self];
    }
}

- (void) doBtnSelectTypeMounth:(UIButton*)sender
{
    if(sender.selected == YES)
        return;
    _btnDay.selected = NO;
    _btnWeek.selected = NO;
    _btnMounth.selected = YES;
    _btnDay.backgroundColor = [UIColor clearColor];
    _btnWeek.backgroundColor = [UIColor clearColor];
    _btnMounth.backgroundColor = Abled_Color;
    uniteType = EnumTypeMounth;
    
    if(delegate && [delegate respondsToSelector:@selector(NotifyUnitsTypeChanged:)]){
        [delegate NotifyUnitsTypeChanged:self];
    }
}

@end
