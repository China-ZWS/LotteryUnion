//
//  ScoreOptionView.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/1.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreOptionView : UIView
+ (id)showWithDatas:(id)datas cacheDatas:(NSArray *)cacheDatas finished:(void(^)(id datas))finished;
@end
