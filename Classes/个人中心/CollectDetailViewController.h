//
//  CollectDetailViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/8.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "WinModel.h"

@interface CollectDetailViewController : PJViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)WinModel *winModel;
@property (nonatomic,copy)NSString *lottery;
@property (nonatomic,strong)NSMutableArray *data;

- (instancetype)initWithModel:(WinModel *)winModel
              withLotteryName:(NSString *)lottery
             withSelectNumber:(NSString *)selecteNumber;

@end
