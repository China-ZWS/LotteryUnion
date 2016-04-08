//
//  XHDHelper.m
//  My--One
//
//  Created by mac on 15-3-28.
//  Copyright (c) 2015年 xhd945. All rights reserved.
//

#import "XHDHelper.h"
#import <sys/utsname.h>


@implementation XHDHelper

//TODO:获得当前窗口
+(UIWindow*) getKeyWindow
{
    UIWindow *keyWind = [UIApplication sharedApplication].keyWindow;
    if(!keyWind)
        keyWind = [[UIApplication sharedApplication].windows objectAtIndex:0];
    return keyWind;
}

//创建按钮
+(UIButton*)createButton:(CGRect)frame title:(NSString*)title image:(UIImage*)image target:(id)target selector:(SEL)selector
{
    UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
    bnt.frame = frame;
    [bnt setTitle:title forState:UIControlStateNormal];
    [bnt addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [bnt setBackgroundImage:image forState:UIControlStateNormal];
   
//    CGRect newFrame=frame;
//    newFrame.origin.y=frame.size.height/2.0;
//    newFrame.size.height=frame.size.height/2.0;
//    newFrame.origin.x=0;
//    
//    UILabel * label=[[UILabel alloc]initWithFrame:newFrame];
//    label.text=title;
//    label.font=[UIFont systemFontOfSize:12];
//    label.backgroundColor=[UIColor clearColor];
//    
//    [bnt addSubview:label];
    return bnt;
    
}

//TODO:创建一个输入框工具条
+(void)addToolBarOnInputFiled:(id)txField Action:(SEL)hideKeyBoard Target:(id)target
{
    //TODO:工具条，导航控制器右键控制
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -36, mScreenWidth, 36)];
    toolbar.barStyle = UIBarStyleDefault;
    UIButton *doneBnt = [[UIButton alloc]initWithFrame:CGRectMake(0, 3, 40, 30)];
    [doneBnt setTitle:@"完成" forState:UIControlStateNormal];
    [doneBnt setTitleColor:REDFONTCOLOR forState:UIControlStateNormal];
    if([((UIViewController*)target) respondsToSelector:hideKeyBoard])
    {
        [doneBnt addTarget:target action:hideKeyBoard forControlEvents:UIControlEventTouchUpInside];
    }
   
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:doneBnt];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolbar.items = @[space, rightBar];
    if([txField isKindOfClass:[UITextField class]])
    {
       ((UITextField*)txField).inputAccessoryView = toolbar;
    }
    if([txField isKindOfClass:[UITextView class]])
    {
        ((UITextView*)txField).inputAccessoryView = toolbar;
    }
    
}


//TODO:创建一个UIBarButtonItem
+(UIBarButtonItem*)createBarButtonWith:(CGRect)frame Title:(NSString*)title ImageName:(NSString*)imageName Target:(id)target Selector:(SEL)selector
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}


//提示框
+ (void)showAlert:(NSString*)message
{
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
    [a show];
}

//创建一个label
+(UILabel*)createLabelWithFrame:(CGRect)frame andText:(NSString*)text andFont:(UIFont*)font AndBackGround:(UIColor*)bgColor AndTextColor:(UIColor*)textColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    [label setFont:font];
    label.textColor = textColor;
    label.backgroundColor = bgColor;
    return label;
}

/**
 *  创建一个UIImageView
 *
 *  @param frame     坐标
 *  @param imageName 图片名字
 *  @param radius    倒角
 *  @param gesture   手势  1==tap， 2==pan，3==1ongPress
 *  @param target    手势目标
 *  @param action    手势点击执行的动作
 *
 *  @return 返回一个ImageView
 */
+(UIImageView*)createImageViewWithFrame:(CGRect)frame AndImageName:(NSString*)imageName AndCornerRadius:(CGFloat)radius andGestureRecognizer:(NSInteger)gesturtCode AndTarget:(id)target AndAction:(SEL)action
{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:frame];
    imageview.image = [UIImage imageNamed:imageName];
    imageview.layer.cornerRadius = radius;
    imageview.clipsToBounds = YES;
    imageview.userInteractionEnabled = YES;
    
    UIGestureRecognizer *gesture;
    switch (gesturtCode) {
        case 1:
        {
            gesture = [[UITapGestureRecognizer alloc]init];
        }
            break;
        case 2:
        {
            gesture = [[UIPanGestureRecognizer alloc]init];
        }
            break;
        case 3:
        {
            gesture = [[UILongPressGestureRecognizer alloc]init];
        }
            break;
        default:
        {
            gesture = nil;
        }
            break;
    }
    [gesture addTarget:target action:action];
    if(gesture){
      [imageview addGestureRecognizer:gesture];
    }
    
    return imageview;
}
//TODO:添加一个分割线
+ (void)addDivLineWithFrame:(CGRect)frame SuperView:(UIView*)fatherView
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [fatherView addSubview:view];

}

