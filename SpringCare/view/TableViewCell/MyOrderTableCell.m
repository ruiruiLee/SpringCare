//
//  MyOrderTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MyOrderTableCell.h"
#import "UIImageView+WebCache.h"
#import "define.h"

@implementation MyOrderTableCell
@synthesize delegate;

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
    _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_imgPhoto];
    _imgPhoto.clipsToBounds = YES;
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbName];
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbPrice];
    _lbPrice.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbCountPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbCountPrice];
    _lbCountPrice.textColor = _COLOR(0xe4, 0x39, 0x3c);
    _lbCountPrice.translatesAutoresizingMaskIntoConstraints = NO;
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    _btnPay = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnPay];
    _btnPay.translatesAutoresizingMaskIntoConstraints = 0;
    _btnPay.backgroundColor = Abled_Color;
    [_btnPay setTitle:@"去付款" forState:UIControlStateNormal];
    _btnPay.layer.cornerRadius = 8;
    _btnPay.clipsToBounds = YES;
    [_btnPay addTarget:self action:@selector(btnToPay:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnStatus = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnStatus];
    _btnStatus.translatesAutoresizingMaskIntoConstraints = 0;
    _btnStatus.hidden = YES;
    _btnStatus.layer.cornerRadius = 8;
    _btnStatus.clipsToBounds = YES;
    [_btnStatus addTarget:self action:@selector(btnToComment:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgPhoto, _lbName, _lbPrice, _lbCountPrice, _line, _btnPay, _btnStatus, _imgLogo, _imgDayTime, _imgNight, _lbDetailTime);
    
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
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbCountPrice attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnPay attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnStatus attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnPay attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_btnPay attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone5:(NSDictionary*) views
{
    _lbName.font = _FONT(14);
    _lbPrice.font = _FONT(12);
    _lbCountPrice.font = _FONT(17);
    _btnPay.titleLabel.font = _FONT(14);
    _btnStatus.titleLabel.font = _FONT(14);
    _lbDetailTime.font = _FONT(11);
    _imgPhoto.layer.cornerRadius = 31;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgPhoto(62)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(62)]-10-[_lbName]->=10-[_btnPay(74)]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnPay(28)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(62)]-10-[_lbPrice]->=10-[_lbCountPrice]->=15-|" options:0 metrics:nil views:views]];
    layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(62)]-10-[_imgDayTime]-0-[_imgNight]-0-[_lbDetailTime]->=15-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:layoutArray];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgLogo(75)]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(75)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnStatus(74)]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnStatus(28)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(62)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_lbName(25)]-3-[_lbPrice(18)]-8-[_lbDetailTime(14)]-10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgPhoto attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnPay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnPay attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbCountPrice attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbPrice attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgDayTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgNight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6:(NSDictionary*) views
{
    _lbName.font = _FONT(15);
    _lbPrice.font = _FONT(13);
    _lbCountPrice.font = _FONT(18);
    _btnPay.titleLabel.font = _FONT(15);
    _btnStatus.titleLabel.font = _FONT(15);
    _lbDetailTime.font = _FONT(12);
    _imgPhoto.layer.cornerRadius = 36;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnPay(32)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgPhoto(72)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(72)]-10-[_lbName]->=10-[_btnPay(74)]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(72)]-10-[_lbPrice]->=10-[_lbCountPrice]->=15-|" options:0 metrics:nil views:views]];
    layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(72)]-10-[_imgDayTime]-0-[_imgNight]-0-[_lbDetailTime]->=15-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:layoutArray];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgLogo(85)]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(85)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnStatus(74)]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnStatus(32)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(72)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_lbName(26)]-5-[_lbPrice(20)]-9-[_lbDetailTime(20)]-15-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgPhoto attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnPay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnPay attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbCountPrice attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbPrice attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgDayTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgNight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) InitConstraintsForiPhone6P:(NSDictionary*) views
{
    _lbName.font = _FONT(16);
    _lbPrice.font = _FONT(14);
    _lbCountPrice.font = _FONT(19);
    _btnPay.titleLabel.font = _FONT(16);
    _btnStatus.titleLabel.font = _FONT(16);
    _lbDetailTime.font = _FONT(13);
    _imgPhoto.layer.cornerRadius = 41;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnPay(36)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgPhoto(82)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_lbName]->=10-[_btnPay(74)]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_lbPrice]->=10-[_lbCountPrice]->=15-|" options:0 metrics:nil views:views]];
    layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_imgDayTime]-0-[_imgNight]-0-[_lbDetailTime]->=15-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:layoutArray];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_btnStatus(74)]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnStatus(36)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imgLogo(95)]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(95)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_lbName(30)]-9-[_lbPrice(20)]-10-[_lbDetailTime(20)]-16-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgPhoto attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnPay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnPay attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
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

