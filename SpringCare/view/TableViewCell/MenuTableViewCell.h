//
//  MenuTableViewCell.h
//  SpringCare
//
//  Created by LiuZach on 15/3/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UILabel *lbContent;
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UIImageView *imgUnflod;
@property (nonatomic, strong) UILabel *separatorLine;

@end
