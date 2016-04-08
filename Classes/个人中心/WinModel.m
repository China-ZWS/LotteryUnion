//
//  WinModel.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "WinModel.h"
#import "NSString+NumberSplit.h"
#import "UIColor+Hex.h"


   /*注:不见了的方法都移到UtilMethod里面去了*/

@implementation WinModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.spfArray = [NSMutableArray new];
        self.bfArray = [NSMutableArray new];
        self.bqcArray = [NSMutableArray new];
        self.jqsArray = [NSMutableArray new];
    }
    return self;
}

// 获取开奖号码
- (NSString *)getBonusNumber {
    if(!isValidateStr(self.bonus_number)){
        return @"未开奖";
    }
    
    NSString *bn = [self.bonus_number replaceAll:@"[^0-9]" withString:@""];
    int lottery_pk = [self.lottery_pk intValue];
    
    if(isFootBallLottery(lottery_pk)){
        return bn;
    }else if(isSingleBall(lottery_pk)){
        return [bn commonString:@" " length:1];
    } else {
        

            bn = [bn commonString:@" " length:2];

        return bn;
    }
}


// 获取开奖视图
- (void)makeBonusViewWithSuperView:(UIView *)superview bounsNumber:(NSString *)bounsNumber lot_pk:(NSString *)lot_pk {
     NSLog(@"bounsNumber =%@",bounsNumber);
    if(!isValidateStr(bounsNumber)){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 100, 40)];
        label.text = @"未开奖";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        [superview addSubview:label];
        return;
    }
    
    NSLog(@"bounsNumber =%@",bounsNumber);
    NSLog(@"lot_pk = %@",lot_pk);
    NSString *bn  = [bounsNumber replaceAll:@"[^0-9]" withString:@""];
    NSLog(@"%@",bn);
    NSRange range;
    if(isFootBallLottery([lot_pk intValue])){ // 足彩
        
        UIView *view = [[UIView alloc] initWithFrame:superview.frame];
        NSString *textStr = [bn commonString:@" " length:1];
        NSArray *textArray = [textStr componentsSeparatedByString:@" "];
        for (int i = 0; i<textArray.count; i++) {
            
            UILabel *ballLabel = [[UILabel alloc] initWithFrame:CGRectMake((10+2)*i-60, -2, 10, 25)];
            [ballLabel setBackgroundColor:[UIColor colorWithHexString:@"#00b2c0"]];
            [ballLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [ballLabel setText:[NSString stringWithFormat:@"%@",textArray[i]]];
            [ballLabel setTextColor:[UIColor whiteColor]];
            ballLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:ballLabel];
        }
        [superview addSubview:view];
    }else {
        
        // 彩种是否为单号(单号为1双号为2)
        int ballLen = isSingleBall([lot_pk intValue])?1:2;
        range.length = ballLen;
        for (int index=0,count=(int)bn.length/ballLen;index<count;index++) {
            range.location = index * ballLen;
            UIButton *ballView;
            
            if(index>4 && [lot_pk intValue]==lDLT_lottery){// 大乐透
                
                ballView = makeBlueBallLabel([bn substringWithRange:range],YES);
            }else if (index > 6&&([lot_pk intValue]==lT367_lottery||[lot_pk intValue]==lT317_lottery)){
                ballView = makeBlueBallLabel([bn substringWithRange:range],YES);
            }else if (index > 5&&[lot_pk intValue]==lSSQ_lottery){
                ballView = makeBlueBallLabel([bn substringWithRange:range],YES);
            }
            else{
                ballView = makeRedBallLabel([bn substringWithRange:range],YES);
            }
            [ballView setLeft:index*(ballView.width)+6];
            [superview addSubview:ballView];
        }
    }
}

// 格式化后的号码
-(NSString *)formatedNumber
{
    if(!isValidateStr(_formatedNumber)){
        NSString *number = self.number;
        int lottery_code = [self.lottery_code intValue];
        int lottery_pk = [self.lottery_pk intValue];
        _formatedNumber=showNumberInCell(number,lottery_pk,lottery_code);
    }
    
    return _formatedNumber;
}


//双色球
- (NSString *)SSNumber:(NSString *)num lottery_code:(NSString *)lottery_code{
    NSArray *dAry = [num componentsSeparatedByString:@"#"];
    NSMutableString *mStr2 = [NSMutableString string];
    if ([lottery_code intValue] == pSSQ_Dantuo) {
        NSDictionary *aDict = [num splitDantuoS];   //拆分胆拖
        [mStr2 appendFormat:@"前区胆 %@\n",[aDict objectForKey:@"qianqu_dan"]];
        [mStr2 appendFormat:@"前区拖 %@\n",[aDict objectForKey:@"qianqu_tuo"]];
        [mStr2 appendFormat:@"后区  %@\n",[aDict objectForKey:@"houqu_dan"]];
        NSLog(@"1 %@",mStr2);
        return mStr2;
    }else if ([lottery_code intValue] == pSSQ_Danshi) {
        for (int i = 0; i < [dAry count]; i++) {
            NSString *subNumber = [dAry objectAtIndex:i];
            subNumber = [subNumber componentsSepartedByString:@" " length:2];
            NSLog(@"%@",subNumber);
            
            subNumber = [NSString stringWithFormat:@"%@+%@",[subNumber substringToIndex:17],[subNumber substringFromIndex:18]];
            [mStr2 appendFormat:@"%@\n", subNumber];
            NSLog(@"3 %@",mStr2);
        }
        return mStr2;
    }else if ([lottery_code intValue] == pSSQ_Fushi) {
        [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:0] componentsSepartedByString:@" " length:2]];
        [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:1] componentsSepartedByString:@" " length:2]];
        return mStr2;
        NSLog(@"2 %@",mStr2);
        return mStr2;
    }
    return nil;
}

/**
 * 获取显示给用户的格式化后的号码
 */
