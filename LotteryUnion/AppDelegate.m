//
//  AppDelegate.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/23.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AppDelegate.h"
#import "ShareTools.h"
#import "Reachability.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AppDelegate ()
{
    NSString *UpdateURL;
    NSString *ShareURL;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [SVProgressHUD setBackgroundColor:kAppBgColor];
    [ShareTools initShare];//分享
    
    self.window.backgroundColor = kAppBgColor;
    
    [UINavigationBar appearance].barTintColor=[UIColor colorWithRed:245/255.0  green:245/255.0  blue:245/255.0 alpha:1];
    
    
    
    //版本号查询
    [self checkVersionUpdate];
    
    [self getRequestID];
    
    return YES;
}



//TODO:测试时间
- (void)getRequestID
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [NSString stringWithFormat:@"%.10f",random];
    NSString *randompassword = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    
    NSString *requestId = [dateTime stringByAppendingString:randompassword];
    NSLog(@"random : %f",random);
    NSLog(@"randomString : %@",randomString);
    NSLog(@"randompassword : %@",randompassword);
    NSLog(@"requestId : %@",requestId);
}

/*----------------------------*/
//TODO:开启网路监听
- (void)openNetworkingReachability
{
    // 开启网络状态的监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    // 初始化一个网络监听的对象
     Reachability* hostReach = [Reachability reachabilityForInternetConnection];
    [hostReach startNotifier];// 开启一个监听

}
// 查看帮助文档
-(void)checkHelpVersion
{
    // 检查自带的帮助文档版本高于已经更新过的版本时，删除更新的帮助文档
    if(HELP_VER>=[NS_USERDEFAULT integerForKey:@"help_version"]){
        [NS_USERDEFAULT setInteger:HELP_VER forKey:@"help_version"];
        [NS_USERDEFAULT synchronize];
        dispatch_async(dispatch_queue_create(0,0), ^{
            NSFileManager *fileMan = [NSFileManager defaultManager];
            [fileMan removeItemAtPath:getPathInDocument(@"help") error:nil];
        });
    }
}

// 网络连接改变
- (void) reachabilityChanged:(NSNotification* )note
{
    Reachability* curReach = [note object];
    if([curReach isKindOfClass:[Reachability class]])
    {
        //从钥匙串中获取SessionId
        if([curReach isReachable]&&IsEmpty(((NSString*)[keychainItemManager readSessionId])))
        {
            //版本号查询
            [self checkVersionUpdate];
            
            //查询成功后保存信息
            [UtilMethod saveVersionInfo:nil];
            
        }

    }
}


#pragma mark -- 支付宝
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"0result = %@",resultDic);
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:url.host message:nil delegate:nil cancelButtonTitle:@"1" otherButtonTitles:@"2", nil];
            [a show];

        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"1result = %@",resultDic);
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:url.host message:nil delegate:nil cancelButtonTitle:@"1" otherButtonTitles:@"2", nil];
            [a show];
        }];
    }
    return YES;
}
/*----------------------------*/
#pragma mark -- 检测版本更新
//TODO:检测更新
- (void)checkVersionUpdate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *date = [NS_USERDEFAULT objectForKey:@"msg_time"];      // 消息时间
    date = isValidateStr(date)?date:@"00000000000000";             // 判断时间是否为零
    NSString *vHelp = [NS_USERDEFAULT objectForKey:@"help_version"]; // 获取当前help版本号
    params[@"ver"] = getBuildVersion();
    params[@"help_version"] = vHelp?vHelp:GET_INT((long)HELP_VER);
    params[@"system"] = @"iOS"; // 系统类型
    params[@"display"] = [NSString stringWithFormat:@"%.0fx%.0f",mScreenWidth,mScreenHeight];  // 屏幕展示的大小
    params[@"phone_name"] = IsPhone?@"iPhone":@"iPad"; // 获取客户端类型
    params[@"msg_time"] = date ;// 消息时间
    params[@"client_id"] = client_id; // 获取客户端id
    [params setPublicDomain:kAPI_QueryVersion];
    
    NSLog(@"------\n%@",params);
     [RequestModel POST:URL(kAPI_QueryVersion) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [SVProgressHUD dismiss];
                       // 升级提示
                       NSString *cancel = [data objectForKey:@"force_update"]==0? nil : LocStr(@"取消");
                       
                       NSString *releaseNote = [data objectForKey:@"release_note"];
                       
                       /*将这两个东西保存到沙盒*/
                       [mUserDefaults setObject:[data objectForKey:@"url"] forKey: @"UpdateURL"];
                       [mUserDefaults setObject:[data objectForKey:@"shore_url"] forKey:@"ShareURL"];
                       [mUserDefaults setObject:[data objectForKey:@"share_recommend"] forKey:@"Share_recommend"];
                       [mUserDefaults setObject:[data objectForKey:@"hide_pk"] forKey:@"Hide_pk"];
                       [mUserDefaults synchronize];
                       
                       NSLog(@"%@=====1",kkAPPDownloadURLAddress);
                       NSLog(@"%@=====2",kkShareURLAddress);
                       NSLog(@"%@=====3",kkShare_recommend);
                       NSLog(@"%@=====4",kkHide_pk);
                       
                       // 判断版本是否有更新
                       if ([[data objectForKey:@"ver"] floatValue]>[getBuildVersion() floatValue])
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"升级提示") message:releaseNote delegate:self cancelButtonTitle:cancel otherButtonTitles:LocStr(@"确定"), nil];
                           /*保存下载地址*/
                           UpdateURL = [data objectForKey:@"url"];
                           /*分享地址*/
                           ShareURL = [data objectForKey:@"shore_url"];
                           [alert show];
                       }
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                       [SVProgressHUD dismiss];
                   }];

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UpdateURL]];
    }
   
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
