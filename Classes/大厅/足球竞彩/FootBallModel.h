//
//  FootBallModel.h
//  LotteryUnion
//
//  Created by 周文松 on 15/10/26.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//


#import "FTHelp.h"

@interface FBDatasModel : NSObject
<NSCopying,NSMutableCopying>
@property (nonatomic) NSDictionary *datas;
@property (nonatomic) NSString *position;
@property (nonatomic) NSString *endTime;
@property (nonatomic) NSMutableArray *scroes;
@property (nonatomic) NSMutableArray *BQCDatas;
@property (nonatomic) BOOL win;
@property (nonatomic) BOOL pin;
@property (nonatomic) BOOL lose;
@property (nonatomic) BOOL rWin;
@property (nonatomic) BOOL rPin;
@property (nonatomic) BOOL rLose;
@property (nonatomic) FBBettingPlay play;
@property (nonatomic) BOOL JQS_select_one;
@property (nonatomic) BOOL JQS_select_two;
@property (nonatomic) BOOL JQS_select_three;
@property (nonatomic) BOOL JQS_select_four;
@property (nonatomic) BOOL JQS_select_five;
@property (nonatomic) BOOL JQS_select_six;
@property (nonatomic) BOOL JQS_select_seven;
@property (nonatomic) BOOL JQS_select_eight;
@property (nonatomic) NSString *value_storage;

@end



#import <Foundation/Foundation.h>
#define FBTool [FootBallModel sharedFootBallModel]
@interface FootBallModel : NSObject
singleton_interface(FootBallModel)
@property (nonatomic) NSInteger multiple;
@property (nonatomic) NSMutableArray *selectDatas;
@property (nonatomic) NSArray *currentDatas;
@property (nonatomic) NSDateFormatter *formatter;
@property (nonatomic) NSCalendar *calendar;
/**
 *  @brief  得到过关投注数据
 *
 *  @param itemDatas 需要重组的所有数据
 *
 *  @return 返回重组好的过关投注数据
 */
+ (NSArray *)getDatasClassifyForLotteryPlayInformation:(NSArray *)itemDatas timestamp:(NSDate *)timestamp keyword:(NSString *)keyword ;

/**
 *  @brief  得到不同单场的返回对阵信息
 *
 *  @param datas                所有需要重组的数据
 *  @param predicateWithFormats 筛选谓词
 *  @param keyword              筛选关键字
 *
 *  @return 返回不同单场投注的所需要数据
 */
+ (NSArray *)getSingleDatasToItemDatas:(id)datas predicateWithFormats:(NSArray *)predicateWithFormats keyword:(NSString *)keyword;


/**
 *  @brief  得到开奖信息重组
 *
 *  @param datas 需要重组的数据
 *
 *  @return 返回重组好的数据
 */
+ (NSArray *)getTheLotteryInformation:(NSArray *)datas;

/**
 *  @brief  设置比分投注详情文字
 *
 *  @param datas 投注集合
 *
 *  @return 返回比分投注详情文字
 */
+ (NSMutableAttributedString *)setScroeTextWithDatas:(NSArray *)datas;

/**
 *  @brief  设置半全场投注详情文字
 *
 *  @param datas 投注集合
 *
 *  @return 返回半全场投注详情文字
 */
+ (NSMutableAttributedString *)setBQCTextWithDatas:(NSArray *)datas;

/**
 *  @brief  设置混合过关投注详情文字
 *
 *  @param model 投注集合
 *
 *  @return 返回混合过关投注详情文字
 */
+ (NSMutableAttributedString *)setHHGGTextWithDatas:(FBDatasModel *)model;

/**
 *  @brief  时间对比
 *
 *  @param date1 时间1
 *  @param date2 时间2
 *
 *  @return 返回是不是同一天
 */
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

/**
 *  @brief  投注界面的数据筛选
 *
 *  @param dic 被筛选的数据
 *
 *  @return 返回一筛选的数据
 */
+ (FBDatasModel *)filtrateWithBettingDatas:(NSDictionary *)dic;

/**
 *  @brief  <#Description#>
 *
 *  @param dic  <#dic description#>
 *  @param play <#play description#>
 *
 *  @return <#return value description#>
 */
+ (FBDatasModel *)filtrateWithBettingDatas:(NSDictionary *)dic play:(FBBettingPlay)play;

/**
 *  @brief  返回用户当前玩法选了多少注
 *
 *  @param play 玩法
 *
 *  @return 返回注数
 */
+ (NSArray *)filtrateWithCurrentBettingPlay:(FBBettingPlay)play;



+ (void)calculateSingleDatas:(NSArray *)datas result:(void(^)(NSInteger bettingNum))result;


+ (void)calculateSkipmatchDatas:(NSArray *)datas scheme:(NSMutableArray *)scheme result:(void(^)(NSInteger bettingNum, CGFloat maxNum, CGFloat minNum))result;

@end
