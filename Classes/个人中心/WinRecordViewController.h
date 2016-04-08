//
//  WinRecordViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"

@interface WinRecordViewController : PJViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *data;

@end
