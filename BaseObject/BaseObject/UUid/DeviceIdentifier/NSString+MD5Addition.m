//
//  NSString+MD5Addition.m
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//

#import "NSString+MD5Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Addition)
- (NSString *) stringFromMD5:(NSString *)MD5Salt
{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [[self stringByAppendingString:MD5Salt]  UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned) strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString ;
}

@end
