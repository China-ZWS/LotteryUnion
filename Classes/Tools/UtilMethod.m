//
//  UtilMethod.m
//  LotteryUnion
//
//  Created by xhd945 on 15/10/26.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "UtilMethod.h"

static NSDictionary *lots_dictionary;  //静态彩种编号字典


@implementation UtilMethod


// 根据字符串返回一个字典对象
NSDictionary *getLotteryDictionary(NSString *lottery_pk) {
    if(!lots_dictionary){
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"PlayType" ofType:@"plist"];
        lots_dictionary = [NSDictionary dictionaryWithContentsOfFile:plist];
        NSLog(@"lots_dictionary = %@",lots_dictionary);
    }
    return [lots_dictionary objectForKey:lottery_pk];
    
}


// 根据一个彩种编号的值返回一个字符串对象（用来得到彩种）
NSString *getLotNames(NSString *lot_pk)
{
    return [getLotteryDictionary(lot_pk) objectForKey:@"PlayName"];
}
// 根据一个彩种编号的值返回一个字符串对象（用来得到彩种的控制器）
NSString *getLotViewController(API_LotteryType lot_pk)
{
    return [getLotteryDictionary(GET_INT(lot_pk)) objectForKey:@"ViewController"];
}

NSString *getLotVCString(API_LotteryType lot_pk)
{
    NSString *vcStr;
    switch (lot_pk) {
        case 1:
        {
         vcStr  = @"SenStarPotteryViewController";
        }
             break;
        case 2:
        {
            vcStr  = @"PL3ViewController";
        }
             break;
        case 5:
        {
            vcStr  = @"PL5ViewController";
        }
             break;
        case 6:
        {
            vcStr  = @"DLTViewController";
        }
             break;
        case 31:
        {
            vcStr  = @"SSQViewController";
        }
             break;
        case 50:
        {
            vcStr  = @"T367ViewController";
        }
             break;
        case 51:
        {
            vcStr  = @"T317ViewController";
        }
             break;
        case 52:
        {
            vcStr  = @"T225ViewController";
        }
          break;
        default:
            break;
    }
    return vcStr;
}


//TODO: 彩种是否为足彩
BOOL isFootBallLottery(API_LotteryType lotPK)
{
    if(lotPK==kType_CTZQ_JQ4||lotPK==kType_CTZQ_SF9
       ||lotPK==kType_CTZQ_SF14||lotPK == kType_CTZQ_BQC6)
        return YES;
    return NO;
}


//彩种是否为竞彩足球
BOOL isJCBallLottery(API_LotteryType lotPK)
{
    if(lotPK==kType_JCZQ)
        return YES;
    return NO;
}

//彩种是否为乐透数字
BOOL isLTLottery(API_LotteryType lotPK)
{
    if(lotPK==lDLT_lottery||lotPK==lSSQ_lottery
       ||lotPK==lSenvenStar_lottery||lotPK == lPL3_lottery
       ||lotPK == lPL5_lottery)
        return YES;
    return NO;
}

//彩种是否为地方彩
BOOL isDFLottery(API_LotteryType lotPK)
{
    if(lotPK==lT225_lottery||lotPK==lT317_lottery
       ||lotPK==lT367_lottery)
        return YES;
    return NO;
}


//TODO: 彩种开奖号码是否为单号 
BOOL isSingleBall(API_LotteryType lotPK){
    if(lotPK==lPL3_lottery||lotPK==lPL5_lottery
       ||lotPK==lSenvenStar_lottery||isFootBallLottery(lotPK))
        return YES;
    return NO;
}

