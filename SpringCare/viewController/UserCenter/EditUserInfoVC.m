//
//  EditUserInfoVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/7.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "EditUserTableviewCell.h"
#import "EditCellTypeData.h"
#import "UserModel.h"
#import "UserAttentionModel.h"
#import <AVOSCloud/AVOSCloud.h>

@interface EditUserInfoVC ()<EditUserTableviewCellDelegate>



@end

@implementation EditUserInfoVC
@synthesize delegate;
@synthesize _tableview = _tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.NavigationBar.btnRight setTitle:@"完成" forState:UIControlStateNormal];
    self.NavigationBar.btnRight.hidden = NO;
    self.NavigationBar.btnRight.layer.cornerRadius = 8;
    self.NavigationBar.btnRight.backgroundColor = [UIColor whiteColor];
    [self.NavigationBar.btnRight setTitleColor:Abled_Color forState:UIControlStateNormal];
    self.NavigationBar.btnRight.titleLabel.font = _FONT(16);
    
    [self initSubViews];
}

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [_sexPick remove];
    [_agePick remove];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Resign_First_Responder object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_sexPick remove];
    [_agePick remove];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Resign_First_Responder object:nil];
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    [_sexPick remove];
    [_agePick remove];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Resign_First_Responder object:nil];
    
    if([userData isKindOfClass:[UserModel class]]){
        AVUser *user = [AVUser currentUser];

        for (int i = 0; i < [_data count]; i++) {
            EditCellTypeData *typedata = [_data objectAtIndex:i];
            if(typedata.cellType == EnumTypeUserName){
                if([_EditDic objectForKey:@"UserName"] != nil)
                     [user setObject:[_EditDic objectForKey:@"UserName"] forKey:@"chineseName"];
            }
            else if(typedata.cellType == EnumTypeSex){
                if([_EditDic objectForKey:@"Sex"] != nil){
                    int sex = [[_EditDic objectForKey:@"Sex"] isEqualToString:@"女"] ? 0: 1;
                    [user setObject: [NSNumber numberWithInt:sex]  forKey:@"sex"];
                }
            }
            else if(typedata.cellType == EnumTypeAge){
                if(selectDate != nil){
                    [user setObject:selectDate  forKey:@"birthDay"];
                }
            }
            else if(typedata.cellType == EnumTypeAddress){
                if([_EditDic objectForKey:@"Address"] != nil)
                    [user setObject:[_EditDic objectForKey:@"Address"] forKey:@"addr"];
            }
        }
 
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[UserModel sharedUserInfo] modifyInfo];
                [self NavLeftButtonClickEvent:nil];
            }
        }];
    }else{
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        if([userData isKindOfClass:[UserAttentionModel class]]){
            UserAttentionModel *model = (UserAttentionModel*)userData;
            if (model.userid!=nil) {
                [mDic setObject:model.userid forKey:@"loverId"];
                [mDic setObject:model.relationId forKey:@"relationId"];
            }
         }
        [mDic setObject:[UserModel sharedUserInfo].userId forKey:@"registerId"];
        
        for (int i = 0; i < [_data count]; i++) {
            EditCellTypeData *typedata = [_data objectAtIndex:i];
                if(typedata.cellType == EnumTypeUserName){
                    if([_EditDic objectForKey:@"UserName"] != nil)
                        [mDic setObject:[_EditDic objectForKey:@"UserName"] forKey:@"name"];
                }
                else if(typedata.cellType == EnumTypeSex){
                    if([_EditDic objectForKey:@"Sex"] != nil){
                        int sex = [[_EditDic objectForKey:@"Sex"] isEqualToString:@"女"] ? 0: 1;
                        [mDic setObject: [NSNumber numberWithInt:sex]  forKey:@"sex"];
                    }
                }
                else if(typedata.cellType == EnumTypeAge){
                    if(selectDate != nil){
                        [mDic setObject:selectDate forKey:@"birthDay"];
                    }
                }
                else if(typedata.cellType == EnumTypeAddress){
                    if([_EditDic objectForKey:@"Address"] != nil)
                        [mDic setObject:[_EditDic objectForKey:@"Address"] forKey:@"addr"];
                }
                else if(typedata.cellType == EnumTypeMobile){
                    if([_EditDic objectForKey:@"Mobile"] != nil)
                        [mDic setObject:[_EditDic objectForKey:@"Mobile"] forKey:@"phone"];
                }
                else if(typedata.cellType == EnumTypeRelationName){
                    if([_EditDic objectForKey:@"RelationName"] != nil)
                        [mDic setObject:[_EditDic objectForKey:@"RelationName"] forKey:@"nickName"];
                }
                else if(typedata.cellType == EnumTypeHeight){
                    if([_EditDic objectForKey:@"Height"] != nil)
                        [mDic setObject:[NSString stringWithFormat:@"%d", [[_EditDic objectForKey:@"Height"] integerValue]] forKey:@"height"];
                }
        }
        
        [LCNetWorkBase postWithMethod:@"api/lover/save" Params:mDic Completion:^(int code, id content) {
            if(code){
                if(delegate && [delegate respondsToSelector:@selector(NotifyReloadData:)]){
                    if ([mDic objectForKey:@"loverId"]==nil) {
                        [delegate NotifyReloadData:@"Add"];
                      }
                    else{
                        [delegate NotifyReloadData:@"edit"];
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubViews
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_tableview];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.backgroundColor = TableBackGroundColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerClass:[EditUserTableviewCell class] forCellReuseIdentifier:@"cell"];
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableview);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableview]-0-|" options:0 metrics:nil views:views]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditUserTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lbUnit.hidden = YES;
    
    cell.delegate = self;
    
    EditCellTypeData *typedata = [_data objectAtIndex:indexPath.row];
    
    [cell SetcontentData:typedata info:nil];
    
        if(typedata.cellType == EnumTypeAccount){
            cell.tfEdit.text = [_EditDic objectForKey:@"Account"];//model.mobilePhoneNumber;
            cell.tfEdit.keyboardType = UIKeyboardTypeDefault;
        }
        else if(typedata.cellType == EnumTypeUserName){
            cell.tfEdit.text = [_EditDic objectForKey:@"UserName"];//model.chineseName;
            cell.tfEdit.keyboardType = UIKeyboardTypeDefault;
        }
        else if(typedata.cellType == EnumTypeSex){
            cell.tfEdit.text = [_EditDic objectForKey:@"Sex"];//model.sex;
            cell.tfEdit.keyboardType = UIKeyboardTypeDefault;
        }
        else if(typedata.cellType == EnumTypeAge){
            cell.tfEdit.text = [_EditDic objectForKey:@"Age"];//[NSString stringWithFormat:@"%d", [Util getAgeWithBirthday:model.birthDay]];
        }
        else if(typedata.cellType == EnumTypeAddress){
            cell.tfEdit.placeholder = nil;
            cell.tfEdit.text = [_EditDic objectForKey:@"Address"];//model.addr;
            cell.tfEdit.keyboardType = UIKeyboardTypeDefault;
        }
        else if(typedata.cellType == EnumTypeMobile){
            cell.tfEdit.text = [_EditDic objectForKey:@"Mobile"];//model.mobilePhoneNumber;
            cell.tfEdit.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if(typedata.cellType == EnumTypeRelationName){
            cell.tfEdit.keyboardType = UIKeyboardTypeDefault;
            cell.tfEdit.text = [_EditDic objectForKey:@"RelationName"];
        }
        else if(typedata.cellType == EnumTypeHeight){
            cell.tfEdit.keyboardType = UIKeyboardTypeNumberPad;
            cell.tfEdit.text = [NSString stringWithFormat:@"%d", [[_EditDic objectForKey:@"Height"] integerValue]];
            cell.lbUnit.hidden = NO;
            cell.lbUnit.text = @"cm";
        }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    EditUserTableviewCell *cell = (EditUserTableviewCell*)[_tableview cellForRowAtIndexPath:indexPath];
    
    [_sexPick remove];
    [_agePick remove];
    
    if(cell.tfEdit.isEnabled)
        [cell.tfEdit becomeFirstResponder];
    
    indexpathStore = indexPath;
    
    if(cell.cellType == EnumTypeSex){
        if(!_sexPick){
            _sexPick = [[LCPickView alloc] initPickviewWithArray:@[@"男", @"女"] isHaveNavControler:NO];
            [_sexPick show];
            _sexPick.delegate = self;
        }else{
            [_sexPick show];
        }
    }else if (cell.cellType == EnumTypeAge){
        if(!_agePick){
            NSDate *date = [NSDate date];
            _agePick = [[LCPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
            [_agePick show];
            _agePick.delegate = self;
        }else{
            [_agePick show];
        }
    }
}


- (void) setContentArray:(NSArray*)dataArray andmodel:(id) model
{
    userData = model;
    _data = dataArray;
    
    [self initEditDic:dataArray andmodel:model];
    
    [_tableview reloadData];
}

- (void) initEditDic:(NSArray*)dataArray andmodel:(id) model
{
    _EditDic = [[NSMutableDictionary alloc] init];
    
    if([model isKindOfClass:[UserModel class]]){
        for (int i = 0; i < [dataArray count]; i++) {
            EditCellTypeData *typedata = [dataArray objectAtIndex:i];
            UserModel *userinfo = (UserModel*)model;
            if(typedata.cellType == EnumTypeAccount){
                if(userinfo.mobilePhoneNumber != nil)
                    [_EditDic setObject:userinfo.mobilePhoneNumber forKey:@"Account"];
            }
            else if(typedata.cellType == EnumTypeUserName){
                if(userinfo.chineseName != nil)
                    [_EditDic setObject:userinfo.chineseName forKey:@"UserName"];
            }
            else if(typedata.cellType == EnumTypeSex){
                if(userinfo.sex != nil)
                    [_EditDic setObject:userinfo.sex forKey:@"Sex"];
            }
            else if(typedata.cellType == EnumTypeAge){
                if(userinfo.birthDay != nil)
                    [_EditDic setObject:[NSString stringWithFormat:@"%d", [Util getAgeWithBirthday:userinfo.birthDay]] forKey:@"Age"];
            }
            else if(typedata.cellType == EnumTypeAddress){
                if(userinfo.addr != nil)
                    [_EditDic setObject:userinfo.addr forKey:@"Address"];
            }
        }
    }
    else{
        for (int i = 0; i < [dataArray count]; i++) {
            EditCellTypeData *typedata = [dataArray objectAtIndex:i];
            UserAttentionModel *attention = (UserAttentionModel*)model;
            if(typedata.cellType == EnumTypeUserName){
                if(attention.username != nil)
                    [_EditDic setObject:attention.username forKey:@"UserName"];
            }
            else if(typedata.cellType == EnumTypeSex){
                if(attention.sex != nil)
                     [_EditDic setObject:attention.sex forKey:@"Sex"];
            }
            else if(typedata.cellType == EnumTypeAge){
                if(attention.age != nil)
                    [_EditDic setObject:attention.age forKey:@"Age"];
            }
            else if(typedata.cellType == EnumTypeAddress){
                if(attention.address != nil)
                    [_EditDic setObject:attention.address forKey:@"Address"];
            }
            else if(typedata.cellType == EnumTypeMobile){
                if(attention.ringNum != nil)
                    [_EditDic setObject:attention.ringNum forKey:@"Mobile"];
            }
            else if(typedata.cellType == EnumTypeRelationName){
                if(attention.relation != nil)
                    [_EditDic setObject:attention.relation forKey:@"RelationName"];
            }
            else if(typedata.cellType == EnumTypeHeight){
                [_EditDic setObject:[NSNumber numberWithInteger:attention.height] forKey:@"Height"];
            }
            
        }
    }
}

-(void)toobarDonBtnHaveClick:(LCPickView *)pickView resultString:(NSString *)resultString
{
    EditUserTableviewCell *cell = (EditUserTableviewCell*)[_tableview cellForRowAtIndexPath:indexpathStore];
    
    if(pickView == _sexPick){
        cell.tfEdit.text = resultString;
    }
    
    else if (pickView == _agePick){
       selectDate=  [Util convertDateFromString:[resultString substringToIndex:13]];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps  = [calendar components:unitFlags fromDate:selectDate];
        int year = (int)[comps year];
        
        comps  = [calendar components:unitFlags fromDate:[NSDate date]];
        int year1 = (int)[comps year];
        
        cell.tfEdit.text = [NSString stringWithFormat:@"%d", year1 - year];
    }
}

- (void) keyboardWillShow:(NSNotification *) notify
{
    
    CGFloat keyboardHeight = [[notify.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGFloat height = self.ContentView.frame.size.height;
    
    __weak EditUserInfoVC *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
//        CGFloat offset = 232 + keyboardHeight - height + 5;
//        if(offset < 0)
//            offset = 0;
//        weakSelf._tableview.contentOffset = CGPointMake(0, offset);
        weakSelf._tableview.frame = CGRectMake(0, 0, ScreenWidth, height - keyboardHeight);
    }];
}

- (void) keyboardWillHide:(NSNotification *)notify
{
    CGFloat height = self.ContentView.frame.size.height;
    
    __weak EditUserInfoVC *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
//        weakSelf._tableview.contentOffset = CGPointMake(0, 0);
        weakSelf._tableview.frame = CGRectMake(0, 0, ScreenWidth, height);
    }];
}

- (void) NotifyTextChanged:(NSString *)value type:(EditCellType) type
{
    if(type == EnumTypeUserName){
        if(value != nil)
            [_EditDic setObject:value forKey:@"UserName"];
    }
    else if(type == EnumTypeSex){
        if(value != nil)
            [_EditDic setObject:value forKey:@"Sex"];
    }
    else if(type == EnumTypeAge){
        if(value != nil)
            [_EditDic setObject:value forKey:@"Age"];
    }
    else if(type == EnumTypeAddress){
        if(value != nil)
            [_EditDic setObject:value forKey:@"Address"];
    }
    else if(type == EnumTypeMobile){
        if(value != nil)
            [_EditDic setObject:value forKey:@"Mobile"];
    }
    else if(type == EnumTypeRelationName){
        if(value != nil)
            [_EditDic setObject:value forKey:@"RelationName"];
    }
    else if(type == EnumTypeHeight){
        [_EditDic setObject:[NSNumber numberWithInteger:[value integerValue]] forKey:@"Height"];
    }
}

@end
