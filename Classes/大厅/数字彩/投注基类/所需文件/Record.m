//
//  Record.m
//  ydtctz
//
//  Created by 小宝 on 1/7/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "Record.h"
#import "NSString+NumberSplit.h"
#import <objc/runtime.h>

@implementation Record

@synthesize lottery_pk = _lottery_pk;
@synthesize period = _period;
@synthesize lottery_code = _lottery_code;
@synthesize lottery_name = _lottery_name;
@synthesize amount = _amount;
@synthesize multiple = _multiple;
@synthesize money = _money;
@synthesize buy_money = _buy_money;
@synthesize number = _number;
@synthesize create_time = _create_time;

@synthesize sup = _sup;
@synthesize status = _status;
@synthesize statusName = _statusName;

@synthesize record_pk = _record_pk;
@synthesize bonus_number = _bonus_number;
@synthesize prize_detail = _prize_detail;
@synthesize follow_num = _follow_num;
@synthesize follow_time = _follow_time;
@synthesize follow_type = _follow_type;
@synthesize follow_prize = _follow_prize;
@synthesize finish_num = _finish_num;
@synthesize follow_status = _follow_status;
@synthesize fail_status = _fail_status;
//@synthesize gift_phone = _gift_phone;

@synthesize actionCode = _actionCode;

@synthesize storeDictionary = _storeDictionary;

#if DEBUG
static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /* 
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.            
             */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }        
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

- (NSDictionary *)getDictionary_Debug
{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            //const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            //NSString *propertyType = [NSString stringWithUTF8String:propType];
            [aDict setValue:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    free(properties);
    
    return aDict;
    
}

#endif
- (id)initWithDictionary:(NSDictionary *)aDict
{
    if ((self = [super init])) {
        self.storeDictionary = aDict;
        NSLog(@"++++++++%@++++++++%@",[aDict valueForKey:@"desc"],self.storeDictionary);
        self.lottery_pk = [aDict valueForKey:@"lottery_pk"];     //彩种编号
        self.period = [aDict valueForKey:@"period"];             //彩种期数
        self.lottery_code = [aDict valueForKey:@"lottery_code"]; //玩法编号
        self.lottery_name = [aDict valueForKey:@"lottery_name"]; //玩法名称
        if(self.lottery_name==NULL){
            self.lottery_name = getLotNames(self.lottery_pk); //彩种名
        }
        self.amount = [aDict valueForKey:@"amount"];             // 注数
        self.multiple = [aDict valueForKey:@"multiple"];         // 倍数
        self.money = [aDict valueForKey:@"money"];               // 中奖余额
        self.buy_money = [aDict valueForKey:@"buy_money"];       // 中奖投注金额
        self.number = [aDict valueForKey:@"number"];             // 投注号码
        self.create_time = [aDict valueForKey:@"create_time"];   // 投注日期
        
        self.sup = [[aDict valueForKey:@"sup"] intValue];        // 是否追加
        self.status = [[aDict valueForKey:@"status"] intValue];  // 投注状态
        self.statusName = getBetStatus(self.status);             // 投注状态解析
        NSLog(@"%d---------%@",self.status,self.statusName);
        
        self.record_pk = [aDict valueForKey:@"record_pk"];       //订单号
        if([aDict objectForKey:@"bonus_number"])
            self.bonus_number = [aDict valueForKey:@"bonus_number"]; //开奖号码
        else if([aDict objectForKey:@"prize_number"])
            self.bonus_number = [aDict valueForKey:@"prize_number"];//中奖号码
        
        self.prize_detail = [aDict valueForKey:@"prize_detail"];//中奖详情(等级注数)
        self.beizhu = [aDict valueForKey:@"desc"];         //备注(等级注数)
        self.follow_num = [aDict valueForKey:@"follow_num"];         //追号号码
        self.follow_time = [aDict valueForKey:@"follow_time"];       //追号时间
        self.follow_type = [aDict valueForKey:@"follow_type"];       //追号类型
        if ([self.follow_type isEqualToString:@"1"]) {
            self.number = @"机选投注";
        }
        self.follow_prize = [aDict valueForKey:@"follow_prize"];     //
        self.follow_num = [aDict valueForKey:@"follow_num"];         //
        self.finish_num = [aDict valueForKey:@"finish_num"];         //
        self.follow_status = [aDict valueForKey:@"follow_status"];   //
        
        self.gift_phone = [aDict valueForKey:@"gift_phone"];   // 被送彩票的手机号
        self.greetings = [aDict valueForKey:@"greetings"];     // 赠言
        
        self.fail_status = [aDict valueForKey:@"fail_status"];
        if(self.follow_status.length==0){
        self.fail_status = @"0";
        }
        
    }
    return self;
}

- (NSDictionary *)getDictionary {
    NSMutableDictionary *aDict = [_storeDictionary mutableCopy];
    [aDict setValue:_lottery_name forKey:@"lottery_name"];
    return aDict;
}

// 格式化后的号码
//-(NSString *)formatedNumber {
//    if(!isValidateStr(_formatedNumber)){
//        NSString *number = self.number;
//        int lottery_code = [self.lottery_code intValue];
//        int lottery_pk = [self.lottery_pk intValue];
//        _formatedNumber=showNumberInCell(number,lottery_pk,lottery_code);
//    }
//
//    return _formatedNumber;
//}

// 文本高度自适应（最低高度45）
-(float)calcFormatedNumberHeight {
    int width = IsPad?400:200;
    int hh = [self.formatedNumber sizeWithFont:[UIFont systemFontOfSize:15]
                             constrainedToSize:CGSizeMake(width,800)].height;
    return MAX(hh + 20, 45);
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
        if(lottery_pk==lDLT_lottery)
        {
            bn = [NSString stringWithFormat:@"%@ %@",
                  [[bn substringToIndex:10] commonString:@" " length:2],
                  [[bn substringFromIndex:10] commonString:@" " length:2]];
        }
        else {
            bn = [bn commonString:@" " length:2];
        }
        return bn;
    }
}

