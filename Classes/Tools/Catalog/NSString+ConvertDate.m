//
//  NSString+ConvertDate.m
//  ydtctz
//
//  Created by 小宝 on 1/15/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "NSString+ConvertDate.h"

@implementation NSString (ConvertDate)

- (NSDate *)toNSDate {    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

- (NSDate *)toLongDate {    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [formatter dateFromString:self];
    return date;
}


- (NSString *)toFormatDateString {
    NSDate *date = [self toLongDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSLocale *local = [NSLocale currentLocale];
    [formatter setLocale:local];
    
    NSString *stringDate = [formatter stringFromDate:date];
    
    return stringDate;
}

- (NSString *)toFormatShortDateString {
    NSDate *date = [self toLongDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLocale *local = [NSLocale currentLocale];
    [formatter setLocale:local];
    
    NSString *stringDate = [formatter stringFromDate:date];
    
    return stringDate;
}
@end
