//
//  RecordListTableViewCell.m
//  SpringCare
//
//  Created by LiuZach on 15/10/12.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import "RecordListTableViewCell.h"
#import "define.h"

@implementation RecordListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        [self initSubviews];
        
    }
    
    return self;
}

- (void) initSubviews
{
    _lbTime = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbTime];
    _lbTime.translatesAutoresizingMaskIntoConstraints = NO;
    _lbTime.backgroundColor = [UIColor clearColor];
    _lbTime.font = _FONT(14);
    _lbTime.textAlignment = NSTextAlignmentCenter;
    _lbTime.textColor = _COLOR(0x99, 0x99, 0x99);
    
    _lbSBP = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbSBP];
    _lbSBP.translatesAutoresizingMaskIntoConstraints = NO;
    _lbSBP.backgroundColor = [UIColor clearColor];
    _lbSBP.font = _FONT(17);
    _lbSBP.textAlignment = NSTextAlignmentCenter;
    _lbSBP.textColor = _COLOR(70, 178, 247);
    
    
    _lbDBP = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbDBP];
    _lbDBP.translatesAutoresizingMaskIntoConstraints = NO;
    _lbDBP.backgroundColor = [UIColor clearColor];
    _lbDBP.font = _FONT(17);
    _lbDBP.textAlignment = NSTextAlignmentCenter;
    _lbDBP.textColor = _COLOR(70, 178, 247);
    
    
    _lbHeartRate = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbHeartRate];
    _lbHeartRate.translatesAutoresizingMaskIntoConstraints = NO;
    _lbHeartRate.backgroundColor = [UIColor clearColor];
    _lbHeartRate.font = _FONT(17);
    _lbHeartRate.textAlignment = NSTextAlignmentCenter;
    _lbHeartRate.textColor = _COLOR(70, 178, 247);
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbDBP, _lbHeartRate, _lbSBP, _lbTime);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lbDBP]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lbHeartRate]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lbSBP]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lbTime]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_lbTime]-10-[_lbSBP]-10-[_lbDBP]-10-[_lbHeartRate]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTime attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbDBP attribute:NSLayoutAttributeWidth multiplier:1 constant:40]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeartRate attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbDBP attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbSBP attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbDBP attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)SetContentWithModel:(HealthRecordItemDataModel*) model
{
    NSDate *date = [Util convertDateFromDateString:model.dateString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"HH:mm"];
    NSString *string = [formatter stringFromDate:date];
    
    _lbTime.text = string;
    _lbDBP.text = model.lp;
    _lbSBP.text = model.hp;
    _lbHeartRate.text = model.pulse;
}


@end
