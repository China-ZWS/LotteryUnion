//
//  ProjectAPI.h
//  LotteryUnion
//
//  Created by 周文松 on 15/10/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+PublicDomain.h"

extern NSString *const serverUrl;

#define kSp_id   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Channel"] // 渠道ID

// 客户端下载地址
#define kkAPPDownloadURLAddress  [mUserDefaults valueForKey:@"UpdateURL"]
#define kkShareURLAddress [mUserDefaults valueForKey:@"ShareURL"]
#define kkShare_recommend [mUserDefaults valueForKey:@"Share_recommend"]
#define kkHide_pk  [mUserDefaults valueForKey:@"Hide_pk"]


//TODO:客服电话
#define kefuNumber @"400-166-6018"
#define kTerminal_no @"ios" //终端编号
#define client_id @"10002" //客户端ID
#define HELP_VER 2 // 默认的帮助版本


// MD5盐值
#if 0
#define MD5_MARCO @"agtech_silvercreek_0755_2012" //现场
#else
#define MD5_MARCO @"{moloclient}" //测试
/*--{moloCliend}fjydtc-client-md5-salt--*/
#endif



#define URL(url) [ProjectAPI setUrl:url]


#pragma mark - 彩种编号枚举
typedef NS_ENUM(NSInteger, API_LotteryType) // 彩种编号
{
    kType_JCZQ = 15, //竞彩足球
    kType_CTZQ_SF14 = 3, // 胜负14
    kType_CTZQ_SF9 = 4, // 任选9
    kType_CTZQ_BQC6 = 8,
    kType_CTZQ_JQ4 = 7,
    
    lDLT_lottery = 6,   //大乐透
    lSSQ_lottery = 31,  //双色球
    lSenvenStar_lottery = 1,  //七星彩
    lPL3_lottery = 2,      //排列3
    lPL5_lottery = 5,   //排列5
    
    lT225_lottery = 52,   //22选5
    lT317_lottery = 51,   //31选7
    lT367_lottery = 50,   //36选7

    
};

#pragma mark -- 红球&蓝球枚举
typedef NS_ENUM(NSInteger,ColorBall) {
    kColorBlue,
    kColorRed
} ;


#pragma mark - 请求消息类型action 枚举
typedef NS_ENUM(NSInteger, API_action) // 消息类型码 枚举
{
    kAPI_QueryVersion = 100,  //版本号查询
    kAPI_Register = 101,    //注册
    kAPI_BasicInfoRegister = 102,  //基本信息注册
    kAPI_BasicInfoModify = 103,  //基本信息修改
    kAPI_BankInfoRegister = 104,  //银行信息注册
    kAPI_BankInfoModify = 105,  //银行信息修改
    kAPI_BankInfoQuery = 106,  //银行信息查询
    kAPI_PasswordReset = 113,   //密码重置
    kAPI_GetVCode = 108,   //获取验证码
    
    kAPI_Login = 110,   //登录
    kAPI_Logout = 111,  //退出
    kAPI_ModifyPwd = 112,   //密码修改
    kAPI_ResetPwd = 113,    // 重置密码
    kAPI_QueryAccount = 114,    //查询账户余额
    kAPI_QueryTrade = 115,    //查询账户明细
    kAPI_GetAccountInfo = 116,  //基本信息查询
    
    kAPI_QueryBetRecord = 120,  //查询投注记录
    kAPI_QueryRewardRecord = 121,   //查询中奖记录
    kAPI_QueryRewardNotice = 122,   //查询开奖详情公告
    kAPI_QueryPlayPeriod = 123, //查询玩法期数
    kAPI_QueryFootballVS = 124, //查询足彩对阵
    kAPI_QueryFollowRecord = 125,   //查询追号记录
    kAPI_QueryLuckyRecord = 126,    //查询送幸运记录
    kAPI_QueryRevendList = 127,     //查询开奖公告
    kAPI_GetRevendDetail = 128,     //查询开奖公告详情
    kAPI_QueryTransferMoneyRecord = 129,        //查询转帐记录
    kAPI_QueryXyscMissValue = 130,      //查询幸运赛车遗漏数据
    
    kAPI_BookmarkAdd = 131,           //收藏夹add
    kAPI_BookmarkList = 132,           //收藏夹list
    kAPI_BookmarkDelete = 133,           //收藏夹删除
    
    kAPI_BetAction = 140,           //投注
    kAPI_CancelFollow = 142,        //取消追号
    kAPI_BetCartAction = 143,       // 购物车投注
    kAPI_RandomBetAction = 144,     // 机选投注
    
    kAPI_ZJZQ = 145,          // 足彩对阵信息
    kAPI_ZJZQ_award = 146,    //竞彩足球开奖信息查询
    kAPI_TransferToMobile = 158,        //转手机支付
    kAPI_TransferToBank = 151,          //转银行卡
    kAPI_PayAli = 152,          //支付宝在线充值  153
    kAPI_PayUpomp = 152,          //银联在线充值  154
    kAPI_Pay_Notify = 155,          //充值结果通知
    kAPI_PayAliWap = 156,          //支付宝wap在线充值
    kAPI_PayUpomp_call = 157,          //银联语音充值
    kAPI_LotteryInformation = 161,      //彩票资讯
    kAPI_LotteryContent = 163,          //资讯内容
    //    kAPI_Trend = 163,                   //走势图
    kAPI_NewsCount = 164,               //查询新资讯数量
    
    kAPI_Feedback = 170,                //意见建议
    kAPI_Help = 171,                    //帮助
    kAPI_banner = 172,                    //首页广告位
    kAPI_Xysc_Video = 180,
    
    kAPI_MobileAlipay_Signature = 300, //支付宝订单签名
    kAPI_MobileAlipay_wap = 301, //支付宝订单签名
    kAPI_MobileAlipay_Trans = 302 //支付宝提现

};