//TODO:保存基本信息
+(NSMutableArray*)saveVersionInfo:(NSDictionary*)aDict
{
    NSMutableArray *bulltinArray = [NSMutableArray array];
    // 保存msg_time
    if(isValidateStr(aDict[@"msg_time"]))
        [NS_USERDEFAULT setObject:aDict[@"msg_time"]
                           forKey:@"msg_time"];
    
    // 保存充值限额
    NSString *recharge_limit = [aDict objectForKey:@"recharge_limit"];
    if (!IsEmpty(recharge_limit))
        [NS_USERDEFAULT setValue:recharge_limit forKey:pk_recharge_limit];
    
    // 保存充值提示
    NSString *recharge_note = [aDict objectForKey:@"recharge_note"];
    if (!IsEmpty(recharge_note))
        [NS_USERDEFAULT setValue:recharge_note forKey:pk_recharge_note];
    
    // 保存提现限额
    NSString *cashout_limit = [aDict objectForKey:@"cashout_limit"];
    if (!IsEmpty(cashout_limit))
        [NS_USERDEFAULT setValue:cashout_limit forKey:pk_cashout_limit];
    
    // 保存提现提示
    NSString *cashout_note = [aDict objectForKey:@"cashout_note"];
    if (!IsEmpty(cashout_note))
        [NS_USERDEFAULT setValue:cashout_note forKey:pk_cashout_note];;
    
    // 保存帮助版本
    if (![NS_USERDEFAULT objectForKey:@"help_version"])
        [NS_USERDEFAULT setInteger:HELP_VER forKey:@"help_version"];
    [NS_USERDEFAULT setValue:[aDict valueForKey:@"help_version"] forKey:@"new_help_version"];
    
    // 保存隐藏彩种
    NSString *hide_pk = [aDict objectForKey:@"hide_pk"];
    if(!IsNull(hide_pk) && hide_pk)
        [NS_USERDEFAULT setValue:hide_pk forKey:pk_hide_lotteries];
    
    // 保存分享推荐
    NSString *share_recommend = [aDict objectForKey:@"share_recommend"];
    if (!IsEmpty(share_recommend)) {
        [NS_USERDEFAULT setValue:share_recommend forKey:pk_share_recommend];
    }
    
    // 保存版本提示
    NSString *release_note = [aDict objectForKey:@"release_note"];
    if (!IsNull(release_note) && release_note)
        [NS_USERDEFAULT setValue:release_note forKey:pk_release_note];
    [NS_USERDEFAULT setValue:[aDict valueForKey:@"url"] forKey:@"url"];
    [NS_USERDEFAULT setValue:[aDict valueForKey:@"ver"] forKey:@"version"];
    [NS_USERDEFAULT setValue:[aDict valueForKey:@"force_update"]
                      forKey:@"force_update"];
    [NS_USERDEFAULT synchronize];
    
    
    // 彩票公告
    if ([aDict objectForKey:@"bulletin"]) {
        for (NSDictionary *bulletin in [aDict objectForKey:@"bulletin"]) {
            NSMutableDictionary *bullentM_ = [bulletin mutableCopy];
            [bullentM_ setObject:@"公告" forKey:@"title"];
            [bullentM_ setObject:@"3" forKey:@"news_type"];
            [bulltinArray addObject:bullentM_];
        }
    }
    // 专家推荐
    if ([aDict objectForKey:@"pro_recommend"]) {
        for (NSDictionary *bulletin in [aDict objectForKey:@"pro_recommend"]) {
            NSMutableDictionary *bullentM_ = [bulletin mutableCopy];
            [bullentM_ setObject:@"推荐" forKey:@"title"];
            [bullentM_ setObject:@"4" forKey:@"news_type"];
            
            [bulltinArray addObject:bullentM_];
        }
    }
    // 营销活动
    if ([aDict objectForKey:@"active_info"]){
        for (NSDictionary *bulletin in [aDict objectForKey:@"active_info"]) {
            NSMutableDictionary *bullentM_ = [bulletin mutableCopy];
            [bullentM_ setObject:@"活动" forKey:@"title"];
            [bullentM_ setObject:@"2" forKey:@"news_type"];
            [bulltinArray addObject:bullentM_];
        }
    }
    // 保存公告信息到本地
    if (bulltinArray && [bulltinArray count] > 0) {
        [NS_USERDEFAULT setObject:bulltinArray forKey:@"bulltin"];
        [NS_USERDEFAULT synchronize];
    }
    
    return bulltinArray;
}

//TODO:根据状态码获取信息
NSString *getCodeMessageWithCode(NSString * code)
{
    int aa = [code intValue];
    NSString *bb = [NSString string];
    switch (aa) {
        case 34:
            bb = @"密码长度限制或字符串格式不合法";
            break;
        case 45:
            bb = @"该用户名信息不存在";
            break;
        case 46:
            bb = @"手机号信息有误";
            break;
        case 47:
            bb = @"短信验证码有误";
            break;
        case 48:
            bb = @"身份证号已被绑定";
            break;
        case 49:
            bb = @"姓名格式不正确";
            break;
        case 54:
            bb = @"彩票投注业务未开通";
            break;
        case 59:
            bb = @"短信验证码超过有效期";
            break;
        default:
            bb = @"信息有误，请检查";
            break;
    }
    return bb;
}

//TODO:拿到客户端版本号
NSString *getBuildVersion()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

//TODO:判断字符串是否为空
BOOL isValidateStr(NSString* dest)
{
    return !IsNull(dest) && !IsEmpty(dest);
}
    
//TODO:是否为纯汉字
BOOL isChinese(NSString *str)
{
        if (!isValidateStr(str))
        {
           return NO;
        }
        NSString *regex = @"[\\u4e00-\\u9fa5]+";
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [pred evaluateWithObject:str];
}

