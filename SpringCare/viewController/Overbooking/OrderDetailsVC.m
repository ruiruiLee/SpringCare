//
//  OrderDetailsVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "UIImageView+WebCache.h"
#import "define.h"
#import "PayForOrderVC.h"
#import "EvaluateOrderVC.h"

@implementation OrderPriceCell
@synthesize delegate;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbPrice.font = _FONT(15);
        _lbPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbPrice];
        _lbPrice.backgroundColor = [UIColor clearColor];
        
        _lbTotalPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTotalPrice.font = _FONT(15);
        _lbTotalPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbTotalPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbTotalPrice];
        _lbTotalPrice.backgroundColor = [UIColor clearColor];
        
        _lbRealPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbRealPrice.font = _FONT(15);
        _lbRealPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbRealPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbRealPrice];
        _lbRealPrice.backgroundColor = [UIColor clearColor];
        
        _couponLogo = [[CouponLogoView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_couponLogo];
        _couponLogo.translatesAutoresizingMaskIntoConstraints = NO;
        
        _btnStatus = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnStatus.titleLabel.font = _FONT(16);
        [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnStatus.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_btnStatus];
        [_btnStatus addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnStatus.layer.cornerRadius = 5;
        _btnStatus.clipsToBounds = YES;
        
        _imgLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgLogo];
        _imgLogo.translatesAutoresizingMaskIntoConstraints = NO;
        _imgLogo.image = [UIImage imageNamed:@"orderend"];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbPrice, _lbTotalPrice, _btnStatus, _imgLogo, _couponLogo, _lbRealPrice);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbPrice]->=20-[_btnStatus(80)]-23-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbTotalPrice]->=20-[_btnStatus]-23-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbRealPrice]-5-[_couponLogo(55)]->=10-[_btnStatus]-13-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_couponLogo(25)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_couponLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRealPrice attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbPrice(20)]-5-[_lbTotalPrice(20)]-5-[_lbRealPrice(20)]-20-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:constraints];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=20-[_imgLogo]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnStatus(32)]->=0-|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void) setContentData:(MyOrderdataModel *) model
{
    NSMutableString *priceStr = [[NSMutableString alloc] init];
    [priceStr appendString:[NSString stringWithFormat:@"单价：¥%d", model.unitPrice]];
    
    [priceStr appendString:[NSString stringWithFormat:@"/%@ X %@", model.priceName, model.orderCountStr]];
    
    [_couponLogo SetCouponValue:model.couponsAmount];
    
    NSString *realyTotalPrice = [NSString stringWithFormat:@"实际金额：¥%d", model.realyTotalPrice];
    NSMutableAttributedString *realystring = [[NSMutableAttributedString alloc]initWithString:realyTotalPrice];
    NSRange realrange = [realyTotalPrice rangeOfString:[NSString stringWithFormat:@"¥%d", model.realyTotalPrice]];
    [realystring addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:realrange];
    [realystring addAttribute:NSFontAttributeName value:_FONT(18) range:realrange];
    _lbRealPrice.attributedText = realystring;
    
    if(model.couponsAmount > 0){
        _couponLogo.hidden = NO;
    }
    else{
        _couponLogo.hidden = YES;
    }
    
    _lbPrice.text = priceStr;
    NSString *total = [NSString stringWithFormat:@"总价：¥%d", model.totalPrice];
    _lbTotalPrice.text = total;
    
    _btnStatus.userInteractionEnabled = YES;
    UIImage *image = [Util imageWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width/2-10, 0, image.size.width/2-10);
    UIImage *normalImage = [image resizableImageWithCapInsets:inset ];
    
    [_btnStatus setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    [_btnStatus setBackgroundImage:normalImage forState:UIControlStateNormal];
    _btnStatus.tag = 4;
    if(model.orderStatus == EnumOrderStatusTypeCancel){
        _imgLogo.hidden = YES;
        [_btnStatus setTitle:@"已取消" forState:UIControlStateNormal];
        _btnStatus.userInteractionEnabled = NO;
    }
    else{
        if(model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeCommented && model.payStatus == EnumTypePayed)
        {
            [_btnStatus setTitle:@"已完成" forState:UIControlStateNormal];
            _btnStatus.userInteractionEnabled = NO;
        }
        else if(model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeNoComment && model.payStatus == EnumTypePayed){
            _imgLogo.hidden = YES;
            _btnStatus.tag = 2;
            [_btnStatus setTitle:@"去评价" forState:UIControlStateNormal];
            [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_btnStatus setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
        }else if (model.orderStatus == EnumOrderStatusTypeNew && model.payStatus == EnumTypeNopay){
            _imgLogo.hidden = YES;
            _btnStatus.tag = 3;
            [_btnStatus setTitle:@"取消订单" forState:UIControlStateNormal];
            [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_btnStatus setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
        }
        else if(model.payStatus == EnumTypeNopay){
            _imgLogo.hidden = YES;
            _btnStatus.tag = 1;
            [_btnStatus setTitle:@"去付款" forState:UIControlStateNormal];
            [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_btnStatus setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
        }
        else{
            _imgLogo.hidden = YES;
            _btnStatus.userInteractionEnabled = NO;
            [_btnStatus setTitle:@"已付款" forState:UIControlStateNormal];
        }
    }
}

- (void) doBtnClicked:(UIButton*)sender
{

        if(delegate && [delegate respondsToSelector:@selector(NotifyButtonClickedWithFlag:)])
            [delegate NotifyButtonClickedWithFlag:sender];

}

@end

@implementation OrderInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
         _imgPhoto.layer.masksToBounds = YES;
         _imgPhoto.layer.cornerRadius = 41;
        [self.contentView addSubview:_imgPhoto];
        _imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(18);
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.backgroundColor = [UIColor clearColor];
        
        _logo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_logo];
        _logo.translatesAutoresizingMaskIntoConstraints = NO;
        _logo.image = [UIImage imageNamed:@"nurselistcert"];
        
        _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnInfo];
        _btnInfo.titleLabel.font = _FONT(13);
        [_btnInfo setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbIntro = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbIntro];
        _lbIntro.translatesAutoresizingMaskIntoConstraints = NO;
        _lbIntro.numberOfLines = 0;
        _lbIntro.font = _FONT(13);
        _lbIntro.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbIntro.preferredMaxLayoutWidth = ScreenWidth - 112;
        _lbIntro.backgroundColor = [UIColor clearColor];
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = SeparatorLineColor;
        [self.contentView addSubview:_line];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbType = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbType];
        _lbType.translatesAutoresizingMaskIntoConstraints = NO;
        _lbType.font = _FONT(15);
        _lbType.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbType.backgroundColor = [UIColor clearColor];
        
        _lbDetailTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbDetailTime];
        _lbDetailTime.translatesAutoresizingMaskIntoConstraints = NO;
        _lbDetailTime.font = _FONT(15);
        _lbDetailTime.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbDetailTime.backgroundColor = [UIColor clearColor];
        
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbPrice];
        _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
        _lbPrice.font = _FONT(15);
        _lbPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbPrice.backgroundColor = [UIColor clearColor];
