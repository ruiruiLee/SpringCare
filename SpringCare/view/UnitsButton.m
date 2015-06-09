//
//  UnitsButton.m
//  SpringCare
//
//  Created by LiuZach on 15/6/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UnitsButton.h"
#import "define.h"

@implementation UnitsButton
@synthesize lbTitle;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:lbTitle];
        lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        lbTitle.font = _FONT(14);
        lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
        lbTitle.textAlignment = NSTextAlignmentCenter;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[lbTitle]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbTitle)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbTitle)]];
    }
    
    return self;
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected == YES)
        lbTitle.textColor = [UIColor whiteColor];
    else
        lbTitle.textColor = _COLOR(0x99, 0x99, 0x99);
}

@end
