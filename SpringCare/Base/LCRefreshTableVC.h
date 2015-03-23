//
//  LCRefreshTableVC.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"

@interface LCRefreshTableVC : LCBaseVC<UITableViewDataSource, PullTableViewDelegate>
{
    BOOL _reloading;
}

@property (nonatomic, strong) PullTableView *pullTableView;
@property (nonatomic, strong) NSMutableArray *DataList;

- (void) appendDataWithArray:(NSArray*)array;

@end
