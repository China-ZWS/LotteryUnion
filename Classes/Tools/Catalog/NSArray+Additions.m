//
//  NSArray+Additions.m
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "NSArray+Additions.h"

#define HALL_SETTING @"hall_setting.plist"

@implementation NSArray (Additions)

- (NSArray *)sort
{
    return [self sortedArrayUsingSelector:@selector(compare:)];
}

-(NSString *)componentsWeekDays
{
    int count = (int)[self count];
    NSMutableString *mStr = [NSMutableString stringWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        if(i != 0)
            [mStr appendString:@","];
        int value = [[self objectAtIndex:i] intValue];
#warning 修改
        /*
        [mStr appendString:[getWeekdayArray() objectAtIndex:value]];
         */
    }
    return mStr;
}

- (NSString *)componentsJoinedByFormat:(NSString *)format
{
    int count = (int)[self count];
    NSMutableString *mStr = [NSMutableString stringWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        [mStr appendFormat:format,[[self objectAtIndex:i] intValue]];
    }
    return mStr;
}

// 将数组变成字符串
- (NSString *)getNumberStringByFormat:(NSString*)format
                       joinedByString:(NSString *)joinString
{
    int count = (int)[self count];
    NSMutableString *mStr = [NSMutableString stringWithCapacity:count];
    for (int i = 0; i < count; i ++)
    {
        NSString *_format = [NSString stringWithFormat:@"%@%@",format,joinString];
        [mStr appendFormat:_format,[[self objectAtIndex:i] intValue]];
    }
    return mStr;

}

- (NSString *)componentsMargeByString:(NSString *)string {
    int count = (int)[self count];
    NSMutableString *mStr = [NSMutableString stringWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        [mStr appendString:[NSString stringWithFormat:@"%@%@",[self objectAtIndex:i],string]];
    }
    return mStr;
}

// 数组转化为字符串（第一个参数）
- (NSString *)formatArrayByString:(NSString *)format
                   joinedByString:(NSString *)str needSort:(BOOL)_sort {
    int count = (int)[self count];
    if (count == 0) return NULL;
    NSMutableString *mStr = [NSMutableString stringWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        NSString *subArray = NULL;
        if ([self[i] isKindOfClass:[NSArray class]]) {
            if (_sort)
                subArray = [[self[i] sort] componentsJoinedByFormat:format];
            else
                subArray = [self[i] componentsJoinedByFormat:format];

        }
        
        [mStr appendFormat:@"%@%@",subArray,str];
    }
    int length = 0;
    if ([str length] == 0) length = (int)[mStr length];
    else length = (int)[mStr length] - 1;
    
    return [mStr substringToIndex:length];
    
}

- (int)subCount {
    int result = 100;
    for (int i = 0; i < [self count]; i ++) {
        int count = (int)[[self objectAtIndex:i] count];
        if (count < result)
            result = count;
    }
    
    return result;
}

- (int)subCountMax {
    int result = 0;
    for (int i = 0; i < [self count]; i ++) {
        int count = (int)[[self objectAtIndex:i] count];
        if (count > result)
            result = count;
    }
    
    return result;
}

- (int)subCountAtIndex:(int)index {
    return (int)[[self objectAtIndex:index] count];
}

- (int)subTotalCount {
    int result = 0;
    for (int i = 0; i < [self count]; i ++) {
        int count = (int)[[self objectAtIndex:i] count];
        if (count > 0)
            result ++;
    }
    
    return result;
}

/* 大厅彩种显示、排序的配置 */  // 获取（hall_setting.plist）的路径
+(NSString*)getHallSettingFile
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:HALL_SETTING];
}

// 保存大厅彩种设置
-(void)saveHallSetting
{
    [self writeToFile:[NSArray getHallSettingFile] atomically:YES];
}

// 保存大厅移动后的的cell的顺序
-(void)saveHallSettingWithouHidedLottery {
    NSMutableArray *destArray = [self mutableCopy];
    [destArray addObjectsFromArray:[NSArray loadHallSettingWithoutHidedLottery:NO]];
    // 将改好的数组写入文件
    [destArray writeToFile:[NSArray getHallSettingFile] atomically:YES];
}

// 加载大厅设置，包含隐藏与非隐藏彩种
+(NSMutableArray*)loadHallSetting {
    NSString *file = [NSArray getHallSettingFile];
    if(![[NSFileManager defaultManager] fileExistsAtPath:file])
        file = [[NSBundle mainBundle] pathForResource:@"hall_setting" ofType:@"plist"];
//    [SDKBundle() pathForResource:@"hall_setting"
//                          ofType:@"plist"];
    NSMutableArray *lots = [NSMutableArray arrayWithContentsOfFile:file];
    
    // 移除服务器隐藏的彩种
    NSString *hide_pks = [NS_USERDEFAULT objectForKey:pk_hide_lotteries];
    
#warning 缺少依赖文件
    /*
    if(isValidateStr(hide_pks)) {
        NSArray *lotsCopy = [lots copy];
        NSArray *hs = [hide_pks componentsSeparatedByString:@","];
        for (NSString *pk in hs) {
            if(!isValidateStr(pk)) continue;
            for (NSDictionary *dict in lotsCopy) {
                NSString *lotPK = dict[@"lottery_pk"];
                if([pk intValue] == [lotPK intValue]) {
                    [lots removeObject:dict];
                    continue;
                }
            }
        }
    }
    */
    return lots;
}

// 加载大厅配置
// isWithout为YES时，只加载非隐藏的彩种
// isWithout为NO时，只加载隐藏的彩种
+(NSMutableArray*)loadHallSettingWithoutHidedLottery:(BOOL)isWithout {
    NSString *file = [NSArray getHallSettingFile];
    if(![[NSFileManager defaultManager] fileExistsAtPath:file])
        
        file = [[NSBundle mainBundle] pathForResource:@"hall_setting" ofType:@"plist"];
//    [SDKBundle() pathForResource:@"hall_setting"
//                          ofType:@"plist"];
    
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:file];
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        if(isWithout && ![[dict objectForKey:KEY_ISHIDE] boolValue])
            [result addObject:dict];
        if(!isWithout && [[dict objectForKey:KEY_ISHIDE] boolValue])
            [result addObject:dict];
    }
    
    // 移除服务器隐藏的彩种
    NSString *hide_pks = [NS_USERDEFAULT objectForKey:pk_hide_lotteries];
#warning 缺少依赖文件
  /*
    if(isValidateStr(hide_pks)) {
        NSArray *lotsCopy = [result copy];
        NSArray *hs = [hide_pks componentsSeparatedByString:@","];
        for (NSString *pk in hs) {
            NSLog(@"LotPK::::%@",pk);
            if(!isValidateStr(pk)) continue;
            for (NSDictionary *dict in lotsCopy) {
                NSString *lotPK = dict[@"lottery_pk"];
                if([pk intValue] == [lotPK intValue]) {
                    [result removeObject:dict];
                    continue;
                }
            }
        }
    }
  */
    return result;
}

@end
