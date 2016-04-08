//
//  XHDHelper.h
//  My--One
//
//  Created by mac on 15-3-28.
//  Copyright (c) 2015年 xhd945. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDImageCache.h"

@interface XHDHelper : NSObject

//TODO:获得当前窗口
+(UIWindow*) getKeyWindow;

//创建按钮
+(UIButton*)createButton:(CGRect)frame title:(NSString*)title image:(UIImage*)image target:(id)target selector:(SEL)selector;

//创建一个UIBarButtonItem
+(UIBarButtonItem*)createBarButtonWith:(CGRect)frame Title:(NSString*)title ImageName:(NSString*)imageName Target:(id)target Selector:(SEL)selector;

//创建一个Label
+(UILabel*)createLabelWithFrame:(CGRect)frame andText:(NSString*)text andFont:(UIFont*)font AndBackGround:(UIColor*)bgColor AndTextColor:(UIColor*)textColor;

//创建一个UIImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame AndImageName:(NSString*)imageName AndCornerRadius:(CGFloat)radius andGestureRecognizer:(NSInteger)gesturtCode AndTarget:(id)target AndAction:(SEL)action;

//TODO:添加一个分割线
+ (void)addDivLineWithFrame:(CGRect)frame SuperView:(UIView*)fatherView;


//提示框
+ (void)showAlert:(NSString*)message;


// 带系统版本判断的label的自适应高度
+ (CGSize)heightOfString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;

//TODO:创建一个输入框工具条
+(void)addToolBarOnInputFiled:(id)txField Action:(SEL)hideKeyBoard Target:(id)target;

//获取今天的日期
+(NSString*)getToday;

//获取时间
+(NSDictionary*)getDate;

//计算单个文件的大小
+(float)fileSizeAtPath:(NSString *)path;

//计算目录大小
//+(float)folderSizeAtPath:(NSString *)path;

//清理缓存文件
+(void)clearCacheWith:(id)target AndAction:(SEL)action;

/*********************************时间相关************************/
+(NSString *)getDocumentsPath;
//根据时间戳获得时间字符串
+(NSString *)gettimeSp:(NSString *)timestr formatdate:(NSString *)formatdate;
+(NSString*)getTime:(NSString*)time;
+(NSString *)stringWithUUID ;
//得到当前时间string
+(NSString *)GetCurrenDateByUser:(int)dateType;
//+(NSString*)getTime:(NSString*)time;
+(NSString *)GetCurrenDateBig:(int)dateType;
//星座转换
+(NSString*)starryByDate:(NSString*)dateStr;
//根据时间返回时间字符串
+(NSString*)stringByDate:(NSDate*)date withDateformate:(NSString *)str;
//时间戳转时间
+(NSDate*)stringTOdate:(NSString*)datestr;
//时间字符串转时间戳 时间格式
+(NSString *)timeFromTimeString:(NSString *)timeStr withDateformate:(NSString *)str;
//根据时间字符串以及时间格式，返回NSDate
+ (NSDate *)dateFromTimeString:(NSString *)timeStr withDateformate:(NSString *)str;
//时间戳转时间
+ (NSString *)timelentoTime:(NSString *)timelen;
//将时间戳转换成最近\几天前...
+(NSString *)formatTimelenStr:(NSString *)timelen formatdate:(NSString *)formatdate;


/*******************************数字相关**********************/
+(BOOL)isphoneStyle:(NSString*)str; //检测电话是否以1开头即手机号码
+ (BOOL)isPureInt:(NSString*)string;//判断是否为整形
+ (BOOL)isFolatOrIntNumber:(NSString *)numberStr; //判断是否为浮点型或者整形
+ (BOOL)isMobileNumber:(NSString *)mobileNum;//检验是否为电话号码
+ (BOOL)isIdentityCard:(NSString *)IDCardNum; //检验是否为身份证号码
+ (BOOL)isHaveSpecialChar:(NSString *)string; //判断是否只有"-"或者数字
//TODO:检验是否是邮箱
+(BOOL)isValidateEmail:(NSString *)email;



+ (void)delWhiteSpace:(NSString **)str
                     :(NSString *)valuestr;//去掉某个字符串空格换行


//TODO:去除空串
+(NSString*)delSpaceWith:(NSString*)str;

+ (int)convertToInt:(NSString*)strtemp;

+ (NSString *)httpMsg:(NSString*)orainmsg;

//计算字符串转换后的字符的个数
+ (NSInteger)getLengthWithString:(NSString *)string;

@end
