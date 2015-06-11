//
//  HomeCareListVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "HomeCareListVC.h"
#import "define.h"
#import "FamilyProductModel.h"
#import "PlaceOrderForProductVC.h"
#import "NurseListVC.h"

#import "UserModel.h"
#import "LoginVC.h"

@interface HomeCareListVC ()

@end

@implementation HomeCareListVC
@synthesize producttypeCell;
@synthesize _tableview = _tableview;
@synthesize _dataArray = _dataArray;
//@synthesize metroView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.lbTitle.text = @"家庭陪护";
    
//    metroView = [[MetroView alloc] initWithFrame:CGRectZero];
//    [self.ContentView addSubview:metroView];
//    metroView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[metroView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(metroView)]];
//    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[metroView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(metroView)]];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)]];
    
    [self loadData];
}

- (void) loadData
{
    __weak HomeCareListVC *weakSelf = self;
    [LCNetWorkBase requestWithMethod:@"api/product/family" Params:nil Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSArray class]]){
                [FamilyProductModel setFamilyProduct:content];
                weakSelf._dataArray = [FamilyProductModel getProductArray];
                [weakSelf._tableview reloadData];
//                [weakSelf.metroView AddDataList:weakSelf._dataArray];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(producttypeCell == nil){
        producttypeCell = [[ProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        producttypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ProductInfoCell *cell = (ProductInfoCell *)self.producttypeCell;
    FamilyProductModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell SetContentWithDic:model];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[ProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FamilyProductModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell SetContentWithDic:model];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FamilyProductModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    if(model.isDirectOrder){
        if(![UserModel sharedUserInfo].isLogin){
            LoginVC *vc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:^{
                
            }];
        }else{
            PlaceOrderForProductVC *vc = [[PlaceOrderForProductVC alloc] initWithModel:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        NurseListVC *vc = [[NurseListVC alloc] initWithProductId:model.pId];
        vc.NavTitle = model.productName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
