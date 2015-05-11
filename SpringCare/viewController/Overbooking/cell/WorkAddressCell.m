//
//  WorkAddressCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/16.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "WorkAddressCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation WorkAddressCell
@synthesize _btnSelect;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews
{
    UIView *bgView = self.contentView;
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
     _photoImage.layer.masksToBounds = YES;
    [bgView addSubview:_photoImage];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    _photoImage.contentMode = UIViewContentModeScaleAspectFill;
//    
    _lbRelation =[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbRelation];
    _lbRelation.translatesAutoresizingMaskIntoConstraints = NO;
    _lbRelation.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbRelation.backgroundColor = [UIColor clearColor];
    
    ImgSex = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:ImgSex];
    ImgSex.translatesAutoresizingMaskIntoConstraints = NO;

    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
    [bgView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.backgroundColor = [UIColor clearColor];
    
    _lbAddress = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbAddress.textColor = _COLOR(0x99, 0x99, 0x99);
    [bgView addSubview:_lbAddress];
    _lbAddress.translatesAutoresizingMaskIntoConstraints = NO;
    _lbAddress.backgroundColor = [UIColor clearColor];
    
    _btnSelect = [[UIButton alloc] initWithFrame:CGRectZero];
    [bgView addSubview:_btnSelect];
    _btnSelect.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnSelect setImage:[UIImage imageNamed:@"paytypenoselect"] forState:UIControlStateNormal];
    [_btnSelect setImage:[UIImage imageNamed:@"paytypeselected"] forState:UIControlStateSelected];
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [bgView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_line, _btnSelect, _lbRelation, _lbName, _lbAddress, _photoImage,ImgSex);
    
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S || EnumValueTypeiPhone5 == type){
        [self InitConstraintsForiPhone5:views];
        
    }else if (EnumValueTypeiPhone6 == type){
        [self InitConstraintsForiPhone6:views];
    }
    else if (EnumValueTypeiPhone6P == type){
        [self InitConstraintsForiPhone6P:views];
    }
    else{
        [self InitConstraintsForiPhone5:views];
    }

}

- (void) InitConstraintsForiPhone5:(NSDictionary*) views
{
     _photoImage.layer.cornerRadius = 31;
    _lbRelation.font = _FONT_B(18);
    _lbName.font = _FONT(14);
    _lbAddress.font = _FONT(13);
    UIView *bgView = self.contentView;
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(62)]-20-[_lbRelation]->=10-[_btnSelect]-20-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(62)]-20-[_lbName]->=10-[_btnSelect]-20-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(62)]-20-[_line]-0-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(62)]-20-[_lbAddress]->=10-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_photoImage(62)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(62)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_lbRelation(20)]-3-[_lbName(20)]-0-[_lbAddress(20)]-7-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:_btnSelect attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6:(NSDictionary*) views
{
     _photoImage.layer.cornerRadius = 36;
    _lbRelation.font = _FONT_B(20);
    _lbName.font = _FONT(15);
    _lbAddress.font = _FONT(14);
    UIView *bgView = self.contentView;
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(72)]-20-[_lbRelation]->=10-[_btnSelect]-20-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(72)]-20-[_lbName]->=10-[_btnSelect]-20-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(72)]-20-[_line]-0-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(72)]-20-[_lbAddress]->=10-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_photoImage(72)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(72)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-19-[_lbRelation(20)]-6-[_lbName(20)]-0-[_lbAddress(20)]-10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:_btnSelect attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6P:(NSDictionary*) views
{
    _photoImage.layer.cornerRadius = 41;
    _lbRelation.font = _FONT_B(22);
    _lbName.font = _FONT(16);
    _lbAddress.font = _FONT(15);
    UIView *bgView = self.contentView;
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(82)]-20-[_lbRelation]->=10-[_btnSelect(30)]-20-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(82)]-20-[_lbName]->=10-[_btnSelect]-20-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(82)]-20-[_line]-0-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(82)]-20-[_lbAddress]->=10-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_photoImage(82)]->=0-|" options:0 metrics:nil views:views]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnSelect(30)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(82)]-18-[_lbRelation]-25-[ImgSex]->=20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:ImgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-22-[_lbRelation(20)]-10-[_lbName(20)]-5-[_lbAddress(20)]-14-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:_btnSelect attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    _lbAddress.text = model.address;
    if(model.address == nil){
        _lbAddress.text = @"地址";
    }
    
    _lbName.text = [NSString stringWithFormat:@"%@     %@     %@", [model.username isEqual:@""]?@"姓名":model.username,[model.age isEqual:@"0"]?@"年龄":[NSString stringWithFormat:@"%@岁",model.age ],model.height<=0?@"身高":[NSString stringWithFormat:@"%dcm",model.height]];
    NSString *relation = model.relation;
    if(relation == nil || [relation length] == 0)
        relation = @"昵称";
    
    _lbRelation.text =relation;
    UserSex sex = [Util GetSexByName:model.sex];
    if(sex == EnumUnknown){
        
    }
    else if (sex == EnumMale){
        [ImgSex setImage:ThemeImage(@"mail")];
    }
    else{
        [ImgSex setImage:ThemeImage(@"femail")];
    }

    }

@end
