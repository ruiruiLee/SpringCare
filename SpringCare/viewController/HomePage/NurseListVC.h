//
//  NurseListVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"
#import "NurseListInfoModel.h"
#import "NurseIntroTableCell.h"
#import "DOPDropDownMenu.h"

@interface NurseListVC : LCBaseVC<UITableViewDataSource, PullTableViewDelegate, UITableViewDelegate, UISearchBarDelegate, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

{
    BOOL _reloading;
    NurseListInfoModel *_model;
    NSMutableDictionary *parmas;
    UISearchBar *searchBar;
    
    NSString *_SearchConditionStr;
    
    NSString *_productId;
    
    NSInteger pages;
    
    NSString *showAllCare;
}

@property (nonatomic, strong) PullTableView *pullTableView;
@property (nonatomic, strong) NSMutableArray *DataList;
@property (nonatomic, strong) NurseIntroTableCell *prototypeCell;

@property (nonatomic, copy) NSArray *prices;
@property (nonatomic, copy) NSArray *ages;
@property (nonatomic, copy) NSArray *goodes;
@property (nonatomic, copy) NSArray *filter;


- (void) appendDataWithArray:(NSArray*)array;

- (id) initWithProductId:(NSString*)pid;

@end
