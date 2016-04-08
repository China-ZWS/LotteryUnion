
//
//  ShareTools.m
//  DongBa
//
//  Created by rt008 on 15/3/2.
//  Copyright (c) 2015年 xiaoxin. All rights reserved.
//

#import "ShareTools.h"

@implementation ShareTools
//TODO:初始化
+ (void)initShare
{
    [ShareSDK registerApp:kkShareAppKey];//此处应该换成自己的shareSDK_Key
 #if 1
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:kkSinaAppKey
                               appSecret:kkSinaAppSecret
                             redirectUri:@"http://www.sharesdk.cn"];
    
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:kkQQAppID
                           appSecret:kkQQAppKey
                    qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:kkWeXinAppKey
                           appSecret:kkWeXinAppSecret
                           wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectQQWithQZoneAppKey:kkQQAppID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //短信
    [ShareSDK connectSMS];
    
#endif
    
}
/**
  *
  *
  **/

+ (void)shareAllButtonClickHandler:(NSString *)activityName andUser:(NSString *)activityUser andUrl:(NSString *)activityUrl andDes:(NSString *)activityImageUrl
{
    //分享图片设置
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    
   
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:activityName
                                       defaultContent:@"彩票联盟"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"快来加入彩票联盟吧~"
                                                  url:activityUrl.length?activityUrl:activityUrl// 跳转的网页
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    //TODO:定制微博分享消息
    [publishContent addSinaWeiboUnitWithContent:activityName.length?activityName:@"彩票联盟" image:nil];
   
    //TODO:定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:activityName.length?activityName:@"彩票联盟"
                                            title:activityUser
                                              url:activityUrl.length?activityUrl:activityUrl
                                       thumbImage:[ShareSDK imageWithPath:imagePath]
                                            image:[ShareSDK imageWithPath:imagePath]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:activityUser
                                           title:activityName.length?activityName:@"彩票联盟"
                                             url:activityUrl.length?activityUrl:activityUrl
                                      thumbImage:[ShareSDK imageWithPath:imagePath]
                                           image:[ShareSDK imageWithPath:imagePath]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //定制QQ分享信息
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:activityUser
                                title:activityName
                                  url:activityUrl
                                image:[ShareSDK imageWithPath:imagePath]];
    //定制QQ空间分享
    [publishContent addQQSpaceUnitWithTitle:activityName url:activityUrl site:@"site" fromUrl:@"fromUrl" comment:@"asdj" summary:@"adskl" image:nil type:@(1) playUrl:nil nswb:nil];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"快来加入彩票联盟吧,下载地址:%@",activityUrl]];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:[NSMutableArray arrayWithObjects:
                                    [NSNumber numberWithInt:SSCShareTypeWeixiSession],
                                    [NSNumber numberWithInt:SSCShareTypeWeixiTimeline],
                                    [NSNumber numberWithInt:SSCShareTypeSinaWeibo],
                                    [NSNumber numberWithInt:SSCShareTypeQQ],
                                    [NSNumber numberWithInt:SSCShareTypeQQSpace],
                                    [NSNumber numberWithInt:SSCShareTypeSMS],
                                    nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                   NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
}

@end