//获取今天日期的字符串YY-MM-DD
+(NSString*)getToday
{
    //获取今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitWeekday;
    
    NSDateComponents *components = [calendar components:unit fromDate:today];
    NSString *year = [NSString stringWithFormat:@"%ld", [components year]];
    NSString *month = [NSString stringWithFormat:@"%02ld", [components month]];
    NSString *day = [NSString stringWithFormat:@"%02ld", [components day]];
    
    NSString *currentDateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    return currentDateStr;
}


//获取时间
+(NSDictionary*)getDate
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *compontents = [calendar components:unit fromDate:today];
    NSString *year = [NSString stringWithFormat:@"%ld",[compontents year]];
    NSString *month = [NSString stringWithFormat:@"%ld",[compontents month]];
    NSString *day = [NSString stringWithFormat:@"%02ld",[compontents day]];
    
    NSDictionary *dic = @{@"year":year,@"month":month,@"day":day};
    return dic;
}


//label的自适应高度
+ (CGSize)heightOfString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode
{
    CGSize h;
    //系统版本适配
    if (UIDevice.currentDevice.systemVersion.doubleValue >= 7.0)
    {
        NSDictionary *dic = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: font};
        h = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    }
    else
    {
        h = [str sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
    }
    return h;
}



//清理缓存
//计算单个文件的大小，传入的时绝对的路径
+(float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

//计算目录大小
+(float)folderSizeAtPath:(NSString *)path
{

    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

//清理缓存文件
+(void)clearCacheWith:(id)target AndAction:(SEL)action
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    NSLog(@"files :%ld",[files count]);
    for (NSString *p in files)
    {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
          [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
        //action 是一个清理缓存成功后的提示框
    [target performSelectorOnMainThread:action withObject:nil waitUntilDone:YES];});
}


//限制输入 Demo
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //只能输入的数字和小数点
   #define kAlphaNum @"0123456789."
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    bool canChange = [string isEqualToString:filtered];
    //限制只能输入小数点后两位
    if ([textField.text containsString:@"."]) {
        NSArray *temp = [textField.text componentsSeparatedByString:@"."];
        NSString *str = temp[1];
        if (str.length >1) {
            return NO;
        }
    }
    //限制输入长度
    return canChange;
}


static NSDateFormatter *dateFormatter = nil;

//TODO:根据时间戳获得时间字符串
+(NSString *)gettimeSp:(NSString *)timestr formatdate:(NSString *)formatdate
{
    if(![formatdate length])formatdate = @"yyyy-MM-dd HH:mm:ss";
    if(![formatdate length]||![timestr length]) return nil;
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:formatdate];
    NSDate *localeDate = [dateFormatter dateFromString:timestr];
    NSString *timeSp = [NSString stringWithFormat:@"%lu", (long)[localeDate timeIntervalSince1970]];
    return timeSp;
}

+ (NSDateFormatter *)getDateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}
+ (NSString *)getDocumentsPath{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [arr objectAtIndex:0];
    return documentPath;
}

//TODO:检验是否为电话号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1\\d{10}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES) || ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//TODO:检验是否为身份证
+ (BOOL)isIdentityCard:(NSString *)IDCardNum
{
    NSString * regex =  @"^(\\d{15}|\\d{17}[\\dxX])$";
    NSLog(@"%@",regex);
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL iscard = [pred evaluateWithObject:IDCardNum];
    return iscard;
}
//TODO:检验是否是邮箱
+(BOOL)isValidateEmail:(NSString *)email

