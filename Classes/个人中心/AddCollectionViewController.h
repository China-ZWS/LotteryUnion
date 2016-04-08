//
//  AddCollectionViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/8.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BaseViewController.h"
#import "WinModel.h"

@interface AddCollectionViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UITextViewDelegate>

@property (nonatomic,strong)WinModel *winModel;

@property (nonatomic,strong)NSMutableArray *data;


- (instancetype)initWithWinModel:(WinModel *)winModel
                WithLotteryName:(NSString *)lotteryName
                WithSelectNumber:(NSString *)selectNumbe;


- (instancetype)initWithWinModel:(WinModel *)winModel
                 WithSelectNumber:(NSString *)selectNumber;


@end
