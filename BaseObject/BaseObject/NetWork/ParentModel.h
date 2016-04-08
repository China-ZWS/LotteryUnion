//
//  ParentModel.h
//  233wangxiaoHD
//
//  Created by 周文松 on 13-12-2.
//  Copyright (c) 2013年 长沙 二三三网络科技有限公司. All rights reserved.
//




#import "ZWSRequest.h"

@interface ParentModel : NSObject


@property (nonatomic,strong) NSString *RESULTDESC;
@property (nonatomic,strong) NSString *RESULTCODE;

+ (NSURLConnection *)POST:(NSString *)string parameter:(id)parameter class:( id)class  success:(void (^)(id data))success failure:(void (^)(NSString *msg, NSString *status ))failure;


+ (void)createData:(NSString *)responseString success:(void (^)(id data))success failure:(void (^)( NSString *msg, NSString *state))failure;

@end
