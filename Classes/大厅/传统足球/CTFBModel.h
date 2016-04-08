//
//  CTFBModel.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/13.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTFBDataModels : ParentModel
@property (nonatomic) NSString *index;
@property (nonatomic) BOOL win;
@property (nonatomic) BOOL pin;
@property (nonatomic) BOOL lose;
@property (nonatomic) BOOL bWin;
@property (nonatomic) BOOL bPin;
@property (nonatomic) BOOL bLose;

@property (nonatomic) BOOL team1_select_one;
@property (nonatomic) BOOL team1_select_two;
@property (nonatomic) BOOL team1_select_three;
@property (nonatomic) BOOL team1_select_four;

@property (nonatomic) BOOL team2_select_one;
@property (nonatomic) BOOL team2_select_two;
@property (nonatomic) BOOL team2_select_three;
@property (nonatomic) BOOL team2_select_four;

@property (nonatomic) NSString *team1;
@property (nonatomic) NSString *team2;
@property (nonatomic) NSString *star_time;
@end


#define CTFBTool [CTFBModel sharedCTFBModel]
@interface CTFBModel : NSObject
singleton_interface(CTFBModel)
@property (nonatomic) NSMutableArray *value_storages;
@property (nonatomic) NSMutableArray *betting_results;
@property (nonatomic) NSInteger multiple;

/**
 *  @brief  计算投注数
 *
 *  @param num    至少要投注的场数
 *  @param result 返回的结果
 */
+ (void)calculateWithBettingNum:(NSInteger)num result:(void(^)(NSInteger bettingNum))result hasSelectDouble:(BOOL)hasSelectDouble;

/**
 *  @brief  得到胜负14场的随机选项
 *
 *  @param datas  要随机的数据
 *  @param result 返回结果
 */
+ (void)get14RandomGames:(NSArray *)datas result:(void(^)(NSArray *datas))result;

/**
 *  @brief  得到任选9场的随机选项
 *
 *  @param datas  要随机的数据
 *  @param result 返回结果
 */
+ (void)get9RandomGames:(NSArray *)datas result:(void(^)(NSArray *datas))result;

+ (void)get6RandomGames:(NSArray *)datas  result:(void(^)(NSArray *datas))result;
+ (void)get4RandomGames:(NSArray *)datas  result:(void(^)(NSArray *datas))result;

/**
 *  @brief  得到投注结果
 */
+ (NSString *)getBettingResultBettingType:(NSInteger)bettingType;

@end
