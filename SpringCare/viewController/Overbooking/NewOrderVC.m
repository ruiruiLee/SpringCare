//
//  NewOrderVC.m
//  SpringCare
//
//  Created by LiuZach on 15/7/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "NewOrderVC.h"
#import "define.h"
#import "UserAppraisalCell.h"
#import "PayTypeCell.h"
#import "UIImageView+WebCache.h"
#import "NurseListInfoModel.h"
#import "MyEvaluateListVC.h"
#import "MyOrderListVC.h"
#import "SliderViewController.h"
#import "LoginVC.h"
#import "NewNurseOrder.h"
#import "NewProductOrder.h"

@interface NewOrderVC ()

@end

@implementation NewOrderVC
@synthesize tableview = _tableview;
@synthesize loverModel = _loverModel;
@synthesize btnSubmit;

- (id) initWIthFamilyProductModel:(FamilyProductModel *)model
{
    NewProductOrder *vc = [[NewProductOrder alloc] initWithNibName:nil bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.NavTitle = @"下单";
    
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
    
    UIView *headerView = [self createTableHeaderView];
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
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)createTableHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PICKVIEW_HIDDEN object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
    }

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void) NotifyCurrentSelectPriceModel:(PriceDataModel *)model
{
    currentPriceModel = model;
    [self NotifySelectCouponsWithModel:nil];
    [_tableview reloadData];
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

- (CGFloat) GetOrderTotalValue:(CGFloat) price count:(CGFloat) count couponvalue:(CGFloat) couponvalue
{
    return price * count - couponvalue;
}

//submit
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
            __weak NewOrderVC *weakSelf = self;
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
            __weak NewOrderVC *weakSelf = self;
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
{}

@end
