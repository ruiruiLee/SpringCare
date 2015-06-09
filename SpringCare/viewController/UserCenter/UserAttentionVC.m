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
#import "EGORefreshTableHeaderView.h"
#import "HealthRecordVC.h"

@interface UserAttentionVC ()<EditUserInfoVCDelegate, EGORefreshTableHeaderDelegate>
{
    BOOL _reloading;
}

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshView;
@property (nonatomic, strong) UserAttentionTableCell *attentionTableCell;
@property (nonatomic, strong) UserApplyAttentionTableCell *requestTableCell;

@end

@implementation UserAttentionVC
@synthesize refreshView;
//@synthesize _tableview = _tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _reloading = NO;
    
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
    
    [self initSubViews];
    
    __weak UserAttentionVC *weakSelf = self;
    if([_attentionData count] == 0){
        [refreshView startAnimatingWithScrollView:_tableview];
        [UserAttentionModel loadLoverList:@"true" block:^(int code) {
            if(code == 1){
                _attentionData = [[NSMutableArray alloc] initWithArray:[UserAttentionModel GetMyAttentionArray]];//[UserAttentionModel GetMyAttentionArray];
                _applyData = [[NSMutableArray alloc] initWithArray:[UserRequestAcctionModel GetRequestAcctionArray]];//[UserRequestAcctionModel
                
                if(_attentionData.count==0 && _applyData.count==0){
                   [weakSelf displayEmpityImageView:noCareBackbroundImg];
                }else{
                    [weakSelf removeBackgroudImgView];
                }
              [_tableview reloadData];
            }
            [weakSelf performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2];
        }];
    }
}

-(void)displayEmpityImageView:(UIImage *)img{
    if (backgroundImageView==nil) {
        backgroundImageView= [[UIImageView alloc]initWithFrame:CGRectMake(_tableview.frame.size.width/2-img.size.width/2, _tableview.frame.size.height/2-img.size.height + 30, img.size.width, img.size.height)];
        // [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderend"]];
        backgroundImageView.image=img;
        [_tableview addSubview:backgroundImageView];
        
    }
    
}
-(void)removeBackgroudImgView{
    if (backgroundImageView !=nil) {
        [backgroundImageView removeFromSuperview];
        backgroundImageView=nil;
    }
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

//-(void)SingleTap:(UITapGestureRecognizer*)recognizer
//{
//    //处理单击操作
//    [_searchBar resignFirstResponder];
//}

- (void) initSubViews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.backgroundColor = _COLOR(242, 242, 242);//TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -100, ScreenWidth, 100)];
    refreshView.delegate = self;
    [_tableview addSubview:refreshView];
    [refreshView refreshLastUpdatedDate];
    
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
            self.attentionTableCell.delegate = self;
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
            cell.delegate = self;
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
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (_applyData.count>0 ){
            if(indexPath.section == 0){
                UserRequestAcctionModel *model = [_applyData objectAtIndex:indexPath.row];
                [model deleteAcctionRequest:^(int code) {
                    if(code){
                        _applyData = [[UserRequestAcctionModel GetRequestAcctionArray] copy];
                        [tableView beginUpdates];
                        
                        if ([[UserRequestAcctionModel GetRequestAcctionArray] count] <= 0) {
                            
                            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                            
                        }
                        
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        [tableView endUpdates];
                        
                        [tableView reloadData];
                    }
                }];
            }else{
                UserAttentionModel *model = [_attentionData objectAtIndex:indexPath.row];
                [model deleteAttention:^(int code) {
                    if(code){
                        _attentionData = [[UserAttentionModel GetMyAttentionArray] copy];
                        [tableView beginUpdates];
                        
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        [tableView endUpdates];
                        
                        [tableView reloadData];
                    }
                }];
            }
        }
        else{
            UserAttentionModel *model = [_attentionData objectAtIndex:indexPath.row];
            [model deleteAttention:^(int code) {
                if(code){
                    _attentionData = [[UserAttentionModel GetMyAttentionArray] copy];
                    [tableView beginUpdates];
                    
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [tableView endUpdates];
                    
                    [tableView reloadData];
                }
            }];
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
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_searchBar]-4-[_btnApply(94)]-12.5-|" options:0 metrics:nil views:views]];
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
    [refreshView startAnimatingWithScrollView:_tableview];
    __weak UserAttentionVC *weakSelf = self;
    [UserAttentionModel loadLoverList:@"true" block:^(int code) {
        if(code){
            _attentionData = [UserAttentionModel GetMyAttentionArray];
            _applyData = [UserRequestAcctionModel GetRequestAcctionArray];
            if(_attentionData.count==0 && _applyData.count==0){
                [weakSelf displayEmpityImageView:noCareBackbroundImg];
            }else{
                [weakSelf removeBackgroudImgView];
            }

             [_tableview reloadData];
          
        }
        [weakSelf performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    }];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableview];
    NSLog(@"doneLoadingTableViewData    1");
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

-(void)refreshTable{
    [self reloadTableViewDataSource];
    __weak UserAttentionVC *weakSelf = self;
    [UserAttentionModel loadLoverList:@"true" block:^(int code) {
        if(code == 1){
            _attentionData = [[NSMutableArray alloc] initWithArray:[UserAttentionModel GetMyAttentionArray]];//[UserAttentionModel GetMyAttentionArray];
            _applyData = [[NSMutableArray alloc] initWithArray:[UserRequestAcctionModel GetRequestAcctionArray]];//[UserRequestAcctionModel GetRequestAcctionArray];
            if(_attentionData.count==0 && _applyData.count==0){
                [weakSelf displayEmpityImageView:noCareBackbroundImg];
            }else{
                [weakSelf removeBackgroudImgView];
            }

            [_tableview reloadData];
        }
        [weakSelf performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2];
    }];
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self refreshTable];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_searchBar resignFirstResponder];
}

- (void)NotifyHealthRecordButtonClickedWithModel:(UserAttentionModel *)model
{
    HealthRecordVC *vc = [[HealthRecordVC alloc] initWithLoverId:model.userid];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
