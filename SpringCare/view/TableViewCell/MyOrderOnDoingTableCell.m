//
//  MyOrderOnDoingTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyOrderOnDoingTableCell.h"
#import "UIImageView+WebCache.h"
#import "define.h"

@implementation MyOrderOnDoingTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self initSubViews];
    }
    return self;
}

- (void) initSubViews
{
    _headerText = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_headerText];
    _headerText.translatesAutoresizingMaskIntoConstraints = NO;
    _headerText.font = _FONT(14);
    _headerText.textColor = _COLOR(0xe4, 0x39, 0x3c);
    _headerText.text = @"正在服务中的订单";
    
    _topLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_topLine];
    _topLine.translatesAutoresizingMaskIntoConstraints = NO;
    _topLine.backgroundColor = SeparatorLineColor;
    
    _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_imgPhoto];
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbName];
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbName.font = _FONT(15);
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbPrice];
    _lbPrice.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
    _lbPrice.font = _FONT(13);
    
    _lbCountPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbCountPrice];
    _lbCountPrice.textColor = _COLOR(0xe4, 0x39, 0x3c);
    _lbCountPrice.translatesAutoresizingMaskIntoConstraints = NO;
    _lbCountPrice.font = _FONT(18);
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    _btnPay = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnPay];
    _btnPay.translatesAutoresizingMaskIntoConstraints = 0;
    _btnPay.titleLabel.font = _FONT(15);
    _btnPay.backgroundColor = Abled_Color;
    [_btnPay setTitle:@"去付款" forState:UIControlStateNormal];
    _btnPay.layer.cornerRadius = 8;
    
    _btnStatus = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnStatus];
    _btnStatus.translatesAutoresizingMaskIntoConstraints = 0;
    _btnStatus.titleLabel.font = _FONT(15);
    _btnStatus.backgroundColor = _COLOR(0x99, 0x99, 0x99);
    _btnStatus.hidden = YES;
    
    _imgLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgLogo];
    _imgLogo.translatesAutoresizingMaskIntoConstraints = NO;
    _imgLogo.image = [UIImage imageNamed:@"orderend"];
    
    _imgDayTime = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgDayTime];
    _imgDayTime.translatesAutoresizingMaskIntoConstraints = NO;
    _imgDayTime.image = [UIImage imageNamed:@"daytime"];
    
    _imgNight = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgNight];
    _imgNight.translatesAutoresizingMaskIntoConstraints = NO;
    _imgNight.image = [UIImage imageNamed:@"night"];
    
    _lbDetailTime = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbDetailTime];
    _lbDetailTime.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbDetailTime.translatesAutoresizingMaskIntoConstraints = NO;
    _lbDetailTime.font = _FONT(12);
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgPhoto, _lbName, _lbPrice, _lbCountPrice, _line, _btnPay, _btnStatus, _imgLogo, _imgDayTime, _imgNight, _lbDetailTime, _topLine, _headerText);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_lbName]->=10-[_btnPay(74)]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_lbPrice]->=10-[_lbCountPrice]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_imgDayTime]-0-[_imgNight]-0-[_lbDetailTime]->=15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgLogo]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnStatus]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headerText(24)]-0-[_topLine(1)]-10-[_lbName(30)]-5-[_lbPrice(20)]-5-[_lbDetailTime(20)]-5-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topLine]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_headerText]->=15-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgPhoto attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:12]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:12]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnPay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbCountPrice attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbPrice attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgDayTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgNight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) SetContentData:(OrderListModel*) data
{
    [_imgPhoto sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
    _lbPrice.text = data.price;
    _lbCountPrice.text = data.countPrice;
    _lbDetailTime.text = data.fromto;
    _lbName.text = data.name;
}

@end
