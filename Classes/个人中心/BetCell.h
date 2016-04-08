//
//  BetCell.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/4.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinModel.h"
static NSDictionary *lots_dictionary;


@interface BetCell : UITableViewCell {
    
    UIImageView *imgView;
    UILabel *lottery_name;
    UILabel *number;
    UILabel *date;
    UILabel *desc;
    UIButton *event;
    UIImageView *dateLog;
    UIImageView *luckyLog;
}

@property (nonatomic,strong)WinModel *winModel;


@end
