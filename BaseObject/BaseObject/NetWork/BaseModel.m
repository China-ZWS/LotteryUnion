//
//  BaseModel.m
//  BabyStory
//
//  Created by 周文松 on 14-11-18.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import "BaseModel.h"
@implementation BaseModel

+ (void )createData:(NSString *)responseString success:(void (^)(id data))success failure:(void (^)(NSString *msg, NSString *state))failure;
{
    NSLog(@"%@",responseString);
    
    NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    BOOL isSuccess = [dict[@"success"] boolValue];
    
    NSString *msg = dict[@"msg"];
    
    if (isSuccess )
    {
        success(dict);
    }
    else
    {
        failure(msg,@"0");
    }
}

@end
