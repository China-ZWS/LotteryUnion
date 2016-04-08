//
//  Header.h
//  NetSchool
//
//  Created by 周文松 on 15/8/27.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#ifndef NetSchool_Header_h
#define NetSchool_Header_h

// Block 安全的self
#define WEAKSELF typeof(self) __weak weakSelf = self;


#define RGBA(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a] //RGB颜色
#define GET_INT(x) [NSString stringWithFormat:@"%d",x]

/**
 *  @brief  与蓝色导航条一样的颜色
 */
#define CustomBlue RGBA(26, 114, 192, 1) //与蓝色导航条一样的颜色
#define CustomSkyblue RGBA(38,164,178,1)
#define CustomRed RGBA(177, 24, 23, 1) //
#define CustomYellow RGBA(242, 162, 92, 1) //与蓝色导航条一样的颜色

#define NavColor RGBA(242, 242, 242, 1)
#define CustomGreen RGBA(137,177,50,1) //绿色下载
#define CustomGray RGBA(160, 160, 160, 1) // 灰色
#define CustomBlack RGBA(110, 110, 110, 1) //自定义黑色
#define CustomDarkPurple RGBA(68, 60, 114, 1) // 紫色
#define CustomlightPurple RGBA(179,171,211,1) // 淡紫色
#define CustomAlphaBlue RGBA(43,189,188,.5) //透明紫色
#define CustomPurple RGBA(75, 55, 103, 1)


#define CustomPink RGBA(186, 59, 119, 1) //粉红
#define CustomlightPink RGBA(192,148,219,1) //淡粉红
#define Loding_text1 @"正在拉取数据"

#define kTop3Scale 2
#define kTop2Scale 1.5

//#define kTop3Scale (640.0 / 320.0)
//#define kTop2Scale (232.0 / 140.0)
#define LineWidth .3


#define kUserDefaults [NSUserDefaults standardUserDefaults]

//判断wifi
#define kSettingIsAllowWIFI  @"kSettingAllowWIFI"
//获取是否wifi
#define kISWIFI ([[NSUserDefaults standardUserDefaults] boolForKey:kSettingIsAllowWIFI])


#define NSNotificationAdd(Server,Sel,Name,Object) [[NSNotificationCenter defaultCenter] addObserver:Server selector:@selector(Sel) name:Name object:Object]
#define NSNotificationPost(name,Object,info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:Object userInfo:info]

#define RefreshWithViews @"refreshWithViews"

#ifdef DEBUG
# define DLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

/*
 专门用来保存单例代码
 最后一行不要加 \
 */

// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

#endif
