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

@property (nonatomic, assign) PayType paytype;

@end

@implementation PayForOrderVC
@synthesize paytype;

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
    _imgPhoto.clipsToBounds = YES;
    _imgPhoto.layer.cornerRadius = 41;
    [_imgPhoto sd_setImageWithURL:[NSURL URLWithString:HeadImage(path)] placeholderImage:[UIImage imageNamed:@"nurselistfemale"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
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
    [priceStr appendString:[NSString stringWithFormat:@"¥%d", _OrderModel.unitPrice]];
    [priceStr appendString:[NSString stringWithFormat:@"/%@ X %d", _OrderModel.priceName, _OrderModel.orderCount]];
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
    _lbTotalPriceValue.text = [NSString stringWithFormat:@"¥%ld", _OrderModel.realyTotalPrice];
    
    _payLogo = [self creatImageViewWithimage:nil placeholder:@"paytype" rootView:headerView];
    _lbPaytype = [self createLabelWithFont:_FONT(15) textcolor:_COLOR(0x99, 0x99, 0x99) backgroundcolor:[UIColor clearColor] rootView:headerView];
    _lbPaytype.text = @"付款方式";
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.ContentView addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.tableFooterView = [[UIView alloc] init];
    
    UILabel *sLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:sLine];
    sLine.backgroundColor = SeparatorLineColor;
    sLine.translatesAutoresizingMaskIntoConstraints = NO;
    
    lbActualPay = [[UILabel alloc] initWithFrame:CGRectZero];
    lbActualPay.backgroundColor = [UIColor clearColor];
    [self.ContentView addSubview:lbActualPay];
    lbActualPay.font = _FONT(15);
    lbActualPay.textColor = _COLOR(0x66, 0x66, 0x66);
//    lbActualPay.text = @"实付款：";realyTotalPrice
    lbActualPay.translatesAutoresizingMaskIntoConstraints = NO;
    lbActualPay.attributedText = [self AttributedStringFromString:[NSString stringWithFormat:@"实付款：¥%d", _OrderModel.realyTotalPrice] subString:[NSString stringWithFormat:@"¥%d", _OrderModel.realyTotalPrice]];
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
//    btnSubmit.layer.cornerRadius = 22;
//    btnSubmit.backgroundColor = Abled_Color;
    [btnSubmit setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
    btnSubmit.clipsToBounds = YES;
    [btnSubmit setTitle:@"立即付款" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [btnSubmit addTarget:self action:@selector(btnSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, _lbPaytype, _payLogo, _lbTotalPriceValue, _lbTotalPrice, _totalPriceBg, _lbDetailTime, _imgNight, _imgDayTime, _lbPrice, _lbName, _imgPhoto, _nurseInfoBg, btnSubmit, lbActualPay, sLine);
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_totalPriceBg]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_nurseInfoBg]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_payLogo(14)]-5-[_lbPaytype]-20-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-28-[_nurseInfoBg(106)]-18-[_totalPriceBg(52.5)]-20-[_payLogo(18)]-6-|" options:0 metrics:nil views:views]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbPaytype attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_payLogo attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgPhoto(82)]->=0-|" options:0 metrics:nil views:views]];
    
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
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-[sLine(0.7)]-0-[btnSubmit(54)]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sLine]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbActualPay]-0-[btnSubmit(160)]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbActualPay(54)]-0-|" options:0 metrics:nil views:views]];
    
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
    

    if(paytype == EnumTypeAlipay){
        if(indexPath.row == 0)
            cell._btnSelect.selected = YES;
        else
            cell._btnSelect.selected = NO;
    }
    else if(paytype == EnumTypeWechat){
        if(indexPath.row == 1)
            cell._btnSelect.selected = YES;
        else
            cell._btnSelect.selected = NO;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        [self setPaytype:EnumTypeAlipay];
        _payValue=@"alipay";
    }
    else{
        [self setPaytype:EnumTypeWechat];
         _payValue=@"wx";
    }
}

- (void) setPaytype:(PayType)_paytype
{
    paytype = _paytype;

    [_tableview reloadData];
}

//- (void)showAlertMessage:(NSString*)msg
//{
//    UIAlertView * mAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
//    [mAlert show];
//}

- (void)btnSubmitClicked:(UIButton*) sender{
    if (_payValue==nil) {
        [Util showAlertMessage:@"请选择支付方式！"];
        return;
    }
   // sender.userInteractionEnabled=false;
    PayForOrderVC * __weak weakSelf = self;
    NSDictionary* dict = @{
                           @"channel" : _payValue,
                           @"amount"  : [NSString stringWithFormat:@"%ld", (long)_OrderModel.realyTotalPrice * 100],
                           @"orderId":_OrderModel.oId
                           };
    [Util PayForOrders:dict Controller:weakSelf];
//    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    [LCNetWorkBase postWithParams:bodyData  Url:kUrl Completion:^(int code, id content) {
//        if(code){
//             NSLog(@"charge = %@", content);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [Pingpp createPayment:(NSString*)content viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
//                    NSLog(@"completion block: %@", result);
//                     sender.userInteractionEnabled=true;
//                    if (error == nil) {
//                        NSLog(@"PingppError is nil");
//                         [weakSelf showAlertMessage:@"支付成功！"];
//                    } else {
//                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
//                         [weakSelf showAlertMessage: [NSString stringWithFormat:@"支付失败(%@)",[error getMsg]]];
//                    }
//                 
//                }];
//            });
//        }
//        else{
//              sender.userInteractionEnabled=true;
//            [weakSelf showAlertMessage:@"支付失败，服务器链接错误！"];
//
//        }
//    }];
}

- (NSMutableAttributedString *)AttributedStringFromString:(NSString*)string subString:(NSString *)subString
{
    NSString *UnitPrice = string;//@"单价：¥300.00（24h） x 1天";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:subString];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf1, 0x15, 0x39) range:range];
    [attString addAttribute:NSFontAttributeName value:_FONT(22) range:range];
    return attString;
}

@end