//        _lbPrice.text = @"单价：380元/24小时";
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbType, _lbPrice, _lbName, _lbIntro, _lbDetailTime, _line, _btnInfo, _imgPhoto, _logo);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_line]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbDetailTime]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbType]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-10-[_lbName]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-10-[_logo]-2-[_btnInfo]->=10-|" options:0 metrics:nil views:views]];
        constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_imgPhoto(82)]-16-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-10-[_lbIntro]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:constraintArray];
        nurseConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-18-[_lbName(20)]-5-[_btnInfo(20)]-3-[_lbIntro]->=0-[_line(1)]->=0-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:nurseConstraintArray];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnInfo attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

- (void) setContentData:(MyOrderdataModel *) model
{
    NSMutableString *typeStr = [[NSMutableString alloc] init];
    [typeStr appendString:[NSString stringWithFormat:@"类型：%@", model.product.name]];
    if(model.product.typeName != nil && ![model.product.typeName isKindOfClass:[NSNull class]]){
        [typeStr appendString:[NSString stringWithFormat:@"-%@", model.product.typeName]];
    }
    _lbType.text = typeStr;
    NSMutableString *detailTime = [[NSMutableString alloc] init];
    [detailTime appendString:@"时间："];
//    [detailTime appendString:[NSString stringWithFormat:@"%d", model.orderCount]];
//    [detailTime appendString:[NSString stringWithFormat:@" X "]];
//    [detailTime appendString:[NSString stringWithFormat:@"%@", model.priceName]];
    
    if(model.dateType == EnumTypeTimes){
        [detailTime appendString:[NSString stringWithFormat:@"%@点", [Util convertShotStrFromDate:model.beginDate]]];
    }
    else{
        [detailTime appendString:[NSString stringWithFormat:@"%@点-%@点", [Util convertShotStrFromDate:model.beginDate], [Util convertShotStrFromDate:model.endDate]]];
    }
    _lbDetailTime.text = detailTime;
    
    NSMutableString *priceStr = [[NSMutableString alloc] init];
    [priceStr appendString:[NSString stringWithFormat:@"单价：%d元", model.unitPrice]];
    [priceStr appendString:[NSString stringWithFormat:@"/%@", model.priceName]];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:priceStr];
    NSRange range = NSMakeRange(3, [priceStr length] - 3);
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
    [string addAttribute:NSFontAttributeName value:_FONT(15) range:range];
    
    _lbPrice.attributedText = string;
    
    NSArray *nurseArray = model.nurseInfo;
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbType, _lbPrice, _lbName, _lbIntro, _lbDetailTime, _line, _btnInfo, _imgPhoto);
    [self.contentView removeConstraints:constraintArray];
    [self.contentView removeConstraints:nurseConstraintArray];
    if([nurseArray count] > 0){
        NurseListInfoModel *nurseModel = [nurseArray objectAtIndex:0];
        _lbIntro.text = nurseModel.intro;
        _lbName.text = nurseModel.name;
        if(nurseArray != nil && [nurseArray count] > 0)
            [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:HeadImage(((NurseListInfoModel*)[nurseArray objectAtIndex:0]).headerImage)] placeholderImage:ThemeImage([Util headerImagePathWith:[Util GetSexByName:((NurseListInfoModel*)[nurseArray objectAtIndex:0]).sex]])];
        else
            [_imgPhoto sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
        
        NSString *info = [NSString stringWithFormat:@"%@  %d岁  护龄%@年", nurseModel.birthPlace, nurseModel.age, nurseModel.careAge];
        
        [_btnInfo setTitle:info forState:UIControlStateNormal];
        
        constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_imgPhoto(82)]-16-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views];
        nurseConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-18-[_lbName(20)]-3-[_btnInfo(20)]-1-[_lbIntro]->=0-[_line(1)]->=0-|" options:0 metrics:nil views:views];
        _btnInfo.hidden = NO;
        _logo.hidden = NO;
    }else{
        constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imgPhoto(0)]-0-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views];
        nurseConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_line(1)]->=0-|" options:0 metrics:nil views:views];
        _btnInfo.hidden = YES;
        _logo.hidden = YES;
    }
    
    [self.contentView addConstraints:constraintArray];
    [self.contentView addConstraints:nurseConstraintArray];
}

