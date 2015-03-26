//
//  NurseListMainVC.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"
#import "NurseListInfoModel.h"

@interface NurseListMainVC : LCBaseVC<UITableViewDataSource, PullTableViewDelegate, UITableViewDelegate>
{
    BOOL _reloading;
    NurseListInfoModel *_model;
}

@property (nonatomic, strong) PullTableView *pullTableView;
@property (nonatomic, strong) NSMutableArray *DataList;

- (void) appendDataWithArray:(NSArray*)array;

@end
