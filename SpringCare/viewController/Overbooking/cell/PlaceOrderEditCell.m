//
//  PlaceOrderEditCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PlaceOrderEditCell.h"
#import "define.h"
#import "Util.h"


@implementation PlaceOrderEditCell
@synthesize delegate;
@synthesize businessType;

@synthesize beginDate;
@synthesize endDate;
@synthesize address;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"totalDays"];
}

- (void) NotifyPickViewHidden:(NSNotification*)notify
{
    [_pickview remove];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(delegate && [delegate respondsToSelector:@selector(NotifyValueChanged:)]){
        [delegate NotifyValueChanged:0];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.totalDays = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyPickViewHidden:) name:NOTIFY_PICKVIEW_HIDDEN object:nil];
            [self addObserver:self forKeyPath:@"totalDays" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        logo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:logo];
        logo.translatesAutoresizingMaskIntoConstraints = NO;
        logo.image = [UIImage imageNamed:@"placeordered"];
        
        lbPaytype = [self createLabelWithFont:_FONT(15) textcolor: _COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor]];
        lbPaytype.text = @"快速下单";
        
        line1 = [self createLabelWithFont:nil textcolor:nil backgroundcolor:SeparatorLineColor];
        line2 = [self createLabelWithFont:nil textcolor:nil backgroundcolor:SeparatorLineColor];
        
        businessType = [[BusinessTypeView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:businessType];
        businessType.translatesAutoresizingMaskIntoConstraints = NO;
        businessType.delegate = self;
        
        _lbUnits = [self createLabelWithFont:_FONT(14) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor]];
        _lbUnits.hidden = YES;
        
        lbUnitPrice = [self createLabelWithFont:_FONT(14) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor]];
        lbCount = [self createLabelWithFont:_FONT(14) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor]];
        lbCount.text = @"共  天";
        
        _couponsView = [[CouponsSelectView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_couponsView];
        _couponsView.translatesAutoresizingMaskIntoConstraints = NO;
        [_couponsView.control addTarget:self action:@selector(doBtnSelectCoupons:) forControlEvents:UIControlEventTouchUpInside];
        
        pricebg = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:pricebg];
        pricebg.translatesAutoresizingMaskIntoConstraints = NO;
        pricebg.backgroundColor = _COLOR(242, 248, 250);
        pricebg.layer.cornerRadius = 3;
        
        warnImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [pricebg addSubview:warnImageView];
        warnImageView.translatesAutoresizingMaskIntoConstraints = NO;
        warnImageView.image = ThemeImage(@"warningimage");
        
        lbshdx = [[UILabel alloc] initWithFrame:CGRectZero];
        [pricebg addSubview:lbshdx];
        lbshdx.translatesAutoresizingMaskIntoConstraints = NO;
        lbshdx.textColor = _COLOR(0x99, 0x99, 0x99);
        lbshdx.font = _FONT(13);
        lbshdx.numberOfLines = 0;
        lbshdx.backgroundColor = [UIColor clearColor];
        
        lbfwsc = [[UILabel alloc] initWithFrame:CGRectZero];
        [pricebg addSubview:lbfwsc];
        lbfwsc.translatesAutoresizingMaskIntoConstraints = NO;
        lbfwsc.textColor = _COLOR(0x99, 0x99, 0x99);
        lbfwsc.font = _FONT(13);
        lbfwsc.numberOfLines = 0;
        lbfwsc.backgroundColor = [UIColor clearColor];
        
        beginDate = [[OrderInfoSelectView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:beginDate];
        beginDate.translatesAutoresizingMaskIntoConstraints = NO;
        beginDate.lbTitle.text = @"请选择服务开始时间";
        beginDate.lbTitle.font = _FONT(16);
        [beginDate.logoImageView setImage:[UIImage imageNamed:@"placeorderdatestart"] forState:UIControlStateNormal];
        [beginDate.control addTarget:self action:@selector(btnSelectBeginDate:) forControlEvents:UIControlEventTouchUpInside];
        
        endDate = [[OrderInfoSelectView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:endDate];
        endDate.translatesAutoresizingMaskIntoConstraints = NO;
        endDate.lbTitle.text = @"请选择服务结束时间";
        endDate.lbTitle.font = _FONT(16);
        [endDate.logoImageView setImage:[UIImage imageNamed:@"placeorderdateend"] forState:UIControlStateNormal];
        [endDate.control addTarget:self action:@selector(btnSelectEndDate:) forControlEvents:UIControlEventTouchUpInside];
        
        address = [[OrderInfoSelectView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:address];
        address.translatesAutoresizingMaskIntoConstraints = NO;
        address.lbTitle.text = @"陪护地址";
        address.lbTitle.font = _FONT(16);
        [address.logoImageView setImage:[UIImage imageNamed:@"placeorderaddress"] forState:UIControlStateNormal];
        [address.control addTarget:self action:@selector(btnSelectAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(logo, lbPaytype, line1, businessType, lbUnitPrice, _couponsView, _lbUnits, pricebg, warnImageView, lbshdx, lbfwsc, lbCount, line2, beginDate, endDate, address);
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:logo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbPaytype attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[logo(24)]-5-[lbPaytype]-20-|" options:0 metrics:nil views:views]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[businessType]->=20-|" options:0 metrics:nil views:views]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[pricebg]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbUnitPrice]->=10-[lbCount]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lbCount attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbUnitPrice attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        Constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[lbPaytype(20)]-7-[line1(1)]-9-[businessType(32)]-10-[pricebg]-10-[lbUnitPrice(14)]-18-[line2(1)]-0-[beginDate(45)]-0-[endDate(45)]-0-[address(45)]-0-[_couponsView(45)]-0-|" options:0 metrics:nil views:views];

        [self.contentView addConstraints:Constraints];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line1]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line1)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line2]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line2)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[_couponsView]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[beginDate]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[endDate]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[address]-20-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbUnits attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:businessType attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbUnits attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:businessType attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbUnits attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:businessType attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [pricebg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[warnImageView(31)]-20-[lbshdx]-10-|" options:0 metrics:nil views:views]];
        [pricebg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[warnImageView(31)]-20-[lbfwsc]-10-|" options:0 metrics:nil views:views]];
        [pricebg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[warnImageView(34)]->=10-|" options:0 metrics:nil views:views]];
        [pricebg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[lbshdx]-10-[lbfwsc]->=10-|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (UILabel*) createLabelWithFont:(UIFont*)font textcolor:(UIColor*)color backgroundcolor:(UIColor*)bgColor
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:lb];
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    lb.textColor = color;
    lb.font = font;
    lb.backgroundColor = bgColor;
    return lb;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) btnSelectBeginDate:(id)sender
{
    if(!_pickview){
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        [mArray addObject:[self getDateArray]];
        [mArray addObject:[self getTimeArray]];
        _pickview = [[ZHPickView alloc] initPickviewWithArray:mArray isHaveNavControler:NO];
        [_pickview show];
        _pickview.delegate = self;
    }else{
        [_pickview show];
    }
}

- (void) btnSelectEndDate:(id)sender
{
    if(beginDate.value == nil)
    {
        [Util showAlertMessage:@"请先选择服务开始时间"];
        return;
    }
    if(currentPriceModel.type == 1 || currentPriceModel.type == 4 || currentPriceModel.type == 5 || currentPriceModel.type == 6 || currentPriceModel.type == 7){
        if(_endPickView)
        {
            [_endPickView remove];
        }
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        int count = 6;
        if(currentPriceModel.type == 6)
        {
            count = 3;
            NSInteger beginhour = [Util GetHourFromdate:beginDate.value];
            count = 20 - beginhour;
        }else if (currentPriceModel.type == 7 || currentPriceModel.type == 1)
        {
            count = 30;
        }
        for(int i = 0; i < count; i++){
            [dataArray addObject:[NSString stringWithFormat:@"%d %@", i + 1, currentPriceModel.typeName]];
        }
        _endPickView = [[LCPickView alloc] initPickviewWithArray:dataArray isHaveNavControler:NO];
        [_endPickView show];
        _endPickView.tag = 1001;
        _endPickView.delegate = self;
    }else{
        if(_endPickView){
            [_endPickView remove];
        }
        NSDate *end = [self GetMinEndDate:beginDate.value];
        _endPickView = [[LCPickView alloc] initDatePickWithDate:end datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        _endPickView.tag = 1002;
        [_endPickView SetDatePickerMin:end];
        [_endPickView show];
        _endPickView.delegate = self;
    }
    
}

- (NSDate *)GetMinEndDate:(NSDate *)date
{
    NSInteger unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:date];
    NSInteger hour = comps.hour;
    
    if(hour < 8){
        comps.hour = 8;
        date  = [cal dateFromComponents:comps];
    }else{
        comps.hour = 8;
        NSDate *newDate  = [cal dateFromComponents:comps];
        date = [newDate dateByAddingTimeInterval:24 * 3600];
    }
    
    return date;
}

- (void) btnSelectAddress:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(NotifyToSelectAddr)]){
        [delegate NotifyToSelectAddr];
    }
}