@end

@implementation BeCareInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgPhoto];
        _imgPhoto.layer.masksToBounds = YES;
        _imgPhoto.layer.cornerRadius = 41;
        _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        _imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(15);
        _lbName.textAlignment = NSTextAlignmentCenter;
        _lbName.backgroundColor = [UIColor clearColor];
        
        _LbRelation = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_LbRelation];
        _LbRelation.translatesAutoresizingMaskIntoConstraints = NO;
        _LbRelation.textColor = _COLOR(0x22, 0x22, 0x22);
        _LbRelation.font = _FONT(18);
        _LbRelation.backgroundColor = [UIColor clearColor];
        
        _lbAge = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbAge];
        _lbAge.translatesAutoresizingMaskIntoConstraints = NO;
        _lbAge.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbAge.font = _FONT(15);
        _lbAge.backgroundColor = [UIColor clearColor];
        
        _lbHeight = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbHeight];
        _lbHeight.translatesAutoresizingMaskIntoConstraints = NO;
        _lbHeight.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbHeight.font = _FONT(15);
        _lbHeight.backgroundColor = [UIColor clearColor];

        
        _btnMobile = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnMobile];
        _btnMobile.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnMobile setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnMobile.titleLabel.font = _FONT(15);
        
        _btnAddress = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnAddress];
        _btnAddress.translatesAutoresizingMaskIntoConstraints = NO;
        _btnAddress.textColor = _COLOR(0x99, 0x99, 0x99);
        _btnAddress.numberOfLines = 0;
        _btnAddress.preferredMaxLayoutWidth = ScreenWidth - 132;
        _btnAddress.font = _FONT(15);
        
        _imgvAddr = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgvAddr];
        _imgvAddr.translatesAutoresizingMaskIntoConstraints = NO;
        _imgvAddr.image = ThemeImage(@"orderdetailaddr");
        
        _imgSex = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgSex];
        _imgSex.translatesAutoresizingMaskIntoConstraints = NO;
        
        seview1 = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:seview1];
        seview1.translatesAutoresizingMaskIntoConstraints = NO;
        
        seview2 = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:seview2];
        seview2.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imgPhoto, _lbName, _LbRelation, _lbAge, _btnMobile, _btnAddress, _imgSex, _lbHeight, _imgvAddr, seview2, seview1);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-10-[_LbRelation]-10-[_imgSex]->=10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-10-[_btnMobile]->=10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-10-[_imgvAddr(15)]-5-[_btnAddress]->=10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-10-[_lbName]-20-[_lbAge]-20-[_lbHeight]->=10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgPhoto(82)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_LbRelation(20)]-5-[_lbName(18)]-2-[_btnAddress]-14-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[seview2(>=10)]-0-[_LbRelation(20)]-5-[_lbName(18)]-5-[_btnAddress]-0-[seview1]-0-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgvAddr attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnAddress attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:seview1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:seview2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbAge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_LbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgPhoto attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

