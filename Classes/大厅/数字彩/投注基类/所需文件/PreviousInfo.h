//
//  PreviousInfo.h
//  ydtctz
//
//  Created by 小宝 on 1/2/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreviousInfo : NSObject

- (id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic) NSString *lottery_pk; // 彩种
@property (nonatomic) NSString *period;     // 彩期
@property (nonatomic) NSString *start_time; //开始时间
@property (nonatomic) NSString *end_time;   // 结束时间
@property (nonatomic) NSString *prize_pool; // 奖池
@property (nonatomic) NSString *before_period;// 上期
@property (nonatomic) NSString *next_period;// 下期
@property (nonatomic) NSString *next_time;  // 下期开始时间
@property (nonatomic) NSString *before_prize_number;//上期开价号码

@property (nonatomic) BOOL prize_status;// 是否已经开奖

@property (nonatomic) NSString *sc_first;// 赛车前一奖金
@property (nonatomic) NSString *sc_place;// 赛车位置奖金

@property (nonatomic) long fixed_delta_time;

+(NSString*)defaultPeriod;

@end
