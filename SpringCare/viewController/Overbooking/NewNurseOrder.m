//
//  NewNurseOrder.m
//  SpringCare
//
//  Created by LiuZach on 15/7/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NewNurseOrder.h"
#import "UserAppraisalCell.h"
#import "PayTypeCell.h"
#import "MyEvaluateListVC.h"
#import "define.h"
#import "WebContentVC.h"

#define LIMIT_LINES 4

@interface NewNurseOrder ()

@end

@implementation NewNurseOrder
@synthesize nurseModel;

- (id) initWithNurseListInfoModel:(NurseListInfoModel *)model productId:(NSString *)productId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        self.nurseModel = model;
        self.productId = productId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void) loadData{
    __weak NewNurseOrder *weakSelf = self;
    __weak NurseListInfoModel *weaknurseModel = nurseModel;
    
    [nurseModel loadetailDataWithproductId:self.productId block:^(id content) {
        
        [UserModel sharedUserInfo].couponsCount = [[content objectForKey:@"couponsCount"] integerValue];
        NSDictionary *firstCoupon = [content objectForKey:@"firstCoupon"];
        CouponsDataModel *coupon = [CouponsDataModel modelFromDictionary:firstCoupon];
        weakSelf.selectCoupons = coupon;
        
        NSDictionary *dic = [content objectForKey:@"care"];
        weaknurseModel.detailIntro =[dic objectForKey:@"detailIntro"];
        weaknurseModel.isLoadDetail=YES;
        weaknurseModel.certList = [dic objectForKey:@"certList"];
        NSDictionary *dicLover = [content objectForKey:@"defaultLover"];
        NSArray *priceList = [dic objectForKey:@"priceList"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < [priceList count]; i++) {
            NSDictionary *dictionary = [priceList objectAtIndex:i];
            PriceDataModel *pricemodel = [PriceDataModel modelFromDictionary:dictionary];
            if(pricemodel.isDefault)
            {
                currentPriceModel = pricemodel;
            }
            [array addObject:pricemodel];
        }
        nurseModel.priceList = array;
        if (dicLover.count>0) {
            weakSelf.loverModel =  [[UserAttentionModel alloc] init];
            weakSelf.loverModel.userid = [dicLover objectForKey:@"id"];
            weakSelf.loverModel.address =[dicLover objectForKey:@"addr"];
        }
        [weakSelf modifyDetailView];
        [weakSelf NotifyAddressSelected:nil model:weakSelf.loverModel];
        
        [weakSelf NotifySelectCouponsWithModel:weakSelf.selectCoupons];
    }];

}

- (UIView *)createTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 293)];
    
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_photoImage];
    _photoImage.clipsToBounds = YES;
    _photoImage.layer.cornerRadius = 38;
    _photoImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:nurseModel.headerImage] placeholderImage:ThemeImage([Util headerImagePathWith:[Util GetSexByName:nurseModel.sex]])];
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbName.font = _FONT(18);
    _lbName.text = nurseModel.name;
    
    _btnCert = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnCert];
    _btnCert.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnCert setImage:[UIImage imageNamed:@"placeoredercert"] forState:UIControlStateNormal];
    [_btnCert addTarget:self action:@selector(lookImageAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnCert.hidden = YES;
    
    _imgvLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_imgvLogo];
    _imgvLogo.translatesAutoresizingMaskIntoConstraints = NO;
    _imgvLogo.image = ThemeImage(@"nurselistcert");
    
    _btnInfo = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnInfo];
    _btnInfo.translatesAutoresizingMaskIntoConstraints = NO;
    _btnInfo.titleLabel.font = _FONT(12);
    [_btnInfo setTitleColor:_COLOR(0x6b, 0x4e, 0x3e) forState:UIControlStateNormal];
    NSString *title = [NSString stringWithFormat:@"%@ %ld岁 护龄%@年", nurseModel.birthPlace, (long)nurseModel.age, nurseModel.careAge];
    [_btnInfo setTitle:title  forState:UIControlStateNormal];
    _btnInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _detailInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_detailInfo];
    _detailInfo.textColor = _COLOR(0x99, 0x99, 0x99);
    _detailInfo.font = _FONT(14);
    _detailInfo.numberOfLines = LIMIT_LINES;
    _detailInfo.preferredMaxLayoutWidth = ScreenWidth - 34;
    
    CGRect frame = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:4];
    CGRect frame1 = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:5];
    
    _btnUnfold = [[UIButton alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_btnUnfold];
    [_btnUnfold setTitle:@"全文" forState:UIControlStateNormal];
    [_btnUnfold setTitle:@"收起" forState:UIControlStateSelected];
    [_btnUnfold setTitleColor:_COLOR(0x10, 0x9d, 0x59) forState:UIControlStateNormal];
    _btnUnfold.titleLabel.font = _FONT(15);
    _btnUnfold.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnUnfold addTarget:self action:@selector(doBtnDetailFoldOrUnfold:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbName, _btnUnfold, _btnInfo, _btnCert,
                                                         _detailInfo, _imgvLogo);
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_photoImage(76)]-3-[_lbName]->=10-[_btnCert(43)]-36-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_photoImage]-3-[_imgvLogo(21)]-0-[_btnInfo]->=2-[_btnCert(43)]-12-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_detailInfo]-12-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_btnUnfold]->=20-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_photoImage(76)]->=20-|" options:0 metrics:nil views:views]];
    if(frame1.size.height != frame.size.height){
        headerViewHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_lbName(20)]-6-[_btnInfo(21)]-10-[_detailInfo]-8-[_btnUnfold(20)]->=0-|" options:0 metrics:nil views:views];
        _btnUnfold.hidden = NO;
    }
    else{
        headerViewHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_lbName(20)]-6-[_btnInfo(21)]-10-[_detailInfo]-8-|" options:0 metrics:nil views:views];
        _btnUnfold.hidden = YES;
    }
    [headerView addConstraints:headerViewHeightConstraint];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_btnCert attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_photoImage attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_imgvLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_btnInfo attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    
    return headerView;
}

