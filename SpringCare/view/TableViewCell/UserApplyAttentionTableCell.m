//
//  UserApplyAttentionTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserApplyAttentionTableCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation UserApplyAttentionTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_photoImage];
        _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
        _photoImage.layer.cornerRadius = 43;
        
        _lbUserName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbUserName];
        _lbUserName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbUserName.textColor = _COLOR(0x22, 0x22, 0x22);
        _lbUserName.font = _FONT(14);
        
        _lbActionName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbActionName];
        _lbActionName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbActionName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbActionName.font = _FONT(13);
        _lbActionName.text = @"申请关注";
        
        _btnAccept = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnAccept];
        _btnAccept.translatesAutoresizingMaskIntoConstraints = NO;
        _btnAccept.layer.cornerRadius = 8;
        _btnAccept.backgroundColor = Abled_Color;
        [_btnAccept setTitle:@"接受" forState:UIControlStateNormal];
        [_btnAccept setTitle:@"接受" forState:UIControlStateSelected];
        _btnAccept.titleLabel.font = _FONT(15);
        
        _imgExplaction = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgExplaction];
        _imgExplaction.translatesAutoresizingMaskIntoConstraints = NO;
        _imgExplaction.image = [UIImage imageNamed:@"usercenterapplystatus"];
        
        _lbExplaction = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbExplaction];
        _lbExplaction.translatesAutoresizingMaskIntoConstraints = NO;
        _lbExplaction.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbExplaction.font = _FONT(12);
        _lbExplaction.numberOfLines = 0;
        NSString *labelText = @"如果您接受后，他将共享您的陪护信息";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        _lbExplaction.attributedText = attributedString;
        _lbExplaction.preferredMaxLayoutWidth = ScreenWidth - 202.5;
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = _COLOR(0xd7, 0xd7, 0xd7);
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbUserName, _lbActionName, _btnAccept, _lbExplaction, _imgExplaction, _line);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(86)]-10-[_lbUserName]-10-[_lbActionName]->=10-[_btnAccept(59)]-22.5-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_photoImage(86)]-10-[_imgExplaction(12)]-1-[_lbExplaction]->=10-[_btnAccept(59)]->=0-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_photoImage(86)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbUserName(20)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_photoImage(86)]->=15-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbActionName(20)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnAccept(32)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAccept attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbActionName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbUserName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbExplaction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imgExplaction attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_lbUserName(20)]-6-[_imgExplaction]->=20-[_line(1)]-0-|" options:0 metrics:nil views:views]];
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

- (void) SetContentData:(UserRequestAcctionModel*) data
{
    [_photoImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"placeholderimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    _lbUserName.text = data.username;
    //    if(data.ringNum != nil)
    //    {
    //
    //    }
}

@end
