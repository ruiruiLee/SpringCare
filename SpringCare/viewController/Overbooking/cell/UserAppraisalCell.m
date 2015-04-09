//
//  UserAppraisalCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserAppraisalCell.h"
#import "define.h"

@implementation UserAppraisalCell
@synthesize _logoView;
@synthesize _lbAppraisalNum;
@synthesize _unfoldStaus;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _logoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_logoView];
        _logoView.translatesAutoresizingMaskIntoConstraints = NO;
        _logoView.image = [UIImage imageNamed:@"placeappraisal"];
        
        _lbAppraisalNum = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbAppraisalNum];
        _lbAppraisalNum.translatesAutoresizingMaskIntoConstraints = NO;
        _lbAppraisalNum.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbAppraisalNum.font = _FONT(15);
        
        _unfoldStaus = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_unfoldStaus];
        _unfoldStaus.translatesAutoresizingMaskIntoConstraints = NO;
        _unfoldStaus.image = [UIImage imageNamed:@"usercentershutgray"];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_logoView, _lbAppraisalNum, _unfoldStaus);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[_logoView]-4-[_lbAppraisalNum]->=0-[_unfoldStaus]-25-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbAppraisalNum(20)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbAppraisalNum attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_unfoldStaus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
