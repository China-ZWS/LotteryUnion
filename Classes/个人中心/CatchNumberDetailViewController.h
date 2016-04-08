//
//  CatchNumberDetailViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/4.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "WinModel.h"

static NSDictionary *lots_dictionary;


@interface CatchNumberDetailViewController : PJViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    NSMutableArray *dataArray;
}


- (instancetype)initWithWinModel:(WinModel *)winModel;
@property (nonatomic,strong)WinModel *winModel;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *hhData;
@property (nonatomic,strong)NSMutableArray *number;

@end
