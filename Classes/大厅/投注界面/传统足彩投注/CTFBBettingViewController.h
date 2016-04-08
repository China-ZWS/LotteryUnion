//
//  CTFBBettingViewController.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/15.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BaseBettingViewController.h"
#import "CTFBHelp.h"
@interface CTFBBettingViewController : BaseBettingViewController
{
    NSInteger _bettingNum;
    CTZQPlayType _playType;
}
@property (nonatomic) NSInteger bettingNum;
@property (nonatomic) CTZQPlayType playType;

- (id)initWithPlayType:(CTZQPlayType)playType;
- (void)refreshViews;
- (API_play)getDetailednessWithPlayType:(BOOL)hasCompound;
- (API_LotteryType )getLotteryType;
- (void)showSuccessWithStatus:(NSString *)status;
- (void)requestGotoBetting;

@end
