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

@interface PlaceOrderForProductVC ()

@end

@implementation PlaceOrderForProductVC

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
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:btnSubmit];
    btnSubmit.layer.cornerRadius = 22;
    btnSubmit.backgroundColor = Abled_Color;
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview, btnSubmit);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[btnSubmit]-60-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-40-[btnSubmit(44)]-40-|" options:0 metrics:nil views:views]];
    
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
        PayTypeForProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if(!cell){
            cell = [[PayTypeForProductCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else{
        PlaceOrderEditForProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell){
            cell = [[PlaceOrderEditForProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
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

@end
