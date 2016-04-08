//
//  ResultCell.h
//  LotteryUnion
//
//  Created by xhd945 on 15/11/17.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BetResult;

@interface BetResultCell : UITableViewCell
@property(strong,nonatomic) UIButton *delResult;
@property(strong,nonatomic) UILabel *numberLabel;
@property(strong,nonatomic) UILabel *playLabel;
@property(strong,nonatomic) UILabel *moneyLabel;
@property(strong,nonatomic) UIImageView *sepLine;

-(id)initWithFrame:(CGRect)frame reusedIdentifier:(NSString *)reuseIdentifier;
-(void)setBetResult:(BetResult*)res;
-(CGSize)calcCellSize;

+(NSMutableArray*) parseBetNumbers:(BetResult*)bean;
@end
