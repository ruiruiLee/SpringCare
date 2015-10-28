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
//    _bgView.layer.borderWidth = 0.7;
//    _bgView.layer.borderColor = SeparatorLineColor.CGColor;
//    _bgView.contentMode = UIViewContentModeScaleToFill;
    
    _photoImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_photoImgV setContentMode:UIViewContentModeScaleAspectFill];
    [_bgView addSubview:_photoImgV];
    _photoImgV.clipsToBounds = YES;
    
    _photoImgV.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [_photoImgV addSubview:_lbTitle];
    _lbTitle.font = _FONT_B(18);
    _lbTitle.textColor = [UIColor blackColor];
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbExplain = [[UILabel alloc] initWithFrame:CGRectZero];
    [_photoImgV addSubview:_lbExplain];
    _lbExplain.translatesAutoresizingMaskIntoConstraints = NO;
    _lbExplain.numberOfLines = 0;
    _lbExplain.preferredMaxLayoutWidth = ScreenWidth - 110 * ScreenWidth / 320 + 10;
    _lbExplain.font = _FONT(13);
    _lbExplain.textColor = [UIColor blackColor];
    _lbExplain.backgroundColor = [UIColor clearColor];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _photoImgV, _lbTitle, _lbExplain);
    
    CGFloat multiplier = 0.333333333;//299.0 / (323.0 * 2);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-0-|" options:0 metrics:nil views:views]];
    
    NSString *format = [NSString stringWithFormat:@"H:|-0-[_photoImgV(%f)]-0-|", ScreenWidth];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    NSString *vformat = [NSString stringWithFormat:@"V:|-0-[_photoImgV(%f)]-0-|", (ScreenWidth) * multiplier];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vformat options:0 metrics:nil views:views]];
    
    NSString *formatExplain = [NSString stringWithFormat:@"H:|-%f-[_lbExplain]-10-|", 110 * ScreenWidth / 320];
    [_photoImgV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatExplain options:0 metrics:nil views:views]];
    NSString *formatTitle = [NSString stringWithFormat:@"H:|-%f-[_lbTitle]-10-|", 110 * ScreenWidth / 320];
    [_photoImgV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatTitle options:0 metrics:nil views:views]];
    NSString *vformatContent = [NSString stringWithFormat:@"V:|-%f-[_lbTitle(20)]-10-[_lbExplain]->=10-|", 20 * ScreenWidth / 320];
    [_photoImgV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vformatContent options:0 metrics:nil views:views]];
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
    //[_photoImgV sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:nil];
    [_photoImgV sd_setImageWithURL:[NSURL URLWithString:ProductImage(model.image_url)] placeholderImage:nil];
//    _photoImgV.image = [UIImage imageNamed:@"nurselistfemale"];
    _lbTitle.text = [NSString stringWithFormat:@"%@",model.productName];
    _lbExplain.text = model.productDesc;
}

@end
