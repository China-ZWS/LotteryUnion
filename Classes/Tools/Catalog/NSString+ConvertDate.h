//
//  NSString+ConvertDate.h
//  ydtctz
//
//  Created by 小宝 on 1/15/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ConvertDate)
- (NSDate *)toNSDate;
- (NSString *)toFormatDateString;
- (NSDate *)toLongDate;
- (NSString *)toFormatShortDateString;


@end
