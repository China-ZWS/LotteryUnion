//
//  UserInfo.h
//  LotteryUnion
//
//  Created by xhd945 on 15/10/27.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserInfoTool [UserInfo sharedInstance]

@interface UserInfo : RequestModel

+ (UserInfo *)sharedInstance;


@property(nonatomic,assign)BOOL isLogined;            // 拿到是否登录的信息
@property(nonatomic,assign)BOOL isLoginedWithVirefi;  // 是否短信登录
@property(nonatomic,strong)NSString* TelNumber;   //电话号码
@property(nonatomic,strong)NSString* Bonus;      // 拿到中奖信息拼接返回
@property(nonatomic,strong)NSString* ShareBonus; // 拿到中奖信息分享内容
@property(nonatomic,strong)NSString* Lot_PK;     // 拿到中奖彩种
@property(nonatomic,strong)NSString* IDCard;     // 拿到身份证号码
@property(nonatomic,strong)NSString* RealName;   // 拿到真是姓名
@property(nonatomic,strong)NSString* UserEmail;      // 拿到邮箱地址
@property(nonatomic,strong)NSString* QQ;         // 拿到qq号码
@property(nonatomic,strong)NSString* Cash;       // 拿到可提现金额
@property(nonatomic,strong)NSString* Balance;    // 拿到账户余额
@property(nonatomic,strong)NSString* PhonePay;   // 拿到手机支付余额
@property(nonatomic,strong)NSString* TelFare;    // 拿到话费余额
@property(nonatomic,strong)NSString* BankName;   // 银行名称
@property(nonatomic,strong)NSString* BankNumber; // 银行账号
@property(nonatomic,strong)NSString* BankID;     // 银行ID
@property(nonatomic,strong)NSString* SelectCharge;// 支付方式


/*用户的基本信息查询*/
- (void)getBaseUserInfoSuccess:(void(^)(void))success
                       failure:(void(^)(void))failure;
/*账户余额查询*/
- (void)getUserBonusSuccess:(void(^)(void))success
                    failure:(void(^)(void))failure;

/*新用户注册刷清空说有数据*/
- (void)clearUserInfo:(BOOL)isClear;

@end