- (void) setContentData:(MyOrderdataModel *) model
{
    [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:HeadImage(model.lover.photoUrl)] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    _lbName.text = model.lover.username;
    if(model.lover.username == nil || [model.lover.username length] == 0)
        _lbName.text = @"姓名";
    _LbRelation.text = model.lover.relation;
    if(model.lover.relation == nil || [model.lover.relation length] == 0)
        _LbRelation.text = @"昵称";

    if(model.lover.age == nil || [model.lover.age isEqual:@"0"] || [model.lover.age isEqual:@""])
        _lbAge.text = @"年龄";
    else
        _lbAge.text = [NSString stringWithFormat:@"%@岁", model.lover.age];

    if(model.lover.height > 0)
        _lbHeight.text = [NSString stringWithFormat:@"%dcm",model.lover.height];
    else
        _lbHeight.text=@"身高";
    if(model.lover.address == nil || [model.lover.address length] == 0)
        _btnAddress.text = @"陪护地址";
    else
        _btnAddress.text = model.lover.address;
    
    UserSex sex = [Util GetSexByName:model.lover.sex];
    if(sex == EnumMale){
        _imgSex.image = [UIImage imageNamed:@"mail"];
    }
    else if (sex == EnumFemale){
        _imgSex.image = [UIImage imageNamed:@"femail"];
    }
    else
        {
            _imgSex.image = nil;
        }
}

@end


@interface OrderDetailsVC ()

@property (nonatomic, strong) OrderPriceCell *priceCell;
@property (nonatomic, strong) BeCareInfoCell *careCell;

@end

@implementation OrderDetailsVC
@synthesize _orderModel = _orderModel;
@synthesize _stepView = _stepView;
@synthesize delegate;
@synthesize _tableview = _tableview;

- (id) initWithOrderModel:(MyOrderdataModel *) model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        storeModel = model;
        [self resetOrderModel];
    }
    
    return self;
}

