//
//  NSString+Extension.h
//  汇银
//
//  Created by 李小斌 on 14-11-27.
//  Copyright (c) 2014年 7ien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/*
 * 判断字符串是否为空白的
 */
- (BOOL)isBlank;

/*
 * 判断字符串是否为空
 */
- (BOOL)isEmpty;

/*
 *
 */
- (BOOL)isNULL;

//判断字符串是否是中文
-(BOOL)isChinese;

// 把手机号第4-7位变成星号
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum;

// 把手机号第5-14位变成星号
+(NSString *)idCardToAsterisk:(NSString *)idCardNum;

// 判断是否是身份证号码
+(BOOL)validateIdCard:(NSString *)idCard;

// 邮箱验证
+(BOOL)validateEmail:(NSString *)email;

// 手机号码验证
+(BOOL)validateMobile:(NSString *)mobile;

-(CGSize) calculateSize:(UIFont *)font maxWidth:(CGFloat)width;

@end
