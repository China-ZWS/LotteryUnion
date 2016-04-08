//
//  SendCell.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/12.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "SendCell.h"

@implementation SendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _createSubViews];
    }
    
    return self;
    
}


- (void)_createSubViews {
    
    
    // 彩种名
    lottery_name = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2-15, (mScreenWidth-20)/4, 30)];
    [lottery_name setBackgroundColor:[UIColor clearColor]];
    [lottery_name setFont:[UIFont systemFontOfSize:12]];
    [lottery_name setTextAlignment:NSTextAlignmentCenter];
    [lottery_name setTextColor:RGBA(111, 137, 189, 1)];
//    lottery_name.backgroundColor = [UIColor redColor];
    [self addSubview:lottery_name];
    
    //期数
    period = [[UILabel alloc] initWithFrame:CGRectMake(lottery_name.width, self.height/2-15, (mScreenWidth-20)/4, 30)];
    [period setBackgroundColor:[UIColor clearColor]];
    [period setFont:[UIFont systemFontOfSize:12]];
    [period setTextAlignment:NSTextAlignmentCenter];
//        [period setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:period];
    
    
    // 奖金
    award = [[UILabel alloc] initWithFrame:CGRectMake(period.width*2, self.height/2-15,(mScreenWidth-20)/4, 30)];
    [award setBackgroundColor:[UIColor clearColor]];
    [award setFont:[UIFont systemFontOfSize:12]];
    [award setTextAlignment:NSTextAlignmentCenter];
//    [award setBackgroundColor:[UIColor grayColor]];
    [self addSubview:award];
    
    
    //手机号码
    teleNumber = [[UILabel alloc] initWithFrame:CGRectMake(period.width*3-8, 0, (mScreenWidth-20)/4+8, self.height)];
    [teleNumber setBackgroundColor:[UIColor clearColor]];
    [teleNumber setFont:[UIFont systemFontOfSize:11]];
    [teleNumber setTextAlignment:NSTextAlignmentCenter];
    teleNumber.numberOfLines = 0;
    [teleNumber setTextColor:RGBA(199, 0, 0, 1)];
//    [teleNumber setBackgroundColor:[UIColor blackColor]];
    [self addSubview:teleNumber];
    
}


- (void)setWinModel:(WinModel *)winModel {
    _winModel = winModel;

    if (self.winModel.period.length == 8) {
        NSString *str1 = [self.winModel.period substringToIndex:4];
        NSString *str2 = [self.winModel.period substringWithRange:NSMakeRange(4, 2)];
        NSString *str3 = [self.winModel.period substringWithRange:NSMakeRange(6, 2)];
        period.text = [NSString stringWithFormat:@"%@-%@-%@",str1,str2,str3];
    }else {
        period.text = [NSString stringWithFormat:@"%@期",self.winModel.period];
    }
    award.text = [NSString stringWithFormat:@"%@元",self.winModel.money];
    teleNumber.text = self.winModel.gift_phone;
    
    NSString *lottery_pk = self.winModel.lottery_pk;
    NSString *lottery_code = self.winModel.lottery_code;
    
    if ([lottery_pk isEqual:@"15"]) {
        if ([lottery_code isEqual:@"11"] || [lottery_code isEqual:@"12"]) {
            lottery_name.text = @"胜平负";
            
        }else if ([lottery_code isEqual:@"21"] || [lottery_code isEqual:@"22"]) {
            lottery_name.text = @"让球胜平负";
        }else if ([lottery_code isEqual:@"31"] || [lottery_code isEqual:@"32"]) {
            lottery_name.text = @"比分";
        }else if ([lottery_code isEqual:@"41"] || [lottery_code isEqual:@"42"]) {
            lottery_name.text = @"半全场";
        }else if ([lottery_code isEqual:@"51"] || [lottery_code isEqual:@"52"]) {
            lottery_name.text = @"进球数";
        }else if ([lottery_code isEqual:@"61"] || [lottery_code isEqual:@"62"]) {
            lottery_name.text = @"混合过关";
        }
    }else {
        lottery_name.text = self.winModel.lottery_name;
    }
    
 
}

@end
