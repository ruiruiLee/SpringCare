//
//  PayForOrderVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PayForOrderVC.h"
#import "PayTypeCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@interface PayForOrderVC ()

@end

@implementation PayForOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"付 款";
    
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 293)];
    headerView.backgroundColor = TableSectionBackgroundColor;
    
    _nurseInfoBg = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_nurseInfoBg];
    _nurseInfoBg.translatesAutoresizingMaskIntoConstraints = NO;
    _nurseInfoBg.layer.borderWidth = 0.76;
    _nurseInfoBg.layer.borderColor = SeparatorLineColor.CGColor;
    _nurseInfoBg.backgroundColor = TableBackGroundColor;
    
    //sub
    _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgPhoto.translatesAutoresizingMaskIntoConstraints = NO;
    [_nurseInfoBg addSubview:_imgPhoto];
    [_imgPhoto sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"nurselistfemale"]];
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_nurseInfoBg addSubview:_lbName];
    _lbName.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbName.font = _FONT(15);
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.text = @"家庭陪护-王莹莹";
    
    _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [_nurseInfoBg addSubview:_lbPrice];
    _lbPrice.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbPrice.translatesAutoresizingMaskIntoConstraints = NO;
    _lbPrice.font = _FONT(13);
    _lbPrice.text = @"¥150/12 X 3天";
    
    _imgDayTime = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_nurseInfoBg addSubview:_imgDayTime];
    _imgDayTime.translatesAutoresizingMaskIntoConstraints = NO;
    _imgDayTime.image = [UIImage imageNamed:@"daytime"];
    
    _imgNight = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_nurseInfoBg addSubview:_imgNight];
    _imgNight.translatesAutoresizingMaskIntoConstraints = NO;
    _imgNight.image = [UIImage imageNamed:@"night"];
    
    _lbDetailTime = [[UILabel alloc] initWithFrame:CGRectZero];
    [_nurseInfoBg addSubview:_lbDetailTime];
    _lbDetailTime.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbDetailTime.translatesAutoresizingMaskIntoConstraints = NO;
    _lbDetailTime.font = _FONT(12);
    _lbDetailTime.text = @"2015.03.25-03.27(20:00-次日08:00)";
    
    _totalPriceBg = [[UIView alloc] initWithFrame:CGRectZero];
    _totalPriceBg.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_totalPriceBg];
    _totalPriceBg.layer.borderWidth = 0.76;
    _totalPriceBg.layer.borderColor = SeparatorLineColor.CGColor;
    _totalPriceBg.backgroundColor = TableBackGroundColor;
    
    //sub
    _lbTotalPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [_totalPriceBg addSubview:_lbTotalPrice];
    _lbTotalPrice.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbTotalPrice.translatesAutoresizingMaskIntoConstraints = NO;
    _lbTotalPrice.font = _FONT(18);
    _lbTotalPrice.text = @"确认总价：";
    
    _lbTotalPriceValue = [[UILabel alloc] initWithFrame:CGRectZero];
    [_totalPriceBg addSubview:_lbTotalPriceValue];
    _lbTotalPriceValue.textColor = _COLOR(0xf1, 0x13, 0x59);
    _lbTotalPriceValue.translatesAutoresizingMaskIntoConstraints = NO;
    _lbTotalPriceValue.font = _FONT(28);
    _lbTotalPriceValue.text = @"¥450.00";
    
    _payLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_payLogo];
    _payLogo.translatesAutoresizingMaskIntoConstraints = NO;
    _payLogo.image = [UIImage imageNamed:@"paytype"];
    
    _lbPaytype = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_lbPaytype];
    _lbPaytype.translatesAutoresizingMaskIntoConstraints = NO;
    _lbPaytype.font = _FONT(15);
    _lbPaytype.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbPaytype.text = @"付款方式";
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.ContentView addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.tableFooterView = [[UIView alloc] init];
//    _tableview.layer.borderWidth = 0.78;
//    _tableview.layer.borderColor = _COLOR(212, 212, 212).CGColor;
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
    btnSubmit.layer.cornerRadius = 22;
    btnSubmit.backgroundColor = Abled_Color;
    [btnSubmit setTitle:@"立即付款" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, _lbPaytype, _payLogo, _lbTotalPriceValue, _lbTotalPrice, _totalPriceBg, _lbDetailTime, _imgNight, _imgDayTime, _lbPrice, _lbName, _imgPhoto, _nurseInfoBg, btnSubmit);
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_totalPriceBg]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_nurseInfoBg]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_payLogo(14)]-5-[_lbPaytype]-20-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-28-[_nurseInfoBg(106)]-18-[_totalPriceBg(52.5)]-20-[_payLogo(18)]-6-|" options:0 metrics:nil views:views]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbPaytype attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_payLogo attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_totalPriceBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_lbTotalPrice]->=10-[_lbTotalPriceValue]-20-|" options:0 metrics:nil views:views]];
    [_totalPriceBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_lbTotalPrice(28)]->=10-|" options:0 metrics:nil views:views]];
    [_totalPriceBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_lbTotalPriceValue(28)]->=10-|" options:0 metrics:nil views:views]];
    [_totalPriceBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbTotalPrice attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_totalPriceBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_totalPriceBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbTotalPriceValue attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_totalPriceBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_nurseInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_imgPhoto(82)]-20-[_lbName]-15-|" options:0 metrics:nil views:views]];
    [_nurseInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_imgPhoto(82)]-20-[_lbPrice]-15-|" options:0 metrics:nil views:views]];
    [_nurseInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_imgPhoto(82)]-20-[_imgDayTime]-0-[_imgNight]-0-[_lbDetailTime]->=15-|" options:0 metrics:nil views:views]];
    [_nurseInfoBg addConstraint:[NSLayoutConstraint constraintWithItem:_imgPhoto attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_nurseInfoBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_nurseInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_lbName(20)]-5-[_lbPrice(20)]-5-[_lbDetailTime(20)]->=5-|" options:0 metrics:nil views:views]];
    [_nurseInfoBg addConstraint:[NSLayoutConstraint constraintWithItem:_imgNight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_nurseInfoBg addConstraint:[NSLayoutConstraint constraintWithItem:_imgDayTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-40-[btnSubmit(44)]-40-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[btnSubmit]-60-|" options:0 metrics:nil views:views]];
    
    _tableview.tableHeaderView = headerView;
    
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
    return 50;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTypeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if(!cell){
        cell = [[PayTypeItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell._line.hidden = NO;
    if (indexPath.row == 0){
        cell._logoImage.image = [UIImage imageNamed:@"alipaylogo"];
        cell._payName.text = @"支付宝支付";
    }
    else if (indexPath.row == 1){
        cell._logoImage.image = [UIImage imageNamed:@"wechatlogo"];
        cell._payName.text = @"微信支付";
        cell._line.hidden = YES;
    }
    
    return cell;
}

@end