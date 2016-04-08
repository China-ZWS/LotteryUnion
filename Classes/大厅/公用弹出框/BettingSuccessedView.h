//
//  BettingSuccessedView.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BettingSuccessedView : UIView
+ (id)showWithContent:(NSString *)content returnEvent:(void(^)())returnEvent shareEvent:()shareEvent;

@end
