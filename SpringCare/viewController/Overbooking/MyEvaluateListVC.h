//
//  MyEvaluateListVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"
#import "EvaluateDataModel.h"

@interface MyEvaluateListVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
{
    PullTableView *_tableview;
    NSString *_SearchConditionStr;
    UILabel *lbTitle;
    
    NSInteger pages;
    NSInteger totals;
    
    CareEvaluateInfoModel *_careModel;
}

@property (nonatomic, strong) PullTableView *tableview;
@property (nonatomic, strong) NSMutableArray *DataList;

- (id) initVCWithNurseId:(NSString *) nurseId;

@end
