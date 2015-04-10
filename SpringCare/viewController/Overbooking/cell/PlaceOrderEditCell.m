//
//  PlaceOrderEditCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PlaceOrderEditCell.h"
#import "define.h"

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
        
        _unfoldStaus = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_unfoldStaus];
        _unfoldStaus.translatesAutoresizingMaskIntoConstraints = NO;
        _unfoldStaus.image = [UIImage imageNamed:@"usercentershutgray"];
        //        _btnSelect.selected = YES;
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.backgroundColor = SeparatorLineColor;
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_logoImageView, _lbTitle, _unfoldStaus, _line);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_logoImageView(35)]-20-[_lbTitle]->=10-[_unfoldStaus]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbTitle(20)]->=0-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_unfoldStaus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_line]-0-|" options:0 metrics:nil views:views]];
    }
    return self;
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
        
        UILabel *lbPaytype = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:lbPaytype];
        lbPaytype.translatesAutoresizingMaskIntoConstraints = NO;
        lbPaytype.font = _FONT(15);
        lbPaytype.textColor = _COLOR(0x99, 0x99, 0x99);
        lbPaytype.text = @"我要下单";
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:line1];
        line1.translatesAutoresizingMaskIntoConstraints = NO;
        line1.backgroundColor = SeparatorLineColor;
        
        businessTypeView = [[BusinessTypeView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:businessTypeView];
        businessTypeView.translatesAutoresizingMaskIntoConstraints = NO;
        
        dateSelectView = [[DateCountSelectView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:dateSelectView];
        dateSelectView.translatesAutoresizingMaskIntoConstraints = NO;
        
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
        
        line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:line];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = SeparatorLineColor;
        
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
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[lbPaytype(20)]-7-[line1(1)]-9-[businessTypeView(38)]-14-[lbUnitPrice(14)]-4-[lbAmountPrice(22)]-14-[line(1)]-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line1]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line1)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[_tableview]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:dateSelectView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:businessTypeView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end