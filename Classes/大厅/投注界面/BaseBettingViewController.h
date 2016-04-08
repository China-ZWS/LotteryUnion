//
//  BettingViewController.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/1.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewController.h"
#import "ShareTools.h"
#import "UserInfo.h"
#import "BettingSuccessedView.h"
#import "BettingFailedView.h"

@interface BaseBettingViewController : PJTableViewController
{
    UILabel *_titleDate;
    UIButton *_addTitle;
    UIButton *_finished;
    UILabel *_infoView;
    UIImageView *_headerImg;
}
@property (nonatomic) UILabel *titleDate;
@property (nonatomic) UIButton *addTitle;
@property (nonatomic) UIButton *finished;
@property (nonatomic) UILabel *infoView;
@property (nonatomic) UIImageView *headerImg;


- (void)gotoBetting:(NSString *)period gift_phone:(NSString *)gift_phone greetings:(NSString *)greetings;

/**
 *  @brief  设置\刷新投注截止时间
 *
 *  @param endTime 投注截止时间
 */
- (void)setEndTime:(NSString *)endTime;

/**
 *  @brief  设置\刷新已添加几场比赛
 */
- (void)setSpendfew;

/**
 *  @brief  <#Description#>
 *
 *  @param attrString <#attrString description#>
 */
- (void)setInfoAttributedText:(NSMutableAttributedString *)attrString;

/**
 *  @brief  继续投注
 */
- (void)eventWithPlayon;

/**
 *  @brief  删除数据
 */
- (void)removeDatas;

/**
 *  @brief  响应完成事件
 */
- (void)eventWithFinish;

- (void)didBack;
@end
