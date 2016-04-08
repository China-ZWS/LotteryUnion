//
//  AwardDetailVC.h
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "JCHModel.h"

@interface AwardDetailVC : PJViewController<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSString *_identify;
    
    
}

- (instancetype)initWithJCHModel:(JCHModel *)JCHModel
                        playName:(NSString *)playName;


@property(nonatomic,strong)JCHModel *jchModel;

@property (nonatomic,strong)NSMutableArray *detailArray;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *dataCount;
@property (nonatomic,strong)NSMutableArray *DLTArray;

@end
