//
//  JCZQTableView.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/10.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinModel.h"

@interface JCZQTableView : UITableView<UITableViewDataSource,UITableViewDelegate> {
    NSString *_chuangGuan;
    float height;
    NSString *stringnumber;
    NSArray *hhNumber;
    NSString *hunheNumber;
}
@property (nonatomic,strong)WinModel *winModel;

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *chuangData;
@property (nonatomic,strong)NSMutableArray *hhData;
@property (nonatomic,assign)BOOL isWin;
@property (nonatomic,assign)BOOL isBet;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style win:(BOOL)isWin betRecord:(BOOL)isBet;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style betRecord:(BOOL)isBet;
@end
