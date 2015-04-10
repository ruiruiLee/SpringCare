//
//  EvaluateOrderCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EvaluateOrderCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation EvaluateOrderCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubviews];
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

- (void) initSubviews
{
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_headerView];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerView.backgroundColor = TableBackGroundColor;
    
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerView addSubview:_photoImage];
    [_photoImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_headerView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbName.font = _FONT(18);
    _lbName.text = @"王莹莹";
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
    [_headerView addSubview:_btnInfo];
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    _btnInfo.titleLabel.font = _FONT(12);
    [_btnInfo setTitleColor:_COLOR(0x6b, 0x4e, 0x3e) forState:UIControlStateNormal];
    [_btnInfo setTitle:@"四川人  38岁 护龄12年" forState:UIControlStateNormal];
    [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
    _btnInfo.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 21);
    
    _tvContent = [[PlaceholderTextView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_tvContent];
    _tvContent.translatesAutoresizingMaskIntoConstraints = NO;
    _tvContent.font = _FONT(14);
    _tvContent.placeholder = @"评价护工";
    
    _btnGood = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnGood];
    _btnGood.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnGood setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
    [_btnGood setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateSelected];
    _btnGood.titleLabel.font = _FONT(14);
    _btnGood.layer.cornerRadius = 5;
    _btnGood.layer.borderWidth = 0.8;
    [_btnGood setTitle:@"有待提高" forState:UIControlStateNormal];
    [_btnGood addTarget:self action:@selector(btnEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnBetter = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnBetter];
    _btnBetter.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnBetter setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
    [_btnBetter setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateSelected];
    _btnBetter.titleLabel.font = _FONT(14);
    _btnBetter.layer.cornerRadius = 5;
    _btnBetter.layer.borderWidth = 0.8;
    [_btnBetter setTitle:@"基本满意" forState:UIControlStateNormal];
    [_btnBetter addTarget:self action:@selector(btnEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnBest = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnBest];
    _btnBest.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnBest setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
    [_btnBest setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateSelected];
    _btnBest.titleLabel.font = _FONT(14);
    _btnBest.layer.cornerRadius = 5;
    _btnBest.layer.borderWidth = 0.8;
    [_btnBest setTitle:@"满意" forState:UIControlStateNormal];
    [_btnBest addTarget:self action:@selector(btnEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnSubmit];
    _btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    _btnSubmit.backgroundColor = Abled_Color;
    _btnSubmit.layer.cornerRadius = 5;
    _btnSubmit.titleLabel.font = _FONT(13);
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_headerView, _btnBest, _btnBetter, _btnGood, _btnInfo, _btnSubmit, _line, _tvContent, _lbName, _photoImage);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_headerView]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_tvContent]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_btnBest(60)]-10-[_btnBetter(60)]-10-[_btnGood(60)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnSubmit(60)]-16-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headerView(79)]-4-[_tvContent(100)]-12-[_btnGood(29)]-12-[_btnSubmit(25)]-4-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_line]-16-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnBetter attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnGood attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnBest attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnGood attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_photoImage(62)]-10-[_lbName]->=10-|" options:0 metrics:nil views:views]];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_photoImage(62)]-10-[_lbName]->=0-|" options:0 metrics:nil views:views]];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_photoImage(62)]-10-[_btnInfo]->=10-|" options:0 metrics:nil views:views]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_lbName(20)]-10-[_btnInfo(20)]-14-|" options:0 metrics:nil views:views]];
    
    [self btnEvaluate:_btnBest];
}

- (void) btnEvaluate:(UIButton*)sender
{
    [self reSetEvaluate];
    
    sender.selected = YES;
    sender.backgroundColor = _COLOR(0xee, 0x81, 0x38);
}

- (void) reSetEvaluate
{
    UIColor *color = _COLOR(245, 245, 245);
    UIColor *borderColor = _COLOR(222, 222, 222);
    _btnBetter.selected = NO;
    _btnBetter.backgroundColor = color;
    _btnBetter.layer.borderColor = borderColor.CGColor;
    _btnGood.selected = NO;
    _btnGood.backgroundColor = color;
    _btnGood.layer.borderColor = borderColor.CGColor;
    _btnBest.selected = NO;
    _btnBest.backgroundColor = color;
    _btnBest.layer.borderColor = borderColor.CGColor;
}

@end
