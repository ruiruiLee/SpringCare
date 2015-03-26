//
//  MessageInfoListVC.h
//  SpringCare
//  陪护时光
//  Created by LiuZach on 15/3/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"

@interface MessageInfoListVC : LCBaseVC<UITableViewDataSource, PullTableViewDelegate, UITableViewDelegate>
{
    BOOL _reloading;
}

@property (nonatomic, strong) PullTableView *pullTableView;
@property (nonatomic, strong) NSMutableArray *DataList;

- (void) appendDataWithArray:(NSArray*)array;

@end
