//
//  WorkAddressCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/16.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "WorkAddressCell.h"
#import "define.h"

@implementation WorkAddressCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews
{
    UIView *bgView = self.contentView;
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [bgView addSubview:_photoImage];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    _btnRelationAndSex = [[UIButton alloc] initWithFrame:CGRectZero];
    [bgView addSubview:_btnRelationAndSex];
    _btnRelationAndSex.translatesAutoresizingMaskIntoConstraints = NO;
    _btnRelationAndSex.titleLabel.font = _FONT(18);
    [_btnRelationAndSex setTitleColor:_COLOR(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    _btnRelationAndSex.userInteractionEnabled = NO;
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbName.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbName.font = _FONT(13);
    [bgView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    
    _btnSelect = [[UIButton alloc] initWithFrame:CGRectZero];
    [bgView addSubview:_btnSelect];
    _btnSelect.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnSelect setImage:[UIImage imageNamed:@"paytypenoselect"] forState:UIControlStateNormal];
    [_btnSelect setImage:[UIImage imageNamed:@"paytypeselected"] forState:UIControlStateSelected];
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [bgView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_line, _btnSelect, _btnRelationAndSex, _lbName, _lbAddress, _photoImage);
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(72)]-20-[_btnRelationAndSex]->=10-[_btnSelect]-20-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(72)]-20-[_lbName]->=10-[_btnSelect]-20-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(72)]-20-[_lbAddress]->=10-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_photoImage(72)]-15-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_btnRelationAndSex(24)]-6-[_lbName(20)]-0-[_lbAddress(20)]-15-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:_btnSelect attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContentWithModel:(id) model
{
    
}

@end
