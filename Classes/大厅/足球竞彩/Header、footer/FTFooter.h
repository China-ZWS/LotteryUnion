//
//  FTFooter.h
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHelp.h"
@interface FTFooter : UIView
+ (FTFooter *)select:(void(^)(id datas))select SCEvent:(void(^)(id datas))SCEvent clear:(void(^)())clear;

/**
 *  @brief  用户选择的单关还是过关，及但来的选择场次的玩法的提示
 *
 *  @param hasSingle <#hasSingle description#>
 */
- (void)setRuleForSingle:(BOOL)hasSingle;

/**
 *  @brief  设置用户当前玩法选择了多少场次
 *
 *  @param bettingType 用户选择的是单关还是过关投注的依据
 *  @param playType    用户选择的是玩法
 */
- (void)setCurrentBettingType:(FBBettingType)bettingType playType:(FBPlayType)playType;

@end

