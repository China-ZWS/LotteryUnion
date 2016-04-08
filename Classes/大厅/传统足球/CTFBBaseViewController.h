//
//  CTFBBaseViewController.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/13.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewController.h"
#import "CTFBModel.h"
#import "CTFBSCBaseViewController.h"

@interface CTFBBaseViewController : PJTableViewController
{
    NSInteger _bettingNum;
    API_LotteryType _lottery_pk;
}
@property (nonatomic) API_LotteryType lottery_pk;

/**
 *  @brief  去投注
 */
- (void)eventWithBettingType:(CTZQPlayType)bettingType;

/**
 *  @brief  去送菜
 */
- (void)eventWithSCP:(CTZQPlayType)bettingType;

/**
 *  @brief  计算投注数、金额。并且显示出来
 *
 *  @param bettingNum <#bettingNum description#>
 */
- (void)setInfoTitleWithText:(NSInteger)bettingNum;


/**
 *  @brief  用户选择投注数的实时变化
 */
- (void)changeWithValue_storages;

/**
 *  @brief 摇一摇 随机号码
 */
- (void)createShake;

@end
