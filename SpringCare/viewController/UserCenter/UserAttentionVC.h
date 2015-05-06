//
//  UserAttentionVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/6.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "UserAttentionTableCell.h"

@interface UserAttentionVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate>
{
    UITableView *_tableview;
    
    UISearchBar *_searchBar;
     UIImageView *backgroundImageView;
    NSMutableArray *_attentionData;
    NSMutableArray *_applyData;
    UIImage *photoimg;
}
@property (nonatomic, retain) UserAttentionTableCell * currentCell;
//@property (nonatomic, retain) UITableView *_tableview;
-(void)refreshTable;
@end
