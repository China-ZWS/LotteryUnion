//
//  BaseBettingModel.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/20.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTFBHelp.h"

@interface BaseBettingModel : NSObject

/**
 *  @brief
 *
 *  @param bettings <#bettings description#>
 *  @param result   <#result description#>
 */
+ (void)gotoBettingWithZCJJ_single:(NSArray *)bettings isHunhe:(BOOL)isHunhe result:(void(^)(NSString *bettingSring, BOOL hasCompound))result;

+ (void)gotoBettingWithCTZQ:(NSArray *)bettings playType:(CTZQPlayType)playType result:(void(^)(NSString *bettingSring))result;

@end
