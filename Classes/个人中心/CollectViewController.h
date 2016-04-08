//
//  CollectViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/6.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"

@interface CollectViewController : PJViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *data;

@end
