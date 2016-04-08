//
//  Device.h
//  BabyStory
//
//  Created by 周文松 on 14-11-7.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//


//相关头文件
#import "AbnormalView.h"
#import "BaseNavigationBar.h"
#import "BaseTextField.h"
#import "BaseTextView.h"
#import "BaseTableViewCell.h"
#import "BaseInputView.h"

#define iPadSizeZero 0

//系统版本判断
#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7&&[[[UIDevice currentDevice] systemVersion] floatValue]<8
#define IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8

//设备型号判断
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE4 [Device isIPhone4]
#define IS_IPHONE5 [Device isIPhone5]
#define IS_IPHONE6 [Device isIPhone6]
#define IS_IPHONE6_PLUS [Device isIPhonePlus]



//设备属性判断
#define DeviceW [Device getDeviceWidth]
#define DeviceH [Device getDeviceHeight]

//不同设备，基于iPhone 6屏幕的比例
#define ScaleVer [Device getScaleVer]
#define ScaleHor [Device getScaleHor]

#define X(iPhoneX,iPadX) (IS_IPHONE?iPhoneX:iPadX) //x点
#define Y(iPhoneY,iPadY) (IS_IPHONE?iPhoneY:iPadY) //y点
#define W(iPhoneW,iPadW) (IS_IPHONE?iPhoneW:iPadW) //width
#define H(iPhoneH,iPadH) (IS_IPHONE?iPhoneH:iPadH) //hight

//#define ScaleX(iPhoneX,iPadX) (IS_IPHONE?(iPhoneX) * ScaleVer:iPadX) //x的比例点
//#define ScaleY(iPhoneY,iPadY) (IS_IPHONE?(iPhoneY) * ScaleHor:iPadY) //y的比例点
//#define ScaleW(iPhoneW,iPadW) (IS_IPHONE?(iPhoneW) * ScaleVer:iPadW) //width的比例宽
//#define ScaleH(iPhoneH,iPadH) (IS_IPHONE?(iPhoneH) * ScaleHor:iPadH) //hight的比例高

#define ScaleX(iPhoneX) (iPhoneX) * ScaleVer //x的比例点
#define ScaleY(iPhoneY) (iPhoneY) * ScaleHor //y的比例点
#define ScaleW(iPhoneW) (iPhoneW) * ScaleVer //width的比例宽
#define ScaleH(iPhoneH) (iPhoneH) * ScaleHor //hight的比例高
#define defaultInset UIEdgeInsetsMake(ScaleX(5),ScaleY(10),ScaleX(5),ScaleX(10))//默认Inset

#define kDefaultInset UIEdgeInsetsMake(ScaleY(8),ScaleX(10),ScaleY(8),ScaleX(10))//默认Inset


#define SetRectMake( x,  y,  width,  height) IS_IPHONE?[Device setRectWithX:x Y:y W:width H:height]:CGRectMake( x,  y,  width,  height)
//#define Font(iPhoneSize, iPadSize) [Device getiPhoneFont:iPhoneSize iPadFont:iPadSize]
#define Font(iPhoneSize) [Device getiPhoneFont:iPhoneSize iPadFont:0]

//#define FontBold(iPhoneSize, iPadSize) [Device getiPhoneFontBold:iPhoneSize iPadFont:iPadSize]
#define FontBold(iPhoneSize) [Device getiPhoneFontBold:iPhoneSize iPadFont:0]

#define NFont(iPhoneSize) [UIFont systemFontOfSize:iPhoneSize]
#define NFontBold(iPhoneSize) [UIFont  boldSystemFontOfSize:iPhoneSize]

@interface Device : NSObject

/**
 *  @brief  判断是否为iPhone4
 *
 *  @return 返回是否
 */
+ (BOOL)isIPhone4;
/**
 *  @brief  判断是否为iPhone5
 *
 *  @return 返回是否
 */

+(BOOL)isIPhone5;

/**
 *  @brief  判断是否是iPhone6
 *
 *  @return 返回是否
 */
+ (BOOL)isIPhone6;

/**
 *  @brief  判断是否是iPhone6 plus
 *
 *  @return 返回是否
 */
+ (BOOL)isIPhonePlus;

/**
 *  @brief  获取屏幕的高
 *
 *  @return 返回屏幕的高
 */
+ (CGFloat)getDeviceHeight;

/**
 *  @brief  获取屏幕的宽
 *
 *  @return 返回屏幕的款
 */
+ (CGFloat)getDeviceWidth;

/**
 *  @brief  得到屏幕宽的比例
 *
 *  @return 返回比例
 */
+ (CGFloat)getScaleVer;

/**
 *  @brief  得到屏幕高的比例
 *
 *  @return 返回比例
 */
+ (CGFloat)getScaleHor;

/**
 *  @brief  得到字体大小
 *
 *  @param iPhoneSize 手机size
 *  @param iPadSize   平板size
 *
 *  @return 返回字体size
 */
+ (UIFont *)getiPhoneFont:(CGFloat)iPhoneSize iPadFont:(CGFloat)iPadSize;


/**
 *  @brief  绘制加粗字体
 *
 *  @param iPhoneSize 手机size
 *  @param iPadSize   平板size
 *
 *  @return 返回字体size
 */
+ (UIFont *)getiPhoneFontBold:(CGFloat)iPhoneSize iPadFont:(CGFloat)iPadSize;


+ (CGRect)setRectWithX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)width H:(CGFloat)height;

@end
