//
//  CouponsListCell.m
//  SpringCare
//
//  Created by LiuZach on 15/5/27.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CouponsListCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation CouponsListCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.cellType = EnumCouponCellTypeNormal;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        couponBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:couponBg];
        couponBg.translatesAutoresizingMaskIntoConstraints = NO;
        couponBg.image = ThemeImage(@"selectcouponsbg");
        couponBg.clipsToBounds = YES;
        couponBg.contentMode = UIViewContentModeScaleAspectFit;
        
        _leftBg = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_leftBg];
        _leftBg.translatesAutoresizingMaskIntoConstraints = NO;
//        _leftBg.backgroundColor = [UIColor redColor];
        _leftBg.clipsToBounds = YES;
        
        _view3 = [[UIView alloc] initWithFrame:CGRectZero];
        [_leftBg addSubview:_view3];
        _view3.translatesAutoresizingMaskIntoConstraints = NO;
        
        _view4 = [[UIView alloc] initWithFrame:CGRectZero];
        [_leftBg addSubview:_view4];
        _view4.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_leftBg addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.backgroundColor = [UIColor clearColor];
        _lbName.font = _FONT(13);
        _lbName.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _lbRMB = [[UILabel alloc] initWithFrame:CGRectZero];
        [_leftBg addSubview:_lbRMB];
        _lbRMB.translatesAutoresizingMaskIntoConstraints = NO;
        _lbRMB.backgroundColor = [UIColor clearColor];
        _lbRMB.font = _FONT(20);
        _lbRMB.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbRMB.text = @"¥";
        
        _lbValue = [[UILabel alloc] initWithFrame:CGRectZero];
        [_leftBg addSubview:_lbValue];
        _lbValue.translatesAutoresizingMaskIntoConstraints = NO;
        _lbValue.backgroundColor = [UIColor clearColor];
        _lbValue.font = _FONT(40);
        _lbValue.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _rightBg = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_rightBg];
        _rightBg.translatesAutoresizingMaskIntoConstraints = NO;
        _rightBg.clipsToBounds = YES;
        
        _lbEndTimeTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_rightBg addSubview:_lbEndTimeTitle];
        _lbEndTimeTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _lbEndTimeTitle.backgroundColor = [UIColor clearColor];
        _lbEndTimeTitle.font = _FONT(13);
        _lbEndTimeTitle.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _lbStatus = [[UILabel alloc] initWithFrame:CGRectZero];
        [_rightBg addSubview:_lbStatus];
        _lbStatus.translatesAutoresizingMaskIntoConstraints = NO;
        _lbStatus.backgroundColor = [UIColor clearColor];
        _lbStatus.font = _FONT(13);
        _lbStatus.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _lbEndTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [_rightBg addSubview:_lbEndTime];
        _lbEndTime.translatesAutoresizingMaskIntoConstraints = NO;
        _lbEndTime.backgroundColor = [UIColor clearColor];
        _lbEndTime.font = _FONT(13);
        _lbEndTime.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _view1 = [[UIView alloc] initWithFrame:CGRectZero];
        [_rightBg addSubview:_view1];
        _view1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _view2 = [[UIView alloc] initWithFrame:CGRectZero];
        [_rightBg addSubview:_view2];
        _view2.translatesAutoresizingMaskIntoConstraints = NO;
        
        selectImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_rightBg addSubview:selectImageView];
        selectImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(couponBg, _lbName, _lbRMB, _lbValue, _lbEndTimeTitle, _lbEndTime, _rightBg, _view1, _view2, _view3, _view4, _leftBg, selectImageView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[couponBg]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[couponBg]-0-|" options:0 metrics:nil views:views]];
        
        [_leftBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_lbName]-20-|" options:0 metrics:nil views:views]];
        [_leftBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_lbName]-0-[_view3]-0-[_lbValue]-0-[_view4]-0-|" options:0 metrics:nil views:views]];
        [_leftBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_lbRMB]-6-[_lbValue]->=20-|" options:0 metrics:nil views:views]];
        [_leftBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbRMB attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_lbValue attribute:NSLayoutAttributeBottom multiplier:1 constant:-6]];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view1]-0-[_lbEndTimeTitle]-0-[_lbEndTime]-0-[_view2]-0-|" options:0 metrics:nil views:views];
        [_rightBg addConstraints:constraints];
        
        EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
        if(type == EnumValueTypeiPhone4S || type == EnumValueTypeiPhone5){
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_leftBg(211)]-0-[_rightBg]-8-|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_rightBg]-7-|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_leftBg]-7-|" options:0 metrics:nil views:views]];
            
            [_rightBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbEndTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:17]];
        }
        else if (type == EnumValueTypeiPhone6){
            _lbName.font = _FONT(15);
            _lbRMB.font = _FONT(22);
            _lbValue.font = _FONT(44);
            _lbEndTimeTitle.font = _FONT(15);
            _lbStatus.font = _FONT(15);
            _lbEndTime.font = _FONT(15);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_leftBg(235)]-0-[_rightBg]-8-|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-18-[_rightBg]-7-|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-18-[_leftBg]-7-|" options:0 metrics:nil views:views]];
            [_rightBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbEndTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:16]];
        }else if(type == EnumValueTypeiPhone6P){
            _lbName.font = _FONT(16);
            _lbRMB.font = _FONT(26);
            _lbValue.font = _FONT(52);
            _lbEndTimeTitle.font = _FONT(16);
            _lbStatus.font = _FONT(16);
            _lbEndTime.font = _FONT(16);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-26-[_leftBg(258)]-0-[_rightBg]-8-|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_rightBg]-7-|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_leftBg]-7-|" options:0 metrics:nil views:views]];
            [_rightBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbEndTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:18]];
        }
        
        [_rightBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbStatus attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_rightBg attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [_rightBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbEndTimeTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_rightBg attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [_rightBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbEndTime attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_rightBg attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [_rightBg addConstraint:[NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [_leftBg addConstraint:[NSLayoutConstraint constraintWithItem:_view3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view4 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        [_rightBg addConstraint:[NSLayoutConstraint constraintWithItem:selectImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_rightBg attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) SetContentWithModel:(CouponsDataModel *)model
{
    [_rightBg removeConstraints:constraints];
    NSDictionary *views = NSDictionaryOfVariableBindings(couponBg, _lbName, _lbRMB, _lbValue, _lbEndTimeTitle, _lbEndTime, _rightBg, _view1, _view2, _view3, _view4, _leftBg, selectImageView);
    
    if(model.type == EnumCouponTypeNotUse){
        couponBg.image = ThemeImage(@"normalcouponsbg");
        _lbName.textColor = Abled_Color;
        _lbValue.textColor = Abled_Color;
        _lbRMB.textColor = Abled_Color;
        _lbEndTimeTitle.textColor = Abled_Color;
        _lbEndTime.textColor = Abled_Color;
        
        if(self.cellType == EnumCouponCellTypeNormal){
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view1]-0-[_lbEndTimeTitle]-0-[_lbEndTime]-0-[_view2]-0-|" options:0 metrics:nil views:views];
        }
        else
        {
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view1]-0-[selectImageView]-0-[_lbEndTimeTitle]-0-[_lbEndTime]-0-[_view2]-0-|" options:0 metrics:nil views:views];
        }
        
        _lbName.text = model.name;
        _lbValue.text = [NSString stringWithFormat:@"%d", model.amount];
        _lbEndTimeTitle.text = @"有效期至";
        _lbEndTime.text = model.endDate;
        _lbStatus.text = @"";
//        _lbEndTime.hidden = NO;
    }
    else{
        couponBg.image = ThemeImage(@"selectcouponsbg");
        _lbName.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbValue.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbRMB.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbEndTimeTitle.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbEndTime.textColor = _COLOR(0x99, 0x99, 0x99);
        
//        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view1]-0-[_lbEndTimeTitle]-0-[_view2]-0-|" options:0 metrics:nil views:views];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view1]-0-[_lbEndTimeTitle]-0-[_lbEndTime]-0-[_view2]-0-|" options:0 metrics:nil views:views];
        
        _lbName.text = model.name;
        _lbValue.text = [NSString stringWithFormat:@"%d", model.amount];
        NSString *title = @"";
        if(model.type == EnumCouponTypeUsed){
            title = @"已使用";
        }
        else if (model.type == EnumCouponTypeDisable){
            title = @"已作废";
        }
        else if (model.type == EnumCouponTypeExpire){
            title = @"已过期";
        }
//        _lbEndTimeTitle.text = title;
        _lbEndTimeTitle.text = @"有效期至";
        _lbStatus.text = title;
        _lbEndTime.text = model.endDate;
//        _lbEndTime.hidden = YES;
    }
    
    [_rightBg addConstraints:constraints];
}

- (void) SetCellSelected:(BOOL) flag
{
    if(flag)
        selectImageView.image = ThemeImage(@"paytypeselected");
    else
        selectImageView.image = ThemeImage(@"paytypenoselect");
}

@end
