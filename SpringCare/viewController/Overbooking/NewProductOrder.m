//
//  NewProductOrder.m
//  SpringCare
//
//  Created by LiuZach on 15/7/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NewProductOrder.h"
#import "UserAppraisalCell.h"
#import "PayTypeCell.h"
#import "WebContentVC.h"

@interface NewProductOrder ()

@property (nonatomic, strong) FamilyProductModel *familyModel;
@property (nonatomic, strong)UserAttentionModel *loverModel;

@end

@implementation NewProductOrder
@synthesize familyModel;
@synthesize loverModel;

- (id) initWIthFamilyProductModel:(FamilyProductModel *)model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        self.familyModel = model;
        [cfAppDelegate setDefaultProductId: model.pId];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData
{
    __weak NewProductOrder *weakSelf = self;
    [self.familyModel loadetailDataWithproductId:familyModel.pId block:^(id content) {
        [UserModel sharedUserInfo].couponsCount = [[content objectForKey:@"couponsCount"] integerValue];
        
        NSDictionary *firstCoupon = [content objectForKey:@"firstCoupon"];
        CouponsDataModel *coupon = [CouponsDataModel modelFromDictionary:firstCoupon];
        weakSelf.selectCoupons = coupon;
        
        FamilyProductModel *model = [[FamilyProductModel alloc] init];
        model.pId = [[content objectForKey:@"product"] objectForKey:@"id"];
        model.image_url = [content objectForKey:@"imageUrl"];
        model.isDirectOrder = [[content objectForKey:@"isDirectOrder"] boolValue];
        model.productName = [[content objectForKey:@"product"] objectForKey:@"productName"];
        model.productDesc = [[content objectForKey:@"product"] objectForKey:@"productDesc"];
        if([[[content objectForKey:@"product"] objectForKey:@"price"] isKindOfClass:[NSNull class]])
            model.price = 0;
        else
            model.price = [[[content objectForKey:@"product"] objectForKey:@"price"] integerValue];
        if([[content objectForKey:@"priceDiscount"] isKindOfClass:[NSNull class]])
            model.priceDiscount = 0;
        else
            model.priceDiscount = [[[content objectForKey:@"product"] objectForKey:@"priceDiscount"] integerValue];
        
        NSArray *priceList = [[content objectForKey:@"product"] objectForKey:@"priceList"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < [priceList count]; i++) {
            NSDictionary *dictionary = [priceList objectAtIndex:i];
            PriceDataModel *pricemodel = [PriceDataModel modelFromDictionary:dictionary];
            [array addObject:pricemodel];
        }
        model.priceList = array;
        
        model.productUrl = [content objectForKey:@"productUrl"];
        model.productImg = [content objectForKey:@"productImg"];

        NSDictionary *dicLover = [content objectForKey:@"defaultLover"];
      
        if (dicLover.count>0) {
            weakSelf.loverModel =  [[UserAttentionModel alloc] init];
            weakSelf.loverModel.userid = [dicLover objectForKey:@"id"];
            weakSelf.loverModel.address =[dicLover objectForKey:@"addr"];
        }
        weakSelf.familyModel = model;
        [weakSelf initProductType];
        
        [weakSelf NotifyAddressSelected:nil model:weakSelf.loverModel];
        [weakSelf.tableview reloadData];
        
        [weakSelf NotifySelectCouponsWithModel:weakSelf.selectCoupons];
        
    }];
}

//
//更新header的内容
//
- (void)initProductType
{
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.businessType setPriseList:familyModel.priceList];
    cell.couponsView.lbCounponsCount.text = [NSString stringWithFormat:@" %ld张可用 ", (long)[UserModel sharedUserInfo].couponsCount];
    _lbTitle.text = [NSString stringWithFormat:@"%@", familyModel.productName];
    _lbExplain.text = [NSString stringWithFormat:@"%@", familyModel.productDesc];
    
    [_bglogo sd_setImageWithURL:[NSURL URLWithString:ProductImage(familyModel.productImg)] placeholderImage:nil];
    
    UIView *headerView = _tableview.tableHeaderView;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    _tableview.tableHeaderView = headerView;
}

