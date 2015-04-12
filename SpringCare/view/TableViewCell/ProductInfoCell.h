//
//  ProductInfoCell.h
//  SpringCare
//
//  Created by LiuZach on 15/4/11.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoCell : UITableViewCell
{
    UIView *_bgView;
    UIImageView *_photoImgV;
    UILabel *_lbTitle;
    UILabel *_lbExplain;
}

@property (nonatomic, strong) UIView *_bgView;

- (void) SetContentWithDic:(NSDictionary*)dic;

@end
