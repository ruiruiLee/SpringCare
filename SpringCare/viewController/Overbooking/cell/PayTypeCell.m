//
//  PayTypeCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PayTypeCell.h"
#import "define.h"
#import "PlaceOrderVC.h"

@implementation PayTypeItemCell
@synthesize _btnSelect = _btnSelect;
@synthesize _logoImage = _logoImage;
@synthesize _payName = _payName;
@synthesize _line = _line;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _logoImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_logoImage];
        
        _payName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_payName];
        _payName.translatesAutoresizingMaskIntoConstraints = NO;
        _payName.font = _FONT(14);
        _payName.textColor = _COLOR(0x22, 0x22, 0x22);
        _payName.backgroundColor = [UIColor clearColor];
        
        _btnSelect = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnSelect];
        _btnSelect.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnSelect setImage:[UIImage imageNamed:@"paytypenoselect"] forState:UIControlStateNormal];
        [_btnSelect setImage:[UIImage imageNamed:@"paytypeselected"] forState:UIControlStateSelected];
        _btnSelect.userInteractionEnabled = NO;
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.backgroundColor = SeparatorLineColor;
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_logoImage, _payName, _btnSelect, _line);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_logoImage(49)]-10-[_payName]->=10-[_btnSelect]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_payName(20)]->=0-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnSelect attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_logoImage(49)]-10-[_line]-20-|" options:0 metrics:nil views:views]];
    }
    return self;
}

@end

@implementation PayTypeCell
@synthesize paytype;

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
        logo.image = [UIImage imageNamed:@"paytype"];
        
        UILabel *lbPaytype = [self createLabelWithFont:_FONT(18) textcolor:_COLOR(0x66, 0x66, 0x66) backgroundcolor:[UIColor clearColor]];
        lbPaytype.text = @"付款方式";
        
        UILabel *line1 = [self createLabelWithFont:nil textcolor:nil backgroundcolor:SeparatorLineColor];
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableview.translatesAutoresizingMaskIntoConstraints = NO;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [self.contentView addSubview:_tableview];
        [_tableview registerClass:[PayTypeItemCell class] forCellReuseIdentifier:@"cell"];
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.scrollEnabled = NO;
        
        line = [self createLabelWithFont:nil textcolor:nil backgroundcolor:SeparatorLineColor];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(logo, lbPaytype, _tableview, line, line1);
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:logo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbPaytype attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[logo(14)]-5-[lbPaytype]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[lbPaytype(20)]-7-[line1(1)]-0-[_tableview]-0-[line(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line1]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line1)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
        
        [self setPaytype:EnumTypeAfter];
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
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    PlaceOrderVC *vc= (PlaceOrderVC*)self.parentController;

    if(indexPath.row == 0){
        [self setPaytype:EnumTypeAfter];
        vc.payValue=nil;
    }
    else if (indexPath.row == 1){
        [self setPaytype:EnumTypeAlipay];
         vc.payValue=@"alipay";
    }
    else{
        [self setPaytype:EnumTypeWechat];
         vc.payValue=@"wx";
    }
    
    [_tableview reloadData];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTypeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell._line.hidden = NO;
    if(indexPath.row == 0)
    {
        cell._logoImage.image = [UIImage imageNamed:@"normalpaylogo"];
        cell._payName.text = @"服务后支付";
    }
    else if (indexPath.row == 1){
        cell._logoImage.image = [UIImage imageNamed:@"alipaylogo"];
        cell._payName.text = @"支付宝支付";
    }
    else if (indexPath.row == 2){
        cell._logoImage.image = [UIImage imageNamed:@"wechatlogo"];
        cell._payName.text = @"微信支付";
        cell._line.hidden = YES;
    }
    
    if(paytype == EnumTypeAfter){
        if(indexPath.row == 0)
            cell._btnSelect.selected = YES;
    }
    else if(paytype == EnumTypeAlipay){
        if(indexPath.row == 1)
            cell._btnSelect.selected = YES;
    }
    else if(paytype == EnumTypeWechat){
        if(indexPath.row == 2)
            cell._btnSelect.selected = YES;
    }
    
    return cell;
}

- (void) setPaytype:(PayType)_paytype
{
    [self resetCell];
    
    paytype = _paytype;
    
    if(_paytype == EnumTypeAfter){
        PayTypeItemCell *cell = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell._btnSelect.selected = YES;
    }
    else if(_paytype == EnumTypeAlipay){
        PayTypeItemCell *cell = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell._btnSelect.selected = YES;
    }
    else if(_paytype == EnumTypeWechat){
        PayTypeItemCell *cell = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell._btnSelect.selected = YES;
    }
}

- (void) resetCell
{
    PayTypeItemCell *cell = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell._btnSelect.selected = NO;
    cell = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell._btnSelect.selected = NO;
    cell = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell._btnSelect.selected = NO;
}

@end