- (NSArray*) getTimeArray
{
    if(businessType.selectPriceModel.type == 1){
        NSArray *array = @[@"08", @"09", @"10",@"11", @"12", @"13",@"14", @"15", @"16",@"17", @"18", @"19", @"20"];
        return array;
    }else{
        NSArray *array = @[@"08", @"09", @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19", @"20"];
        return array;
    }
}

- (NSArray*) getDateArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDate *curdate = [NSDate date];
    NSInteger current = [curdate timeIntervalSince1970];
    for (int i = 0; i < TIME_LIMIT; i++) {
        NSInteger timeInterval = current + i * 24 * 60 * 60 ;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        [array addObject:date];
    }
    
    return array;
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultDate:(NSDate *)resultDate
{
    beginDate.lbTitle.font = _FONT_B(16);
    beginDate.lbTitle.text =[Util orderTimeFromDate:resultDate];
    beginDate.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
    beginDate.value= resultDate;
}

-(void)toobarDonBtnHaveClick:(LCPickView *)pickView resultString:(NSString *)resultString
{
    endDate.lbTitle.font = _FONT_B(16);
    endDate.lbTitle.text = resultString;
    endDate.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
    if(_endPickView.tag == 1001){
        lbCount.text = [NSString stringWithFormat:@"共 %@", resultString];
        self.totalDays = [resultString integerValue];
        endDate.value = resultString;
    }
    else{
        CGFloat count = [Util calcDaysFromBegin:beginDate.value end:pickView.datePicker.date];
        self.totalDays = count;
        lbCount.text = [NSString stringWithFormat:@"共 %.1f 天", count];
        endDate.value = pickView.datePicker.date;
    }
}

- (void) SetPriceList:(NSArray *)priceList
{
    OrderPriceList = priceList;
    [self.businessType setPriseList:priceList];
}

- (void) NotifyBusinessTypeChanged:(BusinessTypeView*) typeView  model:(PriceDataModel *)priceModel
{
    currentPriceModel = priceModel;
    
    lbfwsc.attributedText = [self AttributedStringFromString:[NSString stringWithFormat:@"%@%@", @"服务时长：", priceModel.fwsj] subString:@"服务时长："];
    lbshdx.attributedText = [self AttributedStringFromString:[NSString stringWithFormat:@"%@%@", @"适合对象：", priceModel.shrq] subString:@"适合对象："];
    
    NSInteger uPrice = businessType.selectPriceModel.amount;
    NSString *rangeStr = [NSString stringWithFormat:@"¥%ld", (long)uPrice];
    NSString *UnitPrice = [NSString stringWithFormat:@"单价：%@/%@", rangeStr,
                           businessType.selectPriceModel==nil?@"":businessType.selectPriceModel.typeName];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:[NSString stringWithFormat:@"¥%ld", (long)uPrice]];
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
    [string addAttribute:NSFontAttributeName value:_FONT(20) range:range];
    lbUnitPrice.attributedText = string;
    
    self.totalDays = 0;
    lbCount.text = [NSString stringWithFormat:@"共 0 %@", currentPriceModel.typeName];
    
    if(delegate && [delegate respondsToSelector:@selector(NotifyCurrentSelectPriceModel:)]){
        [delegate NotifyCurrentSelectPriceModel:currentPriceModel];
    }
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    [mArray addObject:[self getDateArray]];
    [mArray addObject:[self getTimeArray]];
    
    [_pickview setPickviewWithArray:mArray];
    
    
    if(currentPriceModel){
        if(currentPriceModel.type == 1 || currentPriceModel.type == 4 || currentPriceModel.type == 5 || currentPriceModel.type == 6 || currentPriceModel.type == 7){
            endDate.lbTitle.text = @"请选择服务数量";
            endDate.lbTitle.font = _FONT(16);
            [endDate.logoImageView setImage:[UIImage imageNamed:@"placeorderdatecount"] forState:UIControlStateNormal];
        }else{
            endDate.lbTitle.text = @"请选择服务结束时间";
            endDate.lbTitle.font = _FONT(16);
            [endDate.logoImageView setImage:[UIImage imageNamed:@"placeorderdateend"] forState:UIControlStateNormal];
        }
    }
    
}

- (void) doBtnSelectCoupons:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(NotifyTOSelectCoupons)])
        [delegate NotifyTOSelectCoupons];
}

- (NSMutableAttributedString *)AttributedStringFromString:(NSString*)string subString:(NSString *)subString
{
    NSString *UnitPrice = string;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:subString];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0x33, 0x33, 0x33) range:range];
    return attString;
}

@end
