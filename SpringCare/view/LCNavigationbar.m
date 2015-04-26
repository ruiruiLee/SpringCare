//
//  LCNavigationbar.m
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "LCNavigationbar.h"
#import "define.h"

@implementation LCNavigationbar
@synthesize controlLeft;
@synthesize controlRight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = Abled_Color;//_COLOR(56, 145, 226);
        
        _btnLeft = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btnLeft];
        _btnLeft.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnLeft setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        _btnRight = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_btnRight];
        _btnRight.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_lbTitle];
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.font = _FONT(21);
        _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [UIColor whiteColor];
        
        controlLeft = [[UIControl alloc] initWithFrame:CGRectZero];
        [self addSubview:controlLeft];
        controlLeft.translatesAutoresizingMaskIntoConstraints = NO;
        [controlLeft addTarget:self action:@selector(HandleLeftButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        controlRight = [[UIControl alloc] initWithFrame:CGRectZero];
        [self addSubview:controlRight];
        controlRight.translatesAutoresizingMaskIntoConstraints = NO;
        [controlRight addTarget:self action:@selector(HandleRightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btnLeft, _btnRight, _lbTitle, controlLeft, controlRight);

        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[_lbTitle(200)]->=10-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_lbTitle(28)]-8-|" options:0 metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[controlLeft(80)]->=10-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[controlLeft(48)]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[controlRight(80)]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[controlRight(48)]-0-|" options:0 metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_btnLeft(28)]->=0-[_lbTitle]->=0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_lbTitle]->=0-[_btnRight(50)]-13-|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_btnLeft attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_btnRight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

- (void) setTitle:(NSString *)titleStr
{
    _Title = titleStr;
    _lbTitle.text = _Title;
}

- (void) HandleLeftButtonClickEvent:(UIButton *)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(NavLeftButtonClickEvent:)]){
        [_delegate NavLeftButtonClickEvent:sender];
    }
}

- (void) HandleRightButtonClickEvent:(UIButton *)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(NavRightButtonClickEvent:)]){
        [_delegate NavRightButtonClickEvent:sender];
    }
}

@end