NSString *showNumberInCell(NSString *numbers,int lottery_pk,int lottery_code) {
    NSString *mStr = @"";
    if (!isValidateStr(numbers))
        return mStr;
    
    if (isFootBallLottery(lottery_pk)) { // 足彩
        if (lottery_code==pHalfWin_Fushi
            || lottery_code==pWinLost14_Fushi
            || lottery_code==pAny9_Fushi
            || lottery_code==pEnter4_Fushi) {
            //当单选多注的情况
            mStr=[numbers stringByReplacingOccurrencesOfString:@"#" withString:@" "];
            mStr=[mStr stringByReplacingOccurrencesOfString:@"A" withString:@"-"];
            return mStr;
        } else {
            //当单选多注的情况
            mStr=[numbers stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
            mStr=[mStr stringByReplacingOccurrencesOfString:@"A" withString:@"-"];
            return mStr;
        }
    } else if (lottery_pk==lSenvenStar_lottery
               || lottery_pk==lPL3_lottery
               || lottery_pk==lPL5_lottery) {
        NSMutableString *mStr2 = [NSMutableString string];
        NSArray *pArray = [numbers componentsSeparatedByString:@"#"];
        
        // 个位数
        if (lottery_code==pSenvenStarLottery_Fushi) {
            for (int i = 0; i < 7; i++) {
                NSString *balls=[pArray[i] componentsSepartedByString:@" " length:1];
                [mStr2 appendFormat:@"第%@位 %@\n",getChineseNumber(i+1),balls];
            }
            return mStr2;
        } else if (lottery_code==pPL3_DirectChoice_Fushi) {
            for (int i = 0; i < 3; i++) {
                NSString *balls=[pArray[i] componentsSepartedByString:@" " length:1];
                [mStr2 appendFormat:@"%@位 %@\n",getChinseHundredFrom3(i + 1),balls];
            }
            return mStr2;
        } else if (lottery_code==pPL5_Fushi) {
            for (int i = 0; i < 5; i++) {
                NSString *balls=[pArray[i] componentsSepartedByString:@" " length:1];
                [mStr2 appendFormat:@"%@位 %@\n",getChinseHundred(i+1),balls];
            }
            return mStr2;
        } else {
            //当单选多注的情况
            for (int i = 0; i < [pArray count]; i++) {
                NSString *balls=[pArray[i] componentsSepartedByString:@" " length:1];
                [mStr2 appendFormat:@"%@\n", balls];
            }
            
            return mStr2;
        }
    } else {
        NSArray *dAry = [numbers componentsSeparatedByString:@"#"];
        NSMutableString *mStr2 = [NSMutableString string];
        if (lottery_code==pDLT_Dantuo) {
            NSDictionary *aDict = [numbers splitDantuo];
            [mStr2 appendFormat:@"前区胆 %@\n",[aDict objectForKey:@"qianqu_dan"]];
            [mStr2 appendFormat:@"前区拖 %@\n",[aDict objectForKey:@"qianqu_tuo"]];
            [mStr2 appendFormat:@"后区胆 %@\n",[aDict objectForKey:@"houqu_dan"]];
            [mStr2 appendFormat:@"后区拖 %@\n",[aDict objectForKey:@"houqu_tuo"]];
            return mStr2;
        } else if (lottery_code==pDLT_Fushi) {
            [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:0] componentsSepartedByString:@" " length:2]];
            [mStr2 appendFormat:@"后区 %@\n",[[dAry objectAtIndex:1] componentsSepartedByString:@" " length:2]];
            return mStr2;
        }else if (lottery_code==pDLT_Danshi) {
            for (int i = 0; i < [dAry count]; i++) {
                NSString *subNumber = [dAry objectAtIndex:i];
                subNumber = [subNumber componentsSepartedByString:@" " length:2];
                subNumber = [NSString stringWithFormat:@"%@+%@",[subNumber substringToIndex:14],[subNumber substringFromIndex:15]];
                [mStr2 appendFormat:@"%@\n", subNumber];
            }
            return mStr2;
        } else if(isXyscDanTuo(lottery_code)){
            if(dAry.count == 2){
                NSString *dan=[dAry[0] componentsSepartedByString:@" " length:2];
                NSString *tuo=[dAry[1] componentsSepartedByString:@" " length:2];
                [mStr2 appendFormat:@"胆码 %@\n拖码 %@",dan,tuo];
            }
            return mStr2;
        }else if(lottery_code==pXysc_Second_Duiwei
                 ||lottery_code==pXysc_Second_Danshi
                 ||lottery_code==pXysc_Third_Duiwei
                 ||lottery_code==pXysc_Third_Danshi){
            NSArray *tits = @[@"冠军",@"亚军",@"季军"];
            for (int i=0,c=(int)dAry.count; i<c;i++) {
                if(i>=3) break;
                NSString *balls=[dAry[i] componentsSepartedByString:@" " length:2];
                [mStr2 appendFormat:@"%@%@\n",tits[i],balls];
            }
            return mStr2;
        } else {
            //当单选多注的情况
            if(lottery_code==pXysc_Pos_Danshi
               ||lottery_code==pXysc_Third_Fushi
               ||lottery_code==pXysc_Zu3_Danshi
               ||lottery_code==pXysc_Zu3_Fushi){
                [mStr2 appendFormat:@"冠亚季军"];
            } else if(lottery_code==pXysc_Second_Fushi
                      ||lottery_code==pXysc_Zu2_Danshi
                      ||lottery_code==pXysc_Zu2_Fushi){
                [mStr2 appendFormat:@"冠亚军"];
            }
            
            NSString *formatStr=(lottery_code==pXysc_Pos_Danshi)?@"%@":@"%@\n";
            for (int i = 0; i < [dAry count]; i++) {
                NSString *balls=[dAry[i] componentsSepartedByString:@" " length:2];
                [mStr2 appendFormat:formatStr, balls];
            }
            
            return mStr2;
        }
    }
}


