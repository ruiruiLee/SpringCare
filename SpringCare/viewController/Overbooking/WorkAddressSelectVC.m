//
//  WorkAddressSelectVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/16.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "WorkAddressSelectVC.h"
#import "define.h"
#import "WorkAddressCell.h"
#import "EditCellTypeData.h"
#import "EditUserInfoVC.h"

@interface WorkAddressSelectVC ()
{
    
}

@end

@implementation WorkAddressSelectVC
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"陪护地址";
    self.NavigationBar.btnRight.hidden = NO;
    [self.NavigationBar.btnRight setImage:[UIImage imageNamed:@"adduser"] forState:UIControlStateNormal];
    
    [self initSubviews];
    
    _dataList = [UserAttentionModel GetMyAttentionArray];
    if([_dataList count] == 0){
        [UserAttentionModel loadLoverList:^(int code) {
            if(code == 1){
                _dataList = [UserAttentionModel GetMyAttentionArray];
                [_tableview reloadData];
            }
        }];
    }
}

- (NSArray *)getContentArray
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    EditCellTypeData *data1 = [[EditCellTypeData alloc] init];
    data1.cellTitleName = @"地址";
    data1.cellType = EnumTypeAddress;
    [mArray addObject:data1];
    
    EditCellTypeData *data2 = [[EditCellTypeData alloc] init];
    data2.cellTitleName = @"关系昵称";
    data2.cellType = EnumTypeRelationName;
    [mArray addObject:data2];
    
    EditCellTypeData *data3 = [[EditCellTypeData alloc] init];
    data3.cellTitleName = @"姓名";
    data3.cellType = EnumTypeUserName;
    [mArray addObject:data3];
    
    EditCellTypeData *data4 = [[EditCellTypeData alloc] init];
    data4.cellTitleName = @"性别";
    data4.cellType = EnumTypeSex;
    [mArray addObject:data4];
    
    EditCellTypeData *data5 = [[EditCellTypeData alloc] init];
    data5.cellTitleName = @"年龄";
    data5.cellType = EnumTypeAge;
    [mArray addObject:data5];
    
    EditCellTypeData *data6 = [[EditCellTypeData alloc] init];
    data6.cellTitleName = @"电话";
    data6.cellType = EnumTypeMobile;
    [mArray addObject:data6];
    
    EditCellTypeData *data7 = [[EditCellTypeData alloc] init];
    data7.cellTitleName = @"身高";
    data7.cellType = EnumTypeHeight;
    [mArray addObject:data7];
    
    return mArray;
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    NSArray *mArray = [self getContentArray];
    
    EditUserInfoVC *vc = [[EditUserInfoVC alloc] initWithNibName:nil bundle:nil];
    [vc setContentArray:mArray andmodel:nil];//新增时为空
    vc.delegate = self;
    vc.NavTitle = @"编辑资料";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyReloadData
{
    [UserAttentionModel loadLoverList:^(int code) {
        if(code == 1){
            _dataList = [UserAttentionModel GetMyAttentionArray];
          [_tableview reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = TableBackGroundColor;
    [self.ContentView addSubview:_tableview];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.tableFooterView = [[UIView alloc] init];
    [_tableview registerClass:[WorkAddressCell class] forCellReuseIdentifier:@"cell"];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:0 views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:0 views:views]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 102.f;
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S || EnumValueTypeiPhone5 == type){
        return 86.f;
        
    }else if (EnumValueTypeiPhone6 == type){
        return 102.f;
    }
    else if (EnumValueTypeiPhone6P == type){
        return 118.f;
    }
    else{
        return 92.f;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;
    UserAttentionModel * model = [_dataList objectAtIndex:indexPath.row];
    [cell setContentWithModel:model];
    [cell._btnSelect addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    cell._btnSelect.tag = 100+indexPath.row;
    
    if(selectLoverId != nil)
        if([model.userid isEqualToString:selectLoverId]){
            selectIndexpath = indexPath;
        }
    
    if(selectIndexpath != nil){
        if(indexPath.row == selectIndexpath.row && indexPath.section == selectIndexpath.section){
            cell._btnSelect.selected = YES;
        }else{
            cell._btnSelect.selected = NO;
        }
    }else
        cell._btnSelect.selected = NO;
    return cell;
}

- (void) btnSelected:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        
        if(delegate && [delegate respondsToSelector:@selector(NotifyAddressSelected:model:)]){
            if([_dataList count] > sender.tag - 100 && sender.tag - 100 >= 0)
                [delegate NotifyAddressSelected:self model:[_dataList objectAtIndex:sender.tag - 100]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserAttentionModel *model = [_dataList objectAtIndex:indexPath.row];
    
    NSArray *mArray = [self getContentArray];
    
    EditUserInfoVC *vc = [[EditUserInfoVC alloc] initWithNibName:nil bundle:nil];
    [vc setContentArray:mArray andmodel:model];//新增时为空
    vc.delegate = self;
    vc.NavTitle = @"编辑资料";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) setSelectItemWithLoverId:(NSString*) loverId
{
    selectLoverId = loverId;
    
    for (int i = 0; i < [_dataList count]; i++) {
        UserAttentionModel *model = [_dataList objectAtIndex:i];
        if([loverId isEqualToString:model.userid]){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            selectIndexpath = indexPath;
            WorkAddressCell *cell = (WorkAddressCell*)[_tableview cellForRowAtIndexPath:indexPath];
            cell._btnSelect.selected = YES;
        }
    }
}

@end
