//
//  AccountCell.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/6.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinModel.h"

@interface AccountCell : UITableViewCell {
    UILabel *_money;
    UILabel *_pay_type;
    UILabel *_time;
    UILabel *_status;
    int _tag;
}

@property (nonatomic,strong)WinModel *winModel;

- (void)winModel:(WinModel *)model sign:(BOOL)decost tag:(int)tag;


@end
