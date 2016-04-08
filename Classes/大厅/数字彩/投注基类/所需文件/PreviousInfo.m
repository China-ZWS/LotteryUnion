//
//  PreviousInfo.m
//  ydtctz
//
//  Created by 小宝 on 1/2/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "PreviousInfo.h"

@implementation PreviousInfo
@synthesize lottery_pk = _lottery_pk;
@synthesize period = _period;
@synthesize start_time = _start_time;
@synthesize end_time = _end_time;
@synthesize prize_pool = _prize_pool;
@synthesize before_period = _before_period;
@synthesize next_period = _next_period;
@synthesize next_time = _next_time;
@synthesize before_prize_number = _before_prize_number;
@synthesize prize_status = _prize_status;
@synthesize sc_first = _sc_first;
@synthesize sc_place = _sc_place;

+(NSString*)defaultPeriod {
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyMMdd00"];
    return [df stringFromDate:now];
}

// 设置数据的对应关系（完成赋值操作）（传进来一个彩票信息的字典，得到彩票的具体信息）
- (id)initWithDictionary:(NSDictionary *)aDict
{
    if ((self = [super init]))
    {
        self.lottery_pk = [aDict valueForKey:@"lottery_pk"];      //彩种
        self.period = [aDict valueForKey:@"period"];              //彩期
        self.start_time = [aDict valueForKey:@"start_time"];      //开始时间
        self.end_time = [aDict valueForKey:@"end_time"];          //结束时间
        self.prize_pool = [aDict valueForKey:@"prize_pool"];      //奖池
        self.before_period = [aDict valueForKey:@"before_period"];//上期
        self.next_period = [aDict valueForKey:@"next_period"];    //下期
        self.next_time = [aDict valueForKey:@"next_time"];        //下期开始时间
        self.before_prize_number = [aDict valueForKey:@"before_prize_number"]; //上期开价号码
        self.prize_status = [[aDict valueForKey:@"prize_status"] boolValue];   //是否已经开价
        self.sc_first = [aDict valueForKey:@"sc_first"];          //赛车前一奖金
        self.sc_place = [aDict valueForKey:@"sc_place"];          //赛车位置奖金
    }
    
    return self;
}

@end
