//
//  ParentModel.m
//  233wangxiaoHD
//
//  Created by 周文松 on 13-12-2.
//  Copyright (c) 2013年 长沙 二三三网络科技有限公司. All rights reserved.
//

#import "ParentModel.h"
@implementation ParentModel


+ (void )createData:(NSString *)responseString  success:(void (^)(id data))success failure:(void (^)( NSString *msg, NSString *state))failure;
{
    failure(@"请求失败，请联系客服",nil);
}


+ (NSURLConnection *)POST:(NSString *)string parameter:(id)parameter class:( id)class  success:(void (^)(id data))success failure:(void (^)(NSString *msg, NSString *status ))failure;
{
  
      return  [ZWSRequest  POST:string parameter:parameter success:^(NSString *responseString)
     {
         
         [class createData:responseString success:^(id data)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                success(data);
              });
              
          }
                   failure:^(NSString *msg, NSString *status)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                failure(msg,status);
              });
          }];
     }
             failure:^( NSString* msg, NSString *status)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             failure(msg,status);
         });
     }
     
     ];
}

@end