// 获取开奖视图
- (void)makeBonusViewWithSuperView:(UIView *)superview bounsNumber:(NSString *)bounsNumber lot_pk:(NSString *)lot_pk {
    if(!isValidateStr(bounsNumber)){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 100, 40)];
        label.text = @"未开奖";
        label.textColor = BLACKFONTCOLOR1;
        label.font = [UIFont systemFontOfSize:15];
        [superview addSubview:label];
        return;
    }
    
    NSString *bn = [bounsNumber replaceAll:@"[^0-9]" withString:@""];
    NSRange range;
    
    if(isFootBallLottery([lot_pk intValue])){ // 足彩
        
        UIView *view = [[UIView alloc] initWithFrame:superview.frame];
        NSString *textStr = [bn commonString:@" " length:1];
        NSArray *textArray = [textStr componentsSeparatedByString:@" "];
        for (int i = 0; i<textArray.count; i++) {
            
            UILabel *ballLabel = [[UILabel alloc] initWithFrame:CGRectMake(9+20*i, 0, 20, 30)];
            [ballLabel setBackgroundColor:[UIColor clearColor]];
            [ballLabel setFont:[UIFont boldSystemFontOfSize:16]];
            [ballLabel setTextColor:[UIColor grayColor]];
            [ballLabel setText:[NSString stringWithFormat:@" %@",textArray[i]]];
            if (i==0) {
                ballLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"f"]];
            }
            if (i==textArray.count-1) {
                ballLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"aa"]];
            }else{
                ballLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"m"]];
            }
            [view addSubview:ballLabel];
        }
        [superview addSubview:view];
    }else {
        
        // 是否为单号(单号为1双号为2)
        int ballLen = isSingleBall([lot_pk intValue])?1:2;
        range.length = ballLen;
        for (int index=0,count=(int)bn.length/ballLen;index<count;index++) {
            range.location = index * ballLen;
            UIButton *ballView;
            
            if(index>4 && [lot_pk intValue]==lDLT_lottery){// 大乐透
                
                ballView = makeBlueBallLabel([bn substringWithRange:range],YES);
            }else if (index > 6&&([lot_pk intValue]==lT367_lottery||[lot_pk intValue]==lT317_lottery)){
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

//高亮中奖号码
-(NSString *)getWin:(NSString*)number {
    
    NSString *bn = [self.bonus_number replaceAll:@"[^0-9]" withString:@""];
    number = [number removeLastString:@"\n"];
    if(!isValidateStr(bn)) return number;
    
    int lottery_pk = [self.lottery_pk intValue];
    int lottery_code = [self.lottery_code intValue];
    NSLog(@"bn:%@  number:%@", bn, number);
    
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
            
        } else if (lottery_pk==kType_CTZQ_JQ4) {
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
            
        }
        else if (lottery_pk==lT367_lottery)
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

@end
