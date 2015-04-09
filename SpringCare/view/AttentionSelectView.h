//
//  AttentionSelectView.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserAttentionModel.h"

@protocol AttentionSelectViewDelegate <NSObject>

- (void) ViewShutDown;
- (void) ViewSelectWithId:(NSString*) uid;

@end

@interface AttentionSelectView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableview;
    UILabel *_lbTitle;
    UIButton *_btnShut;
    
    NSArray *attentionArray;
}

@property (nonatomic, assign) id<AttentionSelectViewDelegate> delegate;

@end
