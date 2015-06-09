//
//  PlaceOrderVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PlaceOrderVC.h"
#import "define.h"
#import "UserAppraisalCell.h"
#import "PayTypeCell.h"
#import "UIImageView+WebCache.h"
#import "NurseListInfoModel.h"
#import "MyEvaluateListVC.h"
#import "WorkAddressSelectVC.h"
#import "MyOrderListVC.h"
#import "SliderViewController.h"
#import "LoginVC.h"
#import "CouponsVC.h"

#define LIMIT_LINES 4

@interface PlaceOrderVC () <WorkAddressSelectVCDelegate, CouponsVCDelegate>
{
    NurseListInfoModel *_nurseModel;
    
    UserAttentionModel *_loverModel;
    NSString * productId;
    
    CouponsDataModel *_selectCoupons;
}

@property (nonatomic, strong)UserAttentionModel *_loverModel;

@end

@implementation PlaceOrderVC
@synthesize _loverModel = _loverModel;


- (id) initWithModel:(NurseListInfoModel*) model andproductId:(NSString*)_productId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _nurseModel = model;
        productId = _productId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"下 单";
    
    
    [self initSubviews];
    
    __weak PlaceOrderVC *weakSelf = self;
    __weak NurseListInfoModel *weaknurseModel = _nurseModel;
   //if([UserModel sharedUserInfo].isLogin){
    [_nurseModel loadetailDataWithproductId:productId block:^(id content) {

        [UserModel sharedUserInfo].couponsCount = [[content objectForKey:@"couponsCount"] integerValue];
            
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
            [array addObject:pricemodel];
        }
        _nurseModel.priceList = array;
        if (dicLover.count>0) {
            weakSelf._loverModel =  [[UserAttentionModel alloc] init];
            weakSelf._loverModel.userid = [dicLover objectForKey:@"id"];
            weakSelf._loverModel.address =[dicLover objectForKey:@"addr"];
        }
        [weakSelf modifyDetailView];
        [weakSelf NotifyAddressSelected:nil model:weakSelf._loverModel];
    }];
 //  }
}

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PICKVIEW_HIDDEN object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.ContentView addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableview registerClass:[PlaceOrderEditCell class] forCellReuseIdentifier:@"cell1"];
    [_tableview registerClass:[PayTypeCell class] forCellReuseIdentifier:@"cell2"];
    _tableview.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [self createTableViewHeader];
    _tableview.tableHeaderView = headerView;
    
    UILabel *sLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:sLine];
    sLine.backgroundColor = SeparatorLineColor;
    sLine.translatesAutoresizingMaskIntoConstraints = NO;
    
    lbActualPay = [[UILabel alloc] initWithFrame:CGRectZero];
    lbActualPay.backgroundColor = [UIColor clearColor];
    [self.ContentView addSubview:lbActualPay];
    lbActualPay.font = _FONT(15);
    lbActualPay.textColor = _COLOR(0x66, 0x66, 0x66);
    lbActualPay.text = @"实付款：";
    lbActualPay.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
//    btnSubmit.layer.cornerRadius = 22;
    [btnSubmit setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
    btnSubmit.clipsToBounds = YES;
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [btnSubmit addTarget:self action:@selector(btnSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, btnSubmit, sLine, lbActualPay);
    if(_IPHONE_OS_VERSION_UNDER_7_0)
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-10)-[_tableview]-(-10)-|" options:0 metrics:nil views:views]];
    else
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sLine]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbActualPay]-0-[btnSubmit(160)]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-[sLine(0.7)]-0-[btnSubmit(54)]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbActualPay(54)]-0-|" options:0 metrics:nil views:views]];
}

- (void) newAttentionWithAddress:(NSString*)address block:(Completion)block;
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    [mDic setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];

    [mDic setObject:address forKey:@"addr"];
    
    [LCNetWorkBase postWithMethod:@"api/lover/save" Params:mDic Completion:^(int code, id content) {
        if(code){
            if(block){
                block(code, content);
            }
            
            [UserAttentionModel loadLoverList:@"true" block:^(int code) {

            }];
        }
    }];

}

