//
//  NSMutableDictionary+PublicDomain.m
//  HCTProject
//
//  Created by 周文松 on 14-3-11.
//  Copyright (c) 2014年 talkweb. All rights reserved.
//

#import "NSMutableDictionary+PublicDomain.h"
#import <CommonCrypto/CommonDigest.h>



@implementation NSMutableDictionary (PublicDomain)


#pragma mark - 公共域
- (void)setPublicDomain:(NSInteger)action;
{
    NSString *timestamp = [self getTimestamp];// 获取时间戳
    NSString *requestId = [self getRequestId:timestamp]; //获取请求id
//    [self setObject:action forKey:@"action"]; //添加获取ID
    [self setObject:requestId forKey:@"id"]; //添加获取ID
    [self setObject:timestamp forKey:@"reqtimestamp"]; // 添加时间戳
    [self setObject:kTerminal_no forKey:@"terminal_no"]; // 添加终端编号
    [self setObject:[self getSign:timestamp requestId:requestId] forKey:@"sign"]; // 添加请求消息的数字签名
    [self setObject:kSp_id forKey:@"sp_id"]; // 添加渠道编号
}

#pragma mark - 获取时间戳
- (NSString *)getTimestamp
{
    /*
     yyyyMMddHHmmss  时间默认格式
     */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:[NSDate date]];
}



#pragma mark - 获取请求id
- (NSString *)getRequestId:(NSString *)timestamp
{
    /*
     yyyyMMddHHmmss+请求序列号
     请求序列号，从1开始计数，步长为1，最大取值为9999，循环使用。固定长度4个字符，不足位左边补0
     */
    static int i = 1;
  
    // id == 请求流水号
    NSString *requestId = [NSString stringWithFormat:@"%@%04d",timestamp,i];
    i++;
    if (i >= 9999) {
        i = 0;
    }
    return requestId;
}

#pragma mark - 获取请求消息的数字签名
- (NSString *)getSign:(NSString *)timestamp requestId:(NSString *)requestId
{
    /*
     md5（id+ reqtimestamp +terminal_no+盐值）
     */
    return md5([NSString stringWithFormat:@"%@%@%@",requestId,timestamp,kTerminal_no]);
}


NSString *md5(NSString* source){
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    source = [source stringByAppendingString:MD5_MARCO];
    CC_MD5([source UTF8String], (int)[source length], digest);
    NSMutableString *result = [NSMutableString string];
    for (i=0;i<CC_MD5_DIGEST_LENGTH;i++) {
        [result appendFormat: @"%02x", (int)(digest[i])];
    }
    return result;
}

/*
- (NSString *) setUuidMd5
{
    NSString * uuIdMd5 = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    return uuIdMd5;
}
 */


@end
