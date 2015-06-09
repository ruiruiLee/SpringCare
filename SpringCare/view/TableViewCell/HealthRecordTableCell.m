//
//  HealthRecordTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/6/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "HealthRecordTableCell.h"
#import "define.h"

@implementation HealthRecordTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _lbhp = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbhp];
        _lbhp.translatesAutoresizingMaskIntoConstraints = NO;
        _lbhp.backgroundColor = [UIColor clearColor];
        _lbhp.font = _FONT(15);
        _lbhp.textColor = _COLOR(0x66, 0x66, 0x66);
        
        _lblp = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lblp];
        _lblp.translatesAutoresizingMaskIntoConstraints = NO;
        _lblp.backgroundColor = [UIColor clearColor];
        _lblp.font = _FONT(15);
        _lblp.textColor = _COLOR(0x66, 0x66, 0x66);
        
        _lbPulse = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbPulse];
        _lbPulse.translatesAutoresizingMaskIntoConstraints = NO;
        _lbPulse.backgroundColor = [UIColor clearColor];
        _lbPulse.font = _FONT(15);
        _lbPulse.textColor = _COLOR(0x66, 0x66, 0x66);
        
        _lbUpTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbUpTime];
        _lbUpTime.translatesAutoresizingMaskIntoConstraints = NO;
        _lbUpTime.backgroundColor = [UIColor clearColor];
        _lbUpTime.font = _FONT(13);
        _lbUpTime.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _spaceView1 = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_spaceView1];
        _spaceView1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _spaceView2 = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_spaceView2];
        _spaceView2.translatesAutoresizingMaskIntoConstraints = NO;
        
        _spaceView3 = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_spaceView3];
        _spaceView3.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbhp, _lblp, _lbPulse, _lbUpTime, _spaceView1, _spaceView2, _spaceView3);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_lbhp]-0-[_spaceView1]-0-[_lblp]-0-[_spaceView2]-0-[_lbPulse]-0-[_spaceView3]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_lbUpTime]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbhp]-10-[_lbUpTime]-20-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lblp attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbhp attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbPulse attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbhp attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_spaceView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_spaceView1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_spaceView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_spaceView1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
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

- (void) SetContentWithModel:(HealthRecordItemDataModel *)model
{
    _lbUpTime.text = model.dateString;
    _lbhp.attributedText =  [self AttributedTitleFromString:[NSString stringWithFormat:@"高压：%@", model.hp] title:[NSString stringWithFormat:@"%@", model.hp]];
    _lblp.attributedText = [self AttributedTitleFromString:[NSString stringWithFormat:@"低压：%@", model.lp] title:[NSString stringWithFormat:@"%@", model.lp]];
    _lbPulse.attributedText = [self AttributedTitleFromString:[NSString stringWithFormat:@"心跳：%@", model.pulse] title:[NSString stringWithFormat:@"%@", model.pulse]];
}

- (NSMutableAttributedString *)AttributedTitleFromString:(NSString*)string title:(NSString *)title
{
    NSString *UnitPrice = string;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:title];
    [attString addAttribute:NSForegroundColorAttributeName value:Abled_Color range:range];
    return attString;
}

@end

