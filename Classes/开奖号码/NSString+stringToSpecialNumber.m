//
//  NSString+stringToSpecialNumber.m
//  HCTProject
//
//  Created by 周文松 on 12-4-9.
//  Copyright (c) 2014年 talkweb. All rights reserved.
//

#import "NSString+stringToSpecialNumber.h"
#import <Foundation/Foundation.h>

@implementation NSString (stringToSpecialNumber)
+ (NSString *)stringToNumberWithDot:(CGFloat)number
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
    return formattedNumberString;
}
+ (NSString *)stringToNumber:(CGFloat)number
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
    return formattedNumberString;
}
@end
