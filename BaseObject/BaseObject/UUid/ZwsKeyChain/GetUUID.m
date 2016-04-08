//
//  GetUUID.m
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//

#import "GetUUID.h"

@implementation GetUUID

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //得到一个要搜索的字典；
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
//    //删除一个旧的item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //搜索词典添加新对象（注意：数据的格式）
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //添加项目到钥匙扣搜索字典
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
//    SecItemDelete(( CFDictionaryRef)keychainQuery);

    //设置搜索的配置
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        }
        @finally
        {
        
        }
    }
    return ret;

}
@end
