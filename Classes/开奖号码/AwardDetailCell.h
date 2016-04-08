//
//  AwardDetailCell.h
//  LotteryUnion
//
//  Created by happyzt on 15/10/30.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwardDetailCell : UITableViewCell {
    
    __weak IBOutlet UILabel *_prizeLabel;
    __weak IBOutlet UILabel *_amountLabel;
    __weak IBOutlet UILabel *_moneyLabel;
    
    NSString *_lottery_pk;
    NSArray *_cellDatas;
    BOOL _isDlt_lot;
}


@property (nonatomic,strong)NSMutableArray *detailArray;
@property (nonatomic,strong)NSMutableArray *DLTArray;

@property (nonatomic) UILabel *bottomLabel4;
@property (nonatomic) UILabel *bottomLabel5;
@property (nonatomic) UILabel *bottomLabel6;

- (void)detailArray:(NSMutableArray *)array lottery_pk:(NSString *)lottery_pk;
- (void)DLTArray:(NSMutableArray *)array lottery_pk:(NSString *)lottery_pk;
//- (void)detailArray:(NSMutableArray *)array isDlt_lot:(BOOL)isDlt_lot;
@end