- (void) doBtnDetailFoldOrUnfold:(UIButton*)sender
{
    UIView *headerView = _tableview.tableHeaderView;
    
    if(!sender.selected){
        _detailInfo.numberOfLines = 0;
        [headerView setNeedsLayout];
        [headerView layoutIfNeeded];
        
        CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    }else{
        _detailInfo.numberOfLines = LIMIT_LINES;
        [headerView setNeedsLayout];
        [headerView layoutIfNeeded];
        
        CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    }
    sender.selected = !sender.selected;
    _tableview.tableHeaderView = headerView;
}

-(void)modifyDetailView{
    
    if(nurseModel.detailIntro != nil){
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:nurseModel.detailIntro];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nurseModel.detailIntro length])];
        _detailInfo.attributedText = attributedString;
        
        UIView *headerView = _tableview.tableHeaderView;
        
        CGRect frame = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:4];
        CGRect frame1 = [_detailInfo textRectForBounds:CGRectMake(0, 0, ScreenWidth, 1000) limitedToNumberOfLines:5];
        
        [headerView removeConstraints:headerViewHeightConstraint];
        NSDictionary *views = NSDictionaryOfVariableBindings(_photoImage, _lbName, _btnUnfold, _btnInfo, _btnCert,
                                                             _detailInfo);
        if(frame1.size.height != frame.size.height){
            headerViewHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_lbName(20)]-6-[_btnInfo(21)]-10-[_detailInfo]-8-[_btnUnfold(20)]->=0-|" options:0 metrics:nil views:views];
            _btnUnfold.hidden = NO;
        }
        else{
            headerViewHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_lbName(20)]-6-[_btnInfo(21)]-10-[_detailInfo]-8-|" options:0 metrics:nil views:views];
            _btnUnfold.hidden = YES;
        }
        
        [headerView addConstraints:headerViewHeightConstraint];
        
        [headerView setNeedsLayout];
        [headerView layoutIfNeeded];
        
        CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
        
        if(nurseModel.certList != nil && [nurseModel.certList count] > 0){
            _btnCert.hidden = NO;
        }
        
        _tableview.tableHeaderView = headerView;
    }
    
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.couponsView.lbCounponsCount.text = [NSString stringWithFormat:@" %ld张可用 ", (long)[UserModel sharedUserInfo].couponsCount];
    [cell.businessType setPriseList:nurseModel.priceList];
    cell.businessType.hidden = NO;
    cell.lbUnits.hidden = YES;
    [_tableview reloadData];
    
    if(nurseModel.workStatus > 0)
    {
        self.btnSubmit.enabled = NO;
        [self.btnSubmit setTitle:@"服务中" forState:UIControlStateNormal];
        UIImage *image = [Util imageWithColor:_COLOR(0x66, 0x66, 0x66) size:CGSizeMake(5, 5)];
        UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width/2-10, 0, image.size.width/2-10);
        
        [self.btnSubmit setBackgroundImage:[image resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    }else{
        self.btnSubmit.enabled = YES;
        [self.btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
        [self.btnSubmit setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 || indexPath.section == 1)
        return 50.f;
    else if (indexPath.section == 2)
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
            if([nurseModel.priceList count] > 1)
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
    if(indexPath.section == 0){
        UserAppraisalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if(!cell){
            cell = [[UserAppraisalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.backgroundColor = [UIColor clearColor];
        }

        cell._lbAppraisalNum.text = [NSString stringWithFormat:@"用户评价（%ld）", (long)nurseModel.commentsNumber];
        return cell;
    }
    else if (indexPath.section == 1){
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
    else if (indexPath.section == 3){
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
    if(indexPath.section == 0){
        if(nurseModel.commentsNumber > 0){
            MyEvaluateListVC *vc = [[MyEvaluateListVC alloc] initVCWithNurseId:nurseModel.nid];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1){
        WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"服务内容" url:nurseModel.productUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)lookImageAction:(UIButton *)sender
{
    NSLog(@"lookImageAction");
    _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
    [_imageList addImagesURL:nurseModel.certList withSmallImage:nil];
    [self.view.window addSubview:_imageList];
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
}

- (void) NotifyAddressSelected:(WorkAddressSelectVC *)selectVC model:(UserAttentionModel *)model
{
    //获取服务地址
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
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
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    CGFloat totalvalue = [self GetOrderTotalValue:currentPriceModel.amount count:cell.totalDays couponvalue:self.selectCoupons.amount];

    lbActualPay.attributedText = [self AttributedStringFromString:[NSString stringWithFormat:@"实付款：¥%d", (int)totalvalue] subString:[NSString stringWithFormat:@"¥%d", (int)totalvalue]];
}

- (void) NotifySelectCouponsWithModel:(CouponsDataModel *)model
{
    self.selectCoupons = model;
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.couponsView.lbCouponsSelected.text = [NSString stringWithFormat:@"抵%ld元", (long)model.amount];
    [self NotifyValueChanged:0];
}

- (void) submitWithloverId:(NSString*)loverId
{
    if (self.payValue!=nil) {
        NSLog(@"charge = %@", self.payValue);
    }
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if(cell.beginDate.value == nil ){
        [Util showAlertMessage:@"请选择订单开始时间！"];
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
    [Params setObject:nurseModel.nid forKey:@"careId"];
    [Params setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [Params setObject:loverId forKey:@"loverId"];
    [Params setObject:[cfAppDelegate defaultProductId] forKey:@"productId"];
    [Params setObject:[cfAppDelegate currentCityModel].city_id forKey:@"cityId"];
    
    NSString *dateType = [NSString stringWithFormat:@"%ld", (long)currentPriceModel.type];
    [Params setObject:dateType forKey:@"dateType"];//
    
    [Params setObject:[Util ChangeToUTCTime:[NSString stringWithFormat:@"%@:00", [Util reductionTimeFromOrderTime:cell.beginDate.lbTitle.text]]] forKey:@"beginDate"];//
    [Params setObject:[NSNumber numberWithFloat:cell.totalDays] forKey:@"orderCount"];//
    if([cell.endDate.value isKindOfClass:[NSDate class]])
        [Params setObject:[Util StringFromDate:cell.endDate.value] forKey:@"endDate"];
    
    NSInteger unitPrice = cell.businessType.selectPriceModel.amount;
    CGFloat totalPrice = [self GetOrderTotalValue:currentPriceModel.amount count:cell.totalDays couponvalue:0];
    [Params setObject:[NSNumber numberWithInteger:unitPrice] forKey:@"unitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:totalPrice] forKey:@"totalPrice"];//
    
    [Params setObject:@"ios" forKey:@"source"];
    [Params setObject:currentPriceModel.typeName forKey:@"priceName"];
    [Params setObject:currentPriceModel.name forKey:@"typeName"];
    
    if(self.selectCoupons != nil){
        [Params setObject:self.selectCoupons.couponsId forKey:@"couponId"];
    }
    
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
                
                NSDictionary* dict = @{
                                       @"channel" : self.payValue,
                                       @"amount"  : [NSString stringWithFormat:@"%@00", [NSNumber numberWithInteger:totalPrice]],
                                       @"orderId":orderID
                                       };
                [Util PayForOrders:dict Controller:vc];
            }
        }
    }];
}

- (void) NotifyTOSelectCoupons
{
    CouponsVC *vc = [[CouponsVC alloc] initWithNibName:nil bundle:nil];
    vc.NavTitle = @"选择使用优惠券";
    vc.productId = self.productId;
    vc.selectModel = self.selectCoupons;
    vc.type = EnumCouponsVCTypeSelect;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
