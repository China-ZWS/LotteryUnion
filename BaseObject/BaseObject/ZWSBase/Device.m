//
//  Device.m
//  BabyStory
//
//  Created by 周文松 on 14-11-7.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//


#import "Device.h"

#pragma mark - 真实基于iPhone6 横、纵坐标比
#define TScaleVer [Device getTScaleVer]
#define TScaleHor [Device getTScaleHor]

@implementation Device


+ (BOOL)isIPhone4;
{
    return CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size);

}

+ (BOOL)isIPhone5
{
    return CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size);
}

+ (BOOL)isIPhone6;
{
    return CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) ;
}

+ (BOOL)isIPhonePlus;
{
    return CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) /[UIScreen mainScreen].scale;
}

+ (CGFloat)getDeviceHeight;
{
    return (UIInterfaceOrientationPortrait != [UIApplication sharedApplication].statusBarOrientation?(IS_IOS8?([[UIScreen mainScreen] bounds].size.height):([[UIScreen mainScreen] bounds].size.width)):([[UIScreen mainScreen] bounds].size.height));
}

+ (CGFloat)getDeviceWidth
{
    return (UIInterfaceOrientationPortrait !=  [UIApplication sharedApplication].statusBarOrientation?(IS_IOS8?([[UIScreen mainScreen] bounds].size.width):([[UIScreen mainScreen] bounds].size.height)):([[UIScreen mainScreen] bounds].size.width));
}

+ (CGFloat)getTScaleVer
{
    return (CGFloat)DeviceW / 320.0f;
    

}

+ (CGFloat)getTScaleHor
{
    return (CGFloat)DeviceH / 568.0f;
}


// 取屏幕 纵坐标 为最接近比例
+ (CGFloat)getScaleVer
{
//    return TScaleVer;
    
    return  IS_IPHONE?((TScaleHor - TScaleVer > 0)?TScaleHor:TScaleVer):1;
}

+ (CGFloat)getScaleHor
{
    //    return TScaleHor;
    return  IS_IPHONE?((TScaleHor - TScaleVer > 0)?TScaleHor:TScaleVer):1;
}

+ (UIFont *)getiPhoneFont:(CGFloat)iPhoneSize iPadFont:(CGFloat)iPadSize;
{
    return [UIFont systemFontOfSize:(IS_IPHONE?(iPhoneSize *TScaleVer):iPadSize)];
}

+ (UIFont *)getiPhoneFontBold:(CGFloat)iPhoneSize iPadFont:(CGFloat)iPadSize;
{
   return [UIFont fontWithName:@"Helvetica-Bold" size:(IS_IPHONE?(iPhoneSize * TScaleVer):iPadSize)];
}

+ (CGRect)setRectWithX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)width H:(CGFloat)height;
{
    CGFloat scaleX = x *TScaleVer, scaleY = y *TScaleHor;
    CGFloat ScaleVeridth = width * TScaleVer, ScaleHoreight = height *TScaleHor;
    return CGRectMake(scaleX + (ScaleVeridth - width * ScaleVer) / 2, scaleY + (ScaleHoreight -  height * ScaleHor) / 2, width * ScaleVer, height * ScaleHor);
}
@end
