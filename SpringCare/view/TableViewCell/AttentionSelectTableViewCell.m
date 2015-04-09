//
//  AttentionSelectTableViewCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "AttentionSelectTableViewCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation AttentionSelectTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_photoImage];
        _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
        _lbName.font = _FONT(17);
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        
        _selectStatus = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_selectStatus];
        _selectStatus.translatesAutoresizingMaskIntoConstraints = NO;
        _selectStatus.image = [UIImage imageNamed:@"EscortTimeSelectCurrentSelect"];
        
        _lbLine = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbLine];
        _lbLine.backgroundColor = SeparatorLineColor;
        _lbLine.translatesAutoresizingMaskIntoConstraints = NO;
        
        _imgAttentionLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_photoImage addSubview:_imgAttentionLogo];
        _imgAttentionLogo.translatesAutoresizingMaskIntoConstraints = NO;
        _imgAttentionLogo.image = [UIImage imageNamed:@"relevancelogo"];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbName, _selectStatus, _lbLine, _imgAttentionLogo);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_photoImage(47)]-10-[_lbName]->=10-[_selectStatus]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbName(30)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_photoImage(47)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbLine(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_lbLine]-20-|" options:0 metrics:nil views:views]];
        
        [_photoImage addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgAttentionLogo(11)]-0-|" options:0 metrics:nil views:views]];
        [_photoImage addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgAttentionLogo(13.5)]-0-|" options:0 metrics:nil views:views]];
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

- (void) setContentWithModel:(UserAttentionModel*) model
{
    [_photoImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    _lbName.text = model.username;
}

@end
