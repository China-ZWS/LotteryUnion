//
//  FBBettingToolView.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/9.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHelp.h"
@class FBBettingToolView;
@protocol FBBettingToolViewDelegate <NSObject>
@optional
- (void)toolView:(FBBettingToolView *)toolView didSelectView:(BOOL)hasSelected;
- (void)toolView:(FBBettingToolView *)toolView changeWithMultiple:(NSInteger)multiple;
@end

@interface FBBettingToolView : UIView
@property (nonatomic, weak) id <FBBettingToolViewDelegate>delegate;
@property (nonatomic) BOOL hasSelected;
+ (void)showViewToView:(UIView *)view delegate:(id<FBBettingToolViewDelegate>)delegate;
/**
 *  @brief  显示用户选择串数玩法
 *
 */
+ (void)setPlayTypeName:(NSMutableAttributedString *)text;


/**
 *  @brief  显示用户选择的倍数
 *
 */
+ (void)setMultiple:(NSInteger)multiple;
+ (void)setBettingType:(FBBettingType)bettingType;
@end
