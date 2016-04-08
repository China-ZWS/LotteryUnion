//
//  NSString+Regex.m
//  01 Regex
//
//  Created by wei.chen on 15/4/10.
//  Copyright (c) 2015年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (NSArray *)findStringByRegex:(NSString *)regex {
    
    //2.创建正则表达式实现对象
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    //3. expression  查找符合正则表达式的字符串
    NSArray *items = [expression matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    //4.循环遍历查找出来的结果
    for (NSTextCheckingResult *result in items) {
        
        //符合表达的字符串的范围
        NSRange range = [result range];
        
        NSString *matchString = [self substringWithRange:range];
        [itemArray addObject:matchString];
    }
    
    return itemArray;
}

@end
