//
//  TransAccountViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/18.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "WXLabel.h"

@interface TransAccountViewController : PJViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,WXLabelDelegate>

@property(nonatomic,strong)UITableView *tableView; //主表

- (instancetype)initWithAlipay:(BOOL)aliPay
                 withTrans:(BOOL)trans;


@end