- (void)resetOrderModel
{
    _orderModel = [[MyOrderdataModel alloc] init];
    _orderModel.isLoadDetail = storeModel.isLoadDetail;
    _orderModel.oId = storeModel.oId;
    _orderModel.dateType = storeModel.dateType;
    _orderModel.beginDate = storeModel.beginDate;
    _orderModel.endDate = storeModel.endDate;
    _orderModel.orderCount = storeModel.orderCount;
    _orderModel.orderCountStr = storeModel.orderCountStr;
    _orderModel.unitPrice = storeModel.unitPrice;
    _orderModel.totalPrice = storeModel.totalPrice;
    _orderModel.orderStatus = storeModel.orderStatus;
    _orderModel.commentStatus = storeModel.commentStatus;
    _orderModel.payStatus = storeModel.payStatus;
    _orderModel.product = storeModel.product;
    _orderModel.nurseInfo = storeModel.nurseInfo;
    _orderModel.lover = storeModel.lover;
    _orderModel.serialNumber = storeModel.serialNumber;
    _orderModel.registerUser = storeModel.registerUser;
    _orderModel.createdDate = storeModel.createdDate;
    _orderModel.realyTotalPrice = storeModel.realyTotalPrice;
    _orderModel.couponsAmount = storeModel.couponsAmount;
    _orderModel.priceName = storeModel.priceName;
    _orderModel.isCanContinue = storeModel.isCanContinue;
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    if(!isReSetEndday){
        isReSetEndday = YES;
        [self.NavigationBar.btnRight setTitle:@"确定" forState:UIControlStateNormal];
        [self btnSelectEndDate:nil];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"续单成功后不能再取消，确认续单吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 1001;
        [alert show];
    }
}

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    if(_endPickView){
        [_endPickView removeFromSuperview];
    }
    [super NavLeftButtonClickEvent:sender];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyCommentChanged:) name:Notify_Comment_Changed object:nil];
    
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"订单详情";
    
    [self.NavigationBar.btnRight setBackgroundImage:ThemeImage(@"whitebtnbg") forState:UIControlStateNormal];
    [self.NavigationBar.btnRight setTitle:@"续单" forState:UIControlStateNormal];
    [self.NavigationBar.btnRight setTitleColor:Abled_Color forState:UIControlStateNormal];
    self.NavigationBar.btnRight.titleLabel.font = _FONT(16);
    self.NavigationBar.btnRight.hidden = YES;
    
    isReSetEndday = NO;
    
    [self initSubviews];
    
    if(!_orderModel.isLoadDetail){
        __weak OrderDetailsVC *weakSelf = self;
        __weak UITableView *weakTableView = _tableview;
        [_orderModel LoadDetailOrderInfo:^(int code) {
            if(code){
                [weakTableView reloadData];
                [weakSelf initDataForView];
            }
        }];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableview registerClass:[OrderPriceCell class] forCellReuseIdentifier:@"cell0"];
    [_tableview registerClass:[OrderInfoCell class] forCellReuseIdentifier:@"cell1"];
    [_tableview registerClass:[BeCareInfoCell class] forCellReuseIdentifier:@"cell2"];
    _tableview.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
//    _tableview.backgroundColor = TableBackGroundColor;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
//    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    if(_IPHONE_OS_VERSION_UNDER_7_0)
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-10)-[_tableview]-(-10)-|" options:0 metrics:nil views:views]];
    else
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
}

