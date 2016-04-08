//
//  keychainItemManager.h
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface keychainItemManager : NSObject

+ (void)writePassWord:(NSString *)passWord;
+ (void)writePhoneNum:(NSString *)PhoneNum;
+ (void)writeSessionId:(NSString *)sessionId;
+ (void)writehasSupplyPwd:(id )hasSupplyPwd;
+ (void)writeUserID:(NSString *)userID;


+ (void)deleteSessionId;
+ (void)deletePassWord;
+ (void)deleteHasSupplyPwd;
+ (void)deleteUserId;


+(id)readPassWord;
+(id)readPhoneNum;
+(id)readSessionId;
+(id)readHasSupplyPwd;
+(id)readUserID;


@end
