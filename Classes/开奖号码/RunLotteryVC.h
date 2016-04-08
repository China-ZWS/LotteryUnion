//
//  RunLotteryVC.h
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"


@interface RunLotteryVC : PJViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *lottery_pk;

@end
