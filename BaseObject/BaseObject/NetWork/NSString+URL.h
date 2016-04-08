//
//  NSString+URL.h
//  233wangxiaoHD
//
//  Created by 周文松 on 13-12-5.
//  Copyright (c) 2013年 长沙 二三三网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (URL)
- (NSString *)URLEncodedString;


/**
 *  用于判断一个字符串是否是http开头
 *
 *  @return 返回一个带http开头的字符串
 */
+ (NSString *)hasHttp:(NSString *)strURL;

@end
