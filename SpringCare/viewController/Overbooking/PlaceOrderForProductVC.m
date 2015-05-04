//
//  PlaceOrderForProductVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PlaceOrderForProductVC.h"
#import "UserAppraisalCell.h"
#import "PayTypeForProductCell.h"
#import "PlaceOrderEditForProductCell.h"
#import "define.h"
#import "WorkAddressSelectVC.h"
#import "UserAttentionModel.h"
#import "PlaceOrderEditCell.h"
#import "MyOrderListVC.h"
#import "SliderViewController.h"
#import "LoginVC.h"
@interface PlaceOrderForProductVC () <WorkAddressSelectVCDelegate>
{
    FamilyProductModel *_productModel;
    
    UserAttentionModel *_loverModel;

}

@property (nonatomic, strong)UserAttentionModel *_loverModel;

@end

@implementation PlaceOrderForProductVC
@synthesize _loverModel = _loverModel;

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PICKVIEW_HIDDEN object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (id) initWithModel:(FamilyProductModel*) model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _productModel = model;
        [cfAppDelegate setDefaultProductId: model.pId];
        __weak PlaceOrderForProductVC *weakSelf = self;
        [_productModel loadetailDataWithproductId:model.pId block:^(id content) {
           // NSDictionary *dic = [content objectForKey:@"care"];
             NSDictionary *dicLover = [content objectForKey:@"defaultLover"];
            if (dicLover.count>0) {
                weakSelf._loverModel =  [[UserAttentionModel alloc] init];
                weakSelf._loverModel.userid = [dicLover objectForKey:@"id"];
                weakSelf._loverModel.address =[dicLover objectForKey:@"addr"];
            }
         [weakSelf NotifyAddressSelected:nil model:weakSelf._loverModel];
        
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"下 单";
    
    [self initSubviews];
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
    [_tableview registerClass:[PayTypeForProductCell class] forCellReuseIdentifier:@"cell2"];
    
    UIView *header = [self CreateTableHeader];
    _tableview.tableHeaderView = header;
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
    btnSubmit.layer.cornerRadius = 22;
//    btnSubmit.backgroundColor = Abled_Color;
    [btnSubmit setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
    btnSubmit.clipsToBounds = YES;
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [btnSubmit addTarget:self action:@selector(btnSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, btnSubmit);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[btnSubmit]-60-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-20-[btnSubmit(44)]-20-|" options:0 metrics:nil views:views]];
}

- (UIView *) CreateTableHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_lbTitle];
    _lbTitle.font = _FONT(15);
    _lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbTitle.text = [NSString stringWithFormat:@"产品名称：%@", _productModel.productName];
    
    _lbExplain = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbExplain.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_lbExplain];
    _lbExplain.font = _FONT(15);
    _lbExplain.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbExplain.text = [NSString stringWithFormat:@"产品介绍：%@", _productModel.productDesc];
    _lbExplain.preferredMaxLayoutWidth = ScreenWidth - 35;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbExplain, _lbTitle);
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTitle]-10-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbExplain]-10-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_lbTitle]-8-[_lbExplain]-10-|" options:0 metrics:nil views:views]];
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, size.height + 1);
    return headerView;
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
            
            [UserAttentionModel loadLoverList:@"true" block:^(int code)  {
                
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
    else if( !_loverModel||!_loverModel.address||[_loverModel.address isEqual:@""]){
          [Util showAlertMessage:@"请选择陪护地址！" ];
        return;
    }
    else{
        if(_loverModel.userid==nil){
            __weak PlaceOrderForProductVC *weakSelf = self;
            [self newAttentionWithAddress:_loverModel.address block:^(int code, id content) {
                if(code){
                    if([content objectForKey:@"code"] == nil)
                        [weakSelf submitWithloverId:@"message"];
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
    PlaceOrderEditForProductCell *cell = (PlaceOrderEditForProductCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if(editcell.lbTitle.text == nil || [editcell.lbTitle.text length] < 10){
        [Util showAlertMessage:@"请选择订单开始时间！" ];
        return;
    }
    if([cfAppDelegate currentCityModel].city_id ==nil){
        [Util showAlertMessage:@"定位失败，请选择所在服务城市！" ];
        return;
    }
    NSMutableDictionary *Params = [[NSMutableDictionary alloc] init];
    [Params setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
//    [Params setObject:_loverModel.userid forKey:@"loverId"];
    [Params setObject:loverId forKey:@"loverId"];
    [Params setObject:[cfAppDelegate defaultProductId] forKey:@"productId"];
    [Params setObject:[cfAppDelegate currentCityModel].city_id forKey:@"cityId"];
    
    UnitsType type = cell.businessTypeView.uniteType;
    NSInteger orgUnitPrice = _productModel.price;
    NSInteger unitPrice = _productModel.priceDiscount;
    NSString *dateType = @"2";
    if(type == EnumTypeWeek){
        dateType = @"3";
        orgUnitPrice = orgUnitPrice * 7;
        unitPrice = unitPrice * 7;
    }
    else if (type == EnumTypeMounth){
        dateType = @"4";
        orgUnitPrice = orgUnitPrice * 30;
        unitPrice = unitPrice * 30;
    }
    [Params setObject:dateType forKey:@"dateType"];//
    
    [Params setObject:[Util ChangeToUTCTime:[NSString stringWithFormat:@"%@:00", [Util reductionTimeFromOrderTime:editcell.lbTitle.text]]] forKey:@"beginDate"];//
    [Params setObject:[NSNumber numberWithInteger:cell.dateSelectView.countNum] forKey:@"orderCount"];//
    [Params setObject:[NSNumber numberWithInteger:orgUnitPrice] forKey:@"orgUnitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice] forKey:@"unitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice * cell.dateSelectView.countNum] forKey:@"totalPrice"];//
    
    __weak PlaceOrderForProductVC *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/order/submit" Params:Params Completion:^(int code, id content) {
        NSString *orderID = [content objectForKey:@"message"];
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        MyOrderListVC *vc = [[MyOrderListVC alloc] initWithNibName:nil bundle:nil];
        [[SliderViewController sharedSliderController] showContentControllerWithPush:vc];
        if(orderID != nil &&self.payValue!=nil)
        {
            // 付款
            MyOrderListVC * __weak weakSelf = vc;
            NSDictionary* dict = @{
                                   @"channel" : self.payValue,
                                   @"amount"  : [NSString stringWithFormat:@"%@", [Params objectForKey:@"totalPrice"]],
                                   @"orderId":orderID
                                   };
            [Util PayForOrders:dict Controller:weakSelf];
        }
    }];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 200.f;
    }
    else{
        return 135.f;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
        PayTypeForProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.parentController=self;
        return cell;
    }
    else{
        PlaceOrderEditForProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell){
            cell = [[PlaceOrderEditForProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell setNurseListInfo:_productModel];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [view addSubview:logo];
    logo.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *lbPaytype = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:lbPaytype];
    lbPaytype.translatesAutoresizingMaskIntoConstraints = NO;
    lbPaytype.font = _FONT(18);
    lbPaytype.textColor = _COLOR(0x66, 0x66, 0x66);
    
    NSDictionary *views = NSDictionaryOfVariableBindings(logo, lbPaytype);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[logo]-0-[lbPaytype]->=0-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[logo]->=0-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbPaytype]-0-|" options:0 metrics:nil views:views]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:logo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    if(section == 0){
        logo.image = [UIImage imageNamed:@"placeordered"];
        lbPaytype.text = @"我要下单";
    }else{
        lbPaytype.text = @"付款方式";
        logo.image = [UIImage imageNamed:@"paytype"];
    }
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.f;
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
    if(_loverModel != nil){
        
        vc.view.backgroundColor = [UIColor clearColor];
        [vc setSelectItemWithLoverId:_loverModel.userid];
        
    }
    else{
        vc.currentAdress = [LcationInstance currentDetailAdrress];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyAddressSelected:(WorkAddressSelectVC *)selectVC  model:(UserAttentionModel*) model
{
    //获取服务地址
  
    PlaceOrderEditForProductCell *cell = (PlaceOrderEditForProductCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (model==nil) {
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
        _loverModel=model;
    }
   
    

}

@end
