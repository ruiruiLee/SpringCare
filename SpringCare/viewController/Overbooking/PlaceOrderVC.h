//
//  PlaceOrderVC.h
//  SpringCare
//  下单
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PlaceOrderEditCell.h"
#import "HBImageViewList.h"

@class NurseListInfoModel;

@interface PlaceOrderVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, PlaceOrderEditCellDelegate>
{
    UITableView *_tableview;
    
    UIImageView *_photoImage;
    UILabel *_lbName;
    UIButton *_btnCert;
    UIButton *_btnInfo;
    UIImageView *_imgvLogo;
    UILabel *_detailInfo;
    UIButton *_btnUnfold;
    
    UILabel *lbActualPay;
    
    NSArray *headerViewHeightConstraint;
    
    HBImageViewList *_imageList;
}
@property (strong, nonatomic) NSString *payValue;
- (id) initWithModel:(NurseListInfoModel*) model andproductId:(NSString*)productId;

@end
