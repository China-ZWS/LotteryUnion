//
//  KeychainItemWrapper.h
//  TalkWeb
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainItemWrapper : NSObject

+ (void)write:(NSString *)service data:(id)data ;
+ (id)read:(NSString *)service;
+ (void)deleteInformation:service;

@end