{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}
//TODO:判断是否为浮点型或者整形
+ (BOOL)isFolatOrIntNumber:(NSString *)numberStr
{
    NSString * regex =  @"^[+-]?\\d+(\\.\\d+)?$";
    NSLog(@"%@",regex);
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL iscard = [pred evaluateWithObject:numberStr];
    return iscard;
}
//TODO: 判断是否只有"-"或者数字
+ (BOOL)isHaveSpecialChar:(NSString *)string
{
    for (NSInteger i = 0 ; i < string.length ; i++) {
        unichar c = [string characterAtIndex:i];
        if (isnumber(c)) {
            continue;
        } else {
            NSRange range = {i, 1};
            NSString * str = [string substringWithRange:range];
            if ([str isEqualToString:@"-"]) {
                continue;
            }
            return NO;
        }
    }
    
    return YES;
}

//生成oc uuid
+(NSString *)stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

//TODO:时间戳转时间
+(NSDate*)stringTOdate:(NSString*)datestr
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDate = [dateFormatter dateFromString:datestr];
    return currentDate;
}
//TODO:时间字符串转时间戳 时间格式
+(NSString *)timeFromTimeString:(NSString *)timeStr withDateformate:(NSString *)str
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:str];
    NSDate * date = [dateFormatter dateFromString:timeStr];
    
    NSString * time = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return time;
    
}
//TODO:根据时间字符串以及时间格式，返回NSDate
+ (NSDate *)dateFromTimeString:(NSString *)timeStr withDateformate:(NSString *)str
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:str];
    NSDate * date = [dateFormatter dateFromString:timeStr];
    
    return date;
}
//TODO:根据时间返回时间字符串
+(NSString*)stringByDate:(NSDate*)date withDateformate:(NSString *)str
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [dateFormatter setDateFormat:str];
    
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return currentDateStr;
}
//得到当前时间string
+(NSString *)GetCurrenDateBig:(int)dateType
{
    //设定时间格式,这里可以设置成自己需要的格式
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    switch (dateType) {
        case 0:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case 1:
            [dateFormatter setDateFormat:@"yyyy-MM"];
            break;
        case 2:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    
    
    //用[NSDate date]可以获取系统当前时间
    NSDate *curDate = [NSDate date];
    NSString *currentDateStr = [dateFormatter stringFromDate:curDate];
    return currentDateStr;
}

+ (NSString *)timelentoTime:(NSString *)timelen
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    long long timeTamp = [timelen longLongValue];
#warning 修改
    NSDate *time ;//= [DocumentPath dateWithTimeIntervalInMilliSecondSince1970:timeTamp];
    NSLog(@"%@",time);
    return [dateFormatter stringFromDate:time];
    
}

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}
//TODO:得到当前时间string
+(NSString *)GetCurrenDateByUser:(int)dateType
{
    //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    NSDate *orDate = [NSDate date];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    switch (dateType) {
        case 0:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            orDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
            break;
        case 1:
            [dateFormatter setDateFormat:@"yyyy-MM"];
            break;
        case 2:
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            break;
        case 3:
            
            break;
        case 4:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            orDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*13];
            break;
        case 5:
            [dateFormatter setDateFormat:@"yyyy"];
            break;
        case 6:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 7:
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            break;
        case 8:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        default:
            break;
    }
    
    
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:orDate];
    
    //alloc后对不使用的对象别忘了release
    //    [dateFormatter release];
    
    return currentDateStr;
}

