//
//  CTFBBettingToolView.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/16.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTFBBettingToolView;

@protocol  CTFBBettingToolViewDelegate <NSObject>
- (void)toolView:(CTFBBettingToolView *)toolView changeWithMultiple:(NSInteger)multiple;
@end
@interface CTFBBettingToolView : UIView
@property (nonatomic, weak) id<CTFBBettingToolViewDelegate>delegate;
+ (void)showViewToView:(UIView *)view delegate:(id<CTFBBettingToolViewDelegate>)delegate;


@end
