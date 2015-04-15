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
#import "LCNetWorkBase.h"

@interface EditUserInfoVC ()

@end

@implementation EditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"编辑我的资料";
    
    [self.NavigationBar.btnLeft setImage:[UIImage imageNamed:@"nav_shut"] forState:UIControlStateNormal];
    [self.NavigationBar.btnRight setTitle:@"完成" forState:UIControlStateNormal];
    self.NavigationBar.btnRight.hidden = NO;
    self.NavigationBar.btnRight.layer.cornerRadius = 8;
    self.NavigationBar.btnRight.backgroundColor = [UIColor whiteColor];
    [self.NavigationBar.btnRight setTitleColor:Abled_Color forState:UIControlStateNormal];
    self.NavigationBar.btnRight.titleLabel.font = _FONT(16);
    
    [self initSubViews];
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
        
        for (int i = 1; i < [_data count]; i++) {
            EditCellTypeData *typedata = [_data objectAtIndex:i];
            EditUserTableviewCell *cell = (EditUserTableviewCell*)[_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(cell.tfEdit.text != nil){
                if(typedata.cellType == EnumTypeUserName){
                    [mDic setObject:cell.tfEdit.text forKey:@"chineseName"];
                }
                else if(typedata.cellType == EnumTypeSex){
                    UserSex sex = [cell.tfEdit.text isEqualToString:@"女"] ? EnumFemale: EnumMale;
                    [mDic setObject:[NSNumber numberWithBool:sex] forKey:@"chineseName"];
                }
                else if(typedata.cellType == EnumTypeAge){
                    NSString *age = cell.tfEdit.text;
                    NSDate *date = [NSDate date];
                    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
                    int year = (int)[comps year];
                    [mDic setObject:[NSString stringWithFormat:@"%d-01-01 00:00:00", year - [age intValue]] forKey:@"birthDay"];
                }
                else if(typedata.cellType == EnumTypeAddress){
                    [mDic setObject:cell.tfEdit.text forKey:@"addr"];
                }
                else if(typedata.cellType == EnumTypeMobile){
                    [mDic setObject:cell.tfEdit.text forKey:@"phone"];
                }
//                else if(typedata.cellType == EnumTypeRelationName){
//                    //            cell.tfEdit.text = model.;
//                }
//                else if(typedata.cellType == EnumTypeHeight){
//                    //            cell.tfEdit.text = userData.username;
//                }
            }
        }
        
        [LCNetWorkBase postWithMethod:@"api/register/geo" Params:mDic Completion:^(int code, id content) {
            if(code){
                [[UserModel sharedUserInfo] getDetailUserInfo];
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
    
    EditCellTypeData *typedata = [_data objectAtIndex:indexPath.row];
    [cell SetcontentData:typedata info:nil];
    if([userData isKindOfClass:[UserModel class]]){
        UserModel *model = (UserModel*)userData;
        if(typedata.cellType == EnumTypeAccount){
            cell.tfEdit.text = model.username;
        }
        else if(typedata.cellType == EnumTypeUserName){
            cell.tfEdit.text = model.chineseName;
        }
        else if(typedata.cellType == EnumTypeSex){
            cell.tfEdit.text = (model.sex == 0)? @"女": @"男";
        }
        else if(typedata.cellType == EnumTypeAge){
            cell.tfEdit.text = model.birthDay;
        }
        else if(typedata.cellType == EnumTypeAddress){
            cell.tfEdit.text = model.addr;
        }
        else if(typedata.cellType == EnumTypeMobile){
            cell.tfEdit.text = model.mobilePhoneNumber;
        }
        else if(typedata.cellType == EnumTypeRelationName){
//            cell.tfEdit.text = model.;
        }
        else if(typedata.cellType == EnumTypeHeight){
//            cell.tfEdit.text = userData.username;
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
    
    EditUserTableviewCell *cell = (EditUserTableviewCell*)[_tableview cellForRowAtIndexPath:indexPath];;//[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
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
    EditUserTableviewCell *cell = (EditUserTableviewCell*)[_tableview cellForRowAtIndexPath:indexpathStore];//[_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexpathStore];
    
    if(pickView == _sexPick){
        cell.tfEdit.text = resultString;
    }
    
    else if (pickView == _agePick){
        NSDate *date =  [Util convertDateFromString:[resultString substringToIndex:13]];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
        int year = (int)[comps year];
        
        comps  = [calendar components:unitFlags fromDate:[NSDate date]];
        int year1 = (int)[comps year];
        
        cell.tfEdit.text = [NSString stringWithFormat:@"%d", year1 - year];
    }
}

@end
