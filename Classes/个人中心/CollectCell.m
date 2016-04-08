//
//  CollectCell.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/8.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CollectCell.h"
#import "NSString+ConvertDate.h"
#import "CollectDetailViewController.h"
#import "NSString+NumberSplit.h"

@implementation CollectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
       
        [self setBackgroundColor:[UIColor clearColor]];

        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bgButton.frame = CGRectMake(10, 10, mScreenWidth-20, 130);
        [bgButton setBackgroundImage:[UIImage imageNamed:@"scj_chupiao@2x.png"] forState:UIControlStateNormal];
        bgButton.userInteractionEnabled = NO;
//        [bgButton addTarget:self action:@selector(toDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bgButton];
        
        lottery_name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bgButton.width-20, bgButton.height/4)];
        [lottery_name setFont:[UIFont systemFontOfSize:14]];
        [bgButton addSubview:lottery_name];

        number = [[UILabel alloc] initWithFrame:CGRectMake(10, lottery_name.bottom,bgButton.width-20, bgButton.height/4)];
        [number setFont:[UIFont systemFontOfSize:14]];
        [bgButton addSubview:number];
        
        date = [[UILabel alloc] initWithFrame:CGRectMake(10, number.bottom,bgButton.width-20, bgButton.height/4)];
        [date setFont:[UIFont systemFontOfSize:14]];
        [bgButton addSubview:date];
        
        desc = [[UILabel alloc] initWithFrame:CGRectMake(10, date.bottom,bgButton.width-20, bgButton.height/4)];
        [desc setFont:[UIFont systemFontOfSize:14]];
        [bgButton addSubview:desc];
        
    }
    return self;
    
}


- (void)setWinModel:(WinModel *)winModel {
    _winModel = winModel;
    
    NSString *playType = getPlayTypeName([[self.winModel lottery_code] intValue]);
    lottery_name.text = [NSString stringWithFormat:@" 彩种: %@ %@",[self getLotNames:_winModel.lottery_pk],playType];
    if ([_winModel.lottery_pk intValue] == 31) {
        NSString *str1 = [[self SSQNumber:_winModel.number] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        number.text = [NSString stringWithFormat:@" 号码: %@",str1];
    }else {
        NSString *str2 = [_winModel.formatedNumber stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
       number.text = [NSString stringWithFormat:@" 号码: %@",str2];
    }
    date.text = [NSString stringWithFormat:@" 时间: %@",[winModel.create_time toFormatDateString]];
    desc.text = [NSString stringWithFormat:@" 备注: %@",winModel.desc];
}

#pragma mark - 通过彩种获得名字
- (NSString *)getLotNames:(NSString *)lot_pk {
    
    return  [[self getLotteryDictionary:lot_pk] objectForKey:@"PlayName"];
}

- (NSDictionary *)getLotteryDictionary:(NSString *)lottery_pk {
    
    if(!lots_dictionary){
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"PlayType" ofType:@"plist"];
        lots_dictionary = [NSDictionary dictionaryWithContentsOfFile:plist];
        NSLog(@"lots_dictionary = %@",lots_dictionary);
    }
    return [lots_dictionary objectForKey:lottery_pk];
}


//双色球
- (NSString *)SSQNumber:(NSString *)num {
    NSArray *dAry = [num componentsSeparatedByString:@"#"];
    NSMutableString *mStr2 = [NSMutableString string];
    if ([self.winModel.lottery_code intValue] == pSSQ_Dantuo) {
        NSDictionary *aDict = [num splitDantuoS];   //拆分胆拖
        [mStr2 appendFormat:@"前区胆 %@\n",[aDict objectForKey:@"qianqu_dan"]];
        [mStr2 appendFormat:@"前区拖 %@\n",[aDict objectForKey:@"qianqu_tuo"]];
        [mStr2 appendFormat:@"后区  %@\n",[aDict objectForKey:@"houqu_dan"]];
        NSLog(@"1 %@",mStr2);
        return mStr2;
    }else if ([self.winModel.lottery_code intValue] == pSSQ_Danshi) {
        NSLog(@"%@",self.winModel.number);
        for (int i = 0; i < [dAry count]; i++) {
            NSString *subNumber = [dAry objectAtIndex:i];
            subNumber = [subNumber componentsSepartedByString:@" " length:2];
            NSLog(@"%@",subNumber);
            
            subNumber = [NSString stringWithFormat:@"%@+%@",[subNumber substringToIndex:17],[subNumber substringFromIndex:18]];
            [mStr2 appendFormat:@"%@\n", subNumber];
            NSLog(@"3 %@",mStr2);
        }
        return mStr2;
    }else if ([self.winModel.lottery_code intValue] == pSSQ_Fushi) {
        [mStr2 appendFormat:@"前区 %@\t\t",[[dAry objectAtIndex:0] componentsSepartedByString:@" " length:2]];
        [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:1] componentsSepartedByString:@" " length:2]];
        return mStr2;
        NSLog(@"2 %@",mStr2);
        return mStr2;
    }
    return nil;
}



@end
