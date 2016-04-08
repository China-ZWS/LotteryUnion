
#import "AppDelegate.h"

/*----------------开发中常用到的宏定义-----------------*/

//系统目录
#define kDocuments  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

/// 预编译函数体
#define NotContain(source,dest) [source rangeOfString:dest].location==NSNotFound
#define IsEmpty(source) !(source&&source.length>0)
#define IsNull(source) [source isKindOfClass:[NSNull class]]
#define IsPhone UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone
#define IsPad UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad
#define LocStr(key) NSLocalizedString(key,@"")

#define NS_USERDEFAULT [NSUserDefaults standardUserDefaults]

#define CACHEDICTIONARY(item) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:item]

#define DOCUMENT_DICTIONARY(item) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:item]

#define NS_SAVE_USERDEFAULT(key,object) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];[[NSUserDefaults standardUserDefaults] synchronize]

#define BARBUTTON(STYLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:STYLE target:self action:SELECTOR] autorelease]

#define BARBUTTON_TITLE(TITLE, STYLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:STYLE target:self action:SELECTOR] autorelease]

#define ccp(x,y) CGPointMake(x,y)

#define GET_INT(x) [NSString stringWithFormat:@"%ld",x]
#define NEW_NUM(x) x<10?[NSString stringWithFormat:@"0%ld",x]:GET_INT(x)

//----------方法简写-------
#define mAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define mWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define mKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define mUserDefaults       [NSUserDefaults standardUserDefaults]
#define mNotificationCenter [NSNotificationCenter defaultCenter]

#define GET_STRING_OF_INT(x) [NSString stringWithFormat:@"%ld",x]

//TODO:加载图片
#define mImageByName(name)        [UIImage imageNamed:name]
#define mImageByPath(name, ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]
#define mImageByCap(imgname,a,b,c,d)   [[UIImage imageNamed:imgname] resizableImageWithCapInsets:UIEdgeInsetsMake(a, b, c, d)]

//TODO:以tag读取View
#define mViewByTag(parentView, tag, Class)  (Class *)[(UIView *)parentView viewWithTag:tag]
//TODO:读取Xib文件的类
#define mViewByNib(Class, owner) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] lastObject]

//TODO:id对象与NSData之间转换
#define mObjectToData(object)   [NSKeyedArchiver archivedDataWithRootObject:object]
#define mDataToObject(data)     [NSKeyedUnarchiver unarchiveObjectWithData:data]

//TODO:度弧度转换
#define mDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define mRadianToDegrees(radian) (radian*180.0) / (M_PI)

//TODO:颜色转换
#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//TODO:rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

//TODO:GCD获取主线程或是后台进程
#define kGCDBackground(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kGCDMain(block)       dispatch_async(dispatch_get_main_queue(),block)

//TODO:简单的以AlertView显示提示信息
#define mAlertView(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];

#define HTTP_DATA   @"data"


//TODO:----------页面设计相关-------
#define UPDATETOLOCATION  @"updatetolocation"
#define UPDATENUMSOFFUCK  @"updatenumsoffuck"
#define CHECK_UNREAD_MSG  @"checkmsg"
#define REFRESH_ACTIVITY  @"refresH_ACT"
#define HUAN_LOGERROR_MSG  @"聊天服务器登录失败"

//TODO:获取坐标点
#define GETSCREENWIDTH    [UIScreen mainScreen].bounds.size.width
#define GETSCREENHEIGHT    [UIScreen mainScreen].bounds.size.height
#define GETVIEWHEIGHT(x)  (x.frame.size.height)
#define GETVIEWWIDTH(x)   (x.frame.size.width)
#define GETVIEWORANGEX(view)   (view.frame.origin.x)
#define GETVIEWORANGEY(view)   (view.frame.origin.y)
#define Max(x,y)          (((x)>(y)?(x):(y)))
#define mRectMake(x,y,w,h) (CGRectMake(x, y, w, h))
#define GETSTRINGWITHTIME  [NSString stringWithFormat:@"%ld",time(NULL)]

#define HIDEPAGE          @"hidepageContrl"


#define mNavBarHeight         44
#define mTabBarHeight         49

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define mScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight         ([UIScreen mainScreen].bounds.size.height)

//TODO:字典自动设置
#define setDickeyobj(dic,obj,key)     [dic setObject:obj forKey:key];
#define dicforkey(dic,key)      [dic objectForKey:key];

