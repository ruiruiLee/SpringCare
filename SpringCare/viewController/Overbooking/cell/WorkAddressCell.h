//
//  WorkAddressCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/16.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkAddressCell : UITableViewCell
{
    UIImageView *_photoImage;
    UIButton *_btnRelationAndSex;
    UILabel *_lbName;
    UILabel *_lbAddress;
    UIButton *_btnSelect;
    UILabel *_line;
}

- (void) setContentWithModel:(id) model;

@end