/* 彩种是否为幸运赛车胆拖 */
BOOL isXyscDanTuo(API_play code){
    if(code==pXysc_Second_Dantuo
       ||code==pXysc_Third_Dantuo
       ||code==pXysc_Zu2_Dantuo
       ||code==pXysc_Zu3_Dantuo)
        return YES;
    return NO;
}


//高亮中奖号码  高亮我的选号中得中奖号码
-(NSString *)getWin:(NSString*)number isBet:(BOOL)isBet{
    NSString *bn;
    if (isBet == YES) {
        bn = [self.prize_number replaceAll:@"[^0-9]" withString:@""];
    }else {
        bn = [self.bonus_number replaceAll:@"[^0-9]" withString:@""];
    }
    number = [number removeLastString:@"\n"];
    //判断字符串是否为空
    if(!isValidateStr(bn)) return number;

    int lottery_pk = [self.lottery_pk intValue];
    int lottery_code = [self.lottery_code intValue];
    NSLog(@"bn:%@  number:%@", bn, number);
    NSLog(@"开奖号码：self.bonus_number = %@",self.bonus_number);
    
    @try{
        if (lottery_pk==lSenvenStar_lottery) {
            // 七星彩
            NSArray *balls = [bn splitToStringArrayByLength:1];// 顺序
            if (lottery_code == pSenvenStarLottery_Danshi) {
                // 单式
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 多注
                NSMutableString *sb = [NSMutableString string];
                NSArray *hao;
                NSLog(@"count:%d",(int)ns.count);
                for (int i = 0; i < ns.count; i++) {
                    NSLog(@"hao:%@",ns[i]);
                    hao = [ns[i] componentsSeparatedByString: @" "];
                    for (int j = 0; j < 7; j++) {
                        
                        [sb appendString:[[hao[j] replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]]];
                        
                        if (j != 6) {
                            [sb appendString:@" "];
                        }
                    }
                    
                    if (i != ns.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
                
            } else if (lottery_code==pSenvenStarLottery_Fushi) {
                // 复式
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 各个位置
                NSMutableString *sb = [NSMutableString string];
                
                for (int j = 0; j < 7; j++) {
                    [sb appendString:[[ns[j] replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]]];
                    if (j != 6) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
            }
            
        } else if (lottery_pk==lPL3_lottery) {
            NSLog(@"排列三");
            NSArray *balls = [bn splitToStringArrayByLength:1];// 顺序
            if (lottery_code==pPL3_DirectChoice_Danshi) {
                NSLog(@" 单式");
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 多注
                NSMutableString *sb = [NSMutableString string];
                NSArray *hao;
                for (int i = 0; i < ns.count; i++) {
                    hao = [ns[i] componentsSeparatedByString: @" "];
                    for (int j = 0; j < 3; j++) {
                        
                        [sb appendString:[[hao[j] replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]]];
                        if(j!=2){
                            [sb appendString:@" "];
                        }
                    }
                    
                    if (i != ns.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
                
            } else if (lottery_code==pPL3_DirectChoice_Fushi) {
                NSLog(@"// 复式");
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 各个位置
                NSMutableString *sb = [NSMutableString string];
                
                for (int j = 0; j < 3; j++) {
                    
                    [sb appendString:[[ns[j] replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]]];
                    if (j != ns.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
            } else if (lottery_code==pPL3_DirectChoice_Group3_Danshi) {
                NSLog(@"// 组三单式");
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 多注
                NSMutableString *sb = [NSMutableString string];
                NSArray *hao;
                NSString *dn;// 双数
                NSString *sn;// 单数
                if ([balls[0] isEqualToString:balls[1]]) {
                    dn = balls[0];
                    sn = balls[2];
                } else if ([balls[0] isEqualToString:balls[2]]) {
                    dn = balls[0];
                    sn = balls[1];
                } else {
                    dn = balls[1];
                    sn = balls[0];
                }
                for (int i = 0; i < ns.count; i++) {
                    hao = [ns[i] componentsSeparatedByString: @" "];
                    int dc = 0, sc = 0;
                    for (int j = 0; j < 3; j++) {
                        if ([hao[j] isEqualToString:dn]) {
                            dc++;
                        } else if ([hao[j] isEqualToString:sn]) {
                            sc++;
                        }
                    }
                    if (dc == 2 && sc == 1) {
                        // 中奖 全部变红
                        [sb appendFormat:@"<font color=\"red\">%@</font>",ns[i]];
                    } else {
                        [sb appendString:ns[i]];
                    }
                    
                    if (i != ns.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
            } else if (lottery_code==pPL3_DirectChoice_Group3_Fushi) {
                NSLog(@"// 组三复式");
                NSMutableString *sb = [NSMutableString string];
                NSArray *hao;
                NSString *dn;
                NSString *sn;// 双数 单数
                if ([balls[0] isEqualToString:balls[1]]) {
                    dn = balls[0];
                    sn = balls[2];
                } else if ([balls[0] isEqualToString:balls[2]]) {
                    dn = balls[0];
                    sn = balls[1];
                } else {
                    dn = balls[1];
                    sn = balls[0];
                }
                
                hao = [number componentsSeparatedByString: @" "];
                // 复式只有一注，能进来肯定是中奖的，所以不用判断是否中奖，直接替换即可
                for (int j = 0; j < hao.count; j++) {
                    if ([hao[j] isEqualToString:dn] || [hao[j] isEqualToString:sn]) {
                        
                        [sb appendFormat:@"<font color=\"red\">%@</font>",hao[j]];
                        
                    } else {
                        [sb appendString:hao[j]];
                    }
                    if (j != hao.count - 1) {
                        [sb appendString:@" "];
                    }
                }
                
                number = sb;
                
            } else if (lottery_code==pPL3_DirectChoice_Group6_Danshi) {
                NSLog(@"// 组六单式");
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 多注
                NSMutableString *sb = [NSMutableString string];
                NSArray *hao;
                
                for (int i = 0; i < ns.count; i++) {
                    hao = [ns[i] componentsSeparatedByString: @" "];
                    int dc = 0;
                    for (int j = 0; j < 3; j++) {
                        if ([hao[j] isEqualToString:balls[0]]
                            || [hao[j] isEqualToString:balls[1]]
                            || [hao[j] isEqualToString:balls[2]]) {
                            dc++;
                        }
                    }
                    if (dc == 3) {
                        // 中奖 全部变红
                        [sb appendFormat:@"<font color=\"red\">%@</font>",ns[i]];
                    } else {
                        [sb appendString:ns[i]];
                    }
                    
                    if (i != ns.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
            } else if (lottery_code==pPL3_DirectChoice_Group6_Fushi) {
                NSLog(@"// 组六复式");
                NSMutableString *sb = [NSMutableString string];
                NSArray *hao;
                
                hao = [number componentsSeparatedByString: @" "];
                // 复式只有一注，能进来肯定是中奖的，所以不用判断是否中奖，直接替换即可
                for (int j = 0; j < hao.count; j++) {
                    if ([hao[j] isEqualToString:balls[0]] || [hao[j] isEqualToString:balls[1]]
                        || [hao[j] isEqualToString:balls[2]]) {
                        
                        [sb appendFormat:@"<font color=\"red\">%@</font>",hao[j]];
                    } else {
                        [sb appendString:hao[j]];
                    }
                    if (j != hao.count - 1) {
                        [sb appendString:@" "];
                    }
                }
                
                number = sb;
            }
            
        } else if (lottery_pk==kType_CTZQ_SF14) {
            // 胜负14 足彩
            if (lottery_code==pWinLost14_Danshi) {
                NSArray *balls = [bn splitToStringArrayByLength:1];
                NSArray *hao = [number componentsSeparatedByString: @"\n"];// 多注
                
                NSMutableString *sb = [NSMutableString string];
                for (int j = 0; j < hao.count; j++) {
                    NSArray *ns=[hao[j] splitToStringArrayByLength:1];
                    for (int i = 0; i < balls.count; i++) {
                        if ([balls[i] isEqualToString:ns[i]]) {
                            [sb appendFormat:@"<font color=\"red\">%@</font>",balls[i]];
                        } else {
                            [sb appendString:ns[i]];
                        }
                    }
                    if (j != hao.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = (sb.length==0)?number:sb;
            } else if (lottery_code==pWinLost14_Fushi) {
                // 每个位置以空格区分
                NSArray *ns = [number componentsSeparatedByString: @" "];
                
                NSArray *balls = [bn splitToStringArrayByLength:1];
                NSMutableString *sb = [NSMutableString string];
                for (int i = 0; i < balls.count; i++) {
                    [sb appendString:[[ns[i] replaceStringBy:balls[i] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[i]]]];
                    if (i != balls.count - 1) {
                        [sb appendString:@" "];
                    }
                }
                number = (sb.length==0)?number:sb;
            }
        } else if (lottery_pk==kType_CTZQ_SF9) {
            // 任选9场 足彩
            if (lottery_code==pAny9_Danshi) {
                NSArray *balls = [bn splitToStringArrayByLength:1];
                NSArray *hao = [number componentsSeparatedByString: @"\n"];// 多注
                
                NSMutableString *sb = [NSMutableString string];
                for (int j = 0; j < hao.count; j++) {
                    NSArray *ns = [hao[j] splitToStringArrayByLength:1];
                    for (int i = 0; i < balls.count; i++) {
                        if ([balls[i] isEqualToString:ns[i]]) {
                            
                            [sb appendFormat:@"<font color=\"red\">%@</font>",balls[i]];
                        } else {
                            [sb appendString:ns[i]];
                        }
                    }
                    if (j != hao.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = (sb.length==0)?number:sb;
            } else if (lottery_code==pAny9_Fushi) {
                NSArray *balls = [bn splitToStringArrayByLength:1];
                NSArray *ns = [number componentsSeparatedByString: @" "];// 每个位置以空格区分
                NSMutableString *sb = [NSMutableString string];
                
                for (int i = 0; i < balls.count; i++) {
                    [sb appendString:[[ns[i] replaceStringBy:balls[i] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[i]]]];
                    
                    if (i != balls.count - 1) {
                        [sb appendString:@" "];
                    }
                }
                number = (sb.length==0)?number:sb;
            }
        } else if (lottery_pk==lPL5_lottery) {
            // 排列五
            NSArray *balls = [bn splitToStringArrayByLength:1];// 顺序
            if (lottery_code==pPL5_Danshi) {
                // 单式
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 多注
                NSMutableString *sb = [NSMutableString string];
                NSArray *hao;
                for (int i = 0; i < ns.count; i++) {
                    hao = [ns[i] componentsSeparatedByString: @" "];
                    for (int j = 0; j < 5; j++) {
                        [sb appendString:[[hao[j] replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]]];
                        
                        if(j!=4){
                            [sb appendString:@" "];
                        }
                    }
                    
                    if (i != ns.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
                
            } else if (lottery_code==pPL5_Fushi) {
                // 复式
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 各个位置
                NSMutableString *sb = [NSMutableString string];
                
                for (int j = 0; j < 5; j++) {
                    [sb appendString:[[ns[j] replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]]];
                    if (j != 4) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
            }
            
        } else if (lottery_pk==lDLT_lottery) {
            // 大乐透
            NSArray *balls = [bn splitToStringArrayByLength:2];// 前0-4 后5-6
            NSLog(@"%@",balls);
            if (lottery_code==pDLT_Danshi) {
                // 单式
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 多注
                NSMutableString *sb = [NSMutableString string];
                NSString *qian;
                NSString *hou;// 前后区 分开比对
                for (int i = 0; i < ns.count; i++) {
                    qian = [ns[i] substringToIndex:14];
                    hou = [ns[i] substringFromIndex:15];
                    for (int j = 0; j < 5; j++) {
                        
                        qian = [[qian replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    
                    for (int j = 5; j < 7; j++) {
                        hou = [[hou replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    [sb appendFormat:@"%@+%@",qian,hou];
                    if (i != ns.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
                
            } else if (lottery_code==pDLT_Fushi) {
                NSLog(@"number%@",number);
                // 复式
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 产分前后区 分开比对
                if (ns.count < 2) {// 错误格式无法处理
                    number = @"";
                } else {
                    NSMutableString *sb = [NSMutableString string];
                    NSString *qian = ns[0];
                    NSString *hou = ns[1];
                    
                    for (int j = 0; j < 5; j++) {//前区
                        qian = [[qian replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    
                    for (int j = 5; j < 7; j++) {//后区
                        //                        NSLog(@"%@===%d",ns[1],(int)[ns[1] length]/2);
                        hou = [[hou replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    [sb appendFormat:@"%@\n%@",qian,hou];
                    
                    number = sb;
                }
            } else if (lottery_code==pDLT_Dantuo) {
                // 胆拖，前后区分开比对
                NSArray *ns = [number componentsSeparatedByString: @"\n"];
                NSLog(@"----------%@----------",ns);
                if (ns.count < 4) {// 错误格式无法处理
                    number = @"";
                } else {
                    NSMutableString *sb = [NSMutableString string];
                    NSString *qian = [NSString stringWithFormat:@"%@\n%@",ns[0],ns[1]];
                    NSString *hou = [NSString stringWithFormat:@"%@\n%@",ns[2],ns[3]];
                    
                    for (int j = 0; j < 5; j++) {
                        qian = [[qian replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    
                    for (int j = 5; j < 7; j++) {
                        hou = [[hou replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    [sb appendFormat:@"%@\n%@",qian,hou];
                    
                    number = sb;
                }
            }
            
        } else if (lottery_pk==lSSQ_lottery) {
            // 双色球
            NSArray *balls = [bn splitToStringArrayByLength:2];// 前0-4 后5-6
            if (lottery_code==pSSQ_Danshi) {
                // 单式
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 多注 01 02 03 04 05 06+07
                NSMutableString *sb = [NSMutableString string];
                NSString *qian;
                NSString *hou;// 前后区 分开比对
                for (int i = 0; i < ns.count; i++) {
                    qian = [ns[i] substringToIndex:17];
                    hou = [ns[i] substringFromIndex:18];
                    for (int j = 0; j < 5; j++) {
                        
                        qian = [[qian replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    
                    for (int j = 5; j < 7; j++) {
                        hou = [[hou replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    [sb appendFormat:@"%@+%@",qian,hou];
                    if (i != ns.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = sb;
                
            } else if (lottery_code==pSSQ_Fushi) {
                NSLog(@"number%@",number);
                // 复式
                NSArray *ns = [number componentsSeparatedByString: @"\n"];// 产分前后区 分开比对
                if (ns.count < 2) {// 错误格式无法处理
                    number = @"";
                } else {
                    NSMutableString *sb = [NSMutableString string];
                    NSString *qian = ns[0];
                    NSString *hou = ns[1];
                    
                    for (int j = 0; j < 5; j++) {//前区
                        qian = [[qian replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    
                    for (int j = 5; j < 7; j++) {//后区
                        //                        NSLog(@"%@===%d",ns[1],(int)[ns[1] length]/2);
                        hou = [[hou replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    [sb appendFormat:@"%@\n%@",qian,hou];
                    
                    number = sb;
                }
            } else if (lottery_code==pSSQ_Dantuo) {
                // 胆拖，前后区分开比对
                NSArray *ns = [number componentsSeparatedByString: @"\n"];
                NSLog(@"----------%@----------",ns);
                if (ns.count < 3) {// 错误格式无法处理
                    number = @"";
                } else {
                    NSMutableString *sb = [NSMutableString string];
                    NSString *qian = [NSString stringWithFormat:@"%@\n%@",ns[0],ns[1]];
                    NSString *hou = [NSString stringWithFormat:@"%@\n",ns[2]];
                    
                    for (int j = 0; j < 5; j++) {
                        qian = [[qian replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    
                    for (int j = 5; j < 7; j++) {
                        hou = [[hou replaceStringBy:balls[j] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[j]]];
                    }
                    [sb appendFormat:@"%@\n%@",qian,hou];
                    
                    number = sb;
                }
            }
            
        }else if (lottery_pk==kType_CTZQ_JQ4) {
            // 进球4 足彩
            if (lottery_code==pEnter4_Danshi) {
                NSArray *balls = [bn splitToStringArrayByLength:1];
                NSArray *hao = [number componentsSeparatedByString: @"\n"];// 多注
                NSArray *ns;
                NSMutableString *sb = [NSMutableString string];
                for (int j = 0; j < hao.count; j++) {
                    ns = [hao[j] splitToStringArrayByLength:1];
                    for (int i = 0; i < balls.count; i++) {
                        if ([balls[i] isEqualToString:ns[i]]) {
                            [sb appendFormat:@"<font color=\"red\">%@</font>",balls[i]];
                        } else {
                            [sb appendString:ns[i]];
                        }
                    }
                    if (j != hao.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = (sb.length==0)?number:sb;
            } else if (lottery_code==pEnter4_Fushi) {
                NSArray *balls = [bn splitToStringArrayByLength:1];
                // 每个位置以空格区分
                NSArray *ns = [number componentsSeparatedByString: @" "];
                NSMutableString *sb = [NSMutableString string];
                
                for (int i = 0; i < balls.count; i++) {
                    [sb appendString:[[ns[i] replaceStringBy:balls[i] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[i]]]];
                    if (i != balls.count - 1) {
                        [sb appendString:@" "];
                    }
                }
                number = (sb.length==0)?number:sb;
            }
            
        } else if (lottery_pk==kType_CTZQ_BQC6) {
            // 半全场 足彩
            if (lottery_code==pHalfWin_Danshi) {
                NSArray *balls = [bn splitToStringArrayByLength:1];
                NSArray *hao = [number componentsSeparatedByString: @"\n"];// 多注
                NSArray *ns;
                NSMutableString *sb = [NSMutableString string];
                for (int j = 0; j < hao.count; j++) {
                    ns = [hao[j] splitToStringArrayByLength:1];
                    for (int i = 0; i < balls.count; i++) {
                        if ([balls[i] isEqualToString:ns[i]]) {
                            
                            [sb appendFormat:@"<font color=\"red\">%@</font>",balls[i]];
                        } else {
                            [sb appendString:ns[i]];
                        }
                    }
                    if (j != hao.count - 1) {
                        [sb appendString:@"\n"];
                    }
                }
                number = (sb.length==0)?number:sb;
            } else if (lottery_code==pHalfWin_Fushi) {
                NSArray *balls = [bn splitToStringArrayByLength:1];
                NSArray *ns = [number componentsSeparatedByString: @" "];// 每个位置以空格区分
                NSMutableString *sb = [NSMutableString string];
                
                for (int i = 0; i < balls.count; i++) {
                    [sb appendString:[[ns[i] replaceStringBy:balls[i] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[i]]]];
                    
                    if (i != balls.count - 1) {
                        [sb appendString:@" "];
                    }
                }
                number = sb;
            }
        } else if (lottery_pk==lT225_lottery) {
            // 全国22
            NSArray *balls = [bn splitToStringArrayByLength:2];
            
            for (int i = 0; i < balls.count; i++) {
                
                number = [[number replaceStringBy:balls[i] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[i]]];
            }
        }else if (lottery_pk==lT317_lottery){
            // 全国22
            NSArray *balls = [bn splitToStringArrayByLength:2];
            
            for (int i = 0; i < balls.count; i++) {
                
                number = [[number replaceStringBy:balls[i] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[i]]];
            }
            
        }else if (lottery_pk==lT367_lottery)
        {
            // 全国22
            NSArray *balls = [bn splitToStringArrayByLength:2];
            
            for (int i = 0; i < balls.count; i++)
            {
                
                number = [[number replaceStringBy:balls[i] withString:@"CHT"] replaceStringBy:@"CHT" withString:[NSString stringWithFormat:@"<font color=\"red\">%@</font>",balls[i]]];
            }
            
        }
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
    }
    
    return number;
}



- (NSString *)chuangGuan:(NSString *)number {
    
    NSArray *array = [number componentsSeparatedByString:@"#"];
    NSLog(@"串关 = %d",[array[0] intValue]);
    switch ([array[0] intValue]) {
        case 101:
            return @"单关";
            break;
        case 201:
            return @"2串1";
            break;
        case 301:
            return @"3串1";
            break;
        case 303:
            return @"3串3";
            break;
        case 304:
            return @"3串4";
            break;
        case 401:
            return @"4串1";
            break;
        case 404:
            return @"4串4";
            break;
        case 405:
            return @"4串5";
            break;
        case 406:
            return @"4串6";
            break;
        case 4011:
            return @"4串11";
            break;
        case 501:
            return @"5串1";
            break;
        case 505:
            return @"5串5";
            break;
        case 506:
            return @"5串6";
            break;
        case 5010:
            return @"5串10";
            break;
        case 5016:
            return @"5串16";
            break;
        case 5020:
            return @"5串20";
            break;
        case 5026:
            return @"5串26";
            break;
        case 601:
            return @"6串1";
            break;
        case 606:
            return @"6串6";
            break;
        case 607:
            return @"6串7";
            break;
        case 6015:
            return @"6串15";
            break;
        case 6020:
            return @"6串20";
            break;
        case 6022:
            return @"6串22";
            break;
        case 6035:
            return @"6串35";
            break;
        case 6042:
            return @"6串42";
            break;
        case 6050:
            return @"6串50";
            break;
        case 6057:
            return @"6串57";
            break;
        case 701:
            return @"7串1";
            break;
        case 707:
            return @"7串7";
            break;
        case 708:
            return @"7串8";
            break;
        case 7021:
            return @"7串21";
            break;
        case 7035:
            return @"7串35";
            break;
        case 7120:
            return @"7串120";
            break;
        case 801:
            return @"8串1";
            break;
        case 808:
            return @"8串8";
            break;
        case 809:
            return @"8串9";
            break;
        case 8028:
            return @"8串28";
            break;
        case 8056:
            return @"8串56";
            break;
        case 8070:
            return @"8串70";
            break;
        case 8247:
            return @"8串247";
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - 竞彩足球选号显示
//竞彩足球选号显示
- (NSArray *)transNumber:(NSString *)numbers lottery_code:(NSString *)lot_code{
    NSMutableArray *resultArray = [NSMutableArray new];
    int lottery_code = [lot_code intValue];
    if (lottery_code == kSFP_single     //胜平负
        || lottery_code == kRQ_SFP_single) {  //让球胜平负单式

        //单式
        NSArray *array = [numbers componentsSeparatedByString:@"#"];
        NSString *btstring = array[1];
        array = [btstring componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array)
        {
            array = [ctstring componentsSeparatedByString:@"$"]; //从字符A中分隔成2个元素的数组
            self.spfString = array[1];
            [resultArray addObject:[self result:array[1]]];
        }
        return resultArray;
    }else if (lottery_code == KHHGG_single){  //混合过关单式
        
        NSLog(@"numbers = %@",numbers);
        NSArray *array = [numbers componentsSeparatedByString:@"#"];
        NSString *btstring = array[1];
        NSLog(@"btstring = %@",btstring);
        array = [btstring componentsSeparatedByString:@"^"];
         NSLog(@"array = %@",array);
        for (NSString *ctstring in array)
        {
            array = [ctstring componentsSeparatedByString:@"$"]; //从字符A中分隔成2个元素的数组
            [resultArray addObject:[self HHGGResult:array[1] playName:array[0] lot_code:lottery_code]];
        }
        return resultArray;
        
    }else if (lottery_code == kJQS_single) {  //进球数单式
        
        NSArray *array = [numbers componentsSeparatedByString:@"#"];
        NSString *btstring = array[1];
        array = [btstring componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array)
        {
            array = [ctstring componentsSeparatedByString:@"$"]; //从字符A中分隔成2个元素的数组
            [resultArray addObject:[self JQSDResult:array[1]]];
        }
        return resultArray;
        
    }else if (lottery_code == kScore_single) {  //比分单式
        //单式
        NSArray *array = [numbers componentsSeparatedByString:@"#"];
        NSString *btstring = array[1];
        array = [btstring componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array)
        {
            array = [ctstring componentsSeparatedByString:@"$"]; //从字符A中分隔成2个元素的数组
            [resultArray addObject:[self BFResult:array[1]]];
        }
        return resultArray;
    }else if (lottery_code == kBQC_single) {    //半全场单式
        
        NSLog(@"%@",numbers);
        //单式
        NSArray *array = [numbers componentsSeparatedByString:@"#"];
        NSString *btstring = array[1];
        array = [btstring componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array)
        {
            array = [ctstring componentsSeparatedByString:@"$"]; //从字符A中分隔成2个元素的数组
            [resultArray addObject:[self BQCDResult:array[1]]];
        }
        return resultArray;
        
    }else if ( lottery_code == kBQC_compound) {  // 半全场复式--->结果多得叫复式
        NSLog(@"numbers = %@",numbers);
        NSRange range = [numbers rangeOfString:@"#"];
        NSString *string = [numbers substringFromIndex:range.location+1];
        NSArray *array = [string componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array) {
            array = [ctstring componentsSeparatedByString:@"$"];
            NSLog(@"array = %@",array[1]);
            [resultArray addObject:[self BQCFResult:array[1]]];    //0-->放的是号码  1--》放的后面结果
        }
        return resultArray;
    }else if (lottery_code == kSFP_compound
              || lottery_code == kRQ_SFP_compound) {   //胜平负复式  让球胜平负复式
        NSLog(@"numbers = %@",numbers);
        NSRange range = [numbers rangeOfString:@"#"];
        NSString *string = [numbers substringFromIndex:range.location+1];
        NSArray *array = [string componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array) {
            array = [ctstring componentsSeparatedByString:@"$"];
            NSLog(@"array = %@",array[1]);
            [resultArray addObject:[self resultSPF:array[1]]];    //0-->放的是号码  1--》放的后面结果
        }
        return resultArray;
    }else if (lottery_code == kScore_compound) {   // 比分复式
        NSLog(@"%@",numbers);
        NSRange range = [numbers rangeOfString:@"#"];
        NSString *string = [numbers substringFromIndex:range.location+1];
        NSArray *array = [string componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array) {
            array = [ctstring componentsSeparatedByString:@"$"];
            NSLog(@"array = %@",array[1]);
            [resultArray addObject:[self BFFResult:array[1]]];    //0-->放的是号码  1--》放的后面结果
        }
        return resultArray;
    }else if (lottery_code == kJQS_compound) {  //进球数复式
        NSLog(@"%@",numbers);
        NSRange range = [numbers rangeOfString:@"#"];
        NSString *string = [numbers substringFromIndex:range.location+1];
        NSArray *array = [string componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array) {
            array = [ctstring componentsSeparatedByString:@"$"];
            NSLog(@"array = %@",array[1]);
            [resultArray addObject:[self JQSFResult:array[1]]];    //0-->放的是号码  1--》放的后面结果
        }
        return resultArray;
    }else if (lottery_code == kHHGG_compound) {   //混合过关复式
         NSLog(@"%@",numbers);
        NSRange range = [numbers rangeOfString:@"#"];
        NSString *string = [numbers substringFromIndex:range.location+1];
        NSArray *array = [string componentsSeparatedByString:@"^"];
        for (NSString *ctstring in array) {
            array = [ctstring componentsSeparatedByString:@"$"];
            NSLog(@"array = %@",array[1]);
            [resultArray addObject:[self HHGGFResult:array[1] playName:array[0]]];    //0-->放的是号码  1--》放的后面结果
        }
        return resultArray;
    }
    return nil;
}

#pragma mark - 竞彩足球单式返回结果
//混合过关单式  里面全部为单式
- (NSString *)HHGGResult:(NSString *)result playName:(NSString *)playName lot_code:(int )lotteryC{
    
    NSArray *array = [playName componentsSeparatedByString:@"@"];
    NSLog(@"result = %@ %@",result,array[0]);
    int lottery_code = [array[0] intValue];
    if (lottery_code == kSFP_single            //胜平负 让球胜负平
        || lottery_code == kRQ_SFP_single) {
        return  [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self result:result]];
    }else if (lottery_code == kJQS_single) {   //进球数单式
        return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self JQSDResult:result]];
        
    }else if (lottery_code == kScore_single) {  //比分单式
        return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self BFResult:result]];
    }else if (lottery_code == kBQC_single) {   //半全场单式
        return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self BQCDResult:result]];
    }
    
    return nil;
}


//胜平负 让球胜平负单式
- (NSString *)result:(NSString *)result {
    
    if ([result isEqual:@"0"]) {
        return  @"负";
    }else if ([result isEqual:@"1"]) {
        return @"平";
    }else if ([result isEqual:@"3"]) {
        return @"胜";
    }
    return nil;
}

//半全场单式
- (NSString *)BQCDResult:(NSString *)result {
    
    NSLog(@"%@",result);
    NSString *str;
    NSString *str1 = [result substringToIndex:1];
    NSString *str2 = [result substringFromIndex:1];
    str = [NSString stringWithFormat:@"%@%@",[self bqfResult:str1],[self bqFResult:str2]];
    return str;
}


//比分单式
- (NSString *)BFResult:(NSString *)result {
    result  = [result replaceAll:@"[^0-9]" withString:@""];
    NSString *textStr = [result commonString:@" " length:1];
    NSLog(@"%@",textStr);
    NSArray  *textArray = [textStr componentsSeparatedByString:@" "];
    NSLog(@"%@",textArray);
    NSString *BF = [NSString stringWithFormat:@"%@:%@",textArray[0],textArray[1]];
    return BF;
}

//进球数单式
- (NSString *)JQSDResult:(NSString *)result {
    NSString *str;
    if ([result isEqual:@"7"]) {
        str = [NSString stringWithFormat:@"%@+",result];
    }else {
        str = [NSString stringWithFormat:@"%@球",result];
    }
    return str;
}



#pragma mark - 竞彩足球复式返回结果
//混合过关复式
- (NSString *)HHGGFResult:(NSString *)result playName:(NSString *)playName {
    //result-->结果   playName-->玩法
    NSArray *array = [playName componentsSeparatedByString:@"@"];
    NSLog(@"%@ %@",result,array[0]);
    int lottery_code = [array[0] intValue];
    if (lottery_code == kSFP_single            //胜平负 让球胜负平单式
        || lottery_code == kRQ_SFP_single) {
       return  [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self result:result]];
    }else if (lottery_code == kScore_single) {  // 比分单式
        return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self BFResult:result]];
    }else if (lottery_code == kJQS_single) {   //进球数单式
        return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self JQSDResult:result]];
    }else if (lottery_code == kBQC_single) {   //半全场单式
         return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self BQCDResult:result]];
    }else if (lottery_code == kSFP_compound
              || lottery_code == kRQ_SFP_compound) {   //胜平负 让球胜负平复式
         return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self resultSPF:result]];
        
    }else if (lottery_code == kScore_compound) {    //比分复式
         return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self BFFResult:result]];
    }else if (lottery_code == kJQS_compound) {    //进球数复式
         return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self JQSFResult:result]];
    }else if (lottery_code == kBQC_compound) {    //半全场复式
         return [NSString stringWithFormat:@"(%@)%@",[ProjectAPI transformNumber:array[0]],[self BQCFResult:result]];
    }
    return nil;
}


//胜平负 让球胜平负复式
- (NSString *)resultSPF:(NSString *)result {  //胜平负的结果是。，。，。，
    NSArray *array = [result componentsSeparatedByString:@"#"];
    NSLog(@"%@",result);
    NSMutableArray *mutaleArray = [NSMutableArray new];
    NSString *str;
    NSLog(@"%@",array);
    for (NSString *string in array) {
        str = [NSString stringWithFormat:@"%@",[self bqfResult:string]];
        [mutaleArray addObject:str];
        NSLog(@"str = %@",str);
    }
    NSLog(@"mutable = %@",mutaleArray);
    
    //数组变成字符串
    NSString *mutableString = [mutaleArray componentsJoinedByString:@","];
    return mutableString;
}

//比分复式
- (NSString *)BFFResult:(NSString *)result {
    NSLog(@"%@",result);
    NSMutableArray *mutaleArray = [NSMutableArray new];
    NSArray *array = [result componentsSeparatedByString:@"#"];
    for (NSString *string in array) {
        NSString *str1 = [string substringToIndex:1];
        NSString *str2 = [string substringFromIndex:1];
        NSString *str;
        if ([[NSString stringWithFormat:@"%@%@",str1,str2] isEqual:@"90"]) {
            str = @"胜其他";
        }else if ([[NSString stringWithFormat:@"%@%@",str1,str2] isEqual:@"99"]) {
            str = @"平其他";
        }else if ([[NSString stringWithFormat:@"%@%@",str1,str2] isEqual:@"09"]) {
            str = @"负其他";
        }else {
            str = [NSString stringWithFormat:@"%@:%@",str1,str2];
        }
        [mutaleArray addObject:str];
    }
    NSString *mutableString = [mutaleArray componentsJoinedByString:@","];
    return mutableString;
}


//进球数复式
- (NSString *)JQSFResult:(NSString *)result {
    NSLog(@"%@",result);
    NSMutableArray *mutaleArray = [NSMutableArray new];
    NSArray *array = [result componentsSeparatedByString:@"#"];
    for (NSString *string in array) {
        NSString *str;
        if ([string isEqual:@"7"]) {
             str = [NSString stringWithFormat:@"%@+",string];
        }else {
             str = [NSString stringWithFormat:@"%@球",string];
        }
        [mutaleArray addObject:str];
    }
     NSString *mutableString = [mutaleArray componentsJoinedByString:@","];
    return mutableString;
}

//半全场胜负复式
- (NSString *)BQCFResult:(NSString *)result {  //两两 。。，。。，。。，
    NSArray *array = [result componentsSeparatedByString:@"#"];
    NSMutableArray *mutaleArray = [NSMutableArray new];
    NSString *str;
    NSLog(@"%@",array);
    for (NSString *string in array) {
        NSString *str1 = [string substringToIndex:1];
        NSString *str2 = [string substringFromIndex:1];
        NSLog(@"str1 = %@ str2 = %@",str1,str2);
        [self bqfResult:str1];
        
        str = [NSString stringWithFormat:@"%@%@",[self bqfResult:str1],[self bqFResult:str2]];
        [mutaleArray addObject:str];
        NSLog(@"str = %@",str);
    }
    NSLog(@"mutable = %@",mutaleArray);
    
    //数组变成字符串
    NSString *mutableString = [mutaleArray componentsJoinedByString:@","];
    
    return mutableString;
    
}

- (NSString *)bqfResult:(NSString *)result{
    NSString *str1;
    if ([result intValue] == 0) {
        return str1 = @"负";
    }else if ([result intValue] == 1) {
        return str1 = @"平";
    }else if ([result intValue] == 3) {
        return str1 = @"胜";
    }
    
    return str1;
}


- (NSString *)bqFResult:(NSString *)re{
    NSString *str2;
    
    if ([re intValue] == 0) {
        return str2 = @"负";
    }else if ([re intValue] == 1) {
        return str2 = @"平";
    }else if ([re intValue] == 3) {
        return str2 = @"胜";
    }
    return str2;
}




@end
