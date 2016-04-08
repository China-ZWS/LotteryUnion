//
//  NSString+URL.m
//  233wangxiaoHD
//
//  Created by 周文松 on 13-12-5.
//  Copyright (c) 2013年 长沙 二三三网络科技有限公司. All rights reserved.
//

#import "NSString+URL.h"
//#import "UIDevice+IdentifierAddition.h"

NSString const *uKey = @"_talkweb";

@implementation NSString (URL)
- (NSString *)URLEncodedString
{
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    return encodedString;
}


+(NSString *)hasHttp:(NSString *)strURL
{
    if(![strURL hasPrefix:@"http"]){
        strURL =[NSString stringWithFormat:@"http://%@",strURL];
    }
    return strURL;
}

@end
