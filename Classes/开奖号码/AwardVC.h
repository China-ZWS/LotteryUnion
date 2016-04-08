//
//  AwardVC.h
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"

@interface AwardVC : PJViewController

- (id)initWithLottery_pk:(NSString *)lottery_pk
                playName:(NSString *)playName;

@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)NSMutableArray *period;




@end
