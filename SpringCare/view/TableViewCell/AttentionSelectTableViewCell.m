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
@synthesize _selectStatus = _selectStatus;
@synthesize _imgAttentionLogo = _imgAttentionLogo;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_photoImage];
        _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
        _photoImage.layer.masksToBounds = YES;
        _photoImage.layer.cornerRadius = 20;
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
        _lbName.font = _FONT(14);
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
        [self.contentView addSubview:_imgAttentionLogo];
        _imgAttentionLogo.translatesAutoresizingMaskIntoConstraints = NO;
        _imgAttentionLogo.image = [UIImage imageNamed:@"relevancelogo"];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbName, _selectStatus, _lbLine, _imgAttentionLogo);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_photoImage(40)]-10-[_lbName]->=10-[_selectStatus]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbName(30)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_photoImage(40)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbLine(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_lbLine]-20-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgAttentionLogo(14)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgAttentionLogo(14)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgAttentionLogo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_photoImage attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgAttentionLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_photoImage attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
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
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:model.photoUrl]  placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    if (model.relation.length==0) {
       _lbName.text = model.username.length==0?@"姓名":model.username;
    }
    else
        _lbName.text = model.relation ;
   
}

@end
