//
//  Record.h
//  ydtctz
//
//  Created by 小宝 on 1/7/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject {
    NSString *_lottery_pk;
    NSString *_lottery_code;
    NSString *_lottery_name;
    NSString *_period;
    NSString *_amount;
    
    NSString *_multiple;
    NSString *_money;
    NSString *_buy_money;
    NSString *_number;
    
    int _sup;
    int _status;
    NSString *statusName;
    NSString *_create_time;
    
    //中奖记录用
    NSString *bonus_number;
    NSString *_prize_detail;
    NSString *beizhu;
    
    //追号记录
    NSString *_record_pk;
    NSString *_follow_time;
    NSString *_follow_num;
    NSString *_finish_num;
    NSString *_follow_type;
    NSString *_follow_prize;
    
    // 送彩票
    NSString *_gift_phone;// 电话号码
    NSString *_greetings;// 赠言
    
    NSString *_follow_status;
    NSString *_fail_status;
    
    int _actionCode;
    
    NSDictionary *_storeDictionary;
}

- (id)initWithDictionary:(NSDictionary *)aDict;
- (NSDictionary *)getDictionary;
#if DEBUG
- (NSDictionary *)getDictionary_Debug;
#endif

@property (nonatomic ,retain) NSString *lottery_pk;
@property (nonatomic ,retain) NSString *period;
@property (nonatomic ,retain) NSString *lottery_code;
@property (nonatomic ,retain) NSString *lottery_name;
@property (nonatomic ,retain) NSString *amount;
@property (nonatomic ,retain) NSString *multiple;
@property (nonatomic ,retain) NSString *money;
@property (nonatomic ,retain) NSString *buy_money;
@property (nonatomic ,retain) NSString *number;
@property (nonatomic ,retain) NSString *create_time;
@property (nonatomic ,retain) NSString *beizhu;

@property (nonatomic) int sup;
@property (nonatomic) int status;
@property (nonatomic ,retain) NSString *statusName;
@property (nonatomic) int actionCode;

@property (nonatomic ,retain) NSString *bonus_number;
@property (nonatomic ,retain) NSString *prize_detail;
@property (nonatomic ,retain) NSString *record_pk;
@property (nonatomic ,retain) NSString *follow_time;
@property (nonatomic ,retain) NSString *follow_num;
@property (nonatomic ,retain) NSString *finish_num;
@property (nonatomic ,retain) NSString *follow_type;
@property (nonatomic ,retain) NSString *follow_prize;
@property (nonatomic ,retain) NSString *follow_status;
@property (nonatomic ,retain) NSString *fail_status;
@property (nonatomic ,retain) NSString *gift_phone;
@property (nonatomic ,retain) NSString *greetings;

// 格式化后的字符串
@property (nonatomic ,retain) NSString *formatedNumber;

@property (nonatomic ,retain) NSDictionary *storeDictionary;

-(float)calcFormatedNumberHeight;

- (NSString *)getBonusNumber;
- (void)makeBonusViewWithSuperView:(UIView *)superview bounsNumber:(NSString *)bounsNumber lot_pk:(NSString *)lot_pk;
- (NSString *)getWin:(NSString*)number;
- (NSMutableArray *)getWin2:(NSString*)number;
@end
