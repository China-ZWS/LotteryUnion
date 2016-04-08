//
//  GetUUID.h
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUIDManager.h"

@interface GetUUID : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;//

+ (void)save:(NSString *)service data:(id)data ;

+ (id)load:(NSString *)service;//读取uuid ;

@end
