//
//  OrderStepView.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderStepView.h"
#import "define.h"

@interface OrderStepView()
{
    UIButton *_imgStep1;
    UILabel *_lbStep1;
    
    UIButton *_imgStep2;
    UILabel *_lbStep2;
    
    UIButton *_imgStep3;
    UILabel *_lbStep3;
    
    UIButton *_imgStep4;
    UILabel *_lbStep4;
    
    UIImageView *_line1;
    UIImageView *_line2;
    UIImageView *_line3;
}

@end

@implementation OrderStepView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews
{
    _imgStep1 = [self CreateButtonStepWithString:@"1"];
    _lbStep1 = [self createDetailLabel:@"已受理"];
    
    _imgStep2 = [self CreateButtonStepWithString:@"2"];
    _lbStep2 = [self createDetailLabel:@"服务中"];
    
    _imgStep3 = [self CreateButtonStepWithString:@"3"];
    _lbStep3 = [self createDetailLabel:@"服务完成"];
    
    _imgStep4 = [self CreateButtonStepWithString:@"4"];
    _lbStep4 = [self createDetailLabel:@"已评价"];
    
    _line1 = [self createLine];
    _line2 = [self createLine];
    _line3 = [self createLine];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgStep1, _imgStep2, _imgStep3, _imgStep4, _lbStep1, _lbStep2, _lbStep3, _lbStep4, _line1, _line2, _line3);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-29-[_imgStep1]-0-[_line1]-0-[_imgStep2]-0-[_line2]-0-[_imgStep3]-0-[_line3]-0-[_imgStep4]-29-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_lbStep1]->=0-[_lbStep2]->=0-[_lbStep3]->=0-[_lbStep4]->=0-|" options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imgStep2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imgStep3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imgStep4 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_line1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_line2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_line3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_line2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_line1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_line3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_line1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbStep1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_imgStep1 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbStep2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_imgStep2 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbStep3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_imgStep3 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbStep4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_imgStep4 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbStep2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbStep3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbStep4 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbStep1 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imgStep1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-8]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lbStep1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:18]];
}

- (UIButton*) CreateButtonStepWithString:(NSString*)str
{
    UIImage *normail = [UIImage imageNamed:@"stepnormal"];
    UIImage *selected = [UIImage imageNamed:@"stepselected"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:btn];
    btn.userInteractionEnabled = NO;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setBackgroundImage:normail forState:UIControlStateNormal];
    [btn setBackgroundImage:selected forState:UIControlStateSelected];
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = _FONT_B(22);
    
    return btn;
}

- (UILabel*) createDetailLabel:(NSString*)str
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:lb];
    lb.font = _FONT(14);
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = _COLOR(0x27, 0xa6, 0x69);
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    lb.text = str;
    return lb;
}

- (UIImageView*) createLine
{
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:imgview];
    imgview.image = [UIImage imageNamed:@"stepselectlinenormal"];
    imgview.translatesAutoresizingMaskIntoConstraints = NO;
    return imgview;
}

- (void) SetCurrentStepWithIdx:(NSInteger) idx
{
    
}

@end
