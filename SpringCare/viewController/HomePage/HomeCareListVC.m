//
//  HomeCareListVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "HomeCareListVC.h"
#import "define.h"
#import "LCNetWorkBase.h"
#import "FamilyProductModel.h"

@interface HomeCareListVC ()

@end

@implementation HomeCareListVC
@synthesize producttypeCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.lbTitle.text = @"家庭陪护";
    
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
    [LCNetWorkBase requestWithMethod:@"api/product/family" Params:nil Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSArray class]]){
                [FamilyProductModel setFamilyProduct:content];
                _dataArray = [FamilyProductModel getProductArray];
                [_tableview reloadData];
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
    return 1  + size.height;
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
}

@end