//TODO:创建文件夹
BOOL makeDirs(NSString *dirPath)
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    if(![fileMan fileExistsAtPath:dirPath])
        return [fileMan createDirectoryAtPath:dirPath
                  withIntermediateDirectories:YES attributes:nil error:nil];
    return YES;
}
//TODO:组合Document文件夹下的路径
NSString *getPathInDocument(NSString *fileName)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

#pragma mark -- 根据球的号码画蓝球
UIButton *makeRedBallLabel(NSString *number,BOOL isSmall)
{
    UIImage *img = [UIImage imageNamed:@"Redball"];
    CGRect frame;
    if (isSmall) {
        frame = CGRectMake(0, 5, 20, 20);
    }else{
        frame = CGRectMake(0, 0, 33, 33);
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    //    [button setImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:img forState:UIControlStateNormal];
    //    button.enabled = NO;
    [button setTitle:number forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor whiteColor];
    return button;
}

#pragma mark -- 根据球的号码画蓝球
UIButton *makeBlueBallLabel(NSString *number,BOOL isSmall) {
    UIImage *img = [UIImage imageNamed:@"Blueball"];
    
    CGRect frame;
    if (isSmall) {
        frame = CGRectMake(0, 5, 20, 20);
    }else{
        frame = CGRectMake(0, 0, 33, 33);
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setTitle:number forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor whiteColor];
    return button;
}

/*----------------------------*/
#pragma mark -- 获取随机数的方法
int randomValueBetween(int min,int max) {
    if(min>max||min<0){
        return -1;
    }
    return arc4random()%(max-min+1)+min;
}

NSMutableArray *getRadomNumber(int number,int high) {
    NSMutableArray *ball = [NSMutableArray arrayWithCapacity:number];
    for (int i = 0;i < number; i++)
    {
        int rad = randomValueBetween(1,high);
        [ball addObject:[NSString stringWithFormat:@"%02d",rad]];
    }
    
    return ball;
}
//TODO:获取机选数字
NSMutableArray *getRadomNumberFromZero(int number,int high)
{
    NSMutableArray *ball = [NSMutableArray arrayWithCapacity:number];
    for (int i = 0;i < number; i++) {
        int rad = randomValueBetween(0,high);
        [ball addObject:[NSString stringWithFormat:@"%02d",rad]];
    }
    
    return ball;
}

// 多少个数里面随机选出几个数
NSMutableArray *getUnRepeatRadomNumber(int number,int high) {
    NSMutableArray *ball = [NSMutableArray arrayWithCapacity:number];
    for (int i = 0;i < number; i++) {
        int rad = randomValueBetween(1,high);
        BOOL skip = NO;
        for (int j = 0; j <[ball count]; j++) {
            if (rad == [[ball objectAtIndex:j] intValue]) {
                //NSLog(@"skip this number:%d",number);
                return getUnRepeatRadomNumber(number, high);
                skip = YES;
                break;
            }
        }
        if (!skip)
            [ball addObject:[NSString stringWithFormat:@"%02d",rad]];
    }
    
    return ball;
    
}
/*----------------------------*/
// 获取投注状态
NSString *getBetStatus(int status)
{
    
    switch (status) {
        case -1:
            return LocStr(@"出票中");
        case 0:
            return LocStr(@"出票中");
        case 1:
            return LocStr(@"投注成功");
        case 2:
            return LocStr(@"投注失败");
        case 3:
            return LocStr(@"未中奖");
        case 4:
            return LocStr(@"出票失败");
        default:
            return LocStr(@"其他");
            
    }
}

//TODO:获取中文个十百千万
NSString *getChinseHundred(int number)
{
    NSString *result = NULL;
    switch (number) {
        case 1:
            result = @"万";
            break;
        case 2:
            result = @"千";
            break;
        case 3:
            result = @"百";
            break;
        case 4:
            result = @"十";
            break;
        case 5:
            result = @"个";
            break;
        default:
            break;
    }
    return result;
}

//TODO:获取中文数字
NSString *getChineseNumber(int number)
{
    NSString *result = NULL;
    switch (number) {
        case 1:
            result = @"一";
            break;
        case 2:
            result = @"二";
            break;
        case 3:
            result = @"三";
            break;
        case 4:
            result = @"四";
            break;
        case 5:
            result = @"五";
            break;
        case 6:
            result = @"六";
            break;
        case 7:
            result = @"七";
            break;
        case 8:
            result = @"八";
            break;
        case 9:
            result = @"九";
            break;
        default:
            break;
    }
    return result;
}

//TODO:获取百十个未
NSString *getChinseHundredFrom3(int number)
{
    NSString *result = NULL;
    switch (number) {
        case 1:
            result = @"百";
            break;
        case 2:
            result = @"十";
            break;
        case 3:
            result = @"个";
            break;
        default:
            break;
    }
    return result;
}


@end