- (void) btnSubmitOrder:(UIButton*)sender
{
    if(![[UserModel sharedUserInfo] isLogin]){
        LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    else if(!_loverModel.address||[_loverModel.address isEqual:@""])
    {
        if (![LcationInstance currentDetailAdrress]) {
              [Util showAlertMessage:@"请选择陪护地址！"];
        }
        else{
            __weak PlaceOrderVC *weakSelf = self;
            [self newAttentionWithAddress:[LcationInstance currentDetailAdrress] block:^(int code, id content) {
                if(code){
                    if([content objectForKey:@"code"] == nil)
                        [weakSelf submitWithloverId:[content objectForKey:@"message"]];
                }
            }];

        }
        
    }
    else{
        if(_loverModel.userid==nil){
            __weak PlaceOrderVC *weakSelf = self;
            [self newAttentionWithAddress:_loverModel.address block:^(int code, id content) {
                if(code){
                    if([content objectForKey:@"code"] == nil)
                        [weakSelf submitWithloverId:[content objectForKey:@"message"]];
                }
            }];
        }
      else
         [self submitWithloverId:_loverModel.userid];
    }
}

- (void) submitWithloverId:(NSString*)loverId
{
    if (self.payValue!=nil) {
         NSLog(@"charge = %@", self.payValue);
    }
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if(editcell.lbTitle.text == nil || [editcell.lbTitle.text length] < 10){
         [Util showAlertMessage:@"请选择订单开始时间！"];
        return;
    }
    if([cfAppDelegate currentCityModel].city_id ==nil){
        [Util showAlertMessage:@"定位失败，请选择所在服务城市！" ];
        return;
    }
    NSMutableDictionary *Params = [[NSMutableDictionary alloc] init];
    [Params setObject:_nurseModel.nid forKey:@"careId"];
    [Params setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [Params setObject:loverId forKey:@"loverId"];
    [Params setObject:[cfAppDelegate defaultProductId] forKey:@"productId"];
    [Params setObject:[cfAppDelegate currentCityModel].city_id forKey:@"cityId"];

    NSString *dateType = [NSString stringWithFormat:@"%d", cell.businessType.selectPriceModel.type];
    [Params setObject:dateType forKey:@"dateType"];//
    
    [Params setObject:[Util ChangeToUTCTime:[NSString stringWithFormat:@"%@:00", [Util reductionTimeFromOrderTime:editcell.lbTitle.text]]] forKey:@"beginDate"];//
    [Params setObject:[NSNumber numberWithInteger:cell.dateSelectView.countNum] forKey:@"orderCount"];//
    
    NSInteger unitPrice = cell.businessType.selectPriceModel.amount;
    
    [Params setObject:[NSNumber numberWithInteger:unitPrice] forKey:@"unitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice * cell.dateSelectView.countNum] forKey:@"totalPrice"];//
    
    if(_selectCoupons != nil){
        [Params setObject:_selectCoupons.couponsId forKey:@"couponId"];
    }
    
    __weak PlaceOrderVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/order/submit" Params:Params Completion:^(int code, id content) {
        if(code){
                NSString *orderID = [content objectForKey:@"message"];
               [weakSelf.navigationController popToRootViewControllerAnimated:NO];
               MyOrderListVC *vc = [[MyOrderListVC alloc] initWithNibName:nil bundle:nil];
               [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
                if(orderID != nil &&self.payValue!=nil)
                {
                    // 付款
                    MyOrderListVC * __weak weakSelf = vc;
                    
                    NSInteger totalPrice = unitPrice * cell.dateSelectView.countNum;
                    
                    if(_selectCoupons != nil){
                        totalPrice -= _selectCoupons.amount;
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
    
    if(_nurseModel.detailIntro != nil){
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_nurseModel.detailIntro];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_nurseModel.detailIntro length])];
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
        
        if(_nurseModel.certList != nil && [_nurseModel.certList count] > 0){
            _btnCert.hidden = NO;
        }
        
        _tableview.tableHeaderView = headerView;
    }
    
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.businessType setPriseList:_nurseModel.priceList];
    if([_nurseModel.priceList count] == 1){
        cell.businessType.hidden = YES;
        cell.lbUnits.hidden = YES;
        cell.lbUnits.text = [NSString stringWithFormat:@"单位：%@", ((PriceDataModel*)[_nurseModel.priceList objectAtIndex:0]).name];
    }else{
        cell.businessType.hidden = NO;
        cell.lbUnits.hidden = YES;
    }
    [_tableview reloadData];
}

- (UIView*) createTableViewHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 293)];
    
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoImage.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_photoImage];
    _photoImage.clipsToBounds = YES;
    _photoImage.layer.cornerRadius = 38;
    _photoImage.contentMode = UIViewContentModeScaleAspectFill;

    [_photoImage sd_setImageWithURL:[NSURL URLWithString:_nurseModel.headerImage] placeholderImage:ThemeImage([Util headerImagePathWith:[Util GetSexByName:_nurseModel.sex]])];
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbName.font = _FONT(18);
    _lbName.text = _nurseModel.name;
    
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
    NSString *title = [NSString stringWithFormat:@"%@ %ld岁 护龄%@年", _nurseModel.birthPlace, (long)_nurseModel.age, _nurseModel.careAge];
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        return 1;
    }
    else if (section == 2){
        return 1;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 50.f;
    else if (indexPath.section == 1)
    {
//        if([UserModel sharedUserInfo].couponsCount > 0)
        
        if([_nurseModel.priceList count] > 1)
            return 301.f + 34.f;
        else
            return 301.f;
//        else
//            return 248.f;
    }
    else{
        return 170.f;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        
        cell._lbAppraisalNum.text = [NSString stringWithFormat:@"用户评价（%ld）", (long)_nurseModel.commentsNumber];
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
        [cell setNurseListInfo:_nurseModel];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if(_nurseModel.commentsNumber > 0){
            MyEvaluateListVC *vc = [[MyEvaluateListVC alloc] initVCWithNurseId:_nurseModel.nid];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13.5f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableBackGroundColor;
    return view;
}

- (void) NotifyToSelectAddr
{
    WorkAddressSelectVC *vc = [[WorkAddressSelectVC alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    if(_loverModel.userid != nil){
       
        vc.view.backgroundColor = [UIColor clearColor];
        [vc setSelectItemWithLoverId:_loverModel.userid];
        
    }
   else{
       vc.currentAdress = [LcationInstance currentDetailAdrress];
    }
   [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyAddressSelected:(WorkAddressSelectVC *)selectVC model:(UserAttentionModel *)model
{
    //获取服务地址
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (model==nil) {
        NSLog(@"%@",[LcationInstance currentDetailAdrress]);
        if ([LcationInstance currentDetailAdrress]) {
            editcell.lbTitle.font = _FONT_B(16);
            editcell.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
            editcell.lbTitle.text=[LcationInstance currentDetailAdrress];

           }
      }
    else{
        _loverModel = model;
        editcell.lbTitle.font = _FONT_B(16);
        editcell.lbTitle.textColor = _COLOR(0x22, 0x22, 0x22);
        editcell.lbTitle.text = model.address;
    }


}

- (void) NotifyTOSelectCoupons
{
    CouponsVC *vc = [[CouponsVC alloc] initWithNibName:nil bundle:nil];
    vc.NavTitle = @"选择使用优惠券";
    vc.selectModel = _selectCoupons;
    vc.type = EnumCouponsVCTypeSelect;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)lookImageAction:(UIButton *)sender
{
    NSLog(@"lookImageAction");
    _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
    [_imageList addImagesURL:_nurseModel.certList withSmallImage:nil];
    [self.view.window addSubview:_imageList];
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
}

- (void) NotifySelectCouponsWithModel:(CouponsDataModel *)model
{
    _selectCoupons = model;
    PlaceOrderEditCell *cell = (PlaceOrderEditCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSInteger unitPrice = cell.businessType.selectPriceModel.amount;//_nurseModel.pricemodel.fullDay;
    
    cell.couponsView.lbCouponsSelected.text = [NSString stringWithFormat:@"抵%d元", model.amount];//model.name;
    lbActualPay.attributedText = [self AttributedStringFromString:[NSString stringWithFormat:@"实付款：¥%d", unitPrice * cell.dateSelectView.countNum - _selectCoupons.amount] subString:[NSString stringWithFormat:@"¥%d", unitPrice * cell.dateSelectView.countNum - _selectCoupons.amount]];
}

- (void) NotifyValueChanged:(NSInteger) value
{
    lbActualPay.attributedText = [self AttributedStringFromString:[NSString stringWithFormat:@"实付款：¥%d", value - _selectCoupons.amount] subString:[NSString stringWithFormat:@"¥%d", value - _selectCoupons.amount]];
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
