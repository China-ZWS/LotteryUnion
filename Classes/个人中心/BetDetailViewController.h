//
//  BetDetailViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "WinModel.h"
static NSDictionary *lots_dictionary;


@interface BetDetailViewController : PJViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)WinModel *winModel;

- (instancetype)initWithModel:(WinModel *)winModel;

@end
