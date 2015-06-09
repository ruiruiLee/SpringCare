//
//  PlaceOrderEditForProductCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PlaceOrderEditForProductCell.h"
#import "define.h"
#import "PlaceOrderEditCell.h"
#import "Util.h"

@implementation PlaceOrderEditForProductCell
@synthesize delegate;
@synthesize _tableview;
@synthesize businessType = businessType;
@synthesize dateSelectView;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) NotifyPickViewHidden:(NSNotification*)notify
{
    [_pickview remove];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyPickViewHidden:) name:NOTIFY_PICKVIEW_HIDDEN object:nil];
        
        businessType = [[BusinessTypeView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:businessType];
        businessType.translatesAutoresizingMaskIntoConstraints = NO;
        businessType.delegate = self;
        
        dateSelectView = [[DateCountSelectView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:dateSelectView];
        dateSelectView.translatesAutoresizingMaskIntoConstraints = NO;
        dateSelectView.delegate = self;
        
        lbUnitPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:lbUnitPrice];
        lbUnitPrice.translatesAutoresizingMaskIntoConstraints = NO;
        lbUnitPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        lbUnitPrice.font = _FONT(14);
        NSString *UnitPrice = @"单价：¥300.00（24h） x 1天";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
        NSRange range = [UnitPrice rangeOfString:@"¥300.00"];
        [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
        lbUnitPrice.attributedText = string;
        lbUnitPrice.backgroundColor = [UIColor clearColor];
        
        _lbUnits = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbUnits];
        _lbUnits.translatesAutoresizingMaskIntoConstraints = NO;
        _lbUnits.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbUnits.font = _FONT(14);
        _lbUnits.backgroundColor = [UIColor clearColor];
        _lbUnits.hidden = YES;
        
        lbOrderUnit = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:lbOrderUnit];
        lbOrderUnit.translatesAutoresizingMaskIntoConstraints = NO;
        lbOrderUnit.textColor = _COLOR(0x99, 0x99, 0x99);
        lbOrderUnit.font = _FONT(14);
        lbOrderUnit.backgroundColor = [UIColor clearColor];
        lbOrderUnit.text = @"单位：";
        
        lbNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:lbNumber];
        lbNumber.translatesAutoresizingMaskIntoConstraints = NO;
        lbNumber.textColor = _COLOR(0x99, 0x99, 0x99);
        lbNumber.font = _FONT(14);
        lbNumber.backgroundColor = [UIColor clearColor];
        lbNumber.text = @"数量：";
        
        lbAmountPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:lbAmountPrice];
        lbAmountPrice.translatesAutoresizingMaskIntoConstraints = NO;
        lbAmountPrice.font = _FONT(14);
        lbAmountPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        NSString *AmountPrice = @"总价：¥300.00";
        string = [[NSMutableAttributedString alloc]initWithString:AmountPrice];
        range = [UnitPrice rangeOfString:@"¥300.00"];
        [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
        [string addAttribute:NSFontAttributeName value:_FONT(20) range:range];
        lbAmountPrice.attributedText = string;
        lbAmountPrice.backgroundColor = [UIColor clearColor];
        
//        line = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:line];
//        line.translatesAutoresizingMaskIntoConstraints = NO;
//        line.backgroundColor = SeparatorLineColor;
        
//        sepline = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:sepline];
//        sepline.translatesAutoresizingMaskIntoConstraints = NO;
//        sepline.backgroundColor = SeparatorLineColor;
        
        _couponsView = [[CouponsSelectView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_couponsView];
        _couponsView.translatesAutoresizingMaskIntoConstraints = NO;
        [_couponsView.control addTarget:self action:@selector(doBtnSelectCoupons:) forControlEvents:UIControlEventTouchUpInside];
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableview.translatesAutoresizingMaskIntoConstraints = NO;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [self.contentView addSubview:_tableview];
        [_tableview registerClass:[PlaceOrderEditItemCell class] forCellReuseIdentifier:@"cell"];
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.scrollEnabled = NO;
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings( _tableview, businessType, dateSelectView, lbUnitPrice, lbAmountPrice, _couponsView, lbNumber, lbOrderUnit);
        
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[businessType(134)]->=5-[dateSelectView(130)]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbOrderUnit(42)]-0-[businessType]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbNumber(42)]-0-[dateSelectView(130)]->=20-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbUnitPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbAmountPrice]-20-|" options:0 metrics:nil views:views]];
//        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[businessType(32)]-10-[dateSelectView(32)]-14-[sepline(1)]-10-[lbUnitPrice(14)]-4-[lbAmountPrice(22)]-14-[line(1)]-0-[_couponsView(45)]-0-[_tableview]-0-|" options:0 metrics:nil views:views];
         hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[dateSelectView(32)]-10-[lbUnitPrice(14)]-6-[lbAmountPrice(22)]-6-[_couponsView(45)]-0-[_tableview]-0-|" options:0 metrics:nil views:views];
        
        [self.contentView addConstraints:hConstraints];
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[sepline]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sepline)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[_tableview]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[_couponsView]-20-|" options:0 metrics:nil views:views]];
        
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:dateSelectView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:businessType attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lbOrderUnit attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:businessType attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lbNumber attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:dateSelectView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbUnits attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:businessType attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbUnits attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:businessType attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbUnits attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:businessType attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0){
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
    }else{
        if(delegate && [delegate respondsToSelector:@selector(NotifyToSelectAddr)]){
            [delegate NotifyToSelectAddr];
        }
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceOrderEditItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0){
        cell.lbTitle.text = @"请选择服务开始时间";
        cell.lbTitle.font = _FONT(16);
        [cell.logoImageView setImage:[UIImage imageNamed:@"placeorderdatestart"] forState:UIControlStateNormal];
    }
    else{
        cell.lbTitle.text = @"陪护地址";
        cell.lbTitle.font = _FONT(16);
        [cell.logoImageView setImage:[UIImage imageNamed:@"placeorderaddress"] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultDate:(NSDate *)resultDate
{
    PlaceOrderEditItemCell *cell = (PlaceOrderEditItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.lbTitle.text =[Util orderTimeFromDate:resultDate];
    cell.lbTitle.font = _FONT_B(16);
    cell.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
}

- (NSArray*) getTimeArray
{
    NSArray *array = @[@"08", @"09", @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19", @"20", @"21", @"22"];
    return array;
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

//- (void) NotifyUnitsTypeChanged:(BusinessTypeView*) view  model:(PriceDataModel *)priceModel
- (void) NotifyBusinessTypeChanged:(BusinessTypeView*) typeView  model:(PriceDataModel *)priceModel
{
    [self setNurseListInfo:_nurseData];
}

- (void) NotifyDateCountChanged:(DateCountSelectView*) view
{
    [self setNurseListInfo:_nurseData];
}

- (void) setNurseListInfo:(FamilyProductModel*) model
{
    _nurseData = model;
    NSInteger count = [dateSelectView getDays];
    NSInteger uPrice = businessType.selectPriceModel.amount;
    NSString *text =  businessType.selectPriceModel==nil?@"":businessType.selectPriceModel.name;
    
    
    NSString *rangeStr = [NSString stringWithFormat:@"¥%ld", (long)uPrice];
    NSString *UnitPrice = [NSString stringWithFormat:@"单价：%@ x %ld%@", rangeStr, count, text];//@"单价：¥300.00（24h） x 1天";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:[NSString stringWithFormat:@"¥%ld", uPrice]];
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
    lbUnitPrice.attributedText = string;
    
    rangeStr = [NSString stringWithFormat:@"¥%ld", uPrice * count];
    NSString *AmountPrice = [NSString stringWithFormat:@"总价：%@", rangeStr];
    string = [[NSMutableAttributedString alloc]initWithString:AmountPrice];
    range = [AmountPrice rangeOfString:rangeStr];
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
    [string addAttribute:NSFontAttributeName value:_FONT(20) range:range];
    lbAmountPrice.attributedText = string;
    
    _couponsView.lbCounponsCount.text = [NSString stringWithFormat:@" %ld张可用 ", (long)[UserModel sharedUserInfo].couponsCount];
    
    NSDictionary *views = NSDictionaryOfVariableBindings( _tableview, businessType, dateSelectView, lbUnitPrice, lbAmountPrice, _couponsView);
    [self.contentView removeConstraints:hConstraints];
    if([model.priceList count] > 1){
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[businessType(32)]-10-[dateSelectView(32)]-10-[lbUnitPrice(14)]-6-[lbAmountPrice(22)]-6-[_couponsView(45)]-0-[_tableview]-0-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:hConstraints];
        businessType.hidden = NO;
        lbOrderUnit.hidden = NO;
    }
    else{
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[dateSelectView(32)]-10-[lbUnitPrice(14)]-6-[lbAmountPrice(22)]-6-[_couponsView(45)]-0-[_tableview]-0-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:hConstraints];
        businessType.hidden = YES;
        lbOrderUnit.hidden = YES;
    }

    
    if(delegate && [delegate respondsToSelector:@selector(NotifyValueChanged:)]){
        [delegate NotifyValueChanged:uPrice * count];
    }
}

- (void) doBtnSelectCoupons:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(NotifyTOSelectCoupons)])
        [delegate NotifyTOSelectCoupons];
}

@end
