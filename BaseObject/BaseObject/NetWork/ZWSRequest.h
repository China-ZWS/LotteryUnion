//
//  ZWSRequest.h
//  233wangxiaoHD
//
//  Created by 周文松 on 13-11-29.
//  Copyright (c) 2013年 长沙 二三三网络科技有限公司. All rights reserved.
//

#import "NSString+URL.h"
#import <UIKit/UIKit.h>
#define kNetworkAnomaly @"-5"

typedef void(^CompletionHandlerBlock)( NSError * error, NSString *responseString) ;

@interface ZWSRequest : NSObject
<NSURLConnectionDataDelegate>
{
    NSMutableData *_receivedData;
    CompletionHandlerBlock _CompletionHandler;
}


/**
 *  @brief  数据请求
 *
 *  @param URLString 服务器地址
 *  @param parameter 参数
 *  @param success   成功回调
 *  @param failure   失败回调
 *
 *  @return 返回请求对象
 */
+ (NSURLConnection *)POST:(NSString *)URLString parameter:(id)parameter success:(void (^)(NSString *responseString))success failure:(void (^)(NSString *msg, NSString *state))failure;

/**
 *  @brief  图片上传
 *
 *  @param url         服务器地址
 *  @param postParems  参数
 *  @param image       图片对象
 *  @param picFileName 图片名称
 *  @param success     成功回调
 *  @param failure     失败回调
 */
+ (void)postRequestWithURL: (NSString *)url  postParems: (NSMutableDictionary *)postParems images:(NSArray *)images picFileName: (NSString *)picFileName success:(void(^)(id datas))success failure:(void (^)(NSString *msg ))failure;  // IN


@end
