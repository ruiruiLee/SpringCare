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

@implementation PlaceOrderEditForProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        businessTypeView = [[UnitsTypeView alloc] initWithFrame:CGRectZero];
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
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings( _tableview, businessTypeView, dateSelectView, lbUnitPrice, lbAmountPrice, line);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[businessTypeView(134)]->=5-[dateSelectView(130)]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbUnitPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[lbAmountPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[businessTypeView(32)]-14-[lbUnitPrice(14)]-4-[lbAmountPrice(22)]-14-[line(1)]-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
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
    return 2;
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
