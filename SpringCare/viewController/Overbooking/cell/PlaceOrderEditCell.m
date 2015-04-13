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

@implementation PlaceOrderEditItemCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _logoImageView = [[UIButton alloc] initWithFrame:CGRectZero];
        _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_logoImageView];
        _logoImageView.userInteractionEnabled = NO;
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbTitle];
        _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _lbTitle.font = _FONT(14);
        _lbTitle.textColor = _COLOR(0x99, 0x99, 0x99);
        
        _unfoldStaus = [self createImageViewWithimageName:@"usercentershutgray"];
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.backgroundColor = SeparatorLineColor;
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_logoImageView, _lbTitle, _unfoldStaus, _line);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_logoImageView(35)]-20-[_lbTitle]->=10-[_unfoldStaus]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbTitle(20)]->=0-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_unfoldStaus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_line]-0-|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (UIImageView*) createImageViewWithimageName:(NSString*) name
{
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imagev];
    imagev.translatesAutoresizingMaskIntoConstraints = NO;
    imagev.image = [UIImage imageNamed:name];
    return imagev;
}

@end

@implementation PlaceOrderEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:logo];
        logo.translatesAutoresizingMaskIntoConstraints = NO;
        logo.image = [UIImage imageNamed:@"placeordered"];
        
        UILabel *lbPaytype = [self createLabelWithFont:_FONT(15) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor]];
        lbPaytype.text = @"我要下单";
        
        UILabel *line1 = [self createLabelWithFont:nil textcolor:nil backgroundcolor:SeparatorLineColor];
        
        businessTypeView = [[BusinessTypeView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:businessTypeView];
        businessTypeView.translatesAutoresizingMaskIntoConstraints = NO;
        
        dateSelectView = [[DateCountSelectView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:dateSelectView];
        dateSelectView.translatesAutoresizingMaskIntoConstraints = NO;
        
        lbUnitPrice = [self createLabelWithFont:_FONT(14) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor]];
        NSString *UnitPrice = @"单价：¥300.00（24h） x 1天";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
        NSRange range = [UnitPrice rangeOfString:@"¥300.00"];
        [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
        lbUnitPrice.attributedText = string;
        
        lbAmountPrice = [self createLabelWithFont:_FONT(14) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor]];
        NSString *AmountPrice = @"总价：¥300.00";
        string = [[NSMutableAttributedString alloc]initWithString:AmountPrice];
        range = [UnitPrice rangeOfString:@"¥300.00"];
        [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
        [string addAttribute:NSFontAttributeName value:_FONT(20) range:range];
        lbAmountPrice.attributedText = string;
        
        line = [self createLabelWithFont:nil textcolor:nil backgroundcolor:SeparatorLineColor];
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableview.translatesAutoresizingMaskIntoConstraints = NO;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [self.contentView addSubview:_tableview];
        [_tableview registerClass:[PlaceOrderEditItemCell class] forCellReuseIdentifier:@"cell"];
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.scrollEnabled = NO;
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(logo, lbPaytype, _tableview, line1, businessTypeView, dateSelectView, lbUnitPrice, lbAmountPrice, line);
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:logo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbPaytype attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[logo(24)]-5-[lbPaytype]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[businessTypeView(134)]->=5-[dateSelectView(130)]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbUnitPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbAmountPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[lbPaytype(20)]-7-[line1(1)]-9-[businessTypeView(32)]-14-[lbUnitPrice(14)]-4-[lbAmountPrice(22)]-14-[line(1)]-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line1]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line1)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[_tableview]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:dateSelectView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:businessTypeView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        [mArray addObject:[self getDateArray]];
        [mArray addObject:[self getTimeArray]];
        
        _pickview = [[ZHPickView alloc] initPickviewWithArray:mArray isHaveNavControler:NO];
        [_pickview show];
        _pickview.delegate = self;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceOrderEditItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0){
        cell.lbTitle.text = @"请选择服务开始日期";
        cell.lbTitle.font = _FONT(18);
        [cell.logoImageView setImage:[UIImage imageNamed:@"placeorderdatestart"] forState:UIControlStateNormal];
    }
    else{
        cell.lbTitle.text = @"陪护地址";
        cell.lbTitle.font = _FONT(15);
        [cell.logoImageView setImage:[UIImage imageNamed:@"placeorderaddress"] forState:UIControlStateNormal];
    }

    return cell;
}

- (NSArray*) getTimeArray
{
    NSArray *array = @[@"08", @"09", @"10", @"20", @"21", @"22"];
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

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultDate:(NSDate *)resultDate
{
    PlaceOrderEditItemCell *cell = (PlaceOrderEditItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.lbTitle.text = [NSString stringWithFormat:@"服务开始时间：%@", [Util StringFromDate:resultDate]];
}

@end
