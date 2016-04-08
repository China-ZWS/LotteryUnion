//
//  BettingCell.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/1.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewCell.h"
#import "BaseTypeTableView.h"
@interface BettingCell : BaseTypeCell
{
    UIButton *_cancel;
    CAShapeLayer *_border;
}
@property (nonatomic) UIButton *cancel;
@property (nonatomic) CAShapeLayer *border;

@end
