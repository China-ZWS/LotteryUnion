//
//  BetCell.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/4.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BetCell.h"


@implementation BetCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height-25), 40, 25)];
        [self addSubview:imgView];
        
        // 彩种名
        lottery_name = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+2,3,80,30)];
        [lottery_name setFont:[UIFont systemFontOfSize:14]];
        [lottery_name setTextAlignment:NSTextAlignmentCenter];
        [lottery_name setNumberOfLines:0];
        [self addSubview:lottery_name];
        
        // 期数
        number = [[UILabel alloc] initWithFrame:CGRectMake(lottery_name.right+3, 9, 100, 20)];
        [number setFont:[UIFont systemFontOfSize:12]];
        [number setTextColor:[UIColor grayColor]];
        [number setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:number];
        
        // 投注金额
        date = [[UILabel alloc] initWithFrame:CGRectMake(mScreenWidth-90+10, self.bottom-13, 80, 20)];
        [date setFont:[UIFont systemFontOfSize:13]];
        [date setTextAlignment:NSTextAlignmentCenter];
        [date setTextColor:RGBA(199, 54, 51, 1)];
        [self addSubview:date];
        
        // 状态
        desc = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+2, lottery_name.bottom, 80, 20)];
        [desc setFont:[UIFont systemFontOfSize:12]];
        [desc setTextAlignment:NSTextAlignmentCenter];
        [desc setTextColor:[UIColor grayColor]];
        [self addSubview:desc];
        
        
        //中奖标识  mScreenWidth-90+40+6
        dateLog = [[UIImageView alloc] initWithFrame:CGRectMake(0, date.top-20, 15, 15)];
        [self.contentView addSubview:dateLog];
        
        //送彩票的标识
        luckyLog = [[UIImageView alloc] initWithFrame:CGRectMake(0, date.top-20, 15, 15)];
        [self.contentView addSubview:luckyLog];
    }
    return self;
    
}


- (void)setWinModel:(WinModel *)winModel {
    _winModel = winModel;
    NSLog(@"%@",self.winModel.contributor_phone);
    
    NSString *lottery_pk = _winModel.lottery_pk;
    NSString *lottery_code = _winModel.lottery_code;
    if ([lottery_pk isEqual:@"15"]) {
        if ([lottery_code isEqual:@"11"] || [lottery_code isEqual:@"12"]) {
            lottery_name.text = @"胜平负";
            imgView.image = [UIImage imageNamed:@"jczq_1@2x.png"];
        }else if ([lottery_code isEqual:@"21"] || [lottery_code isEqual:@"22"]) {
            lottery_name.text = @"让球胜平负";
            imgView.image = [UIImage imageNamed:@"jczq_2@2x.png"];
        }else if ([lottery_code isEqual:@"31"] || [lottery_code isEqual:@"32"]) {
            lottery_name.text = @"比分";
            imgView.image = [UIImage imageNamed:@"jczq_3@2x.png"];
        }else if ([lottery_code isEqual:@"41"] || [lottery_code isEqual:@"42"]) {
            lottery_name.text = @"半全场";
            imgView.image = [UIImage imageNamed:@"jczq_4@2x.png"];
        }else if ([lottery_code isEqual:@"51"] || [lottery_code isEqual:@"52"]) {
            lottery_name.text = @"总进球数";
            imgView.image = [UIImage imageNamed:@"jczq_5@2x.png"];
        }else if ([lottery_code isEqual:@"61"] || [lottery_code isEqual:@"62"]) {
            lottery_name.text = @"混合过关";
            imgView.image = [UIImage imageNamed:@"jczq_6@2x.png"];
        }
    }else {
        lottery_name.text = winModel.lottery_name;
        NSLog(@"%@",self.winModel.lottery_pk);
        NSString *imgName = [self getLotIcons:self.winModel.lottery_pk];
        imgView.image = [UIImage imageNamed:imgName];
    }
    
    if (self.winModel.period.length == 8) {
        NSString *str1 = [self.winModel.period substringToIndex:4];
        NSString *str2 = [self.winModel.period substringWithRange:NSMakeRange(4, 2)];
        NSString *str3 = [self.winModel.period substringWithRange:NSMakeRange(6, 2)];
        number.text = [NSString stringWithFormat:@"%@-%@-%@",str1,str2,str3];
    }else {
        number.text = [NSString stringWithFormat:@"%@期",self.winModel.period];
    }
    
    date.text = [NSString stringWithFormat:@"%@元",self.winModel.money];
    
    if ([self.winModel.prize_status isEqualToString:@"2"]) {    //中奖
        if (![self.winModel.contributor_phone isEqual:@""]) {    //送彩票 既中奖又送彩票
            dateLog.image = [UIImage imageNamed:@"zhongjiang.png"];
            dateLog.left = mScreenWidth-90+35;
            luckyLog.image = [UIImage imageNamed:@"songcaip@2x.png"];
            luckyLog.left = mScreenWidth-90+52;
        }else {
            dateLog.image = [UIImage imageNamed:@"zhongjiang.png"];
            dateLog.left = mScreenWidth-90+40+6;
        }
    }else {    //未中奖
        if (![self.winModel.contributor_phone isEqual:@""]) {    //送彩票
            luckyLog.image = [UIImage imageNamed:@"songcaip@2x.png"];
            luckyLog.left = mScreenWidth-90+40+6;
        }else {
        }
    }
 
    
    if ([self.winModel.status isEqual:@"0"]) {          //投注中
        desc.text = @"投注中";
    }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
        desc.text = @"投注成功";
    }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
        desc.text = @"投注失败";
    }
    
}



#pragma mark - 通过彩种获得名字
- (NSString *)getLotIcons:(NSString *)lot_pk {
    
    return  [[self getLotteryDictionary:lot_pk] objectForKey:@"SmallIcon"];
}


- (NSDictionary *)getLotteryDictionary:(NSString *)lottery_pk {
    
    if(!lots_dictionary){
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"PlayType" ofType:@"plist"];
        lots_dictionary = [NSDictionary dictionaryWithContentsOfFile:plist];
        NSLog(@"lots_dictionary = %@",lots_dictionary);
    }
    return [lots_dictionary objectForKey:lottery_pk];
    
}

@end
