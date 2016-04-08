//
//  NSObject+CGTool.h
//  BabyStory
//
//  Created by 周文松 on 14-11-6.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//
#import <UIKit/UIKit.h>


typedef void (^GetImageBlock)(UIImage *image);

typedef NS_ENUM(NSInteger, ImageStyle) {
    ImageStateNone = 0,  ///< 原型.
    ImageStateGround ///< 圆角
    
    
};



@interface NSObject (CGTool)

@property (nonatomic) id bindingInfo;


/**
 *  @brief 计算字符串大小
 *
 *  @param text    text
 *  @param font    textFont
 *  @param maxSize text maxSize
 *
 *  @return textSize
 */
+ (CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  @brief  适配图片大小
 *
 *  @param image     用来适配的图片
 *  @param maxHeight 最高大小
 *  @param maxWidth  最款大小
 *
 *  @return 返回适配好的size
 */
+ (CGSize)adaptiveWithImage:(UIImage *)image maxHeight:(CGFloat)maxHeight maxWidth:(CGFloat)maxWidth;

/**
 *  @brief  16进制颜色(html颜色值)字符串转为UIColor
 *
 *  @param stringToConvert 16制色值
 *
 *  @return 返回UIColor
 */
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

/**
 *  @brief  验证邮箱
 *
 *  @param email 邮箱地址
 *
 *  @return 返回BOOL值
 */
-(BOOL)isValidateEmail:(NSString *)email;

/**
 *  @brief  图片下载
 *
 *  @param url              图片地址
 *  @param placeholderImage 默认图片
 *  @param imageStyle       图片类型
 *  @param getImage         返回已下载图片
 */
+ (void)imageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage imageStyle:(ImageStyle)imageStyle getImage:(GetImageBlock)getImage;

/**
 *  @brief  截取图片
 *
 *  @param theView 要截取的界面
 *  @param rect    截取范围
 *
 *  @return 返回截取好的图片
 */
+ (UIImage *)getImageFromView:(UIView *)theView rangRect:(CGRect)rect;


+ (UIImage *)getComImage:(UIImage *)originalImage addImage:(UIImage *)addImage;


/**
 *  @brief  绘图片
 *
 *  @param size            图片大小
 *  @param backgroundColor 背景颜色
 *
 *  @return 返回图片
 */
+ (UIImage *)drawrWithImage:(CGSize)size  backgroundColor:(UIColor *)backgroundColor;


/**
 *  @brief  电话号码验证
 *
 *  @param mobileNum 号码
 *
 *  @return 返回真假
 */
+ (BOOL)isMobile:(NSString *)mobileNum;


/**
 *  @brief  电话号码验证
 *
 *  @param mobileNum 号码
 *
 *  @return 返回真假
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  @brief  移动号码判断
 *
 *  @param mobileNum 电话号码
 *
 *  @return 返回真假
 */
+ (BOOL)isCM:(NSString *)mobileNum;

/**
 *  @brief  联通号码判断
 *
 *  @param mobileNum 电话号码
 *
 *  @return 返回真假
 */
+ (BOOL)isCU:(NSString *)mobileNum;

/**
 *  @brief  电信号码判断
 *
 *  @param mobileNum 电话号码
 *
 *  @return 返回真假
 */
+ (BOOL)isCT:(NSString *)mobileNum;


/**
 *  @brief   计算某个日期所在的周一和周末的日期
 *
 *  @param nowDate           传入时间
 *  @param getFirstDayOfWeek 得到周1
 *  @param getLastDayOfWeek  得到周末
 */
+ (void)setNowDate:(NSString *)nowDate format:(NSString *)format getFirstDayOfWeek:(void(^)(NSString *date))getFirstDayOfWeek getLastDayOfWeek:(void(^)(NSString *date))getLastDayOfWeek;


+ (NSString *)pushedBackSevenDays:(NSString *)date format:(NSString *)format;


/**
 *  @brief  计算星期
 *
 *  @param nowDate 当前时间
 *  @param format  格式
 *
 *  @return 返回星期
 */
+ (NSString *)getWeekDay:(NSString *)nowDate format:(NSString *)format;
/**
 *  @brief  计算指定过去时间与当前的时间差
 *
 *  @param compareDate  某一指定时间
 *
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTimeToPastTime:(NSDate*)compareDate;


/**
 *  @brief  计算指定未来时间与当前的时间差
 *
 *  @param compareDate  某一指定时间
 *
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareFutureTimeToCurrentTime:(NSDate*)compareDate;

/**
 *  @brief  身份证
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 *  @brief  手机储存空间
 *
 *  @return 返回手机储存空间
 */
+ (NSString *)usedSpaceAndfreeSpace;

/**
 *  @brief  根据日期算出星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;


/**
 *  @brief  字符串拼接
 *
 *  @param string     被拼接的字符串
 *  @param aString    要拼接的字符串
 *  @param components 拼接符号
 *
 *  @return 返回拼接好的字符串
 */
+ (NSString *)string:(NSString *)string AppendingString:(NSString *)aString components:(NSString *)components;


@end
