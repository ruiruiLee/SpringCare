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

@interface PlaceOrderForProductVC () <WorkAddressSelectVCDelegate>
{
    FamilyProductModel *_nurseModel;
    
    UserAttentionModel *_loverModel;
}

@end

@implementation PlaceOrderForProductVC

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PICKVIEW_HIDDEN object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (id) initWithModel:(FamilyProductModel*) model
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _nurseModel = model;
        ((AppDelegate*)[UIApplication sharedApplication].delegate).defaultProductId = model.pId;
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
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
    btnSubmit.layer.cornerRadius = 22;
    btnSubmit.backgroundColor = Abled_Color;
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [btnSubmit addTarget:self action:@selector(btnSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, btnSubmit);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[btnSubmit]-60-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-40-[btnSubmit(44)]-40-|" options:0 metrics:nil views:views]];
}

- (void) btnSubmitOrder:(UIButton*)sender
{
    
    PlaceOrderEditForProductCell *cell = (PlaceOrderEditForProductCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if(editcell.lbTitle.text == nil || [editcell.lbTitle.text length] < 10){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择订单开始时间！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(_loverModel == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择陪护对象地址！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *Params = [[NSMutableDictionary alloc] init];
    [Params setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
    [Params setObject:_loverModel.userid forKey:@"loverId"];
    [Params setObject:((AppDelegate*)[UIApplication sharedApplication].delegate).defaultProductId forKey:@"productId"];
    [Params setObject:((AppDelegate*)[UIApplication sharedApplication].delegate).currentCityModel.city_id forKey:@"cityId"];
    
    UnitsType type = cell.businessTypeView.uniteType;
    NSInteger orgUnitPrice = _nurseModel.price;
    NSInteger unitPrice = _nurseModel.priceDiscount;
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
    
    NSString *beginDate = [NSString stringWithFormat:@"%@:00:00", editcell.lbTitle.text];
    
    [Params setObject:beginDate forKey:@"beginDate"];//
    [Params setObject:[NSNumber numberWithInteger:cell.dateSelectView.countNum] forKey:@"orderCount"];//
    [Params setObject:[NSNumber numberWithInteger:orgUnitPrice] forKey:@"orgUnitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice] forKey:@"unitPrice"];//
    [Params setObject:[NSNumber numberWithInteger:unitPrice * cell.dateSelectView.countNum] forKey:@"totalPrice"];//
    
    [LCNetWorkBase postWithMethod:@"api/order/submit" Params:Params Completion:^(int code, id content) {
        if(code){
            
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

        [cell setPaytype:EnumTypeAfter];
        
        return cell;
    }
    else{
        PlaceOrderEditForProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell){
            cell = [[PlaceOrderEditForProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell setNurseListInfo:_nurseModel];
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyAddressSelected:(WorkAddressSelectVC *)selectVC model:(UserAttentionModel *)model
{
    //获取服务地址
    PlaceOrderEditForProductCell *cell = (PlaceOrderEditForProductCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PlaceOrderEditItemCell *editcell = (PlaceOrderEditItemCell*)[cell._tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    editcell.lbTitle.text = model.address;
    
    _loverModel = model;
}

@end
