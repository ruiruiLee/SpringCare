//
//  LCRefreshTableVC.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "LCBaseVC.h"
#import "EGORefreshTableHeaderView.h"

@interface LCRefreshTableVC : LCBaseVC<EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, strong, readonly) EGORefreshTableHeaderView *TableHeader;
@property (nonatomic, strong, readonly) EGORefreshTableHeaderView *TableFppter;
@property (nonatomic, strong, readonly) UITableView *ListView;

@end
