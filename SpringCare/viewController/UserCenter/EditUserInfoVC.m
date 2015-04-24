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
#import "IQKeyboardReturnKeyHandler.h"

@interface EditUserInfoVC ()

@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@end

@implementation EditUserInfoVC
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.NavigationBar.btnLeft setImage:[UIImage imageNamed:@"nav_shut"] forState:UIControlStateNormal];
    [self.NavigationBar.btnRight setTitle:@"完成" forState:UIControlStateNormal];
    self.NavigationBar.btnRight.hidden = NO;
    self.NavigationBar.btnRight.layer.cornerRadius = 8;
    self.NavigationBar.btnRight.backgroundColor = [UIColor whiteColor];
    [self.NavigationBar.btnRight setTitleColor:Abled_Color forState:UIControlStateNormal];
    self.NavigationBar.btnRight.titleLabel.font = _FONT(16);
    
    [self initSubViews];
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyNext;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
}

- (void) NavLeftButtonClickEvent:(UIButton *)sender
{
    [_sexPick remove];
    [_agePick remove];
    [self.ContentView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_sexPick remove];
    [_agePick remove];
    [self.ContentView resignFirstResponder];
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    [_sexPick remove];
    [_agePick remove];
    [self.ContentView resignFirstResponder];
    
    if([userData isKindOfClass:[UserModel class]]){
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        [mDic setObject:[UserModel sharedUserInfo].registerId forKey:@"registerId"];
        [mDic setObject:[UserModel sharedUserInfo].userId forKey:@"baseUserId"];
        
        for (int i = 0; i < [_data count]; i++) {
            EditCellTypeData *typedata = [_data objectAtIndex:i];
            EditUserTableviewCell *cell = (EditUserTableviewCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];//[_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(cell.tfEdit.text != nil){
                NSLog(@"%@", cell.tfEdit.text);
                if(typedata.cellType == EnumTypeUserName){
                    [mDic setObject:cell.tfEdit.text forKey:@"chineseName"];
                }
                else if(typedata.cellType == EnumTypeSex){
                    UserSex sex = [cell.tfEdit.text isEqualToString:@"女"] ? EnumFemale: EnumMale;
                    [mDic setObject:[NSNumber numberWithBool:sex] forKey:@"sex"];
                }
                else if(typedata.cellType == EnumTypeAge){
                    if(selectDate != nil){
                        [mDic setObject:selectDate forKey:@"birthDay"];
                    }
                }
                else if(typedata.cellType == EnumTypeAddress){
                    [mDic setObject:cell.tfEdit.text forKey:@"addr"];
                }
                else if(typedata.cellType == EnumTypeAccount){
                    [mDic setObject:cell.tfEdit.text forKey:@"phone"];
                }
//                else if(typedata.cellType == EnumTypeRelationName){
//                    [mDic setObject:cell.tfEdit.text forKey:@"nickName"];
//                }
                else if(typedata.cellType == EnumTypeHeight){
                    [mDic setObject:[NSString stringWithFormat:@"%.2f", [cell.tfEdit.text intValue]/100.0] forKey:@"height"];
                }
            }
        }
        
        [LCNetWorkBase postWithMethod:@"api/register/save" Params:mDic Completion:^(int code, id content) {
            if(code){
                [UserModel sharedUserInfo].sex = [[mDic objectForKey:@"sex"] boolValue]?@"男":@"女";
                [UserModel sharedUserInfo].addr = [mDic objectForKey:@"addr"];
                [UserModel sharedUserInfo].birthDay =    [Util StringFromDate:selectDate];
                [UserModel sharedUserInfo].chineseName = [mDic objectForKey:@"chineseName"];

                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        if([userData isKindOfClass:[UserAttentionModel class]]){
            UserAttentionModel *model = (UserAttentionModel*)userData;
            [mDic setObject:model.userid forKey:@"loverId"];
            [mDic setObject:model.relationId forKey:@"relationId"];
            
        }
        [mDic setObject:[UserModel sharedUserInfo].userId forKey:@"currentUserId"];
        
        for (int i = 0; i < [_data count]; i++) {
            EditCellTypeData *typedata = [_data objectAtIndex:i];
            EditUserTableviewCell *cell = (EditUserTableviewCell*)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(cell.tfEdit.text != nil){
                NSLog(@"%@", cell.tfEdit.text);
                if(typedata.cellType == EnumTypeUserName){
                    [mDic setObject:cell.tfEdit.text forKey:@"name"];
                }
                else if(typedata.cellType == EnumTypeSex){
                    if(cell.tfEdit.text != nil && ![cell.tfEdit.text isKindOfClass:[NSNull class]] && [cell.tfEdit.text length] > 0){
                        UserSex sex = [cell.tfEdit.text isEqualToString:@"女"] ? EnumFemale: EnumMale;
                        [mDic setObject:[NSNumber numberWithBool:sex] forKey:@"sex"];
                    }
                }
                else if(typedata.cellType == EnumTypeAge){
                    if(selectDate != nil){
                        [mDic setObject:selectDate forKey:@"birthDay"];
                    }
                }
                else if(typedata.cellType == EnumTypeAddress){
                    [mDic setObject:cell.tfEdit.text forKey:@"addr"];
                }
                else if(typedata.cellType == EnumTypeMobile){
                    [mDic setObject:cell.tfEdit.text forKey:@"phone"];
                }
                else if(typedata.cellType == EnumTypeRelationName){
                    [mDic setObject:cell.tfEdit.text forKey:@"nickName"];
                }
                else if(typedata.cellType == EnumTypeHeight){
                    [mDic setObject:[NSString stringWithFormat:@"%.2f", [cell.tfEdit.text intValue]/100.0] forKey:@"height"];
                }
            }
        }
        
        [LCNetWorkBase postWithMethod:@"api/lover/save" Params:mDic Completion:^(int code, id content) {
            if(code){
                [UserAttentionModel loadLoverList:@"true" block:^(int code)  {
                    if(code == 1){
                        if(delegate && [delegate respondsToSelector:@selector(NotifyReloadData)]){
                            [delegate NotifyReloadData];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
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
    
    EditCellTypeData *typedata = [_data objectAtIndex:indexPath.row];
    [cell SetcontentData:typedata info:nil];
    if([userData isKindOfClass:[UserModel class]]){
        UserModel *model = (UserModel*)userData;
        if(typedata.cellType == EnumTypeAccount){
            cell.tfEdit.text = model.mobilePhoneNumber;
        }
        else if(typedata.cellType == EnumTypeUserName){
            cell.tfEdit.text = model.chineseName;
        }
        else if(typedata.cellType == EnumTypeSex){
            cell.tfEdit.text = model.sex;
        }
        else if(typedata.cellType == EnumTypeAge){
            if(model.birthDay != nil)
                cell.tfEdit.text = [NSString stringWithFormat:@"%d", [Util getAgeWithBirthday:model.birthDay]];
        }
        else if(typedata.cellType == EnumTypeAddress){
            cell.tfEdit.text = model.addr;
        }
        else if(typedata.cellType == EnumTypeMobile){
            cell.tfEdit.text = model.mobilePhoneNumber;
        }
        else if(typedata.cellType == EnumTypeRelationName){
            cell.tfEdit.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if(typedata.cellType == EnumTypeHeight){
            cell.tfEdit.keyboardType = UIKeyboardTypeNumberPad;
            cell.lbUnit.hidden = NO;
            cell.lbUnit.text = @"cm";
        }
    }
    else if ([userData isKindOfClass:[UserAttentionModel class]]){
        UserAttentionModel *model = (UserAttentionModel*)userData;
        if(typedata.cellType == EnumTypeUserName){
            cell.tfEdit.text = model.username;
        }
        else if(typedata.cellType == EnumTypeSex){
            cell.tfEdit.text = model.sex;
        }
        else if(typedata.cellType == EnumTypeAge){

            cell.tfEdit.text = model.age;
        }
        else if(typedata.cellType == EnumTypeAddress){
            cell.tfEdit.text = model.address;
            if(model.address == nil || [model.address length] == 0)
                cell.tfEdit.placeholder = @"必须填写";
        }
        else if(typedata.cellType == EnumTypeMobile){
            cell.tfEdit.keyboardType = UIKeyboardTypeNumberPad;
            cell.tfEdit.text = model.ringNum;
        }
        else if(typedata.cellType == EnumTypeRelationName){
            cell.tfEdit.text = model.relation;
            if(model.relation == nil || [model.relation length] == 0)
                cell.tfEdit.placeholder = @"如父亲，母亲";
        }
        else if(typedata.cellType == EnumTypeHeight){
            cell.tfEdit.text = [NSString stringWithFormat:@"%d", (int)([model.height floatValue] * 100)];
            cell.tfEdit.keyboardType = UIKeyboardTypeNumberPad;
            cell.lbUnit.hidden = NO;
            cell.lbUnit.text = @"cm";
        }
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
    
    EditUserTableviewCell *cell = (EditUserTableviewCell*)[_tableview cellForRowAtIndexPath:indexPath];//[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
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
    [_tableview reloadData];
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

@end
