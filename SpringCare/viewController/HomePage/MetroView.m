//
//  MetroView.m
//  SpringCare
//
//  Created by LiuZach on 15/6/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MetroView.h"
#import "FamilyProductModel.h"
#import "UIButton+WebCache.h"
#import "define.h"
#import "FamilyInfoButton.h"

@implementation MetroView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    
    return self;
}

- (void) AddDataList:(NSArray *)list
{
    int i = 0;
    while ( i < [list count]) {
        FamilyProductModel *model = [list objectAtIndex:i];
        FamilyInfoButton *btn = [[FamilyInfoButton alloc] initWithFrame:CGRectZero];
        [self addSubview:btn];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:ProductImage(model.image_url)] forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.7;
        btn.layer.borderColor = _COLOR(243, 243, 243).CGColor;
        btn.contentMode = UIViewContentModeScaleAspectFit;
        
        [self SetViewFrameWithIdx:i view:btn];
        
        i ++;
    }
}

- (void) SetViewFrameWithIdx:(NSInteger) index  view:(UIView *)view
{
    NSInteger viewCode = index % 10;
    NSInteger rows = index / 100;
    
    CGFloat itemwidth  = (ScreenWidth - 20)/2;
    CGFloat itemheight = 88 * itemwidth/150;
    CGFloat height = (itemheight + 4) * 6 * rows + 6;
    
    switch (viewCode) {
        case 0:
            view.frame = CGRectMake(8, height, itemwidth, itemheight * 2 + 4);
            self.contentSize = CGSizeMake(ScreenWidth, height + (itemheight + 4) * 2 + 4);
            break;
        case 1:
            view.frame = CGRectMake(12 + itemwidth, height, itemwidth, itemheight);
            break;
        case 2:
            view.frame = CGRectMake(12 + itemwidth, height + itemheight + 4, itemwidth, itemheight);
            break;
        case 3:
            view.frame = CGRectMake(8, height + (itemheight + 4) * 2, itemwidth, itemheight);
            self.contentSize = CGSizeMake(ScreenWidth, height + (itemheight + 4) * 3 + 4 );
            break;
        case 4:
            view.frame = CGRectMake(12 + itemwidth, height + (itemheight + 4) * 2, itemwidth, itemheight);
            break;
        case 5:
            view.frame = CGRectMake(8,  height + (itemheight + 4) * 3, itemwidth, itemheight);
            self.contentSize = CGSizeMake(ScreenWidth, height + (itemheight + 4) * 4 + 4 );
            break;
        case 6:
            view.frame = CGRectMake(12 + itemwidth,  height + (itemheight + 4) * 3, itemwidth, itemheight * 2 + 4);
            self.contentSize = CGSizeMake(ScreenWidth, height + (itemheight + 4) * 5 + 4 );
            break;
        case 7:
            view.frame = CGRectMake(8,  height + (itemheight + 4) * 4, itemwidth, itemheight);
            break;
        case 8:
            view.frame = CGRectMake(8,  height + (itemheight + 4) * 5, itemwidth, itemheight);
            self.contentSize = CGSizeMake(ScreenWidth, height + (itemheight + 4) * 6 + 4 );
            break;
        case 9:
            view.frame = CGRectMake(8,  height + (itemheight + 4) * 5, itemwidth, itemheight);
            break;
        default:
            break;
    }

}

@end
