//
//  AdScrollView.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import "AdScrollView.h"
//#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "define.h"
#import "NewsDataModel.h"
#import "WebContentVC.h"
#import "NewProductOrder.h"
#import "NurseListVC.h"
#import "LoginVC.h"

#define UISCREENWIDTH  self.bounds.size.width//广告的宽度
#define UISCREENHEIGHT  self.bounds.size.height//广告的高度

#define HIGHT self.frame.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标

static CGFloat const chageImageTime = 5.0;

@interface AdScrollView (){
    NSMutableArray * titleUrlarray;
    NSMutableArray * titleArray;
    NSTimer *_autoScrollTimer;
}

@end

@implementation AdScrollView

#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
        self.delegate = self;
        
        self.backgroundColor = _COLOR(240, 240, 240);
        
         }
    return self;
}

#pragma mark - 设置广告所使用的图片(名字)
- (void)setNewsmodelArray:(NSArray *)models
{
    _NewsmodelArray = models;
    if([_NewsmodelArray count] == 0){
        return;
    }
    titleUrlarray =  [[NSMutableArray alloc]init];
    titleArray  =  [[NSMutableArray alloc]init];
    self.contentSize = CGSizeMake(UISCREENWIDTH * models.count,UISCREENHEIGHT);
    _pageControl.numberOfPages = [models count];
    for (int i = 0; i < models.count; i++) {
    
        //添加图片展示按钮
        NewsDataModel *item = [models objectAtIndex:i];
        [titleUrlarray addObject:item.news_url];
         [titleArray addObject:item.news_title];
        UIButton * imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:FormatImage_1(item.image_url, (int)self.frame.size.width * 2, (int)self.frame.size.height * 2)] forState:UIControlStateNormal placeholderImage:nil];
          imageView.tag = i;
        //添加点击事件
        [imageView addTarget:self action:@selector(clickPageImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageView];
        //添加标题栏
//        if (item.news_title.length>0) {
//           UILabel * lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(i * self.frame.size.width+5, self.frame.size.height-20.0, self.frame.size.width, 20.0)];
//            [lbltitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
//            [lbltitle setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
//
//             lbltitle.text =item.news_title;
//             lbltitle.backgroundColor = [UIColor clearColor];
//            [self addSubview:lbltitle];
//        }
        if (models.count>1) {
             if (!_autoScrollTimer) {
              _autoScrollTimer =[NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(switchFocusImageItems) userInfo:nil repeats:YES];
             }
        //[self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:chageImageTime];
        }
       

    }

}

- (void) clickPageImage:(UIButton*)sender
{
        NSLog(@"%ld",(long)sender.tag);

    
    NewsDataModel *model = [self.NewsmodelArray objectAtIndex:sender.tag];
    if(model.productType == 1){
        NurseListVC *vc = [[NurseListVC alloc] initWithProductId:model.productId];
        vc.NavTitle = model.news_title;
        vc.hidesBottomBarWhenPushed = YES;
        [_parentController.navigationController pushViewController:vc animated:YES];
    }
    else if (model.productType == 2){
        if(![UserModel sharedUserInfo].isLogin){
            LoginVC *loginvc = [[LoginVC alloc] initWithNibName:nil bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginvc];
            [_parentController.navigationController presentViewController:nav animated:YES completion:^{
                
            }];
        }else{
            FamilyProductModel *proModel = [[FamilyProductModel alloc] init];
            proModel.pId = model.productId;
            proModel.productName = model.news_title;
            NewProductOrder *vc = [[NewProductOrder alloc] initWIthFamilyProductModel:proModel];
            vc.hidesBottomBarWhenPushed = YES;
            vc.NavTitle = model.news_title;
            [_parentController.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        
        if (titleUrlarray!=nil && [titleUrlarray[sender.tag] length] > 0) {
            WebContentVC *vc = [[WebContentVC alloc] initWithTitle:titleArray[sender.tag]==nil?@"详情":titleArray[sender.tag] url:titleUrlarray[sender.tag]];
            vc.hidesBottomBarWhenPushed = YES;
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, titleUrlarray[sender.tag]];
            [vc loadInfoFromUrl: url];
            [_parentController.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)switchFocusImageItems
{
   // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = self.contentOffset.x + self.frame.size.width;
    [self moveToTargetPosition:targetX];
    
  //  [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:chageImageTime];
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
  //  NSLog(@"moveToTargetPosition : %f" , targetX);
    if (targetX >= self.contentSize.width) {
        targetX = 0.0;
    }
    
    [self setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    _pageControl.currentPage = (int)(self.contentOffset.x / self.frame.size.width);
}


#pragma mark - 创建pageControl,指定其显示样式
- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (PageControlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _NewsmodelArray.count;
    
    if (PageControlShowStyle == UIPageControlShowStyleLeft)
    {
        _pageControl.frame = CGRectMake(10, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    else if (PageControlShowStyle == UIPageControlShowStyleCenter)
    {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(UISCREENWIDTH/2.0, HIGHT+UISCREENHEIGHT - 10);
    }
    else
    {
        _pageControl.frame = CGRectMake( UISCREENWIDTH - 20*_pageControl.numberOfPages, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    _pageControl.currentPage = 0;
    
    _pageControl.enabled = NO;
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
}
//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}


//减速停止了时执行，手触摸时执行执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewDidEndDecelerating");
    //手动滑动时候暂停自动替换
    [_autoScrollTimer invalidate];
    _autoScrollTimer = nil;
      _autoScrollTimer =[NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(switchFocusImageItems) userInfo:nil repeats:YES];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

@end