//TODO:----------设备系统相关---------
#define mRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define mIsiP5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)


#define mIsPad    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define mIsiphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//系统版本
#define mSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define mCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define mAPPVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define mFirstLaunch     mAPPVersion     //以系统版本来判断是否是第一次启动，包括升级后启动。
#define mFirstRun        @"firstRun"     //判断是否为第一次运行，升级后启动不算是第一次运行
//#define UIButtonType        UIButtonTypeCustom

//设置导航控制器的标题
#define NAVTITLE(TITLE)    self.navigationItem.title = TITLE

//TODO:字体
#define UIFONT(size)      [UIFont systemFontOfSize:size]
#define UIFONT_bold(size)      [UIFont boldSystemFontOfSize:size]


//TODO:沙盒文件处理
#define SETUSERID(userId)  \
{ \
[[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"myuserID"]; \
[[NSUserDefaults standardUserDefaults] synchronize];\
}  //保存用户ID
#define CURRENTUSERID  [[NSUserDefaults standardUserDefaults] objectForKey:@"myuserID"] //获取用户ID


#define SETDEVICEID(deviceid)  \
{ \
[[NSUserDefaults standardUserDefaults] setObject:deviceid forKey:@"deviceid"]; \
[[NSUserDefaults standardUserDefaults] synchronize];\
}//保存设备ID
#define CURRENTDEVICEID  [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceid"]//获取设备ID

//--------通知相关--------




//--------调试相关-------
//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
#define mSafeRelease(object)     [object release];  x=nil
#endif

//调试模式下输入NSLog，发布后不再输入。
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#if mTargetOSiPhone
//iPhone Device
#endif

#if mTargetOSiPhoneSimulator
//iPhone Simulator
#endif

//TODO:获取appDelegate实例。
UIKIT_STATIC_INLINE AppDelegate *appDelegate()
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//TODO:获取颜色
UIKIT_STATIC_INLINE UIColor *toPCcolor(NSString *pcColorstr)
{
    unsigned int c;
    
    if ([pcColorstr characterAtIndex:0] == '#') {
        
        [[NSScanner scannerWithString:[pcColorstr substringFromIndex:1]] scanHexInt:&c];
        
    } else {
        
        [[NSScanner scannerWithString:pcColorstr] scanHexInt:&c];
        
    }
    
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
}
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored "-Warc-performSelector-leaks"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//TODO:默认图片设置
#define PlaceHeaderImage @"340.png"
#define PlaceHeaderSquareImage @"340.png"
#define PlaceHeaderBigSquareImage @"720.png"
#define PlaceHeaderRectangularImage @"750x380.png"
#define PlaceHeaderIconImage @"icon512.png"

//TODO:适配相关
//#import "UIViewExt.h" // 相对布局

/*判断iphone设备，通过设备的屏幕进行判断*/
#define  iPhone4   (\
CGSizeEqualToSize( [UIScreen mainScreen].bounds.size , CGSizeMake(320, 480)) || CGSizeEqualToSize( [UIScreen mainScreen].bounds.size , CGSizeMake(640, 960)) \
)


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

//如果能执行（currentMode）就说明可以像素来区分，如果等于就返回YES
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)




//获取设备的物理宽度
#define deviceWidth ([UIScreen mainScreen].bounds.size.width)
#define deviceHeight ([UIScreen mainScreen].bounds.size.height)

/*判断系统是否是IOS7*/
#define isIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES:NO)

#define iOS7Later        [[KKSource getSystemVersion] floatValue] > 6.5f ? YES : NO

#define iOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES:NO)


/*起始坐标的Y值*/
/*
 从状态栏下开始算起
 如果view的Y坐标为状态栏以下50像素，CGRectMake(0,startOriginY+50,0,0)
 */
#define startOriginY ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20:0)
//自定义上导航栏高度为44
#define navigationBarHeight 64.0

// 字符串扩展
//#import "NSString+Extension.h"

//屏幕的坐标
#define ORIGIN_X        [UIScreen mainScreen].bounds.origin.x
#define ORIGIN_Y        [UIScreen mainScreen].bounds.origin.y

//UITableViewCell的坐标
#define TableCell_X       self.contentView.frame.origin.x
#define TableCell_Y       self.contentView.frame.origin.y
#define TableCell_Width   self.contentView.frame.size.width
#define TableCell_Height  self.contentView.frame.size.height




