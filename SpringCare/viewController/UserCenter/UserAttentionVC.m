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
#import "UserModel.h"
#import "EditUserInfoVC.h"
#import "EditCellTypeData.h"
#import <AVOSCloud/AVOSCloud.h>

@interface UserAttentionVC ()<EditUserInfoVCDelegate>
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
    self.NavigationBar.btnRight.hidden = NO;
    [self.NavigationBar.btnRight setImage:[UIImage imageNamed:@"adduser"] forState:UIControlStateNormal];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 44)];
    _searchBar.placeholder = @"请输入要关注人手机号";
    _searchBar.keyboardType = UIKeyboardTypeNumberPad;
    _attentionData = [UserAttentionModel GetMyAttentionArray];
    _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
    
    if([_attentionData count] == 0){
        [UserAttentionModel loadLoverList:@"true" block:^(int code) {
            if(code == 1){
                _attentionData = [UserAttentionModel GetMyAttentionArray];
                _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
                [_tableview reloadData];
            }
        }];
    }
    
    [self initSubViews];
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

#pragma mark- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"],1.0);
    photoimg= [UIImage imageWithData:imageData];;
    photoimg = [Util fitSmallImage:photoimg scaledToSize:imgHeaderSize];
     [self dismissViewControllerAnimated:YES completion:^{
     [self.currentCell.btnphotoImg setImage:photoimg forState:UIControlStateNormal];
      AVFile *file = [AVFile fileWithName:@"head.jpg" data:imageData];
      
      [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      //  NSLog(@"%@", file.objectId) ;
            self.currentCell.model.photoUrl=file.url;
          NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
              [mDic setObject:self.currentCell.model.userid forKey:@"loverId"];
              [mDic setObject:file.objectId forKey:@"headerImageId"];
           [LCNetWorkBase postWithMethod:@"api/lover/save" Params:mDic Completion:nil];
        }];
   }];
}
- (void) NotifyReloadHeadPhoto:(UserAttentionTableCell*)cell{
   
}
#pragma UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_applyData.count>0) {
        return 2;
    }
    else
        return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_applyData.count>0) {
        if(section == 0)
            return [_applyData count];
        else
            return [_attentionData count];
    }
    else
         return [_attentionData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_applyData.count>0) {
        if(section == 0)
            return 54;
        else
            return 20;
      }
    else
        return 54;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_applyData.count>0 && indexPath.section==0) {
        if(self.requestTableCell == nil){
            self.requestTableCell = [[UserApplyAttentionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        UserRequestAcctionModel *model = [_applyData objectAtIndex:indexPath.row];
        [self.requestTableCell SetContentData:model];
        
        [self.requestTableCell setNeedsLayout];
        [self.requestTableCell layoutIfNeeded];
        
        CGSize size = [self.requestTableCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else
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
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_applyData.count>0 && indexPath.section==0) {
        UserApplyAttentionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[UserApplyAttentionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell._btnAccept addTarget:self action:@selector(btnAccept:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
       UserRequestAcctionModel *model = [_applyData objectAtIndex:indexPath.row];
        cell._btnAccept.tag = indexPath.row;
       [cell SetContentData:model];
        return cell;

    }
    else{
        UserAttentionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(!cell){
            cell = [[UserAttentionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;
            cell.parentController= self;
        }
        UserAttentionModel *model = [_attentionData objectAtIndex:indexPath.row];
        [cell SetContentData:model];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (_applyData.count>0 ){
            if(indexPath.section == 0){
                UserRequestAcctionModel *model = [_applyData objectAtIndex:indexPath.row];
                [model deleteAcctionRequest:^(int code) {
                    if(code){
                        [tableView beginUpdates];
                        
                        if ([[UserRequestAcctionModel GetRequestAcctionArray] count] <= 0) {
                            
                            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                            
                        }
                        
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        [tableView endUpdates];
                        
                        [tableView reloadData];
                    }
                }];
                _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
            }else{
                UserAttentionModel *model = [_attentionData objectAtIndex:indexPath.row];
                [model deleteAttention:^(int code) {
                    if(code){
                        [tableView beginUpdates];
                        
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        [tableView endUpdates];
                        
                        [tableView reloadData];
                    }
                }];
                _attentionData = [UserAttentionModel GetMyAttentionArray];
            }
        }
        else{
            UserAttentionModel *model = [_attentionData objectAtIndex:indexPath.row];
            [model deleteAttention:^(int code) {
                if(code){
                    [tableView beginUpdates];
                    
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [tableView endUpdates];
                    
                    [tableView reloadData];
                }
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

        [view addSubview:_searchBar];
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
    if (_applyData.count>0 && indexPath.section==0) {
        return;
    }
    else{
       NSArray *mArray = [self getContentArray];
    
    EditUserInfoVC *vc = [[EditUserInfoVC alloc] initWithNibName:nil bundle:nil];
    [vc setContentArray:mArray andmodel:[_attentionData objectAtIndex:indexPath.row]];//新增时为空
    vc.delegate = self;
    vc.NavTitle = @"编辑资料";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) doApplyAttention:(UIButton*) sender
{
    NSString *phone = _searchBar.text;
    if(phone.length==0)
    {
        [_searchBar resignFirstResponder];
        return;
    }
    BOOL isMobile = [NSStrUtil isMobileNumber:phone];
    if(!isMobile){
        [Util showAlertMessage:@"电话号码有误！" ];
        return;
    }
    sender.userInteractionEnabled=false;
    NSDictionary *dic = @{@"phone" : phone, @"requesterId" :[UserModel sharedUserInfo].userId};
    [LCNetWorkBase postWithMethod:@"api/request/apply" Params:dic Completion:^(int code, id content) {
         sender.userInteractionEnabled=true;
        [_searchBar resignFirstResponder];
        if (code) {
             [Util showAlertMessage:@"申请已经发送！" ];
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
- (void) NotifyReloadData:(NSString*)loveID
{
    [UserAttentionModel loadLoverList:@"true" block:^(int code) {
        if(code){
            _attentionData = [UserAttentionModel GetMyAttentionArray];
            _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
             [_tableview reloadData];
          
        }
    }];
}

@end
