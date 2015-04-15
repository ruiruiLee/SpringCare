//
//  UserAttentionVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface UserAttentionVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    
    UISearchBar *_searchBar;
    
    NSMutableArray *_attentionData;
    NSMutableArray *_applyData;
}


@end