- (UIView *) createTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    
    _bglogo = [[UIImageView alloc]initWithFrame:CGRectZero];
    [headerView addSubview:_bglogo];
    _bglogo.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_lbTitle];
    _lbTitle.font = _FONT_B(20);
    _lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbTitle.text = [NSString stringWithFormat:@"%@", familyModel.productName];
    _lbTitle.backgroundColor = [UIColor clearColor];
    
    _lbExplain = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbExplain.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_lbExplain];
    _lbExplain.font = _FONT(15);
    _lbExplain.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbExplain.text = [NSString stringWithFormat:@"%@", familyModel.productDesc];
    _lbExplain.preferredMaxLayoutWidth = ScreenWidth - 95* ScreenWidth / 320 - 10;
    _lbExplain.backgroundColor = [UIColor clearColor];
    _lbExplain.numberOfLines = 2;
    
    CGFloat multiplier = 0.333333333;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbExplain, _lbTitle, _bglogo);
    
    NSString *vformat = [NSString stringWithFormat:@"V:|-0-[_bglogo(%f)]->=0-|", (ScreenWidth) * multiplier];
    NSString *formatExplain = [NSString stringWithFormat:@"H:|-%f-[_lbExplain]-10-|", 95 * ScreenWidth / 320];
    NSString *formatTitle = [NSString stringWithFormat:@"H:|-%f-[_lbTitle]-10-|", 95 * ScreenWidth / 320];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatTitle options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatExplain options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-28-[_lbTitle]-8-[_lbExplain]->=10-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bglogo]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vformat options:0 metrics:nil views:views]];
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    return headerView;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableview reloadData];
    
    [self initProductType];
    [self NotifyAddressSelected:nil model:self.loverModel];
    [self NotifySelectCouponsWithModel:self.selectCoupons];
}

