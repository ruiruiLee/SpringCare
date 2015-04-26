//
//  WorkAddressSelectVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/16.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "EditUserInfoVC.h"
#import "UserAttentionModel.h"

@class WorkAddressSelectVC;

@protocol WorkAddressSelectVCDelegate <NSObject>

- (void) NotifyAddressSelected:(WorkAddressSelectVC*) selectVC model:(UserAttentionModel*) model;

@end

@interface WorkAddressSelectVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, EditUserInfoVCDelegate>
{
    UITableView *_tableview;
    
    NSArray *_dataList;
    
    NSString *selectLoverId;
    UserAttentionModel * SelectModel;
}
@property (nonatomic, copy) NSString * currentAdress;
@property (nonatomic, assign) id<WorkAddressSelectVCDelegate> delegate;


- (void) setSelectItemWithLoverId:(NSString*) loverId;

@end
