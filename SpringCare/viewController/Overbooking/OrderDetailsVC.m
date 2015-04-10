//
//  OrderDetailsVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "UIImageView+WebCache.h"

@implementation OrderPriceCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbPrice.font = _FONT(15);
        _lbPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbPrice];
        _lbPrice.text = @"单价：¥380.00（24h）X 3天";
        
        _lbTotalPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTotalPrice.font = _FONT(15);
        _lbTotalPrice.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbTotalPrice.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbTotalPrice];
        _lbTotalPrice.text = @"总价：¥1140.00";
        
        _lbStatus = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbStatus.font = _FONT(18);
        _lbStatus.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbStatus.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lbStatus];
        _lbStatus.text = @"已付款";
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbPrice, _lbTotalPrice, _lbStatus);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbPrice]->=20-[_lbStatus]-43-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbTotalPrice]->=20-[_lbStatus]-43-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbPrice(20)]-5-[_lbTotalPrice(20)]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbStatus attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

@end

@implementation OrderInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imgPhoto];
        [_imgPhoto sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(18);
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.text = @"王莹莹";
        
        _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnInfo];
        _btnInfo.titleLabel.font = _FONT(14);
        [_btnInfo setImage:[UIImage imageNamed:@"nurselistcert"] forState:UIControlStateNormal];
        [_btnInfo setTitle:@"四川人" forState:UIControlStateNormal];
        [_btnInfo setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbIntro = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbIntro];
        _lbIntro.translatesAutoresizingMaskIntoConstraints = NO;
        _lbIntro.numberOfLines = 0;
        _lbIntro.font = _FONT(13);
        _lbIntro.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbIntro.text = @"我公司的分公司的风格上的分公司的风格分公司的风格分公司的风格我公司的分公司的风格上的分公司的风格分公司的风格分公司的风格";
        _lbIntro.preferredMaxLayoutWidth = ScreenWidth - 132;
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = SeparatorLineColor;
        [self.contentView addSubview:_line];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbType = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbType];
        _lbType.translatesAutoresizingMaskIntoConstraints = NO;
        _lbType.font = _FONT(15);
        _lbType.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbType.text = @"类型：医院陪护";
        
        _lbDetailTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbDetailTime];
        _lbDetailTime.translatesAutoresizingMaskIntoConstraints = NO;
        _lbDetailTime.font = _FONT(15);
        _lbDetailTime.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbDetailTime.text = @"时间：3天（2015.03.19-2015.03.21）";
        
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbPrice];
        _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
        _lbPrice.font = _FONT(18);
        _lbPrice.textColor = _COLOR(0xf1, 0x13, 0x59);
        _lbPrice.text = @"单价：380元/24小时";
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbType, _lbPrice, _lbName, _lbIntro, _lbDetailTime, _line, _btnInfo, _imgPhoto);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_line]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbDetailTime]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbPrice]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[_lbType]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_lbName]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_btnInfo]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgPhoto(82)]-20-[_lbIntro]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_imgPhoto(82)]-16-[_line(1)]-16-[_lbType(20)]-12-[_lbDetailTime(20)]-12-[_lbPrice(20)]-12-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-18-[_lbName(20)]-3-[_btnInfo(20)]-1-[_lbIntro]->=0-[_line(1)]->=0-|" options:0 metrics:nil views:views]];
    }
    return self;
}

@end

@implementation BeCareInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgPhoto];
        _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        [_imgPhoto sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbName];
        _lbName.translatesAutoresizingMaskIntoConstraints = NO;
        _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbName.font = _FONT(15);
        _lbName.text = @"张发财";
        _lbName.textAlignment = NSTextAlignmentCenter;
        
        _LbRelation = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_LbRelation];
        _LbRelation.translatesAutoresizingMaskIntoConstraints = NO;
        _LbRelation.textColor = _COLOR(0x22, 0x22, 0x22);
        _LbRelation.font = _FONT(18);
        _LbRelation.text = @"父亲";
        
        _lbAge = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbAge];
        _lbAge.translatesAutoresizingMaskIntoConstraints = NO;
        _lbAge.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbAge.font = _FONT(15);
        _lbAge.text = @"72岁";
        
        _btnMobile = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnMobile];
        _btnMobile.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnMobile setImage:[UIImage imageNamed:@"orderdetailtel"] forState:UIControlStateNormal];
        [_btnMobile setTitle:@"13980092751" forState:UIControlStateNormal];
        [_btnMobile setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnMobile.titleLabel.font = _FONT(15);
        
        _btnAddress = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_btnAddress];
        _btnAddress.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnAddress setImage:[UIImage imageNamed:@"orderdetailaddr"] forState:UIControlStateNormal];
        [_btnAddress setTitle:@"四川省成都市三槐树街" forState:UIControlStateNormal];
        [_btnAddress setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _btnAddress.titleLabel.font = _FONT(15);
        
        _imgSex = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgSex];
        _imgSex.translatesAutoresizingMaskIntoConstraints = NO;
        _imgSex.image = [UIImage imageNamed:@"mail"];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imgPhoto, _lbName, _LbRelation, _lbAge, _btnMobile, _btnAddress, _imgSex);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_LbRelation]-10-[_imgSex]-10-[_lbAge]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_btnMobile]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imgPhoto(62)]-20-[_btnAddress]->=20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_imgPhoto(62)]-10-[_lbName(20)]->=0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_LbRelation(20)]-10-[_btnMobile(20)]-10-[_btnAddress(20)]->=0-|" options:0 metrics:nil views:views]];
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgSex attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_LbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbAge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_LbRelation attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnAddress attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_imgPhoto attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    return self;
}

@end


@interface OrderDetailsVC ()

@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"订单详情";
    
    [self initSubviews];
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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
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
        return 85.f;
    else if (indexPath.section == 1)
        return 223.f;
    else
        return 120.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        OrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 1){
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        return cell;
    }else{
        BeCareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
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
    }
    else if (section == 1){
        lbOrderNum = [[UILabel alloc] initWithFrame:CGRectZero];
        lbOrderNum.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lbOrderNum];
        lbOrderNum.textColor = _COLOR(0x66, 0x66, 0x66);
        lbOrderNum.font = _FONT(14);
        lbOrderNum.text = @"订 单 号 ：BXV3496800035464";
        
        lbOrderTime = [[UILabel alloc] initWithFrame:CGRectZero];
        lbOrderTime.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lbOrderTime];
        lbOrderTime.textColor = _COLOR(0x66, 0x66, 0x66);
        lbOrderTime.font = _FONT(14);
        lbOrderTime.text = @"下单时间：2015-03-19 12:46";
        
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
        lb.text = @"被保护人信息";
        
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

@end
