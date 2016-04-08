//
//  JCHModel.h
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCHModel : NSObject

@property(nonatomic,copy)NSString *bonus_number;   //开奖号码
@property(nonatomic,copy)NSString *bonus_time;     //开奖日期
@property(nonatomic,copy)NSString *lottery_pk;     //彩种编号
@property(nonatomic,copy)NSString *period;         //彩种期数

BOOL isFootBallLottery(API_LotteryType lotPK);

@end
