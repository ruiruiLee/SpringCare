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
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_backgroundView];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundView.backgroundColor = [UIColor whiteColor];
        
        _btnphotoImg = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnphotoImg.layer.masksToBounds = YES;
        [_backgroundView addSubview:_btnphotoImg];
        _btnphotoImg.translatesAutoresizingMaskIntoConstraints = NO;
        _btnphotoImg.userInteractionEnabled=NO;
        
        
        _lbUserName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_lbUserName];
        _lbUserName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbUserName.textColor = _COLOR(0x22, 0x22, 0x22);
        _lbUserName.backgroundColor = [UIColor clearColor];
        
        _lbActionName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_lbActionName];
        _lbActionName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbActionName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbActionName.text = @"申请关注";
        _lbActionName.backgroundColor = [UIColor clearColor];
        
        _btnAccept = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_btnAccept];
        _btnAccept.translatesAutoresizingMaskIntoConstraints = NO;
        _btnAccept.layer.cornerRadius = 8;
        [_btnAccept setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
        _btnAccept.clipsToBounds = YES;
        [_btnAccept setTitle:@"接受" forState:UIControlStateNormal];
        [_btnAccept setTitle:@"接受" forState:UIControlStateSelected];
        _btnAccept.backgroundColor = [UIColor clearColor];
        
        _imgExplaction = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_imgExplaction];
        _imgExplaction.translatesAutoresizingMaskIntoConstraints = NO;
        _imgExplaction.image = [UIImage imageNamed:@"usercenterapplystatus"];
        
        _lbExplaction = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_lbExplaction];
        _lbExplaction.translatesAutoresizingMaskIntoConstraints = NO;
        _lbExplaction.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbExplaction.numberOfLines = 0;
        NSString *labelText = @"如果您接受后，他将共享您的陪护信息";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        _lbExplaction.attributedText = attributedString;
        _lbExplaction.backgroundColor = [UIColor clearColor];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btnphotoImg, _lbUserName, _lbActionName, _btnAccept, _lbExplaction, _imgExplaction, _backgroundView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundView]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_backgroundView]-5-|" options:0 metrics:nil views:views]];
        
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
    _lbExplaction.preferredMaxLayoutWidth = ScreenWidth - 184.5;
    _lbExplaction.font = _FONT(11);
    _lbActionName.font = _FONT(12);
    _btnAccept.titleLabel.font = _FONT(14);
    _lbUserName.font = _FONT(13);
    _btnphotoImg.layer.cornerRadius = 31;
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(62)]-10-[_lbUserName]-10-[_lbActionName]->=10-[_btnAccept(52)]-22.5-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(62)]-10-[_imgExplaction(12)]-1-[_lbExplaction]->=10-[_btnAccept(52)]->=0-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbUserName(20)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(62)]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbActionName(20)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnAccept(29)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAccept attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbActionName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbUserName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbExplaction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imgExplaction attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-21-[_lbUserName(20)]-6-[_imgExplaction]->=20-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6:(NSDictionary*) views
{
    _lbExplaction.font = _FONT(12);
    _btnAccept.titleLabel.font = _FONT(15);
    _lbUserName.font = _FONT(14);
    _lbActionName.font = _FONT(13);
    _btnphotoImg.layer.cornerRadius = 36;
    _lbExplaction.preferredMaxLayoutWidth = ScreenWidth - 194.5;
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(72)]-10-[_lbUserName]-10-[_lbActionName]->=10-[_btnAccept(59)]-22.5-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(72)]-10-[_imgExplaction(12)]-1-[_lbExplaction]->=10-[_btnAccept(59)]->=0-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbUserName(20)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(72)]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbActionName(20)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnAccept(32)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAccept attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbActionName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbUserName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbExplaction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imgExplaction attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-23-[_lbUserName(20)]-6-[_imgExplaction]->=25-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6P:(NSDictionary*) views
{
    _lbExplaction.font = _FONT(13);
    _btnAccept.titleLabel.font = _FONT(16);
    _lbActionName.font = _FONT(14);
    _lbUserName.font = _FONT(15);
    _btnphotoImg.layer.cornerRadius = 41;
    _lbExplaction.preferredMaxLayoutWidth = ScreenWidth - 204.5;
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_btnphotoImg(82)]-10-[_lbUserName]-10-[_lbActionName]->=10-[_btnAccept(66)]-22.5-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnphotoImg(82)]-10-[_imgExplaction(12)]-1-[_lbExplaction]->=10-[_btnAccept(66)]->=0-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbUserName(20)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=15-[_btnphotoImg(82)]->=15-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbActionName(20)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnAccept(35)]->=0-|" options:0 metrics:nil views:views]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAccept attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbActionName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbUserName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_lbExplaction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imgExplaction attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [_backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-27-[_lbUserName(20)]-6-[_imgExplaction]->=30-|" options:0 metrics:nil views:views]];
    
    [_backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:_btnphotoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
    [_btnAccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if(!data.isAccept){
        [_btnAccept setTitle:@"接受" forState:UIControlStateNormal];
        _btnAccept.userInteractionEnabled = YES;
        [_btnAccept setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
        _lbActionName.hidden = NO;
        
        NSString *labelText = @"如果您接受后，他将共享您的陪护信息";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        _lbExplaction.attributedText = attributedString;
        
    }else{
        [_btnAccept setTitle:@"已接受" forState:UIControlStateNormal];
        _btnAccept.userInteractionEnabled = NO;
        UIImage *image = [Util imageWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)];
        UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width/2-10, 0, image.size.width/2-10);
        [_btnAccept setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
        [_btnAccept setBackgroundImage:[image resizableImageWithCapInsets:inset ] forState:UIControlStateNormal];
        _lbActionName.hidden = YES;
        
        NSString *labelText = @"如果您接受后，他将共享您的陪护信息";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        _lbExplaction.attributedText = attributedString;
    }
    _lbUserName.text = data.username;
}

@end
