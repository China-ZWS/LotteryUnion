//
//  NSObject+CGTool.m
//  BabyStory
//
//  Created by 周文松 on 14-11-6.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import "NSObject+CGTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

char* const ASSOCIATION_MUTABLE_USER_INFO = "ASSOCIATION_MUTABLE_USER_INFO";
static NSString * const FORM_FLE_INPUT = @"file";

@implementation NSObject (CGTool)

-(void)setBindingInfo:(id)bindingInfo
{
    objc_setAssociatedObject(self,ASSOCIATION_MUTABLE_USER_INFO,bindingInfo,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (id )bindingInfo
{
    id userInfo =objc_getAssociatedObject(self,ASSOCIATION_MUTABLE_USER_INFO);
    
    return userInfo;

}



+ (CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
{
    
    if (text.length) {
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:maxSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        return rect.size;
    }
    return CGSizeZero;
}

+ (CGSize)adaptiveWithImage:(UIImage *)image maxHeight:(CGFloat)maxHeight maxWidth:(CGFloat)maxWidth;
{
    
    
    CGSize imageSize = image.size;
    CGFloat height = 0, width = 0;
    
    
    /*
    if (imageSize.height > maxHeight || imageSize.width > maxWidth)
    {
        if ((imageSize.height / imageSize.width) > (maxHeight / maxWidth))
        {
            height = maxHeight;
            width = height * imageSize.width / imageSize.height;
            
        }
        else if ((imageSize.height / imageSize.width) < (maxHeight / maxWidth))
        {
            width = maxWidth;
            height = imageSize.height * width / imageSize.width;
        }
        
        else if ((imageSize.height / imageSize.width) == (maxHeight / maxWidth))
        {
            height = maxHeight;
            width = maxWidth;
        }
    }
    else
    {
        
        width = imageSize.width;
        height = imageSize.height;
    }
    */
    if ((imageSize.height / imageSize.width) > (maxHeight / maxWidth))
    {
        height = maxHeight;
        width = height * imageSize.width / imageSize.height;
        
    }
    else if ((imageSize.height / imageSize.width) < (maxHeight / maxWidth))
    {
        width = maxWidth;
        height = imageSize.height * width / imageSize.width;
    }
    
    else if ((imageSize.height / imageSize.width) == (maxHeight / maxWidth))
    {
        height = maxHeight;
        width = maxWidth;
    }

    return CGSizeMake(width, height);
}



+ (UIColor *) hexStringToColor: (NSString *) stringToConvert;
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}




+ (void)imageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage imageStyle:(ImageStyle)imageStyle getImage:(GetImageBlock)getImage;
{
    
    NSString * imageCache = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:imageCache]) {
        [fileManager createDirectoryAtPath:imageCache withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    
    /*方法一*/
    
    NSData *imgData = nil;
    __block UIImage *image = nil;
    NSString *imgPath = [imageCache stringByAppendingPathComponent:[self stringFromMD5:url]];
    
    
    if ([fileManager fileExistsAtPath:imgPath]) {
        //        //NSLog(@"缓存");
        imgData = [NSData dataWithContentsOfFile:imgPath];
        
        if (imageStyle == ImageStateNone)
        {
            
            image  = [UIImage imageWithData:imgData];
            getImage (image);
        }
        else if (imageStyle == ImageStateGround)
        {
            image = [self circleImage:[UIImage imageWithData:imgData] withParam:1]; ;
            getImage (image);
        }
    }
    else
    {
        
        
        [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]]
                                           queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             
             NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
             if (!error && responseCode == 200)
             {
                 [data writeToFile:imgPath atomically:YES];
                 
                 if (imageStyle == ImageStateNone)
                 {
                     image = [UIImage imageWithData:data];
                     getImage (image);
                     
                 }
                 
                 else if (imageStyle == ImageStateGround)
                 {
                     image = [self circleImage:[UIImage imageWithData:data] withParam:1];
                     getImage (image);
                     
                 }
             }
             else
             {
                 getImage(nil);
             }
         }];
    }
    
}


+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetShadow(context, CGSizeMake(0, 0), 5);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


#pragma mark - 邮箱验证
-(BOOL)isValidateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

+ (NSString *) stringFromMD5:(NSString *)path
{
    
    if(self == nil || [path length] == 0)
        return nil;
    
    const char *value = [path UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString ;
}

+ (UIImage *)getImageFromView:(UIView *)theView rangRect:(CGRect)rect;
{
    //    UIGraphicsBeginImageContext(CGSizeMake(theView.frame.size.width, theView.frame.size.height));
    //    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    //    UIImage *subImage = [UIImage getSubImage:image inFrame:rect];
    //UIGraphicsBeginImageContext(theView.bounds.size);
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, 1);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    
    CGImageRef imageRef = image.CGImage;
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    UIGraphicsEndImageContext();
    
    return sendImage;
}

