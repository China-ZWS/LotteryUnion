//
//  FTHelp.h
//  LotteryUnion
//
//  Created by 周文松 on 15/10/27.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//
/*********************帮助文档*****************************/
/*
    
 
 
 
 
 
 */
 


typedef NS_ENUM(NSInteger, FBPlayType)
{
    kSFP = 0, // 胜负平
    kRSFP, // 让球胜负平
    kScore, // 比分
    kBQC, // 半全场
    kJQS,  // 进球数
    kHHGG // 混合过关
};

typedef NS_ENUM(NSInteger, FBBettingType) {
    kSingle = 0,
    kSkipmatch,
};

typedef NS_ENUM(NSInteger, FBBettingPlay)
{
    kSFP_one = 0, // 胜负平
    kSFP_two,
    kRSFP_one,
    kRSFP_two, // 让球胜负平
    kScore_one, // 比分
    kScore_two, // 比分
    kBQC_one, // 半全场
    kBQC_two, // 半全场
    kJQS_one,  // 进球数
    kJQS_two,  // 进球数
    kHHGG_two, // 混合过关
};

