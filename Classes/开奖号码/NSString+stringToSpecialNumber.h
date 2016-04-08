//
//  NSString+stringToSpecialNumber.h
//  HCTProject
//
//  Created by 周文松 on 12-4-9.
//  Copyright (c) 2014年 talkweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (stringToSpecialNumber)
+ (NSString *)stringToNumberWithDot:(CGFloat)number;
+ (NSString *)stringToNumber:(CGFloat)number;
@end
