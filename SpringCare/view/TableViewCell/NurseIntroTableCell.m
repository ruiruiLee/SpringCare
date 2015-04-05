//
//  NurseIntroTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/5.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NurseIntroTableCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation NurseIntroTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews
{
    _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgPhoto];
    _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
    _imgPhoto.layer.cornerRadius = 32;
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.font = _FONT(15);
    _lbName.textColor = _COLOR(73, 73, 73);
    
    _gradeView = [[GradeInfoView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_gradeView];
    _gradeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbCommitCount = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbCommitCount];
    _lbCommitCount.translatesAutoresizingMaskIntoConstraints = NO;
    _lbCommitCount.font = _FONT(12);
    _lbCommitCount.textColor = Disabled_Color;
    
    _imgCert = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgCert];
    _imgCert.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbNurseIntro = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbNurseIntro];
    _lbNurseIntro.translatesAutoresizingMaskIntoConstraints = NO;
    _lbNurseIntro.font = _FONT(13);
    _lbNurseIntro.textColor = [UIColor greenColor];
    
    _lbWorkIntro = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbWorkIntro];
    _lbWorkIntro.translatesAutoresizingMaskIntoConstraints = NO;
    _lbWorkIntro.numberOfLines = 0;
    _lbWorkIntro.font = _FONT(13);
    _lbWorkIntro.textColor = Disabled_Color;
    
    _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbPrice];
    _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
    _lbPrice.font = _FONT(13);
    _lbPrice.textColor = [UIColor redColor];
    
    _btnLocation = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnLocation];
    _btnLocation.translatesAutoresizingMaskIntoConstraints = NO;
    _btnLocation.userInteractionEnabled = NO;
    [_btnLocation setTitleColor:Disabled_Color forState:UIControlStateNormal];
    _btnLocation.titleLabel.font = _FONT(11);
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbPrice, _lbWorkIntro, _lbNurseIntro, _lbName, _lbCommitCount, _imgCert, _imgPhoto, _btnLocation, _gradeView);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_imgPhoto(64)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(64)]->=10-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgPhoto(64)]-15-[_lbName]-5-[_gradeView(70)]-5-[_lbCommitCount]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_lbName(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_gradeView(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[_lbCommitCount(20)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgPhoto(64)]-15-[_imgCert]-5-[_lbNurseIntro]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbName(20)]-5-[_imgCert]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbName(20)]-5-[_lbNurseIntro]->=10-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgPhoto(64)]-15-[_lbWorkIntro]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbNurseIntro]-5-[_lbWorkIntro]->=10-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgPhoto(64)]-15-[_lbPrice]->=10-[_btnLocation]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbWorkIntro]-5-[_lbPrice]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbWorkIntro]-5-[_btnLocation]->=10-|" options:0 metrics:nil views:views]];
}

- (void) SetContentData:(NurseListInfoModel*) model
{
    [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:Place_Holder_Image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    _lbName.text = model.name;
    [_gradeView setScore:model.score];
    _lbCommitCount.text = [NSString stringWithFormat:@"（%d）", model.comment];
    _lbNurseIntro.text = @"四川人";
    _lbWorkIntro.text = model.simpleIntro;
    _lbPrice.text = [NSString stringWithFormat:@"¥%ld/天", (long)model.price];//model.price;
}

@end
