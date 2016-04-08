//
//  NSArray+Additions.h
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_ISHIDE @"is_hide"

@interface NSArray (Additions)

- (NSString *)componentsWeekDays;

- (NSString *)componentsJoinedByFormat:(NSString *)format;
- (NSString *)formatArrayByString:(NSString *)format joinedByString:(NSString *)str needSort:(BOOL)_sort;
- (NSString *)componentsMargeByString:(NSString *)string;
- (NSString *)getNumberStringByFormat:(NSString*)format joinedByString:(NSString *)joinString;

- (NSArray *)sort;
- (int)subCount;
- (int)subCountMax;
- (int)subTotalCount;
- (int)subCountAtIndex:(int)index;

// 保存大厅设置，array中包含隐藏彩种使使用
-(void)saveHallSetting;
// 保存大厅设置，array中不包含隐藏彩种使使用
-(void)saveHallSettingWithouHidedLottery;
// 加载大厅设置，包含隐藏和不隐藏的彩种
+(NSMutableArray*)loadHallSetting;
// 加载大厅设置，仅包含隐藏或不隐藏的彩种其中一种，YES:不包含隐藏彩种
+(NSMutableArray*)loadHallSettingWithoutHidedLottery:(BOOL)isWithout;
@end
