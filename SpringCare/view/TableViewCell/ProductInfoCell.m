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
    
    _lbExplain = [[UILabel alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_lbExplain];
    _lbExplain.translatesAutoresizingMaskIntoConstraints = NO;
    _lbExplain.numberOfLines = 0;
    _lbExplain.preferredMaxLayoutWidth = ScreenWidth - 52;
    _lbExplain.font = _FONT(14);
    _lbExplain.textColor = _COLOR(0x99, 0x99, 0x99);
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _photoImgV, _lbTitle, _lbExplain);
    
    CGFloat multiplier = 299.0 / (323.0 * 2);
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImgV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_photoImgV attribute:NSLayoutAttributeWidth multiplier:multiplier constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-26-[_bgView]-26-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[_bgView]-17-|" options:0 metrics:nil views:views]];
    
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lbExplain]-0-|" options:0 metrics:nil views:views]];
    NSString *format = [NSString stringWithFormat:@"H:|-0-[_photoImgV(%f)]-0-|", ScreenWidth - 52];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    NSString *vformat = [NSString stringWithFormat:@"V:|-0-[_photoImgV(%f)]-3-[_lbExplain(>=30)]-3-|", (ScreenWidth - 52) * 0.63];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vformat options:0 metrics:nil views:views]];
    [_photoImgV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lbTitle]-0-|" options:0 metrics:nil views:views]];
    [_photoImgV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbTitle(36)]-0-|" options:0 metrics:nil views:views]];
    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:-52]];
//    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImgV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImgV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_photoImgV attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
//    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImgV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_photoImgV attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) SetContentWithDic:(FamilyProductModel*)model
{
//    [_photoImgV sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:nil];
    _photoImgV.image = [UIImage imageNamed:@"hospital"];
    _lbTitle.text = model.productName;
    _lbExplain.text = model.productDesc;
}

@end
