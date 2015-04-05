//
//  LCMenuViewController.h
//  SpringCare
//
//  Created by LiuZach on 15/3/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *_imgViewBg;
    UITableView *tableview;
    
    UIImageView *_photoBg;
    UIImageView *_photoImgView;
    UIButton *_btnUserName;
    UIImageView *_imgUnflod;
    
    NSArray *unflodConstraints;
    UIImageView *_headerView;
    
    UIImageView *_imgLogo;
    UIButton *_btnHotLine;
}

@end
