//
//  WinDetailViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "WinModel.h"

static NSDictionary *lots_dictionary;


@interface WinDetailViewController : PJViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)WinModel *winModel;

- (instancetype)initWithModel:(WinModel *)winModel;

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *hhData;



@end
