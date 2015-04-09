//
//  DateCountSelectView.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "DateCountSelectView.h"
#import "define.h"

@implementation DateCountSelectView
@synthesize countNum;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        countNum = 1;
        
        _imgBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgBg.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imgBg];
        _imgBg.image = [UIImage imageNamed:@"placeorderdateselect"];
        _imgBg.userInteractionEnabled = YES;
        
        _btnDel = [[UIButton alloc] initWithFrame:CGRectZero];
        [_imgBg addSubview:_btnDel];
        _btnDel.translatesAutoresizingMaskIntoConstraints = NO;
        _btnDel.backgroundColor = [UIColor clearColor];
        [_btnDel addTarget:self action:@selector(doBtnDelDays:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnAdd = [[UIButton alloc] initWithFrame:CGRectZero];
        [_imgBg addSubview:_btnAdd];
        _btnAdd.translatesAutoresizingMaskIntoConstraints = NO;
        _btnAdd.backgroundColor = [UIColor clearColor];
        [_btnAdd addTarget:self action:@selector(doBtnAddDays:) forControlEvents:UIControlEventTouchUpInside];
        
        _lbCount = [[UILabel alloc] initWithFrame:CGRectZero];
        [_imgBg addSubview:_lbCount];
        _lbCount.translatesAutoresizingMaskIntoConstraints = NO;
        _lbCount.textAlignment = NSTextAlignmentCenter;
        _lbCount.textColor = [UIColor blackColor];
        _lbCount.font = _FONT(18);
        _lbCount.backgroundColor = [UIColor clearColor];
        _lbCount.text = [NSString stringWithFormat:@"%ld", countNum];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imgBg, _btnAdd, _btnDel, _lbCount);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imgBg(130)]->=0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imgBg(38)]->=0-|" options:0 metrics:nil views:views]];
        
        [_imgBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_btnDel(36)]-0-[_lbCount]-0-[_btnAdd(36)]-0-|" options:0 metrics:nil views:views]];
        [_imgBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_btnDel]-2-|" options:0 metrics:nil views:views]];
        [_imgBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_lbCount]-2-|" options:0 metrics:nil views:views]];
        [_imgBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_btnAdd]-2-|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void) doBtnAddDays:(UIButton*)sender
{
    countNum ++;
    _lbCount.text = [NSString stringWithFormat:@"%ld", countNum];
}

- (void) doBtnDelDays:(UIButton*)sender
{
    countNum --;
    if(countNum < 1)
        countNum = 1;
    _lbCount.text = [NSString stringWithFormat:@"%ld", countNum];
}

@end
