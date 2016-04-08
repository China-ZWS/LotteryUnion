//
//  WinModel.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"

@interface WinModel : WXBaseModel


@property (nonatomic,copy)NSString *lottery_name;    //彩种名称
@property (nonatomic,copy)NSString *period;          //期数
@property (nonatomic,copy)NSString *money;           //金额
@property (nonatomic,copy)NSString *status;          //1》状态  0->未派奖   1->已派奖                 开奖记录
                                                     //2》投注状态  0：投注中   1:投注状态  2 投注失败   投注记录
                                                    //3》 0：投注中，1：成功，2：失败                   送彩票记录
                                                   //4> 交易状态, -1：其他 0: 受理中 1：成功，2：失败    账户明细
@property (nonatomic,copy)NSString *lottery_pk;      //彩种编号
@property (nonatomic,copy)NSString *amount;          //注数




//----------------中奖记录-------------------
@property (nonatomic,copy)NSString *desc;           //备注
@property (nonatomic,copy)NSString *multiple;       //倍数
@property (nonatomic,copy)NSString *buy_money;      //投注金额
@property (nonatomic,copy)NSString *number;         //投注号码
@property (nonatomic,copy)NSString *create_time;    //创建时间
@property (nonatomic,copy)NSString *record_pk;      //订单号
@property (nonatomic,copy)NSString *fail_status;     //注数


//----------------追号记录-------------------
@property (nonatomic,copy)NSString *follow_status;    //状态
@property (nonatomic,copy)NSString *follow_prize;    //中奖继续追号
@property (nonatomic,copy)NSString *follow_type;    //追号类型
@property (nonatomic,copy)NSString *sup;                 //是否追加   0：不追加，1：追加
@property (nonatomic,copy)NSString *follow_time;     //创建时间
@property (nonatomic,copy)NSString *follow_num;      //追号期数
@property (nonatomic,copy)NSString *finish_num;      //追号状态
@property (nonatomic,copy)NSString *lottery_code;    //玩法编号


//---------------投注记录---------------------
@property (nonatomic,copy)NSString *prize_money;  //中奖金额
@property (nonatomic,copy)NSString *prize_status;  //0：未开奖 1：未中奖  2：已中奖
@property (nonatomic,copy)NSString *query_type;  //0：所有（默认） 1：等待开奖  2：已中奖
@property (nonatomic,copy)NSString *prize_number;  //投注记录的开奖号码
@property (nonatomic,copy)NSString *status_desc;  //开奖号码
@property (nonatomic,copy)NSString *bonus_number;  //中奖记录的开奖号码
@property (nonatomic,copy)NSString *contributor_phone;  //赠送者手机号

//---------------送彩票记录--------------------
@property (nonatomic,copy)NSString *gift_phone;         //赠送手机
@property (nonatomic,copy)NSString *greetings;         //祝福语

@property (nonatomic,copy)NSString *contributor_name;         //赠送者
@property (nonatomic,copy)NSString *contributor_msg;         //祝福语


//---------------账户明细记录--------------------
//0：处理中 2：现金 5：molo奖金账户 6：手机支付 8：银行卡 30：话费
@property (nonatomic,copy)NSString *pay_type;       //扣费类型


@property (nonatomic,strong)NSMutableArray *spfArray;
@property (nonatomic,strong)NSMutableArray *bfArray;
@property (nonatomic,strong)NSMutableArray *bqcArray;
@property (nonatomic,strong)NSMutableArray *jqsArray;


@property (nonatomic,copy)NSString *spfString;



// 格式化后的字符串
@property (nonatomic ,retain) NSString *formatedNumber;

- (void)makeBonusViewWithSuperView:(UIView *)superview bounsNumber:(NSString *)bounsNumber lot_pk:(NSString *)lot_pk;
-(NSString *)formatedNumber;
-(NSString *)getWin:(NSString*)number isBet:(BOOL)isBet;
- (NSString *)chuangGuan:(NSString *)number;
- (NSArray *)transNumber:(NSString *)numbers lottery_code:(NSString *)lot_code;
- (NSString *)SSNumber:(NSString *)num lottery_code:(NSString *)lottery_code;

@end
