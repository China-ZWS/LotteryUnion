//
//  ShareTools.h
//  DongBa
//
//  Created by rt008 on 15/3/2.
//  Copyright (c) 2015年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppKey.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/ISSQZoneApp.h>



@interface ShareTools : NSObject
//sharesdk分享
+ (void)initShare;
//分享内容定制
+ (void)shareAllButtonClickHandler:(NSString *)activityName andUser:(NSString *)activityUser andUrl:(NSString *)activityUrl andDes:(NSString *)activityImageUrl;
@end
