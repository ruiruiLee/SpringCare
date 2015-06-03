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
        
        btnArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setPriseList:(NSArray *)list
{
    _priceList = list;
    
    for (int i = 0; i < [btnArray count]; i++) {
        UIButton *btn = [btnArray objectAtIndex:i];
        [btn removeFromSuperview];
    }
    [btnArray removeAllObjects];
    
    for (int i = 0; i < [_priceList count]; i++) {
        PriceDataModel *model = [_priceList objectAtIndex:i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:btn];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.titleLabel.font = _FONT(15);
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor: _COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image = [Util imageWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
        UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width/2-10, 0, image.size.width/2-10);
        [btn setBackgroundImage:[image resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
        [btn setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateSelected];
        btn.tag = 1000 + i;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
        
        if([_priceList count] > 1){
            UIButton *preBtn = [btnArray lastObject];
            
            if(i == 0){
                [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            }else{
                [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:preBtn attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
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
        
        if(i == 0){
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
    if(delegate && [delegate respondsToSelector:@selector(NotifyUnitsTypeChanged:model:)]){
        [delegate NotifyUnitsTypeChanged:self model:model];
    }
}

@end