+ (UIImage *)getComImage:(UIImage *)originalImage addImage:(UIImage *)addImage;
{
    UIGraphicsBeginImageContext(originalImage.size);
    
    [originalImage drawInRect:CGRectMake(0, addImage.size.height, originalImage.size.width, originalImage.size.height)];
    
    [addImage drawInRect:CGRectMake((originalImage.size.width - addImage.size.width) / 2, 0, addImage.size.width, addImage.size.height)];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aimg;
}


+ (UIImage *)drawrWithImage:(CGSize)size  backgroundColor:(UIColor *)backgroundColor;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height ), NO, 0);
    [backgroundColor setFill];
    [backgroundColor setStroke];
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = size.width;
    CGFloat maxY = size.height;
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGPoint poins[] = {CGPointMake(minX, minY),CGPointMake(maxX, minY),CGPointMake(maxX, maxY),CGPointMake(minX, maxY)};
    CGContextAddLines(context,poins,4);
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);

    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return im;
}



// 正则判断手机号码地址格式

+ (BOOL)isMobile:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    return NO;
    
}

+ (BOOL)isCM:(NSString *)mobileNum
{
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    if (([regextestcm evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    return NO;
}

+ (BOOL)isCU:(NSString *)mobileNum
{
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    if (([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    return NO;
}

+ (BOOL)isCT:(NSString *)mobileNum
{
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestct evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    return NO;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    if (!mobileNum.length)
    {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    
    BOOL isMobile = [self isMobile:mobileNum];
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    BOOL isCM = [self isCM:mobileNum];
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    BOOL isCU = [self isCU:mobileNum];
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    BOOL isCT = [self isCT:mobileNum];
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    if (isMobile || isCM || isCU || isCT)
    {
        return YES;
    }
    else
    {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [alert show];
        return NO;
    }
}

+ (void)setNowDate:(NSString *)nowDate format:(NSString *)format getFirstDayOfWeek:(void(^)(NSString *date))getFirstDayOfWeek getLastDayOfWeek:(void(^)(NSString *date))getLastDayOfWeek;
{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSDate *now=[dateFormatter dateFromString:nowDate];
  
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
//    NSLog(@"weekDay:%ld   day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    firstDiff = [calendar firstWeekday] - weekDay;
    lastDiff = 7 - weekDay;
    
    

    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    
    
    getFirstDayOfWeek([dateFormatter stringFromDate:firstDayOfWeek]);
    getLastDayOfWeek([dateFormatter stringFromDate:lastDayOfWeek]);
   
    
//    NSLog(@"星期天开始 %@",[dateFormatter stringFromDate:firstDayOfWeek]);
//    NSLog(@"当前 %@",[dateFormatter stringFromDate:now]);
//    NSLog(@"星期一结束 %@",[dateFormatter stringFromDate:lastDayOfWeek]);
}


+ (NSString *)pushedBackSevenDays:(NSString *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSDate *now=[dateFormatter dateFromString:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    // 得到几号
    NSInteger day = [comp day];
    
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day - 7];
    NSDate *dayOfWeek= [calendar dateFromComponents:firstDayComp];
    return [dateFormatter stringFromDate:dayOfWeek];
}

+ (NSString *)getWeekDay:(NSString *)nowDate format:(NSString *)format
{
    
    nowDate = [nowDate componentsSeparatedByString:@" "][0];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSDate *now=[dateFormatter dateFromString:nowDate];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [comp weekday];
    NSString *weekDayString = nil;
    switch (weekDay) {
        case 1:
            weekDayString = @"星期天";
            break;
        case 2:
            weekDayString = @"星期一";
            break;
        case 3:
            weekDayString = @"星期二";
            break;
        case 4:
            weekDayString = @"星期三";
            break;
        case 5:
            weekDayString = @"星期四";
            break;
        case 6:
            weekDayString = @"星期五";
            break;
        case 7:
            weekDayString = @"星期六";
            break;
    
        default:
            break;
    }
    return weekDayString;
}

#pragma mark - 计算指定过去时间与当前的时间差
+(NSString *)compareCurrentTimeToPastTime:(NSDate*)compareDate;
//
{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    
    NSDate *today = [NSDate new];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    今天的时间
    NSDateComponents *todayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:today];
    //    比较时间的时间
    NSDateComponents *compareDateComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:compareDate];
    //    NSLog(@"%ld === %ld",todayComp.year,compareDateComp.year);
    
    NSString *result;
    if ([todayComp year] == [compareDateComp year]) // 同一年
    {
        
        if ([todayComp month] == [compareDateComp month]) //同一个月
        {
            if ([todayComp day] == [compareDateComp day]) // 同一天
            {
                if ([todayComp hour] == [compareDateComp hour])
                {
                    //同一个小时
                    if ([todayComp minute] == [compareDateComp minute])
                    {
                        //同一分钟
                        NSInteger insetSecond = [todayComp second] - [compareDateComp second];
                        result = [NSString stringWithFormat:@"%ld 秒前",insetSecond];
                    }
                    else
                    {
                        //同一小时不同分钟
                        NSInteger insetMinute = [todayComp minute] - [compareDateComp minute];
                        result = [NSString stringWithFormat:@"%ld 分钟前",insetMinute];
                    }
                }
                else
                {
                    // 同天不同时
                    //                    [dateFormatter setAMSymbol:@"上午 "];
                    //                    [dateFormatter setPMSymbol:@"下午 "];
                    [dateFormatter setDateFormat:@"hh:mm"];
                    result = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:compareDate]];
                }
            }
            else
            {
                //同月不同天
                NSInteger insetDay = [todayComp day] - [compareDateComp day];
                if (insetDay == 1) {
                    //昨天
                    //                    [dateFormatter setAMSymbol:@"上午 "];
                    //                    [dateFormatter setPMSymbol:@"下午 "];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    result = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:compareDate]];
                }
                else
                {
                    //同月的其他天
                    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                    result = [dateFormatter stringFromDate:compareDate];
                }
            }
        }
        else
        {
            //同年不同月
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            result = [dateFormatter stringFromDate:compareDate];
        }
    }
    else
    {
        //不同年
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    
    return  result;
}

#pragma mark - 计算指定未来时间与当前的时间差
+(NSString *)compareFutureTimeToCurrentTime:(NSDate*)compareDate;
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    
    NSDate *today = [NSDate new];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    今天的时间
    NSDateComponents *todayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:today];
    //    比较时间的时间
    NSDateComponents *compareDateComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:compareDate];
    //    NSLog(@"%ld === %ld",todayComp.year,compareDateComp.year);
    
    NSLog(@"%d",[todayComp day]);
    
    
    NSString *result = nil;
  
    if ([todayComp year] == [compareDateComp year]) // 同一年
    {
        if ([todayComp month] == [compareDateComp month])
        {
            if ([todayComp day] == [compareDateComp day])
            {
                return nil;
            }
            else
            {
                //同月不同天
                NSInteger insetDay = [compareDateComp day] - [todayComp day];
                if (insetDay == 1) {
                    //昨天
                    //                    [dateFormatter setAMSymbol:@"上午 "];
                    //                    [dateFormatter setPMSymbol:@"下午 "];
                    NSTimeInterval time=[today timeIntervalSinceDate:compareDate];
                    int hours = (int)time / 3600;
                    if (hours <= 24)
                    {
                        return nil;
                    }
                    
                    
                    [dateFormatter setDateFormat:@"HH:mm"];
                    result = [NSString stringWithFormat:@"明天 %@",[dateFormatter stringFromDate:compareDate]];
                }
                else
                {
                    //同月的其他天
                    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                    result = [dateFormatter stringFromDate:compareDate];
                }

            }
        }
        else
        {
          
            NSTimeInterval time=[compareDate timeIntervalSinceDate:today];
        
            int hours = (int)time / 3600;
          
            if (hours <= 24)
            {
                return nil;
            }
            else
            {
      
                //同年不同月
                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                result = [dateFormatter stringFromDate:compareDate];

            }
        }
    }
    else
    {
        //不同年
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    
    return  result;
}


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (NSString *)usedSpaceAndfreeSpace
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    NSString  * str= [NSString stringWithFormat:@"已占用%0.1fG/剩余%0.1fG",([totalSpace longLongValue] - [freeSpace longLongValue])/1024.0/1024.0/1024.0,[freeSpace longLongValue]/1024.0/1024.0/1024.0];
    return str;
}

#pragma mark - 根据日期算出星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+ (NSString *)string:(NSString *)string AppendingString:(NSString *)aString components:(NSString *)components
{
    if (!string ) {
        string = @"";
    }
    if (!aString) {
        aString = @"";
    }
    if (!components) {
        components = @"";
    }
    return [[string stringByAppendingString:components] stringByAppendingString:aString];
}

+(UIImage *)rotateAndScaleImage:(UIImage *)image maxResolution:(NSInteger)maxResolution {
    
    int kMaxResolution;
    if (maxResolution <= 0)
        kMaxResolution = 640;
    else
        kMaxResolution = maxResolution;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
@end
