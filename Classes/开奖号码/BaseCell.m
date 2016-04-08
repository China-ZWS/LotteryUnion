//
//  BaseCell.m
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BaseCell.h"
#import "JCHModel.h"
#import "NSString+NumberSplit.h"
#import "UIView+Additions.h"
#import "UIColor+Hex.h"

@implementation BaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //        [self _createSubViews];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.data = [NSMutableArray new];
        
    }
    
    return self;
}


- (void)setLottery_pk:(NSString *)lottery_pk {
    _lottery_pk = lottery_pk;
    
    [self _createSubViews];
    
}

- (void)setJchModel:(JCHModel *)jchModel {
    _jchModel = jchModel;
    
    UILabel *periodLabel = (UILabel *)[self.contentView viewWithTag:101];
    periodLabel.text = [NSString stringWithFormat:@"第%@期",_jchModel.period];
    NSArray *textArray = [self transformData];
    
    if ([_lottery_pk intValue] ==kType_CTZQ_SF14
        || [_lottery_pk intValue] ==kType_CTZQ_SF9
        || [_lottery_pk intValue] ==kType_CTZQ_BQC6
        || [_lottery_pk intValue] ==kType_CTZQ_JQ4) {
    
        [self createBalls:textArray];   //足彩
        
    }else if ([_lottery_pk intValue] ==lDLT_lottery
              || [_lottery_pk intValue] ==lT225_lottery
              || [_lottery_pk intValue] ==lSSQ_lottery) {
        
        [self _createDLTBalls:textArray];
        
    }else if ([_lottery_pk intValue] ==lT367_lottery
              || [_lottery_pk intValue] ==lT317_lottery){
        
        [self _createSBalls:textArray];
    }else {
        
        [self _createOtherBalls:textArray];
    }
    
}



// 将字符串--》数组
- (NSArray *)transformData {
    NSString *textString = _jchModel.bonus_number;
    textString  = [textString replaceAll:@"[^0-9]" withString:@""];
    NSString *textStr = [textString commonString:@" " length:1];
    NSArray  *textArray = [textStr componentsSeparatedByString:@" "];
    NSLog(@"textArray=%@",textArray);
    
    return textArray;
    
}

- (void)setPlayName:(NSString *)playName {
    _playName = playName;
    
    UILabel *titleLabel = (UILabel *)[self.contentView viewWithTag:100];
    titleLabel.text = _playName;
}


//创建标题与彩期
- (void)_createSubViews {
    
    //创建标题label
    UILabel *titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(10, 5, (mScreenWidth-20)/3, 30)];
    titleLabel.tag = 100;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    //创建彩期label
    UILabel *periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+10, 7, 100, 30)];
    periodLabel.tag = 101;
    periodLabel.textColor = [UIColor grayColor];
    periodLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:periodLabel];
}


//创建开奖号码的球  足彩
- (void)createBalls:(NSArray *)textArray {
    
    UILabel *titlLabel = (UILabel *)[self.contentView viewWithTag:100];
    
    //创建开奖号码label
    for (int i = 0; i<textArray.count; i++)
    { 
        _ballLabel = [[UILabel alloc] initWithFrame:CGRectMake(9+(15+1)*i, titlLabel.bottom+2, 15, 20)];
        [_ballLabel setBackgroundColor:[UIColor clearColor]];
        [_ballLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_ballLabel setTextColor:[UIColor whiteColor]];
        _ballLabel.backgroundColor = [UIColor colorWithHexString:@"#00b2c0"];
        _ballLabel.text = textArray[i];
        _ballLabel.font = BallFont;
        _ballLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_ballLabel];
    }
}


//创建大乐透 双色球
- (void)_createDLTBalls:(NSArray *)textArray {
    
    UILabel *titlLabel = (UILabel *)[self.contentView viewWithTag:100];
    
    for (int i = 0; i < textArray.count; i++)
    {
        NSString *text = [NSString stringWithFormat:@"%@%@",textArray[i],textArray[i+1]];
        [self.data addObject:text];
        i++;
    }
    
    for (int i = 0; i < textArray.count/2; i++) {
        
        LBallLabel = [[UILabel alloc] initWithFrame:CGRectMake(9+(25+1)*i, titlLabel.bottom, 25, 25)];
        LBallLabel.layer.cornerRadius = LBallLabel.size.width/2;
        LBallLabel.layer.masksToBounds = YES;
        LBallLabel.text = [NSString stringWithFormat:@"%@",self.data[i]];
        LBallLabel.textAlignment = NSTextAlignmentCenter;
        LBallLabel.textColor = [UIColor whiteColor];
        LBallLabel.font = BallFont;
        [self.contentView addSubview:LBallLabel];
       
        if ([self.jchModel.lottery_pk isEqual:@"6"] || [self.jchModel.lottery_pk isEqual:@"52"])
        {
            
            if (i >= 5) {
                LBallLabel.backgroundColor = RGBA(66, 115, 249, 1);
            }else {
                LBallLabel.backgroundColor = [UIColor colorWithHexString:@"c12b1c"];
                
            }
        }else {
            if (i >= 6) {
                LBallLabel.backgroundColor = RGBA(66, 115, 249, 1);
            }else {
                LBallLabel.backgroundColor = [UIColor colorWithHexString:@"c12b1c"];
                
            }
        }
    }
}

//创建剩余的形状 七彩星 排列3 排列5
- (void)_createOtherBalls:(NSArray *)textArray {
    
    UILabel *titlLabel = (UILabel *)[self.contentView viewWithTag:100];
    
    for (int i = 0; i < textArray.count; i++) {
        
        UILabel *otherBallLabel = [[UILabel alloc] initWithFrame:CGRectMake(9+(25+1)*i, titlLabel.bottom, 25, 25)];
        otherBallLabel.backgroundColor = [UIColor colorWithHexString:@"c12b1c"];
        otherBallLabel.layer.cornerRadius = otherBallLabel.size.width/2;
        otherBallLabel.layer.masksToBounds = YES;
        otherBallLabel.text = textArray[i];
        otherBallLabel.font = BallFont;
        otherBallLabel.textAlignment = NSTextAlignmentCenter;
        otherBallLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:otherBallLabel];
    }
}


//创建选7  本地彩
- (void)_createSBalls:(NSArray *)textArray {
    
    UILabel *titlLabel = (UILabel *)[self.contentView viewWithTag:100];
    
    for (int i = 0; i < textArray.count; i++) {
        NSString *text = [NSString stringWithFormat:@"%@%@",textArray[i],textArray[i+1]];
        [self.data addObject:text];
        i++;
    }
    
    for (int i = 0; i < textArray.count/2; i++) {
        
        LBallLabel = [[UILabel alloc] initWithFrame:CGRectMake(9+(25+1)*i, titlLabel.bottom, 25, 25)];
        LBallLabel.layer.cornerRadius = LBallLabel.size.width/2;
        LBallLabel.layer.masksToBounds = YES;
        LBallLabel.text = [NSString stringWithFormat:@"%@",self.data[i]];
        LBallLabel.font = BallFont;
        LBallLabel.textAlignment = NSTextAlignmentCenter;
        LBallLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:LBallLabel];
        
        if (i >= 7) {
            LBallLabel.backgroundColor = RGBA(66, 115, 249, 1);
        }else {
            LBallLabel.backgroundColor = [UIColor colorWithHexString:@"c12b1c"];
            
        }
    }
}

@end
