//
//  NSString+NumberSplit.h
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Additions.h"

@interface NSString (NumberSplit)
- (NSString *)trimWhiteSpace;
- (NSString *)componentsSepartedByString:(NSString *)aStr length:(NSUInteger)length;
- (NSDictionary *)splitDantuo;
- (NSString *)replaceStringBy:(NSString *)sor withString:(NSString*)dest;
- (NSArray *)splitToNumberArrayByLength:(NSUInteger)length;
- (NSArray *)splitToStringArrayByLength:(NSUInteger)length;
- (NSDictionary *)splitDantuoS;

// 每隔len个字符之间添加str
- (NSString *)commonString:(NSString *)str length:(int)len;

/* 删除末尾与src相同的字符 */
- (NSString *)removeLastString:(NSString*)src;

/* 正则表达式替换字符串 */
- (NSString *)replaceAll:(NSString *)regexStr withString:(NSString*)dest;

- (BOOL)isAllDigits;
- (BOOL)isAllInvalidEmailString;
- (BOOL)isAllInCharacterSet:(NSCharacterSet*)cs;
@end