+(NSString*)getTime:(NSString*)time
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    //    [dateF setTimeZone:[NSTimeZone localTimeZone]];
    [dateF setDateFormat:@"YYYY"];
    NSString *nowYear = [dateF stringFromDate:date];
    
    NSString *cacheYear = [time substringToIndex:4];
    
    if ([nowYear isEqualToString:cacheYear]) {
        NSString *AAA = [time substringFromIndex:5];
        NSArray *arr = [AAA componentsSeparatedByString:@":"];
        AAA = [NSString stringWithFormat:@"%@:%@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
        return AAA;
    }else{
        
        NSArray *arr = [time componentsSeparatedByString:@":"];
        time = [NSString stringWithFormat:@"%@:%@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
        return time;
    }
    return @"";
}
//TODO:星座转换
+(NSString*)starryByDate:(NSString*)dateStr
{
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setTimeZone:[NSTimeZone localTimeZone]];
    [dateF setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateF dateFromString:dateStr];
    
    NSMutableArray *dateArr = [[NSMutableArray alloc] init];
    [dateArr addObject:@"3-21|4-20|白羊座"];
    [dateArr addObject:@"4-21|5-20|金牛座"];
    [dateArr addObject:@"5-21|6-21|双子座"];
    [dateArr addObject:@"6-22|7-22|巨蟹座"];
    [dateArr addObject:@"7-23|8-22|狮子座"];
    [dateArr addObject:@"8-23|9-22|处女座"];
    [dateArr addObject:@"9-23|10-23|天秤座"];
    [dateArr addObject:@"10-24|11-21|天蝎座"];
    [dateArr addObject:@"11-22|12-21|射手座"];
    [dateArr addObject:@"12-22|1-19|魔羯座"];
    [dateArr addObject:@"1-20|2-18|水瓶座"];
    [dateArr addObject:@"2-19|3-20|双鱼座"];
    
    NSString *str = @"魔羯座";
    
#if 0
    for (int i=0; i<dateArr.count; i++) {
    NSString *returnStr = [DocumentPath whichStarry:[dateArr objectAtIndex:i] :date];
    if (returnStr.length >0) {
            // 说明 匹配
            str = returnStr;
            break;
        }
    }
#endif
    
    //    [dateF setDateFormat:@"YYYY"];
    //    NSString *minYear = [dateF stringFromDate:date];
    //    NSString *maxYear = [dateF stringFromDate:[NSDate date]];
    //    int year = [maxYear intValue]-[minYear intValue];
    
    return [NSString stringWithFormat:@"%@",str];
    
}

+(NSString*)whichStarry:(NSString*)indexStr :(NSDate*)date
{
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setTimeZone:[NSTimeZone systemTimeZone]];
    [dateF setDateFormat:@"MM-dd"];
    NSString *cmpDateStr = [dateF stringFromDate:date];
    NSDate *cmpDate = [dateF dateFromString:cmpDateStr];
    
    
    NSArray *arr = [indexStr componentsSeparatedByString:@"|"];
    
    NSString *beginStr = [arr objectAtIndex:0];
    NSDate *beginDate = [dateF dateFromString:beginStr];
    NSString *endStr = [arr objectAtIndex:1];
    NSDate *endDate = [dateF dateFromString:endStr];
    
    if ([cmpDate isEqualToDate:beginDate] || [cmpDate isEqualToDate:endDate] || ([[cmpDate earlierDate:endDate] isEqualToDate:cmpDate]&&[[cmpDate laterDate:beginDate] isEqualToDate:cmpDate])) {
        return [arr objectAtIndex:2];
    }
    return nil;
    
}
//TODO:检测电话是否以1开头即手机号码
+(BOOL)isphoneStyle:(NSString*)str
{
    NSString * regex =  @"^1\\d{10}$";
    NSLog(@"%@",regex);
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPhone = [pred evaluateWithObject:str];
    return isPhone;
}
//TODO:去掉某个字符串空格换行
+ (void)delWhiteSpace:(NSString **)str :(NSString *)valuestr
{
    *str = [valuestr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//TODO:将时间戳转换成最近\几天前...
+(NSString *)formatTimelenStr:(NSString *)timelen formatdate:(NSString *)formatdate{
    
    NSString *ret = @"";
//    NSString *longtime = [DocumentPath gettimeSp:timelen formatdate:formatdate];
//    ret = [NSDate formattedTimeFromTimeInterval:[longtime longLongValue]];
    return ret;
}

+ (int)convertToInt:(NSString*)strtemp
{
    //    方法1
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
    
    //    方法2
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    NSData* da = [strtemp dataUsingEncoding:enc];
    //    return [da length];
}

+ (NSString *)httpMsg:(NSString*)orainmsg
{
    NSArray *msgarr = [orainmsg componentsSeparatedByString:@"|"];
    
    if([msgarr count]) return @"";
    
    BOOL type = [msgarr.firstObject boolValue];
    
    if(type) return msgarr.lastObject;
    
    return @"";
    
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


//TODO:计算字符串转换后的字符的个数
+ (NSInteger)getLengthWithString:(NSString *)string
{

        NSUInteger len = string.length;
        // 汉字字符集
        NSString * pattern  = @"[\u4e00-\u9fa5]";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        // 计算中文字符的个数
        NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
        
        return numMatch+len;
}



//TODO:去除空串
+(NSString*)delSpaceWith:(NSString*)str
{
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    NSString * username = [str  stringByTrimmingCharactersInSet:whitespace];
    username =[username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    username = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    return username;
}


@end
