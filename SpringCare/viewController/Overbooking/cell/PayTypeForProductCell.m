//
//  PayTypeForProductCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PayTypeForProductCell.h"
#import "define.h"
#import "PayTypeCell.h"

@implementation PayTypeForProductCell
@synthesize paytype;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableview.translatesAutoresizingMaskIntoConstraints = NO;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [self.contentView addSubview:_tableview];
        [_tableview registerClass:[PayTypeItemCell class] forCellReuseIdentifier:@"cell"];
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.scrollEnabled = NO;
        
        line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:line];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = SeparatorLineColor;
        
        NSDictionary *views = NSDictionaryOfVariableBindings( _tableview, line);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-[line(1)]-0-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2.5-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22.5-[line]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
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
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PayTypeItemCell *cell1 = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cell1._btnSelect.selected = NO;
    cell1 = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    cell1._btnSelect.selected = NO;
    cell1 = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    cell1._btnSelect.selected = NO;
    
    PayTypeItemCell *cell = (PayTypeItemCell*)[_tableview cellForRowAtIndexPath:indexPath];
    cell._btnSelect.selected = YES;
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
