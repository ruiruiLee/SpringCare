//
//  UserApplyAttentionTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserApplyAttentionTableCell.h"
#import "define.h"
//#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


@implementation UserApplyAttentionTableCell
@synthesize _btnAccept;
@synthesize requestModel;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _btnphotoImg = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnphotoImg.layer.masksToBounds = YES;
        [self.contentView addSubview:_btnphotoImg];
        _btnphotoImg.translatesAutoresizingMaskIntoConstraints = NO;
        _btnphotoImg.userInteractionEnabled=NO;
        
        
        _lbUserName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbUserName];
        _lbUserName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbUserName.textColor = _COLOR(0x22, 0x22, 0x22);
        
        _lbActionName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbActionName];
        _lbActionName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbActionName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbActionName.text = @"申请关注";
        
        _btnAccept = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnAccept];
        _btnAccept.translatesAutoresizingMaskIntoConstraints = NO;
        _btnAccept.layer.cornerRadius = 8;
        _btnAccept.backgroundColor = Abled_Color;
        [_btnAccept setTitle:@"接受" forState:UIControlStateNormal];
        [_btnAccept setTitle:@"接受" forState:UIControlStateSelected];
        
        _imgExplaction = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgExplaction];
        _imgExplaction.translatesAutoresizingMaskIntoConstraints = NO;
        _imgExplaction.image = [UIImage imageNamed:@"usercenterapplystatus"];
        
        
        _lbExplaction = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbExplaction];
        _lbExplaction.translatesAutoresizingMaskIntoConstraints = NO;
        _lbExplaction.textColor = _COLOR(0x99, 0x99, 0x99);
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
        _line.backgroundColor = SeparatorLineColor;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btnphotoImg, _lbUserName, _lbActionName, _btnAccept, _lbExplaction, _imgExplaction, _line);
        EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
        if(type == EnumValueTypeiPhone4S){
            [self InitConstraintsForiPhone5:views];
        }
        else if (type == EnumValueTypeiPhone5){
            [self InitConstraintsForiPhone5:views];
        }
        else if (type == EnumValueTypeiPhone6){
            [self InitConstraintsForiPhone6:views];
        }
        else if (type == EnumValueTypeiPhone6P){
            [self InitConstraintsForiPhone6P:views];
        }else{
            [self InitConstraintsForiPhone5:views];
        }
    }
    return self;
}

- (void) InitConstraintsForiPhone5:(NSDictionary*) views
{
    _lbExplaction.font = _FONT(11);
    _lbActionName.font = _FONT(12);
    _btnAccept.titleLabel.font = _FONT(14);
    _lbUserName.font = _FONT(13);
    _btnphotoImg.layer.cornerRadius = 31;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-10-[_lbUserName]-10-[_lbActionName]->=10-[_btnAccept(52)]-22.5-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(62)]-10-[_imgExplaction(12)]-1-[_lbExplaction]->=10-[_btnAccept(52)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(62)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbUserName(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(62)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbActionName(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnAccept(29)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAccept attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbActionName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbUserName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbExplaction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imgExplaction attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_lbUserName(20)]-6-[_imgExplaction]->=20-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6:(NSDictionary*) views
{
    _lbExplaction.font = _FONT(12);
    _btnAccept.titleLabel.font = _FONT(15);
    _lbUserName.font = _FONT(14);
    _lbActionName.font = _FONT(13);
    _btnphotoImg.layer.cornerRadius = 36;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-10-[_lbUserName]-10-[_lbActionName]->=10-[_btnAccept(59)]-22.5-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(72)]-10-[_imgExplaction(12)]-1-[_lbExplaction]->=10-[_btnAccept(59)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(72)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbUserName(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(72)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbActionName(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnAccept(32)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAccept attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbActionName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbUserName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbExplaction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imgExplaction attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_lbUserName(20)]-6-[_imgExplaction]->=20-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6P:(NSDictionary*) views
{
    _lbExplaction.font = _FONT(13);
    _btnAccept.titleLabel.font = _FONT(16);
    _lbActionName.font = _FONT(14);
    _lbUserName.font = _FONT(15);
    _btnphotoImg.layer.cornerRadius = 41;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-10-[_lbUserName]-10-[_lbActionName]->=10-[_btnAccept(66)]-22.5-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(82)]-10-[_imgExplaction(12)]-1-[_lbExplaction]->=10-[_btnAccept(66)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(82)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbUserName(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(82)]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbActionName(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnAccept(35)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAccept attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbActionName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbUserName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbExplaction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imgExplaction attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_lbUserName(20)]-6-[_imgExplaction]->=20-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
    requestModel = data;
    [_btnphotoImg sd_setImageWithURL:[NSURL URLWithString:data.photoUrl] forState:UIControlStateNormal placeholderImage:ThemeImage(@"placeholderimage")];
    
    if(!data.isAccept){
        [_btnAccept setTitle:@"接受" forState:UIControlStateNormal];
        _btnAccept.userInteractionEnabled = YES;
    }else{
        [_btnAccept setTitle:@"已接受" forState:UIControlStateNormal];
        _btnAccept.userInteractionEnabled = NO;
         _btnAccept.backgroundColor = Disabled_Color;
    }
    _lbUserName.text = data.username;
}

@end