- (void) SetContentData:(MyOrderdataModel *) data
{
    orderModel = data;
//    [_imgPhoto sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
    
    NSArray *nurseinfo = data.nurseInfo;
    if(nurseinfo != nil && [nurseinfo count] > 0)
        [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:HeadImage(((NurseListInfoModel*)[nurseinfo objectAtIndex:0]).headerImage)] placeholderImage:ThemeImage([Util headerImagePathWith:[Util GetSexByName:((NurseListInfoModel*)[nurseinfo objectAtIndex:0]).sex]])];
    else
        [_imgPhoto sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
    
    NSMutableString *priceStr = [[NSMutableString alloc] init];
    [priceStr appendString:[NSString stringWithFormat:@"¥%ld", data.unitPrice]];
    if(data.dateType == EnumTypeHalfDay){
        [priceStr appendString:[NSString stringWithFormat:@"/12h X %ld天", data.orderCount]];
    }
    else if (data.dateType == EnumTypeOneDay){
        [priceStr appendString:[NSString stringWithFormat:@"/天 X %ld天", data.orderCount]];
    }
    else if (data.dateType == EnumTypeOneWeek){
        [priceStr appendString:[NSString stringWithFormat:@"/周 X %ld周", data.orderCount]];
    }
    else if (data.dateType == EnumTypeOneMounth){
        [priceStr appendString:[NSString stringWithFormat:@"/月 X %ld月", data.orderCount]];
    }
    
    _lbPrice.text = priceStr;
    _lbCountPrice.text = [NSString stringWithFormat:@"¥%ld", data.totalPrice];
    _lbDetailTime.text = [Util GetOrderServiceTime:data.beginDate enddate:data.endDate datetype:data.dateType];//data.fromto;

    NSMutableString *name = [[NSMutableString alloc] init];
    [name appendString:data.product.name];
    for (int i = 0; i < [data.nurseInfo count]; i++) {
        NurseListInfoModel *model = [data.nurseInfo objectAtIndex:i];
        [name appendString:@"-"];
        [name appendString:model.name];
    }
    
    _lbName.text = name;
    
    _imgDayTime.image = [UIImage imageNamed:@"daytime"];
    _imgNight.image = [UIImage imageNamed:@"night"];
    
    [self.contentView removeConstraints:layoutArray];
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgPhoto, _lbName, _lbPrice, _lbCountPrice, _line, _btnPay, _btnStatus, _imgLogo, _imgDayTime, _imgNight, _lbDetailTime);
    layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_imgDayTime]-0-[_imgNight]-0-[_lbDetailTime]->=15-|" options:0 metrics:nil views:views];
    
    if(data.dateType == EnumTypeHalfDay){
        ServiceTimeType timeType = [Util GetServiceTimeType:data.beginDate];
        if(timeType == EnumServiceTimeNight){
            layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_imgNight]-0-[_lbDetailTime]->=15-|" options:0 metrics:nil views:views];
            _imgDayTime.image = nil;
        }
        else if (timeType == EnumServiceTimeDay){
            layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imgPhoto(82)]-10-[_imgDayTime]-0-[_lbDetailTime]->=15-|" options:0 metrics:nil views:views];
            _imgNight.image = nil;
        }
    }
    
    [self.contentView addConstraints:layoutArray];
    
    _btnPay.hidden = NO;
    _btnStatus.hidden = NO;
    _imgLogo.hidden = NO;
    
    UIImage *image = [Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)];
    UIImage *clearImage = [Util imageWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)];
    
    [_btnPay setBackgroundImage:image forState:UIControlStateNormal];
    [_btnStatus setBackgroundImage:clearImage forState:UIControlStateNormal];
    [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if(data.orderStatus == EnumOrderStatusTypeCancel){
        _imgLogo.hidden = YES;
        _btnPay.hidden = YES;
        [_btnStatus setTitle:@"已取消" forState:UIControlStateNormal];
        [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    }
    else{
        if(data.orderStatus == EnumOrderStatusTypeFinish && data.commentStatus == EnumTypeCommented && data.payStatus == EnumTypePayed)
        {
            _btnPay.hidden = YES;
            [_btnStatus setTitle:@"已完成" forState:UIControlStateNormal];
            [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        }
        else if(data.orderStatus == EnumOrderStatusTypeFinish && data.commentStatus == EnumTypeNoComment && data.payStatus == EnumTypePayed){
            _imgLogo.hidden = YES;
            _btnPay.hidden = YES;
            _btnStatus.selected = YES;
            [_btnStatus setTitle:@"去评价" forState:UIControlStateNormal];
//            _btnStatus.backgroundColor = Abled_Color;
            [_btnStatus setBackgroundImage:image forState:UIControlStateNormal];
        }else if(data.orderStatus == EnumOrderStatusTypeNew){
            _imgLogo.hidden = YES;
            [_btnStatus setTitle:@"待确定" forState:UIControlStateNormal];
            [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
//            [_btnPay setTitle:@"去付款" forState:UIControlStateNormal];
            _btnPay.hidden = YES;
        }
        else if(data.payStatus != EnumTypePayed){
            _imgLogo.hidden = YES;
            _btnStatus.hidden = YES;
            [_btnPay setTitle:@"去付款" forState:UIControlStateNormal];
        }else{
            _imgLogo.hidden = YES;
            _btnStatus.hidden = YES;
            [_btnPay setTitle:@"已付款" forState:UIControlStateNormal];
            _btnPay.backgroundColor = [UIColor clearColor];
            [_btnPay setBackgroundImage:clearImage forState:UIControlStateNormal];
             [_btnPay setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        }
    }
}

- (void) btnToPay:(UIButton*)sender
{
    if(delegate && [delegate respondsToSelector:@selector(NotifyToPayWithModel:cell:)]){
        if(orderModel){
            [delegate NotifyToPayWithModel:orderModel cell:self];
        }
    }
}

- (void) btnToComment:(UIButton*)sender
{
    if(sender.selected == NO)
        return;
    if(delegate && [delegate respondsToSelector:@selector(NotifyToCommentWithModel:cell:)]){
        if(orderModel){
            [delegate NotifyToCommentWithModel:orderModel cell:self];
        }
    }
}

@end
