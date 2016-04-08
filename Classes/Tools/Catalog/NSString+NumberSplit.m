//
//  NSString+NumberSplit.m
//  ydtctz
//
//  Created by liuchan on 1/18/12.
//  Copyright (c) 2012 DoMobile. All rights reserved.
//

#import "NSString+NumberSplit.h"

@implementation NSString (NumberSplit)

- (NSString *)trimWhiteSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)componentsSepartedByString:(NSString *)aStr length:(NSUInteger)length {
    NSMutableArray *scanner = [NSMutableArray array];
    int count = (int)[self length];
    for (int i = 0; i < count; i += length) {
        int curNumber;
        NSRange range;
        range.length = length;
        range.location = i;
#warning 3.12号改
        if (range.length + range.location > count) {
            range.length --;
        }
        [[NSScanner scannerWithString:[self substringWithRange:range]] scanInt:&curNumber];
        
        [scanner addObject:[NSNumber numberWithInt:curNumber]];
    }
    NSString *format = [NSString stringWithFormat:@"0%dd%@",(int)length,aStr];
    return [scanner componentsJoinedByFormat:[NSString stringWithFormat:@"%%%@",format]];
}

/* length为长度拆分成数组 */
- (NSArray *)splitToNumberArrayByLength:(NSUInteger)length {
    NSMutableArray *cArray = [NSMutableArray array];
    int count = (int)[self length];
    for (int i = 0; i < count; i += length) {
        int curNumber;
        NSRange range;
        range.length = length;
        range.location = i;
        [[NSScanner scannerWithString:[self substringWithRange:range]] scanInt:&curNumber];
        
        [cArray addObject:[NSNumber numberWithInt:curNumber]];
    }

    return cArray;
}

/* length为长度拆分成数组 */
- (NSArray *)splitToStringArrayByLength:(NSUInteger)length {
    NSMutableArray *cArray = [NSMutableArray array];
    int count = (int)[self length];
    NSRange range;
    
    for (int i = 0; i < count; i += length) {
        range.length = length;
        range.location = i;
        
        [cArray addObject:[self substringWithRange:range]];
    }
    
    return cArray;
}

/* 拆分胆拖 */
- (NSDictionary *)splitDantuo {
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    @try {
        
        NSArray *all_num = [self componentsSeparatedByString:@"#"];
        NSString *qian0 = [[[all_num objectAtIndex:0] componentsSeparatedByString:@"A"] objectAtIndex:0];
        NSString *qian1 = [[[all_num objectAtIndex:0] componentsSeparatedByString:@"A"] objectAtIndex:1];

        NSString *hou0 = [[[all_num objectAtIndex:1] componentsSeparatedByString:@"A"] objectAtIndex:0];
        NSString *hou1 = [[[all_num objectAtIndex:1] componentsSeparatedByString:@"A"] objectAtIndex:1];
        

        [aDict setValue:[qian0 componentsSepartedByString:@" " length:2] forKey:@"qianqu_dan"];
        [aDict setValue:[qian1 componentsSepartedByString:@" " length:2] forKey:@"qianqu_tuo"];
        [aDict setValue:[hou0 componentsSepartedByString:@" " length:2] forKey:@"houqu_dan"];
        [aDict setValue:[hou1 componentsSepartedByString:@" " length:2] forKey:@"houqu_tuo"];
    } @catch (NSException *exception) {
    }
    
    return aDict;
}

//拆分双色球胆拖
- (NSDictionary *)splitDantuoS {
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    @try {
        
        NSArray *all_num = [self componentsSeparatedByString:@"#"];
        NSString *qian0 = [all_num  objectAtIndex:0];
        NSString *qian1 = [all_num  objectAtIndex:1];
        NSString *hou = [all_num  objectAtIndex:2];
        
        
        [aDict setValue:[qian0 componentsSepartedByString:@" " length:2] forKey:@"qianqu_dan"];
        [aDict setValue:[qian1 componentsSepartedByString:@" " length:2] forKey:@"qianqu_tuo"];
        [aDict setValue:[hou componentsSepartedByString:@" " length:2] forKey:@"houqu_dan"];
    } @catch (NSException *exception) {
    }
    
    return aDict;
}

- (NSString *)replaceStringBy:(NSString *)sor withString:(NSString*)dest {
    NSString *result = [self stringByReplacingOccurrencesOfString:sor withString:dest];
    if ([result rangeOfString:sor].length > 0)
        return [self replaceStringBy:sor withString:dest];

    return result;
}

- (NSString *)replaceAll:(NSString *)regexStr withString:(NSString*)dest {
    NSString *result = self;
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    
    if (regex) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:result options:0     range:NSMakeRange(0, result.length)];
        
        while (firstMatch) {
            NSRange range = [firstMatch rangeAtIndex:0];
            result = [result stringByReplacingCharactersInRange:range withString:dest];
            firstMatch = [regex firstMatchInString:result options:0 range:NSMakeRange(0, result.length)];
        }
    }
    return result;
}

/* 删除末尾与src相同的字符 */
- (NSString *)removeLastString:(NSString*)src {
    if(self.length < src.length)
        return self;

    NSString *last = [self substringFromIndex:self.length-src.length];
    if([src isEqualToString:last]){
        return [self substringToIndex:self.length-src.length];
    }
    
    return self;
}

// 组合字符串，
- (NSString *)commonString:(NSString *)str length:(int)len
{
    if(self.length<1)
        return self;
    
    NSMutableString *result = [NSMutableString string];
    for (int index=0; index<self.length; ) {
        if(index+len >= self.length) {
            // 余下字符已不足len或刚好，则加上余下的字符
            [result appendString:[self substringFromIndex:index]];
            break;
        }
        
        NSRange range = NSMakeRange(index, len);
        NSString *newStr = [self substringWithRange:range];
        [result appendFormat:@"%@%@",newStr,str];
        index += len;
    }
    
    return result;
}

- (BOOL)isAllDigits {
    NSCharacterSet* cs = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet:cs];
    return r.location == NSNotFound;
}

// 判断是否是邮箱
- (BOOL)isAllInvalidEmailString {
    NSMutableCharacterSet *mcs = [[NSMutableCharacterSet alloc] init];
    [mcs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [mcs formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    [mcs addCharactersInString:@".@_"];
    NSRange r = [self rangeOfCharacterFromSet:[mcs invertedSet]];
    return r.location == NSNotFound;
}

- (BOOL)isAllInCharacterSet:(NSCharacterSet*)cs {
    NSRange r = [self rangeOfCharacterFromSet:cs.invertedSet];
    return r.location == NSNotFound;
}
@end
