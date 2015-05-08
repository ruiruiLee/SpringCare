//
//  NurseListMainVC.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "MainBaseVC.h"
#import "PullTableView.h"
#import "NurseListInfoModel.h"
#import "NurseIntroTableCell.h"
#import "DOPDropDownMenu.h"

@interface NurseListMainVC : MainBaseVC<UITableViewDataSource, PullTableViewDelegate, UITableViewDelegate, UISearchBarDelegate, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>
{
    BOOL _reloading;
    NurseListInfoModel *_model;
    NSMutableDictionary *parmas;
    UISearchBar *searchBar;
    
    NSString *_SearchConditionStr;
    
    NSInteger pages;
    
    DOPDropDownMenu *menu;
}

@property (nonatomic, strong) PullTableView *pullTableView;
@property (nonatomic, strong) NSMutableArray *DataList;
@property (nonatomic, strong) NurseIntroTableCell *prototypeCell;

@property (nonatomic, copy) NSArray *prices;
@property (nonatomic, copy) NSArray *ages;
@property (nonatomic, copy) NSArray *goodes;


- (void) appendDataWithArray:(NSArray*)array;
- (void) LoadDataList;

@end
