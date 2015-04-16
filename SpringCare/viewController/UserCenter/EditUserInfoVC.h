//
//  EditUserInfoVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/7.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCPickView.h"

@protocol EditUserInfoVCDelegate <NSObject>

- (void) NotifyReloadData;

@end

@interface EditUserInfoVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, LCPickViewDelegate>
{
    UITableView *_tableview;
    NSArray *_data;
    
    id  userData;
    
    LCPickView *_sexPick;
    LCPickView *_agePick;
    
    NSIndexPath *indexpathStore;
}

@property (nonatomic, assign) id<EditUserInfoVCDelegate> delegate;

- (void) setContentArray:(NSArray*)dataArray andmodel:(id) model;

@end