#pragma delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 50.f;
    }
    else if (indexPath.section == 1)
    {
        if(currentPriceModel){
            CGFloat width = ScreenWidth - 123.5;
            CGSize size = [[NSString stringWithFormat:@"%@%@", @"服务时长：", currentPriceModel.fwsj]
                           sizeWithFont:[UIFont systemFontOfSize:13]
                           constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                           lineBreakMode:NSLineBreakByCharWrapping];
            CGSize size1 = [[NSString stringWithFormat:@"%@%@", @"适合对象：", currentPriceModel.shrq]
                            sizeWithFont:[UIFont systemFontOfSize:13]
                            constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                            lineBreakMode:NSLineBreakByCharWrapping];
            CGFloat height1 = size.height + size1.height + 30;
            CGFloat height = 54;
            return (309 + ((height > height1) ? height : height1));
            
        }
        else{
            if([familyModel.priceList count] > 1)
                return 301.f + 34.f - 20 + 45;
            else
                return 301.f - 28 + 45;
        }
    }
    else{
        return 215.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        UserAppraisalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if(!cell){
            cell = [[UserAppraisalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell._lbAppraisalNum.text = @"服务内容";
        cell._logoView.image = ThemeImage(@"servicecontent");
        return cell;
    }
    else if (indexPath.section == 2){
        PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.parentController = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else{
        PlaceOrderEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.delegate = self;
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"服务内容" url:familyModel.productUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) NotifyAddressSelected:(WorkAddressSelectVC *)selectVC model:(UserAttentionModel *)model
{
    //获取服务地址
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (model==nil) {
        NSLog(@"%@",[LcationInstance currentDetailAdrress]);
        if ([LcationInstance currentDetailAdrress]) {
            cell.address.lbTitle.font = _FONT_B(16);
            cell.address.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
            cell.address.lbTitle.text=[LcationInstance currentDetailAdrress];
            cell.address.value = cell.address.lbTitle.text;
        }
    }
    else{
        _loverModel = model;
        cell.address.lbTitle.font = _FONT_B(16);
        cell.address.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
        cell.address.lbTitle.text = model.address;
        cell.address.value = model;
    }
}

- (void) NotifyValueChanged:(NSInteger) value
{
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    CGFloat totalvalue = [self GetOrderTotalValue:currentPriceModel.amount count:cell.totalDays couponvalue:self.selectCoupons.amount];
    
    lbActualPay.attributedText = [self AttributedStringFromString:[NSString stringWithFormat:@"实付款：¥%d", (int)totalvalue] subString:[NSString stringWithFormat:@"¥%d", (int)totalvalue]];
}

- (void) NotifySelectCouponsWithModel:(CouponsDataModel *)model
{
    self.selectCoupons = model;
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.couponsView.lbCouponsSelected.text = [NSString stringWithFormat:@"抵%ld元", (long)model.amount];
    [self NotifyValueChanged:0];
}

- (void) submitWithloverId:(NSString*)loverId
{
    if (self.payValue!=nil) {
        NSLog(@"charge = %@", self.payValue);
    }
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];

    if(cell.beginDate.value == nil){
        [Util showAlertMessage:@"请选择订单开始时间！" ];
        return;
    }
    if([cfAppDelegate currentCityModel].city_id ==nil){
        [Util showAlertMessage:@"定位失败，请选择所在服务城市！" ];
        return;
    }
    
    if(cell.endDate.value == nil){
        if(currentPriceModel.type == 1 || currentPriceModel.type == 4 || currentPriceModel.type == 5 || currentPriceModel.type == 6 || currentPriceModel.type == 7){
            [Util showAlertMessage:@"请选择服务数量！"];
        }else{
            [Util showAlertMessage:@"请选择服务结束时间！"];
        }
        return;
    }
    
    NSMutableDictionary *Params = [[NSMutableDictionary alloc] init];
    [Params setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [Params setObject:loverId forKey:@"loverId"];
    [Params setObject:[cfAppDelegate defaultProductId] forKey:@"productId"];
    [Params setObject:[cfAppDelegate currentCityModel].city_id forKey:@"cityId"];

    NSInteger orgUnitPrice = cell.businessType.selectPriceModel.amount;
    NSInteger unitPrice = cell.businessType.selectPriceModel.amount;
    NSString *dateType = [NSString stringWithFormat:@"%ld", (long)currentPriceModel.type];
    [Params setObject:dateType forKey:@"dateType"];//

    [Params setObject:[Util ChangeToUTCTime:[NSString stringWithFormat:@"%@:00", [Util reductionTimeFromOrderTime:cell.beginDate.lbTitle.text]]] forKey:@"beginDate"];//
    [Params setObject:[NSNumber numberWithFloat:cell.totalDays] forKey:@"orderCount"];//
    [Params setObject:[NSNumber numberWithInteger:orgUnitPrice] forKey:@"orgUnitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice] forKey:@"unitPrice"];//
    CGFloat totalPrice = [self GetOrderTotalValue:currentPriceModel.amount count:cell.totalDays couponvalue:0];
    [Params setObject:[NSNumber numberWithFloat:totalPrice] forKey:@"totalPrice"];//
    if(self.selectCoupons != nil){
        [Params setObject:self.selectCoupons.couponsId forKey:@"couponId"];
    }
    
    if([cell.endDate.value isKindOfClass:[NSDate class]])
        [Params setObject:[Util StringFromDate:cell.endDate.value] forKey:@"endDate"];
    
    [Params setObject:@"ios" forKey:@"source"];
    [Params setObject:currentPriceModel.typeName forKey:@"priceName"];
    [Params setObject:currentPriceModel.name forKey:@"typeName"];

    __weak NewOrderVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/order/submit" Params:Params Completion:^(int code, id content) {
        if(code){
            NSString *orderID = [content objectForKey:@"message"];
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            MyOrderListVC *vc = [[MyOrderListVC alloc] initWithNibName:nil bundle:nil];
            [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
            if(orderID != nil &&self.payValue!=nil)
            {
                // 付款
                
                CGFloat totalPrice = [weakSelf GetOrderTotalValue:currentPriceModel.amount count:cell.totalDays couponvalue:self.selectCoupons.amount];
                
                if(self.selectCoupons != nil){
                    totalPrice -= self.selectCoupons.amount;
                }
                
                NSDictionary* dict = @{
                                       @"channel" : self.payValue,
                                       @"amount"  : [NSString stringWithFormat:@"%@00", [NSNumber numberWithInteger:totalPrice]],
                                       @"orderId":orderID
                                       };
                [Util PayForOrders:dict Controller:weakSelf];
            }
        }
    }];
}

- (void) NotifyTOSelectCoupons
{
    CouponsVC *vc = [[CouponsVC alloc] initWithNibName:nil bundle:nil];
    vc.NavTitle = @"选择使用优惠券";
    vc.productId = familyModel.pId;
    vc.selectModel = self.selectCoupons;
    vc.type = EnumCouponsVCTypeSelect;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
