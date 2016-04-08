//
//  DataConfigManager.m
//  NetSchool
//
//  Created by 周文松 on 15/8/28.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "DataConfigManager.h"

@implementation DataConfigManager
+ (NSDictionary *)returnRoot;
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *root=[[NSDictionary alloc] initWithContentsOfFile:path];
    return root;

}

+ (NSArray *)getMainConfigList;
{
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"MainList"]];
    return data;
}

+ (NSArray *)getTabList
{
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"MainTab"]];
    return data;
}

+ (NSArray *)getMoreList
{
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"MoreDatas"]];
    return data;
}


+ (NSArray *)getLottery_JCZQ;
{
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"Lottery_JCZQ"]];
    return data;
}

+ (NSDictionary *)returnRootJJZC;
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"JJZC_BettingNum" ofType:@"plist"];
    NSDictionary *root=[[NSDictionary alloc] initWithContentsOfFile:path];
    return root;
}


+ (NSDictionary *)getFB_bettingPlay:(NSInteger)bettingNum;
{
    if (bettingNum > 8) {
        bettingNum = 8;
    }
    NSDictionary * root = [self returnRootJJZC];
    NSDictionary *data=[[NSDictionary alloc] initWithDictionary:[root objectForKey:[NSString stringWithFormat:@"%d",bettingNum]]];
    
    return data;
}


@end
