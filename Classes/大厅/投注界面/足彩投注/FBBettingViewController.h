//
//  FBBettingViewController.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/2.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BaseBettingViewController.h"
#import "BettingSPFCell.h"
#import "BettingRQSPFCell.h"
#import "BettingScoreCell.h"
#import "BettingBQCCell.h"
#import "BettingJQSCell.h"
#import "BettingHHGGCell.h"

@interface FBBettingViewController : BaseBettingViewController

- (id)initWithParameters:(id)parameters playType:(FBPlayType)playType bettingType:(FBBettingType)bettingType clear:(void(^)())clear;
//- (void)gotoBetting:(NSString *)period gift_phone:(NSString *)gift_phone greetings:(NSString *)greetings;

@end
