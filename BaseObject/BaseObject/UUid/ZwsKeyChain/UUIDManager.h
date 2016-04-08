//
//  UUIDManager.h
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUIDManager : NSObject

/**
 *   保存唯一标示符
 */
+(void)saveUUID:(NSString *)uuid;

/**
 *   读取唯一标示符
 */
+(NSString *)readUUID;

@end