#pragma mark - 请求数据返回Code状态码枚举
typedef enum{
    Status_Code_Request_Success = 0,   //请求成功状态码
    Status_Code_Request_Error = 1,     //请求失败状态码
    Status_Code_Money_Not_Enough = 20,
    Status_Code_Login_Success = 40,   //登陆成功
    Status_Code_Login_Error = 41,     //登陆失败
    Status_Code_User_Login = 42,      //用户登陆
    Status_Code_User_Not_Login = 43,  //用户未登陆
    Status_Code_Need_Profile = 200,
    
}Status_Code;

#pragma mark - 彩种玩法代码枚举
typedef NS_ENUM(NSInteger, API_play)
{
    //大乐透
    pDLT_Danshi = 522,     //单式
    pDLT_Fushi = 523,      //复式
    pDLT_Dantuo = 524,     //胆托
    
    //7星彩
    pSenvenStarLottery_Danshi = 72,     //单式
    pSenvenStarLottery_Fushi = 73,      //复式
    
    
    //排列3
    pPL3_DirectChoice_Danshi = 32,               //排列3直选排列3直选复式
    pPL3_DirectChoice_Fushi = 33,                //排列3直选复式
    pPL3_DirectChoice_Group3_Danshi = 332,       //排列3组3单式
    pPL3_DirectChoice_Group3_Fushi = 333,        //排列3组3复式
    pPL3_DirectChoice_Group6_Danshi = 362,       //排列3组6单式
    pPL3_DirectChoice_Group6_Fushi = 363,        //排列3组6复式
    
    //排列5
    pPL5_Danshi = 52,     //单式
    pPL5_Fushi = 53,       //复式
    
    //胜负14场
    pWinLost14_Danshi = 142,   //单式
    pWinLost14_Fushi = 143,    //复式
    
    //任选9场
    pAny9_Danshi = 92,     //单式
    pAny9_Fushi = 93,       //复式
    
    //半全场
    pHalfWin_Danshi = 62,   //单式
    pHalfWin_Fushi = 63,    //复式
    
    //进球4
    pEnter4_Danshi = 42,
    pEnter4_Fushi = 43,
    
    //22选5
    pT225_Danshi = 222,
    pT225_Fushi = 223,
    pT225_Dantuo = 224,
    
    // 31选7
    pT317_Danshi = 312,
    pT317_Fushi = 313,
    pT317_Dantuo = 314,
    
    // 36选7
    pT367_Danshi = 662,
    pT367_Fushi = 663,
    pT367_Dantuo = 664,
    
    //双色球
    pSSQ_Danshi = 3362,
    pSSQ_Fushi = 3363,
    pSSQ_Dantuo = 3364,
    
    
    //竞彩足球
    kSFP_single = 11, // 胜平负单式
    kSFP_compound = 12, // 胜平负复式
    
    kRQ_SFP_single = 21, // 让球胜平负单式
    kRQ_SFP_compound = 22, // 让球胜平负复式
    
    kScore_single = 31, // 比分单式
    kScore_compound = 32, // 比分复式
    
    kBQC_single = 41, //半全场单式
    kBQC_compound = 42, //半全场复式
    
    kJQS_single = 51, //进球数单式
    kJQS_compound = 52, //进球数复式
    
    KHHGG_single = 61, // 混合过关单式
    kHHGG_compound = 62, // 混合过关复式
    
    
    
    // 幸运赛车
    pXysc_Pos_Danshi = 1201,
    pXysc_First_Danshi = 1211,
    pXysc_Second_Danshi = 1221,
    pXysc_Second_Fushi = 1222,
    pXysc_Second_Dantuo = 1224,
    pXysc_Second_Duiwei = 1228,
    pXysc_Third_Danshi = 1231,
    pXysc_Third_Fushi = 1232,
    pXysc_Third_Dantuo = 1234,
    pXysc_Third_Duiwei = 1238,
    pXysc_Zu2_Danshi = 1241,
    pXysc_Zu2_Fushi = 1242,
    pXysc_Zu2_Dantuo = 1244,
    pXysc_Zu3_Danshi = 1251,
    pXysc_Zu3_Fushi = 1252,
    pXysc_Zu3_Dantuo = 1254
};

//typedef NS_ENUM(NSInteger, API_FBID)
//{
//    
//};


@interface ProjectAPI : NSObject
+ (NSString *)setUrl:(API_action)code;
+ (NSString *)transformNumber:(NSString *)lottery_code;
NSString *getPlayTypeName(API_play playType);
+ (NSArray *)getFB_bettingPlay;

@end
