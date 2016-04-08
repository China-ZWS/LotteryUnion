//
//  BaseBettingModel.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/20.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BaseBettingModel.h"
#import "FootBallModel.h"

@implementation BaseBettingModel

+ (void)gotoBettingWithZCJJ_single:(NSArray *)bettings isHunhe:(BOOL)isHunhe result:(void(^)(NSString *bettingSring, BOOL hasCompound))result;
{
    NSMutableString *betting = [NSMutableString new];
    BOOL hasCompound = NO; //用来判断是单关还是复式
    int i = 0;
    for (FBDatasModel *model in bettings)
    {
        if (isHunhe) {
            
            [betting appendString:[NSString stringWithFormat:@"%d",[self bettingPlay:model]]];
            [betting appendString:@"@"];
        }
        [betting appendString:model.position];
        [betting appendString:@"$"];
        if (model.win)
        {
            [betting appendString:@"3"];
        }
        if (model.pin)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"1"];
        }
        if (model.lose)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"0"];
        }
        if (model.rWin)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"3"];
        }
        if (model.rPin)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"1"];
        }
        if (model.rLose)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"0"];
        }
        if (model.scroes && model.scroes.count)
        {
            for (NSDictionary *dic in model.scroes)
            {
                NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
                if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                    [betting appendString:@","];
                    hasCompound = YES;
                }
                [betting appendString:dic[@"value_storage"]];
            }
        }
        if (model.BQCDatas && model.BQCDatas.count) {
            for (NSDictionary *dic in model.BQCDatas)
            {
                NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
                if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                    [betting appendString:@","];
                    hasCompound = YES;
                }
                [betting appendString:dic[@"value_storage"]];
            }
        }
        if (model.JQS_select_one)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"0"];

        }
        
        if (model.JQS_select_two)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"1"];
        }
        if (model.JQS_select_three)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"2"];
        }
        if (model.JQS_select_four)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"3"];
        }
        if (model.JQS_select_five)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"4"];
        }
        if (model.JQS_select_six)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"5"];
        }
        if (model.JQS_select_seven)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"6"];
        }
        if (model.JQS_select_eight)
        {
            NSString *tempStr = [betting substringWithRange:NSMakeRange(betting.length - 1, 1)];
            if (![tempStr isEqualToString:@","] && ![tempStr isEqualToString:@"$"]) {
                [betting appendString:@","];
                hasCompound = YES;
            }
            [betting appendString:@"7"];
        }
        i ++;
        if (i != bettings.count) {
            [betting appendString:@"^"];
        }
    }
    
    result(betting,hasCompound);
}


+ (API_play)bettingPlay:(FBDatasModel *)model
{
    int i = 0;
    if (model.win) i ++;
    if (model.pin) i ++;
    if (model.lose) i ++;
    if (i > 0) {
        if (i > 1) {
            return kSFP_compound;
        }
        else
        {
            return kSFP_single;
        }
    }
    
    if (model.rWin) i ++;
    if (model.rPin) i ++;
    if (model.rLose) i ++;
    if (i > 0) {
        if (i > 1) {
            return kRQ_SFP_compound;
        }
        else
        {
            return kRQ_SFP_single;
        }
    }

    if (model.scroes) i += model.scroes.count;
    if (i > 0) {
        if (i > 1) {
            return kScore_compound;
        }
        else
        {
            return kScore_single;
        }
    }

    if (model.BQCDatas) i += model.BQCDatas.count;
    if (i > 0) {
        if (i > 1) {
            return kBQC_compound;
        }
        else
        {
            return kBQC_single;
        }
    }

    if (model.JQS_select_one) i ++;
    if (model.JQS_select_two) i ++;
    if (model.JQS_select_three) i ++;
    if (model.JQS_select_four) i ++;
    if (model.JQS_select_five) i ++;
    if (model.JQS_select_six) i ++;
    if (model.JQS_select_seven) i ++;
    if (model.JQS_select_eight) i ++;
    if (i > 0) {
        if (i > 1) {
            return kJQS_compound;
        }
        else
        {
            return kJQS_single;
        }
    }
    return NSNotFound;
}

+ (void)gotoBettingWithCTZQ:(NSArray *)bettings playType:(CTZQPlayType)playType result:(void(^)(NSString *bettingSring))result;
{
    NSMutableString *betting = [NSMutableString new];
    BOOL hasCompound = NO;
    int i = 0;
    for (NSDictionary *dic in bettings)
    {
        if([dic[@"bettingText"] rangeOfString:@"#"].location !=NSNotFound)
        {
            hasCompound = YES;
        }
        API_play type = [self getDetailednessWithPlayType:playType hasCompound:hasCompound];
        [betting appendString:[NSString stringWithFormat:@"%03d",type]];
        [betting appendString:@"|"];
        [betting appendString:dic[@"bettingText"]];
        i ++;
        if (i != bettings.count)
        {
            [betting appendString:@";"];
        }
        hasCompound = NO;
    }
    result(betting);
}

+ (API_play)getDetailednessWithPlayType:(CTZQPlayType)_playType hasCompound:(BOOL)hasCompound
{
    API_play playType = NSNotFound;
    switch (_playType) {
        case kSF14:
        {
            if (hasCompound) {
                playType = pWinLost14_Fushi;
            }
            else
            {
                playType = pWinLost14_Danshi;
            }
        }
            break;
        case kRX9:
        {
            if (hasCompound) {
                playType = pAny9_Fushi;
            }
            else
            {
                playType = pAny9_Danshi;
            }
        }
            
            break;
        case k6CBQC:
        {
            if (hasCompound) {
                playType = pHalfWin_Fushi;
            }
            else
            {
                playType = pHalfWin_Danshi;
            }
        }
            
            break;
        case k4CJQ:
        {
            if (hasCompound) {
                playType = pEnter4_Fushi;
            }
            else
            {
                playType = pEnter4_Danshi;
            }
        }
        default:
            break;
    }
    return playType;
    
}
@end
