//
//  CatchNumberCell.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinModel.h"


static NSDictionary *lots_dictionary;

@interface CatchNumberCell : UITableViewCell {
    UILabel *lottery_name;
    UILabel *number;
    UILabel *period;
    UILabel *date;
    UILabel *desc;
    UIButton *event;
    UIImageView *fail;
}

@property (nonatomic,strong)WinModel *winModel;

@end
