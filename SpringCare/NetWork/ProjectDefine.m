//
//  ProjectDefine.m
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "ProjectDefine.h"

static ProjectDefine *prjDefine;

@implementation ProjectDefine

@synthesize TagList;
BOOL isFromSelf = NO;

+(ProjectDefine*)shareProjectDefine
{
    if(prjDefine==nil){
        isFromSelf = YES;
        prjDefine = [[ProjectDefine alloc] init];
        isFromSelf = NO;
    }
    return prjDefine;
}

-(ProjectDefine*)init
{
    self = [super init];
    if(self){
        TagList = [[NSMutableArray alloc] init];
    }
    return self;
}

+(id)alloc
{
    if(isFromSelf){
        return [super alloc];
    }
    else
        return nil;
}

+(BOOL)searchRequestTag:(NSString*)string
{
    NSMutableArray *list = prjDefine.TagList;
    for(int i=0; i< [list count]; i++){
        NSString *tag = [list objectAtIndex:i];
        if([tag isEqualToString:string]){
            return YES;
        }
    }
    return NO;
}

+(void)removeRequestTag:(NSString*)string
{
    NSMutableArray *list = prjDefine.TagList;
    for(int i=0; i< [list count]; i++){
        NSString *tag = [list objectAtIndex:i];
        if([tag isEqualToString:string]){
            [list removeObjectAtIndex:i];
        }
    }
}

+(void)addRequestTag:(NSString*)string
{
    NSMutableArray *list = prjDefine.TagList;
    [list addObject:string];
}

+(void)showMessageAutoHide:(NSString*)string
{
//    UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
//    [AlertView show];
}

+(void)showMessage:(NSString*)string
{
    
}

+(void)hideMessage:(NSString*)string
{
    
}


@end
