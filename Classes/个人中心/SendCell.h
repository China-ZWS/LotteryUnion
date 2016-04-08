//
//  SendCell.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/12.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinModel.h"

@interface SendCell : UITableViewCell {
    UILabel *lottery_name;
    UILabel *period;
    UILabel *award;
    UILabel *teleNumber;
}

@property (nonatomic,strong)WinModel *winModel;

@end
