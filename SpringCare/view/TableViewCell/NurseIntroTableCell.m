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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
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
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    
    _gradeView = [[GradeInfoView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_gradeView];
    _gradeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbCommitCount = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbCommitCount];
    _lbCommitCount.translatesAutoresizingMaskIntoConstraints = NO;
    _lbCommitCount.font = _FONT(11);
    _lbCommitCount.textColor = _COLOR(0x99, 0x99, 0x99);
    
    _imgCert = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgCert];
    _imgCert.translatesAutoresizingMaskIntoConstraints = NO;
    _imgCert.image = [UIImage imageNamed:@"nurselistcert"];
    
    _lbNurseIntro = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbNurseIntro];
    _lbNurseIntro.translatesAutoresizingMaskIntoConstraints = NO;
    _lbNurseIntro.font = _FONT(13);
    _lbNurseIntro.textColor = _COLOR(0x6b, 0x4e, 0x3e);
    
    _lbWorkIntro = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbWorkIntro];
    _lbWorkIntro.translatesAutoresizingMaskIntoConstraints = NO;
    _lbWorkIntro.font = _FONT(12);
    _lbWorkIntro.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbWorkIntro.numberOfLines = 0;
    _lbWorkIntro.preferredMaxLayoutWidth = ScreenWidth - 117;
    
    _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbPrice];
    _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
    _lbPrice.font = _FONT(15);
    _lbPrice.textColor = _COLOR(0xe4, 0x39, 0x3c);
    
    _btnLocation = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnLocation];
    _btnLocation.translatesAutoresizingMaskIntoConstraints = NO;
    _btnLocation.userInteractionEnabled = NO;
    [_btnLocation setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
    _btnLocation.titleLabel.font = _FONT(13);
    [_btnLocation setTitle:@"约500米" forState:UIControlStateNormal];
    _btnLocation.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 4, 0);
    [_btnLocation setImage:[UIImage imageNamed:@"nurselistlocation"] forState:UIControlStateNormal];
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbPrice, _lbWorkIntro, _lbNurseIntro, _lbName, _lbCommitCount, _imgCert, _imgPhoto, _btnLocation, _gradeView, _line);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_imgPhoto(82)]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_lbName]-5-[_gradeView(70)]-5-[_lbCommitCount]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_lbName(20)]-5-[_lbNurseIntro(21)]-5-[_lbWorkIntro]-8-[_lbPrice(21)]-14-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-19-[_gradeView(20)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_lbCommitCount(20)]->=0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgPhoto(82)]-10-[_imgCert(21)]-5-[_lbNurseIntro]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbName(20)]-5-[_imgCert(21)]->=10-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgPhoto(82)]-10-[_lbWorkIntro]-10-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgPhoto(82)]-10-[_lbPrice]->=10-[_btnLocation]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbWorkIntro]-8-[_btnLocation(21)]-15-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgPhoto(82)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
}

- (void) SetContentData:(NurseListInfoModel*) model
{
    [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:[UIImage imageNamed:@"nurselistfemale"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    _lbName.text = model.name;
    [_gradeView setScore:model.score];
    _lbCommitCount.text = [NSString stringWithFormat:@"（%d）", model.comment];
    _lbNurseIntro.text = @"四川人";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.simpleIntro];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.simpleIntro length])];
//    _lbWorkIntro.attributedText = attributedString;
    _lbWorkIntro.text = model.simpleIntro;
    
    _lbPrice.text = [NSString stringWithFormat:@"¥ %ld/天", (long)model.price];//model.price;
}

@end