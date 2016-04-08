//
//  BaseCell.h
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCHModel;

@interface BaseCell : UITableViewCell {
     UILabel *_ballLabel;
    UILabel *LBallLabel;
    UIView *ballsView;      // 球视图

}

@property(nonatomic,strong)JCHModel *jchModel;
@property(nonatomic,copy)NSString *lottery_pk;
@property(nonatomic,copy)NSString *playName;

@property (nonatomic,strong)NSMutableArray *data;


@end
