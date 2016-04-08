//
//  ProjectAPI.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "ProjectAPI.h"
//TODO:服务器地址选择
#if 1
NSString *const serverUrl = @"http://client.lotunion.com";
#else
NSString *const serverUrl = @"http://test.caipiaolianmeng.cn:9095";
#endif

@implementation ProjectAPI
+ (NSString *)setUrl:(API_action)code;
{
    NSDictionary *apiPlist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"action_code_urls" ofType:@"plist"]];
    NSString *actionUrl = [apiPlist objectForKey:[NSString stringWithFormat:@"%ld",(long)code]];
   
    NSLog(@"%@", [NSString stringWithFormat:@"%@;jsessionid=%@",[serverUrl stringByAppendingString:actionUrl],[keychainItemManager readSessionId]]);
    
    return [NSString stringWithFormat:@"%@;jsessionid=%@",[serverUrl stringByAppendingString:actionUrl],[keychainItemManager readSessionId]]; //响应中都会返回jsessionid参数，客户端需要获取并替换，
//    return [serverUrl stringByAppendingString:actionUrl];
}


+ (NSString *)transformNumber:(NSString *)lottery_code {
    switch ([lottery_code intValue]) {
            
            //竞彩足球
        case kSFP_single:
            return @"胜平负单式";
            break;
        case kSFP_compound:
            return @"胜平负复式";
            break;
        case kRQ_SFP_single:
            return @"让球胜平负单式";
            break;
        case kRQ_SFP_compound:
            return @"让球胜平负复式";
            break;
        case kScore_single:
            return @"比分单式";
            break;
        case kScore_compound:
            return @"比分复式";
            break;
        case kBQC_single:
            return @"半全场单式";
            break;
        case kBQC_compound:
            return @"半全场复式";
            break;
        case kJQS_single:
            return @"进球数单式";
            break;
        case kJQS_compound:
            return @"进球数复式";
            break;
        case KHHGG_single:
            return @"混合过关单式";
            break;
        case kHHGG_compound:
            return @"混合过关复式";
            break;
            
            //大乐透
        case pDLT_Danshi:
            return @"混合过关复式";
            break;
        case pDLT_Fushi:
            return @"混合过关复式";
            break;
        case pDLT_Dantuo:
            return @"混合过关复式";
            break;
            
            
        default:
            return nil;
            break;
    }
}


// 获取玩法

NSString *getPlayTypeName(API_play playType)
{
    switch (playType)
    {
        
        case pPL3_DirectChoice_Fushi:
            return @"直选复式";
        case pPL3_DirectChoice_Danshi:
            return @"直选单式";
        case pDLT_Fushi:
        case pSSQ_Fushi:
        case pPL5_Fushi:
        case pT225_Fushi:
        case pT317_Fushi:
        case pT367_Fushi:
        case pSenvenStarLottery_Fushi:
        case pWinLost14_Fushi:
        case pAny9_Fushi:
        case pHalfWin_Fushi:
        case pEnter4_Fushi:
            return @"自选复式";
        case pDLT_Dantuo:
        case pT225_Dantuo:
        case pT317_Dantuo:
        case pT367_Dantuo:
        case pSSQ_Dantuo:
            return @"胆拖";
        case pPL3_DirectChoice_Group3_Danshi:
            return @"组三单式";
        case pPL3_DirectChoice_Group3_Fushi:
            return @"组三复式";
        case pPL3_DirectChoice_Group6_Danshi:
            return @"组六单式";
        case pPL3_DirectChoice_Group6_Fushi:
            return @"组六复式";
        default:
            return @"自选单式";
    }
}




@end
