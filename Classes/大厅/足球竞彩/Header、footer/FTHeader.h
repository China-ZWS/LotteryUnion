//
//  FTHeader.h
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHelp.h"

@interface FTHeader : UIView
+ (FTHeader *)selectBlock:(void(^)(FBBettingType type))select;

/**
 *  @brief  显示总赛事数量
 *
 *  @param numOfAllCompetition 数量
 */
- (void)setHeaderWithAllCompetition:(NSInteger)numOfAllCompetition;

/**
 *  @brief  默认过关选项
 */
- (void)defaultTouchWithSkipmatch;

- (void)hideSingleOption:(BOOL)hasHide;

@end
