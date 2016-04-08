//
//  CatchNumberCell.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CatchNumberCell.h"

@implementation CatchNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _createSubViews];
    }
    
    return self;
    
}


- (void)_createSubViews {
    
    // 彩种名
    lottery_name = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2-10, (mScreenWidth-20)/5, 20)];
    [lottery_name setBackgroundColor:[UIColor clearColor]];
    [lottery_name setFont:[UIFont systemFontOfSize:12]];
    [lottery_name setTextAlignment:NSTextAlignmentCenter];
    lottery_name.textColor = RGBA(111, 137, 189, 1);
//    lottery_name.backgroundColor = [UIColor redColor];
    [self addSubview:lottery_name];
    
    // 追号期数
    number = [[UILabel alloc] initWithFrame:CGRectMake(lottery_name.width, self.height/2-10, (mScreenWidth-20)/5, 20)];
    [number setBackgroundColor:[UIColor clearColor]];
    [number setFont:[UIFont systemFontOfSize:13]];
    [number setTextAlignment:NSTextAlignmentCenter];
//    [number setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:number];
    
    // 剩余追号期数
    period = [[UILabel alloc] initWithFrame:CGRectMake(number.width*2, self.height/2-10, (mScreenWidth-20)/5, 20)];
    [period setBackgroundColor:[UIColor clearColor]];
    [period setFont:[UIFont systemFontOfSize:13]];
    [period setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:period];
    
    // 金额
    date = [[UILabel alloc] initWithFrame:CGRectMake(period.width*3, self.height/2-10,(mScreenWidth-20)/5, 20)];
    [date setBackgroundColor:[UIColor clearColor]];
    [date setFont:[UIFont systemFontOfSize:13]];
    [date setTextAlignment:NSTextAlignmentCenter];
    date.textColor = RGBA(249, 177, 116, 1);
    [self addSubview:date];
    
    
    // 状态
    desc = [[UILabel alloc] initWithFrame:CGRectMake(date.width*4, self.height/2-10, (mScreenWidth-20)/5, 20)];
    [desc setBackgroundColor:[UIColor clearColor]];
    [desc setFont:[UIFont systemFontOfSize:13]];
    [desc setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:desc];
    
}

- (void)setWinModel:(WinModel *)winModel {
    _winModel = winModel;
    
    NSString *lottery_pk = _winModel.lottery_pk;
    NSString *lottery_code = _winModel.lottery_code;
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
            lottery_name.text = @"总进球数";
        }else if ([lottery_code isEqual:@"61"] || [lottery_code isEqual:@"62"]) {
            lottery_name.text = @"混合过关";
        }
    }else {
        lottery_name.text = getLotNames(_winModel.lottery_pk);
    }
    number.text = [NSString stringWithFormat:@"%@期",[_winModel.follow_num isEqualToString:@"-1"]?@"无限":_winModel.follow_num];
    NSLog(@"%@",_winModel.follow_num);
    if ([_winModel.follow_num intValue]-[_winModel.finish_num intValue]==-1) {
        period.text = @"无限期";
    }else if ([_winModel.follow_num intValue] == -1) {
        period.text = @"无限期";
    }else {
        period.text = [_winModel.follow_num intValue] == -1 ?@"无限期":[NSString stringWithFormat:@"%d期",[_winModel.follow_num intValue]-[_winModel.finish_num intValue]];
    }

    // 计算金额
    if (_winModel.sup) {
        int s = [_winModel.sup intValue];
        if (s == 0) {    //不追加
            int money = [_winModel.amount intValue] * 2 * [_winModel.multiple intValue];
            date.text = [NSString stringWithFormat:@"%d元",money];
        } else {       //追加
            int money = [_winModel.amount intValue] * 3 * [_winModel.multiple intValue];
            date.text = [NSString stringWithFormat:@"%d元",money];
        }
    } else {
        
        int money = [_winModel.amount intValue] * 2 * [_winModel.multiple intValue];
        date.text = [NSString stringWithFormat:@"%d元",money];
    }
    
    switch ([_winModel.follow_status intValue]) {
        case 0:
            desc.text = @"未结束";
            break;
        case 1:
            desc.text = @"已结束";
            break;
        case -1:
            desc.text = @"已取消";
            break;
        case 2:
            desc.text = @"中奖结束";
            break;
    }

    if (_winModel.fail_status.intValue != 0) {
        if (_winModel.fail_status.intValue == 1) {
            UIImage *header = [UIImage imageNamed:@"trade_fail_nomoney"];
            [fail setImage:header];
        } else if (_winModel.fail_status.intValue == 2) {
            UIImage *header = [UIImage imageNamed:@"trade_fail_lock"];
            [fail setImage:header];
        }
        
        CGSize sizeToFit = [NSObject getSizeWithText:desc.text font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(60, CGFLOAT_MAX)];
        
//        CGSize sizeToFit = [desc.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(60, CGFLOAT_MAX) lineBreakMode:NSLineBreakByClipping];
        
        int offset = (80-(sizeToFit.width+15))/2;
        [desc setTextAlignment:NSTextAlignmentLeft];
        [desc setFrame:CGRectMake(240+offset, 12, 80, 20)];
        [fail setFrame:CGRectMake(320-offset-17, 16, 12, 12)];
    } else {
        [fail setImage:[UIImage imageNamed:@""]];
    }
    
}




@end
