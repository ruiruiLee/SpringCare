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
#import "LCNetWorkBase.h"
#import "UserModel.h"

@interface UserAttentionVC ()
{
    
}

@property (nonatomic, strong) UserAttentionTableCell *attentionTableCell;
@property (nonatomic, strong) UserApplyAttentionTableCell *requestTableCell;

@end

@implementation UserAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"我的关注";
    
    _attentionData = [UserAttentionModel GetMyAttentionArray];
    _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
    if([_attentionData count] == 0){
        [UserAttentionModel loadLoverList:^(int code) {
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
            [cell._btnAccept addTarget:self action:@selector(btnAccept:) forControlEvents:UIControlEventTouchUpInside];
        }
    
        UserRequestAcctionModel *model = [_applyData objectAtIndex:indexPath.row];
        cell._btnAccept.tag = indexPath.row;
        [cell SetContentData:model];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(indexPath.section == 0){
            UserRequestAcctionModel *model = [_applyData objectAtIndex:indexPath.row];
            [model deleteAcctionRequest:^(int code) {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
        }else{
            UserAttentionModel *model = [_attentionData objectAtIndex:indexPath.row];
            [model deleteAttention:^(int code) {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            _attentionData = [UserAttentionModel GetMyAttentionArray];
        }
        // Delete the row from the data source.
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

//编辑删除按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//这个方法用来告诉表格 某一行是否可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete; //每行左边会出现红的删除按钮
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
        [_btnApply addTarget:self action:@selector(doApplyAttention:) forControlEvents:UIControlEventTouchUpInside];
        
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
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) doApplyAttention:(UIButton*) sender
{
    NSString *phone = _searchBar.text;
    BOOL isMobile = [NSStrUtil isMobileNumber:phone];
    if(!isMobile){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"电话号码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDictionary *dic = @{@"phone" : phone, @"requesterId" :[UserModel sharedUserInfo].userId};
    [LCNetWorkBase postWithMethod:@"api/request/apply" Params:dic Completion:^(int code, id content) {
        if(code){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"申请发送成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void) btnAccept:(UIButton*) sender
{
    UserRequestAcctionModel *model = [_applyData objectAtIndex:sender.tag];
    [model acceptAcceptRequest:^(int code) {
        if(code){
            model.isAccept = 1;
            [_tableview reloadData];
        }
    }];
}

@end
