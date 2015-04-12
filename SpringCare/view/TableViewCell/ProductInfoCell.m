//
//  ProductInfoCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "ProductInfoCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation ProductInfoCell
@synthesize _bgView;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self initSubViews];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void) initSubViews
{
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_bgView];
    _bgView.translatesAutoresizingMaskIntoConstraints = NO;
    _bgView.layer.borderWidth = 0.75;
    _bgView.layer.borderColor = SeparatorLineColor.CGColor;
    _bgView.contentMode = UIViewContentModeScaleToFill;
    
    _photoImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_photoImgV];
    _photoImgV.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [_photoImgV addSubview:_lbTitle];
    _lbTitle.font = _FONT(16);
    _lbTitle.textColor = [UIColor whiteColor];
    _lbTitle.backgroundColor = [UIColor blackColor];
    _lbTitle.alpha = 0.3f;
    _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _lbTitle.text = @"家庭老人陪护 乐享幸福晚年生活";
    
    _lbExplain = [[UILabel alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_lbExplain];
    _lbExplain.translatesAutoresizingMaskIntoConstraints = NO;
    _lbExplain.numberOfLines = 0;
    _lbExplain.preferredMaxLayoutWidth = ScreenWidth - 52;
    _lbExplain.font = _FONT(14);
    _lbExplain.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbExplain.text = @"护理老人，为护理老人提供专业的照顾，专注老年人生活照料，护理服务";
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _photoImgV, _lbTitle, _lbExplain);
    
    CGFloat multiplier = 299.0 / (323.0 * 2);
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImgV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_photoImgV attribute:NSLayoutAttributeWidth multiplier:multiplier constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-26-[_bgView]-26-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[_bgView]-17-|" options:0 metrics:nil views:views]];
    
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lbExplain]-0-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_photoImgV]-0-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_photoImgV]-3-[_lbExplain]-3-|" options:0 metrics:nil views:views]];
    [_photoImgV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lbTitle]-0-|" options:0 metrics:nil views:views]];
    [_photoImgV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbTitle(36)]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:-52]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) SetContentWithDic:(NSDictionary*)dic
{
    
}

@end
