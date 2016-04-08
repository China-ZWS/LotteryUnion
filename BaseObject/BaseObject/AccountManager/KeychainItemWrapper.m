//
//  KeychainItemWrapper.m
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//


#import "KeychainItemWrapper.h"

@implementation KeychainItemWrapper


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            nil];
    //    ( id)kSecAttrAccessibleAfterFirstUnlock,( id)kSecAttrAccessible,
    //    service, ( id)kSecAttrService,
    
}

+ (void)write:(NSString *)service data:(id)data
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);

}

+ (void)deleteInformation:service;
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);

}



+ (id)read:(NSString *)service;
{
    id ret = nil;

    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFDataRef passwordData = NULL;
    OSStatus s = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&passwordData);
    if (s == noErr)
    {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)passwordData];

    }
    
    return ret;
}

@end
