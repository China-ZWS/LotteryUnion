//
//  RequestModel.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

+ (void )createData:(NSString *)responseString success:(void (^)(id data))success failure:(void (^)(NSString *msg, NSString *state))failure;
{
    NSLog(@"%@",responseString);
    NSLog(@"成功");
    NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *code = dict[@"code"];
    NSString * jsessionid = dict[@"jsessionid"];
    [keychainItemManager writeSessionId:jsessionid];
    NSString *msg = dict[@"note"];
    if ([code integerValue] == Status_Code_Request_Success)
    {
        success(dict);
    }
    else
    {
      
        failure(msg,code);
    }
}


@end
