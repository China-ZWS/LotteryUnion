//
//  AccountDetailViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/6.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "WinModel.h"

@interface AccountDetailViewController : PJViewController<UITableViewDataSource,UITableViewDelegate>

- (instancetype)initWithWinModel:(WinModel *)winModel;
@property (nonatomic,strong)WinModel *winModel;

@end
