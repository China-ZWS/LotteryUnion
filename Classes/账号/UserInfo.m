//
//  UserInfo.m
//  LotteryUnion
//
//  Created by xhd945 on 15/10/27.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "UserInfo.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UserInfo
+ (UserInfo *)sharedInstance;
{
    
    static UserInfo *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =[[[self class] alloc] init];
    });
    return manager;
}

/*用户的基本信息查询*/
- (void)getBaseUserInfoSuccess:(void(^)(void))success
                       failure:(void(^)(void))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain:kAPI_GetAccountInfo];
    
    [RequestModel POST:URL(kAPI_GetAccountInfo) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [[UserInfo sharedInstance] setRealName:[data valueForKey:@"customer_name"]];
                       [[UserInfo sharedInstance] setIDCard:[data valueForKey:@"idcard"]];
                       [[UserInfo sharedInstance] setUserEmail:[data valueForKey:@"email"]];
                       [[UserInfo sharedInstance] setBankNumber:[data valueForKey:@"bank_card"]];
                       if(success)
                       {
                          success();
                       }
                       
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
                       if(failure)
                       {
                          failure();
                       }
                       
                   }];
    

}

/*账户余额查询*/
- (void)getUserBonusSuccess:(void(^)(void))success
                    failure:(void(^)(void))failure
{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain:kAPI_QueryAccount];
    
    [RequestModel POST:URL(kAPI_QueryAccount) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       if (!data) {
                           [SVProgressHUD showErrorWithStatus:LocStr(@"无网络连接")];
                           return;
                       }
                       if ([[data objectForKey:@"code"] isEqualToString:@"000"])
                       {
                           UserInfo *mod = [UserInfo sharedInstance];
                           mod.RealName =  [data objectForKey:@"customer_name"];
                           mod.Cash =  [data objectForKey:@"cash_money"];
                           NSArray *accouts = [data objectForKey:@"item"];// 获得个人账户余额信息
                           
                           for (NSDictionary *element in accouts)
                           {
                               // 账户类型
                               NSString *chargeType = [element objectForKey:@"charge_type"];
                               if ([chargeType isEqualToString:@"5"])
                               { // molo账户
                                   
                                   // 开通则显示余额，否则显示未开通
                                   [[UserInfo  sharedInstance] setCash:[element objectForKey:@"balance"]];
                               }
                               else if ([chargeType isEqualToString:@"4"]) // 手机支付账户
                               {
                                   
                                   [[UserInfo sharedInstance]setBalance:[element objectForKey:@"balance"]];
                                   
                               }
                           }
                           // 设置数据头部数据
                       }
                       else
                       {
                           [SVProgressHUD showErrorWithStatus:[data objectForKey:@"note"]];
                       }
                       [SVProgressHUD dismiss];
                       if(success)
                       {
                         success();
                       }
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                      
                   }];

}

/*新用户注册刷清空说有数据*/
- (void)clearUserInfo:(BOOL)isClear
{
   if(isClear)
   {
       _isLogined = NO;
       _isLoginedWithVirefi = NO;
       _TelNumber = @"";
       _Bonus = @"";
       _ShareBonus =@"";
       _Lot_PK = @"";
       _IDCard = @"";
       _RealName = @"";
       _UserEmail = @"";
       _QQ = @"";
       _Cash = @"0.00";
       _Balance = @"0.00";
       _PhonePay =@"";
       _TelFare = @"";
       _BankName = @"";
       _BankNumber = @"";
       _BankID = @"";
       _SelectCharge = @"4";
   }

}

@end
