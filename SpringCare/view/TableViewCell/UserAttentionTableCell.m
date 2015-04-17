//
//  UserAttentionTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserAttentionTableCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation UserAttentionTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_photoImage];
        _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
        _photoImage.layer.cornerRadius = 43;
        
        _btnRelation = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnRelation];
        _btnRelation.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnRelation setTitleColor:_COLOR(0x22, 0x22, 0x22) forState:UIControlStateNormal];
//        _btnRelation.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
//        _btnRelation.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _btnRelation.titleLabel.font = _FONT(18);
        _btnRelation.userInteractionEnabled = NO;
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(14);
        
        _Address = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_Address];
        _Address.translatesAutoresizingMaskIntoConstraints = NO;
        _Address.textColor = _COLOR(0x99, 0x99, 0x99);
        _Address.font = _FONT(13);
        _Address.numberOfLines = 0;
        _Address.preferredMaxLayoutWidth = ScreenWidth - 169;
        
        _btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnRing];
        _btnRing.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnRing setImage:[UIImage imageNamed:@"userattentionring"] forState:UIControlStateNormal];
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = SeparatorLineColor;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbName, _btnRelation, _btnRing, _line, _Address);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(86)]-10-[_lbName]->=10-[_btnRing]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImage(86)]-10-[_Address]->=10-[_btnRing]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_photoImage(86)]->=15-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_photoImage(86)]-15-[_line]-0-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_btnRelation(30)]-1-[_lbName(20)]-2-[_Address]->=10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnRelation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
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

- (void) SetContentData:(UserAttentionModel*) data
{
    [_photoImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"placeholderimage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    NSString *relation = data.relation;
    if(relation == nil || [relation length] == 0)
        relation = @"关系";
    [_btnRelation setTitle:relation forState:UIControlStateNormal];
    UserSex sex = [Util GetSexByName:data.sex];
    if(sex == EnumUnknown){
        [_btnRelation setImage:nil forState:UIControlStateNormal];
    }
    else if (sex == EnumMale){
        [_btnRelation setImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    }
    else{
        [_btnRelation setImage:[UIImage imageNamed:@"femail"] forState:UIControlStateNormal];
    }
    
    _lbName.text = [NSString stringWithFormat:@"%@  身高:%@米", data.username, data.height];
    _Address.text = data.address;
    if(data.address == nil){
        _Address.text = @"地址:";
    }
}

@end
