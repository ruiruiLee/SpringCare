//
//  BusinessTypeView.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "BusinessTypeView.h"
#import "define.h"
#import "PriceDataModel.h"
#import "UnitsButton.h"

@implementation BusinessTypeView
@synthesize delegate;
@synthesize priseList = _priceList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        btnArray = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void) setPriseList:(NSArray *)list
{
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
    
    _priceList = list;
    
    for (int i = 0; i < [btnArray count]; i++) {
        UIButton *btn = [btnArray objectAtIndex:i];
        [btn removeFromSuperview];
    }
    [btnArray removeAllObjects];
    
    
    NSString *text = @"";
    for (int i = 0; i < [_priceList count]; i++) {
        PriceDataModel *model = [_priceList objectAtIndex:i];
        text = [text stringByAppendingString:[Util getSubStrings:model.name]];
    }
    
    CGFloat s = 0;
    CGSize size = [text sizeWithFont:_FONT(14)];
    if(size.width + [_priceList count] * 10 < 130){
        s = (130 - (size.width + [_priceList count] * 10))/[_priceList count];
    }
    
    for (int i = 0; i < [_priceList count]; i++) {
        PriceDataModel *model = [_priceList objectAtIndex:i];
        UnitsButton *btn = [[UnitsButton alloc] initWithFrame:CGRectZero];
        [self addSubview:btn];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.titleLabel.font = _FONT(14);
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.lbTitle.text = [Util getSubStrings:model.name];
        [btn addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image = [Util imageWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
        UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width/2-10, 0, image.size.width/2-10);
        [btn setBackgroundImage:[image resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
        [btn setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateSelected];
        btn.tag = 1000 + i;
        btn.layer.borderWidth = 0.6;
        btn.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
        
        NSString *format = [NSString stringWithFormat:@"H:|->=0-[btn(>=42)]->=0-|"];
        if(s > 0 && size.width + 10 + s > 42){
            CGSize size = [[Util getSubStrings:model.name] sizeWithFont:_FONT(14)];
            format = [NSString stringWithFormat:@"H:|->=0-[btn(%f)]->=0-|", size.width + 10 + s];
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
        
        if([_priceList count] > 1){
            UIButton *preBtn = [btnArray lastObject];
            
            if(i == 0){
                [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            }else{
                [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:preBtn attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                if( i == [_priceList count] - 1){
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                }
            }
            
        }else
        {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[btn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
        }
        [btnArray addObject:btn];
        
        if(model.isDefault){
            [self doBtnClicked:btn];
        }
    }
}

- (void) doBtnClicked:(UIButton *)sender
{
    if(sender.selected == YES)
        return;
    
    for (int i = 0; i < [btnArray count]; i++) {
        UIButton *btn = [btnArray objectAtIndex:i];
        btn.selected = NO;
    }
    sender.selected = YES;
    
    int index = sender.tag - 1000;
    PriceDataModel *model = [_priceList objectAtIndex:index];
    self.selectPriceModel = model;
    if(delegate && [delegate respondsToSelector:@selector(NotifyBusinessTypeChanged:model:)]){
        [delegate NotifyBusinessTypeChanged:self model:model];
    }
}


@end
