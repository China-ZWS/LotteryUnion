//
//  UUIDManager.m
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//

#import "UUIDManager.h"
#import "GetUUID.h"

static NSString * const KEY_IN_KEYCHAIN = @"com.talkweb.www";
static NSString * const KEY_UUID = @"com.talkweb.www.uuid";

@implementation UUIDManager

/**
 *   保存唯一标示符
 */
+(void)saveUUID:(NSString *)uuid
{
    NSMutableDictionary *userUuidKVPairs = [NSMutableDictionary dictionary];
    [userUuidKVPairs setObject:uuid forKey:KEY_UUID];
    [GetUUID save:KEY_IN_KEYCHAIN data:userUuidKVPairs];
}

/**
 *   读取唯一标示符
 */
+(NSString *)readUUID
{
    NSMutableDictionary *userUuidKVPairs = (NSMutableDictionary *)[GetUUID load:KEY_IN_KEYCHAIN];
    
    if (userUuidKVPairs == nil )//如果返回的为nil，就从新存储uuid;
    {
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        [self saveUuid:cfuuidString];
        CFRelease(cfuuid);
    }
    
    return [userUuidKVPairs objectForKey:KEY_UUID];//返回需要的uuid;
}
@end
