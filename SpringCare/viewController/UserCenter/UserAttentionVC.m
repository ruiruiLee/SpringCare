//
//  UserAttentionVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserAttentionVC.h"
#import "UserAttentionModel.h"
#import "UserAttentionTableCell.h"
#import "UserApplyAttentionTableCell.h"
#import "UserRequestAcctionModel.h"

@interface UserAttentionVC ()
{
    UserAttentionModel *attentionModel;
}

@property (nonatomic, strong) UserAttentionTableCell *attentionTableCell;
@property (nonatomic, strong) UserApplyAttentionTableCell *requestTableCell;

@end

@implementation UserAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"我的关注";
    attentionModel = [[UserAttentionModel alloc] init];
    
    _attentionData = [UserAttentionModel GetMyAttentionArray];
    _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
    if([_attentionData count] == 0){
        [attentionModel loadLoverList:^(int code) {
            if(code == 1){
                _attentionData = [UserAttentionModel GetMyAttentionArray];
                _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
                [_tableview reloadData];
            }
        }];
    }
    
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubViews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
}

#pragma UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [_applyData count];
    else
        return [_attentionData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return 34;
    if(section == 0)
        return 54;
    else
        return 20;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(self.attentionTableCell == nil){
            self.attentionTableCell = [[UserAttentionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        UserAttentionModel *model = [_attentionData objectAtIndex:indexPath.row];
        [self.attentionTableCell SetContentData:model];
        
        [self.attentionTableCell setNeedsLayout];
        [self.attentionTableCell layoutIfNeeded];
        
        CGSize size = [self.attentionTableCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }
    else{
        if(self.requestTableCell == nil){
            self.requestTableCell = [[UserApplyAttentionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        UserRequestAcctionModel *model = [_applyData objectAtIndex:indexPath.row];
        [self.requestTableCell SetContentData:model];
        
        [self.requestTableCell setNeedsLayout];
        [self.requestTableCell layoutIfNeeded];
        
        CGSize size = [self.requestTableCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        UserAttentionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell){
            cell = [[UserAttentionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        
        UserAttentionModel *model = [_attentionData objectAtIndex:indexPath.row];
        [cell SetContentData:model];
        return cell;
    }
    else{
        UserApplyAttentionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[UserApplyAttentionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    //    cell.lbTitle.text = @"成都市";
        UserRequestAcctionModel *model = [_applyData objectAtIndex:indexPath.row];
        [cell SetContentData:model];
        return cell;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    
    if (section == 0) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        [view addSubview:_searchBar];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 44)];
        _searchBar.placeholder = @"请输入要关注人手机号";
        
        UIButton *_btnApply = [[UIButton alloc] initWithFrame:CGRectZero];
        [view addSubview:_btnApply];
        _btnApply.translatesAutoresizingMaskIntoConstraints = NO;
        [_btnApply setImage:[UIImage imageNamed:@"applyAttention"] forState:UIControlStateNormal];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_searchBar, _btnApply);
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_searchBar]-10-[_btnApply(94)]-22.5-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnApply(32)]->=0-|" options:0 metrics:nil views:views]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:_btnApply attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    
    return view;
}

#pragma UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