- (void) btnSelectEndDate:(id)sender
{
    if(!_endPickView){
        
        NSDate *beginDate = _orderModel.endDate;
        
    //    NSDate *end = [self GetMinEndDate:beginDate];
        _endPickView = [[LCPickView alloc] initDatePickWithDate:beginDate datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        _endPickView.lbTitle.text = @"选择服务结束时间";
        [_endPickView SetDatePickerMin:beginDate];
        _endPickView.delegate = self;
    }
    [_endPickView show];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
//        return 93.f;
    {
        if(!self.priceCell)
            self.priceCell = [[OrderPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
        [self.priceCell setContentData:_orderModel];
        [self.priceCell setNeedsLayout];
        [self.priceCell layoutIfNeeded];
        
        CGSize size = [self.priceCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }
    else if (indexPath.section == 1){
//        return 223.f;
        if(!ordercell)
        ordercell = [[OrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        [ordercell setContentData:_orderModel];
        [ordercell setNeedsLayout];
        [ordercell layoutIfNeeded];
        
        CGSize size = [ordercell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }
    else
//        return 92.f;
    {
        if(!self.careCell){
            self.careCell = [[BeCareInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        [self.careCell setContentData:_orderModel];
        [self.careCell setNeedsLayout];
        [self.careCell layoutIfNeeded];
        
        CGSize size = [self.careCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        OrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if (indexPath.section == 1){
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        BeCareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell setContentData:_orderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableBackGroundColor;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableBackGroundColor;
    if(section == 0){
        _stepView = [[OrderStepView alloc] initWithFrame:CGRectZero];
        _stepView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:_stepView];
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_stepView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stepView)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_stepView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stepView)]];
        if(_orderModel.orderStatus == EnumOrderStatusTypeCancel){
            [_stepView SetStepViewType:StepViewType2Step];
            [_stepView SetCurrentStepWithIdx:3];//此处为3
        }else{
            [_stepView SetStepViewType:StepViewType4Step];
            [_stepView SetCurrentStepWithIdx:[self GetStepWithModel:_orderModel]];
        }
    }
    else if (section == 1){
        lbOrderNum = [[UILabel alloc] initWithFrame:CGRectZero];
        lbOrderNum.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lbOrderNum];
        lbOrderNum.textColor = _COLOR(0x66, 0x66, 0x66);
        lbOrderNum.font = _FONT(14);
        lbOrderNum.text = [NSString stringWithFormat:@"订 单 号 ：%@", _orderModel.serialNumber];
        lbOrderNum.backgroundColor = [UIColor clearColor];
        
        lbOrderTime = [[UILabel alloc] initWithFrame:CGRectZero];
        lbOrderTime.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lbOrderTime];
        lbOrderTime.textColor = _COLOR(0x66, 0x66, 0x66);
        lbOrderTime.font = _FONT(14);
        lbOrderTime.text = [NSString stringWithFormat:@"下单时间：%@", [Util StringFromDate:_orderModel.createdDate]];//@"下单时间：2015-03-19 12:46";
        lbOrderTime.backgroundColor = [UIColor clearColor];
        
        NSDictionary*views = NSDictionaryOfVariableBindings(lbOrderNum, lbOrderTime);
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbOrderNum]-20-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbOrderTime]-20-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[lbOrderNum(20)]-2-[lbOrderTime(20)]-6-|" options:0 metrics:nil views:views]];
    }
    else{
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
        lb.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lb];
        lb.textColor = _COLOR(0x66, 0x66, 0x66);
        lb.font = _FONT(14);
        lb.text = @"被陪护人信息";
        lb.backgroundColor = [UIColor clearColor];
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lb]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    }
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 85.f;
    }else if(section == 1)
        return 54.f;
    else
        return 29.f;
}

- (void) initDataForView
{
    if(_orderModel.isCanContinue == YES){
        self.NavigationBar.btnRight.hidden = NO;
    }
    else{
        self.NavigationBar.btnRight.hidden = YES;
    }
    
    if(_orderModel.serialNumber != nil)
        lbOrderNum.text = [NSString stringWithFormat:@"订 单 号 ：%@", _orderModel.serialNumber];
    if(_orderModel.createdDate != nil)
        lbOrderTime.text = [NSString stringWithFormat:@"下单时间：%@", [Util StringFromDate:_orderModel.createdDate]];//@"下单时间：2015-03-19 12:46";
    if(_orderModel.orderStatus == EnumOrderStatusTypeCancel){
        [_stepView SetStepViewType:StepViewType2Step];
        [_stepView SetCurrentStepWithIdx:3];//此处为3
    }else{
        [_stepView SetStepViewType:StepViewType4Step];
        [_stepView SetCurrentStepWithIdx:[self GetStepWithModel:_orderModel]];
    }
}

- (int) GetStepWithModel:(MyOrderdataModel *) model
{
    if(model.orderStatus == EnumOrderStatusTypeNew)
        return 1;
    else if (model.orderStatus == EnumOrderStatusTypeConfirm)
        return 2;
    else if (model.orderStatus == EnumOrderStatusTypeServing)
        return 3;
    else if (model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeNoComment)
        return 4;
    else if (model.orderStatus == EnumOrderStatusTypeFinish && model.commentStatus == EnumTypeCommented)
        return 5;
    else
        return 0;
}

- (void) NotifyButtonClickedWithFlag:(UIButton*) sender
{
    
    NSInteger flag = (sender.tag - 1);
//    0 去付款， 1 去评论
    if(flag == 0){
        PayForOrderVC *vc = [[PayForOrderVC alloc] initWithModel:_orderModel];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(flag == 1){
        EvaluateOrderVC *vc = [[EvaluateOrderVC alloc] initWithModel:_orderModel];
         vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (flag == 2){
        sender.userInteractionEnabled=false;
        __weak MyOrderdataModel *weakModel = _orderModel;
        __weak OrderDetailsVC *weakSelf = self;
            [LCNetWorkBase postWithMethod:@"api/order/cancel" Params:@{@"orderId" : _orderModel.oId, @"registerId" : [UserModel sharedUserInfo].userId} Completion:^(int code, id content) {
                if(code){
                    sender.userInteractionEnabled=true;
                    if([content isKindOfClass:[NSDictionary class]]){
                        NSString *code = [content objectForKey:@"code"];
                        if(code == nil)
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单取消成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                            
                            weakModel.orderStatus = EnumOrderStatusTypeCancel;
                            [weakSelf._tableview reloadData];
                        }
                    }
                }
            }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1001){
        if(buttonIndex == 0){
            NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
            [parmas setObject:_orderModel.oId forKey:@"orderId"];
            [parmas setObject:[Util StringFromDate:_orderModel.endDate] forKey:@"endDate"];
            [parmas setObject:_orderModel.orderCountStr forKey:@"orderCount"];
            [parmas setObject:[NSNumber numberWithFloat:_orderModel.totalPrice] forKey:@"totalPrice"];
            
            [LCNetWorkBase postWithMethod:@"api/order/continue" Params:parmas Completion:^(int code, id content) {
                if(code){
                    if([content objectForKey:@"code"] != nil){
                        [Util showAlertMessage:[content objectForKey:@"message"]];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        if(delegate && [delegate respondsToSelector:@selector(NotifyOrderCancelAndRefreshTableView:)]){
            [delegate NotifyOrderCancelAndRefreshTableView:self];
        }
    }
}


#pragma EvaluateOrderDelegate
- (void) NotifyReloadOrderInfo{
   [_tableview reloadData];
}

-(void)toobarDonBtnHaveClick:(LCPickView *)pickView resultString:(NSString *)resultString
{
    _orderModel.endDate = pickView.datePicker.date;
    _orderModel.totalPrice = [Util calcDaysFromBegin:_orderModel.beginDate end:_orderModel.endDate] * _orderModel.unitPrice;
    _orderModel.orderCount = [Util calcDaysFromBegin:_orderModel.beginDate end:_orderModel.endDate];
    _orderModel.realyTotalPrice = _orderModel.totalPrice - _orderModel.couponsAmount;
    
    if(((int)(_orderModel.orderCount * 10) % 10) > 0){
        _orderModel.orderCountStr = [NSString stringWithFormat:@"%.1f", _orderModel.orderCount];
    }else
        _orderModel.orderCountStr = [NSString stringWithFormat:@"%d", (int)_orderModel.orderCount];
    [_tableview reloadData];
}

- (void)toobarDonBtnCancel:(LCPickView *)pickView
{
    isReSetEndday = NO;
    [self.NavigationBar.btnRight setTitle:@"续单" forState:UIControlStateNormal];
}

@end
