//
//  BettingFailedView.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BettingFailedView : UIView
+ (id)showWithContent:(NSString *)content finishedEvent:(void(^)())finishedEvent;

@end
