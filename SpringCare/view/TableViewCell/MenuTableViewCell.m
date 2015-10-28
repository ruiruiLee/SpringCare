//
//  MenuTableViewCell.m
//  SpringCare
//
//  Created by LiuZach on 15/3/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "define.h"

@implementation MenuTableViewCell

@synthesize indexPath;
@synthesize lbContent;
@synthesize imgIcon;
@synthesize imgUnflod;
@synthesize separatorLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // Initialization code
        lbContent = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:lbContent];
        lbContent.translatesAutoresizingMaskIntoConstraints = NO;
        lbContent.backgroundColor = [UIColor clearColor];
        lbContent.textColor = _COLOR(0xff, 0xff, 0xff);
        lbContent.font = _FONT(18);
        
        imgIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:imgIcon];
        imgIcon.translatesAutoresizingMaskIntoConstraints = NO;
        
        imgUnflod = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:imgUnflod];
        imgUnflod.translatesAutoresizingMaskIntoConstraints = NO;
        imgUnflod.image = [UIImage imageNamed:@"usercentershut"];
        
        separatorLine = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:separatorLine];
        separatorLine.backgroundColor = SeparatorLineColor;
        separatorLine.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *views = NSDictionaryOfVariableBindings(lbContent, imgUnflod, imgIcon, separatorLine);
        NSString *format = [NSString stringWithFormat:@"H:|-39-[imgIcon]-16-[lbContent]->=10-[imgUnflod(12)]-%f-|", ScreenWidth + 24 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imgIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lbContent attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imgIcon attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imgUnflod attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imgIcon attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgUnflod(16)]->=0-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[separatorLine(0.76)]-0-|" options:0 metrics:nil views:views]];
        NSString *sepFormat = [NSString stringWithFormat:@"H:|-39-[separatorLine]-%f-|", ScreenWidth + 25 -((ScreenWidth - 60)*0.8 + (ScreenWidth - ScreenWidth * 0.8) /2)];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:sepFormat options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)setContentTitle:(NSString*)content
{
    lbContent.text = content;
}


@end
