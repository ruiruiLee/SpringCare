//
//  EditUserTableviewCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCellTypeData.h"

@interface EditUserTableviewCell : UITableViewCell
{
    UILabel *_lbTite;
    UITextField *_tfEdit;
    UILabel *_lbLine;
    UIImageView *_imgUnflod;
}

@property (nonatomic ,strong) UITextField *tfEdit;
@property (nonatomic , assign) EditCellType cellType;
@property (nonatomic, strong) UILabel *lbUnit;
@property (nonatomic, strong) NSArray *layoutArray;

- (void) SetcontentData:(EditCellTypeData*) celldata info:(NSDictionary*) info;

@end
