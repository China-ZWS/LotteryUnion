//
//  NSMutableDictionary+PublicDomain.h
//  HCTProject
//
//  Created by 周文松 on 14-3-11.
//  Copyright (c) 2014年 talkweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PublicDomain)

/**
 *  @brief  设置请求公共域
 *
 *  @param action <#action description#>
 */
- (void)setPublicDomain:(NSInteger)action;
// MD5加密
NSString *md5(NSString* source);
@end
