//
//  CityListCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/4.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CityListCell.h"
#import "define.h"

@implementation CityListCell
@synthesize lbTitle;
@synthesize imgSelectFlag;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:lbTitle];
        lbTitle.font = _FONT(15);
        lbTitle.textColor = _COLOR(73, 73, 73);
        lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        
        imgSelectFlag = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:imgSelectFlag];
        imgSelectFlag.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, imgSelectFlag);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[lbTitle]-10-[imgSelectFlag(30)]-30-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imgSelectFlag]-0-|" options:0 metrics:nil views:views]];
    }
    return self;
}

@end
