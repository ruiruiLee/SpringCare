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

- (id) initWithModel:(MyOrderdataModel *) model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _OrderModel = model;
    }
    
    return self;
}

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

- (UILabel*) createLabelWithFont:(UIFont*)font textcolor:(UIColor*)color backgroundcolor:(UIColor*)bgColor rootView:(UIView*)rootView
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    [rootView addSubview:lb];
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    lb.textColor = color;
    lb.font = font;
    lb.backgroundColor = bgColor;
    return lb;
}

- (UIImageView*) creatImageViewWithimage:(NSString*)name placeholder:(NSString*)placeholder  rootView:(UIView*)rootView
{
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectZero];
    imagev.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:imagev];
    [imagev sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:placeholder]];
    return imagev;
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
    NSArray *nurse = _OrderModel.nurseInfo;
    NSString *path = nil;
    if([nurse count] > 0){
        path = ((NurseListInfoModel *)[nurse objectAtIndex:0]).headerImage;
    }
    _imgPhoto = [self creatImageViewWithimage:nil placeholder:@"nurselistfemale" rootView:_nurseInfoBg];
    [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nurselistfemale"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _lbName = [self createLabelWithFont:_FONT(15) textcolor:_COLOR(0x66, 0x66, 0x66) backgroundcolor:[UIColor clearColor] rootView:_nurseInfoBg];

    NSMutableString *name = [[NSMutableString alloc] init];
    [name appendString:_OrderModel.product.name];
    for (int i = 0; i < [_OrderModel.nurseInfo count]; i++) {
        NurseListInfoModel *model = [_OrderModel.nurseInfo objectAtIndex:i];
        [name appendString:@"-"];
        [name appendString:model.name];
    }
    _lbName.text = name;
    
    _lbPrice = [self createLabelWithFont:_FONT(13) textcolor:_COLOR(0x66, 0x66, 0x66) backgroundcolor:[UIColor clearColor] rootView:_nurseInfoBg];
    NSMutableString *priceStr = [[NSMutableString alloc] init];
    [priceStr appendString:[NSString stringWithFormat:@"¥%ld", _OrderModel.unitPrice]];
    if(_OrderModel.dateType == EnumTypeHalfDay){
        [priceStr appendString:[NSString stringWithFormat:@"/12h X %ld天", _OrderModel.orderCount]];
    }
    else if (_OrderModel.dateType == EnumTypeOneDay){
        [priceStr appendString:[NSString stringWithFormat:@"/天 X %ld天", _OrderModel.orderCount]];
    }
    else if (_OrderModel.dateType == EnumTypeOneWeek){
        [priceStr appendString:[NSString stringWithFormat:@"/周 X %ld周", _OrderModel.orderCount]];
    }
    else if (_OrderModel.dateType == EnumTypeOneMounth){
        [priceStr appendString:[NSString stringWithFormat:@"/月 X %ld月", _OrderModel.orderCount]];
    }
    _lbPrice.text = priceStr;
    
    
    _imgDayTime = [self creatImageViewWithimage:nil placeholder:@"daytime" rootView:_nurseInfoBg];
    _imgNight = [self creatImageViewWithimage:nil placeholder:@"night" rootView:_nurseInfoBg];
    
    _imgDayTime.image = [UIImage imageNamed:@"daytime"];
    _imgNight.image = [UIImage imageNamed:@"night"];
    if(_OrderModel.dateType == EnumTypeHalfDay){
        ServiceTimeType timeType = [Util GetServiceTimeType:_OrderModel.beginDate];
        if(timeType == EnumServiceTimeNight){
            _imgDayTime.image = nil;
        }
        else if (timeType == EnumServiceTimeDay){
            _imgNight.image = nil;
        }
    }
    
    _lbDetailTime = [self createLabelWithFont:_FONT(12) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor] rootView:_nurseInfoBg];
    _lbDetailTime.text = [Util GetOrderServiceTime:_OrderModel.beginDate enddate:_OrderModel.endDate datetype:_OrderModel.dateType];//data.fromto;
    
    _totalPriceBg = [[UIView alloc] initWithFrame:CGRectZero];
    _totalPriceBg.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_totalPriceBg];
    _totalPriceBg.layer.borderWidth = 0.76;
    _totalPriceBg.layer.borderColor = SeparatorLineColor.CGColor;
    _totalPriceBg.backgroundColor = TableBackGroundColor;
    
    //sub
    _lbTotalPrice = [self createLabelWithFont:_FONT(18) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor] rootView:_totalPriceBg];
    _lbTotalPrice.text = @"确认总价：";
    _lbTotalPriceValue = [self createLabelWithFont:_FONT(28) textcolor:_COLOR(0xf1, 0x13, 0x59) backgroundcolor:[UIColor clearColor] rootView:_totalPriceBg];
    _lbTotalPriceValue.text = [NSString stringWithFormat:@"¥%ld", _OrderModel.totalPrice];
    
    _payLogo = [self creatImageViewWithimage:nil placeholder:@"paytype" rootView:headerView];
    _lbPaytype = [self createLabelWithFont:_FONT(15) textcolor:_COLOR(0x66, 0x66, 0x66) backgroundcolor:[UIColor clearColor] rootView:headerView];
    _lbPaytype.text = @"付款方式";
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.ContentView addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.tableFooterView = [[UIView alloc] init];
    
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
