//
//  CollectCell.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/8.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinModel.h"

static NSDictionary *lots_dictionary;


@interface CollectCell : UITableViewCell {
    
    
    UILabel *lottery_name;
    UILabel *number;
    UILabel *date;
    UILabel *desc;
}

@property (nonatomic,strong)WinModel *winModel;

@end
