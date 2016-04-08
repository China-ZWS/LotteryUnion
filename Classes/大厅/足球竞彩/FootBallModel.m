//
//  FootBallModel.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/26.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//



#import "FootBallModel.h"
#import "DataConfigManager.h"

#pragma mark - 数据类型


@implementation FBDatasModel
- (id)mutableCopyWithZone:(NSZone *)zone
{
    FBDatasModel *copy = [[[self class] allocWithZone:zone] init];
    copy.datas = _datas;
    copy.position = _position;
    copy.endTime = _endTime;
    copy.scroes = _scroes ;
    copy.BQCDatas = _BQCDatas;
    copy.win = _win;
    copy.pin = _pin;
    copy.lose = _lose;
    copy.rWin = _rWin;
    copy.rPin = _rPin;
    copy.rLose = _rLose;
    copy.JQS_select_one = _JQS_select_one;
    copy.JQS_select_two = _JQS_select_two;
    copy.JQS_select_three = _JQS_select_three;
    copy.JQS_select_four = _JQS_select_four;
    copy.JQS_select_five = _JQS_select_five;
    copy.JQS_select_six = _JQS_select_six;
    copy.JQS_select_one = _JQS_select_seven;
    copy.JQS_select_one = _JQS_select_eight;
    copy.play = _play;

    return copy;
}

- (id)copyWithZone:(NSZone *)zone
{
    FBDatasModel *copy = [[[self class] allocWithZone:zone] init];
    copy.datas = _datas;
    copy.position = _position;
    copy.endTime = _endTime;
    copy.scroes = _scroes;
    copy.BQCDatas = _BQCDatas;
    copy.win = _win;
    copy.pin = _pin;
    copy.lose = _lose;
    copy.rWin = _rWin;
    copy.rPin = _rPin;
    copy.rLose = _rLose;
    copy.JQS_select_one = _JQS_select_one;
    copy.JQS_select_two = _JQS_select_two;
    copy.JQS_select_three = _JQS_select_three;
    copy.JQS_select_four = _JQS_select_four;
    copy.JQS_select_five = _JQS_select_five;
    copy.JQS_select_six = _JQS_select_six;
    copy.JQS_select_one = _JQS_select_seven;
    copy.JQS_select_one = _JQS_select_eight;
    copy.play = _play;
    return copy;
}

@end



@interface FootBallModel (private)

/**
 *  @brief  按时间分类。递归
 *
 *  @param items     要分类的数据
 *  @param endDate   递归停止的时间节点
 *  @param timestamp 开始节点
 *  @param keyword   筛选关键字
 *  @param carrier   载体数组
 *
 *  @return 返回筛选好的数组
 */
+ (NSArray *)_searchDatas:(NSArray *)items endDate:(NSDate *)endDate timestamp:(NSDate *)timestamp keyword:(NSString *)keyword carrier:(NSMutableArray *)carrier;


/**
 *  @brief  时间排序
 *
 *  @param items  时间集
 *  @param result 返回状态
 *
 *  @return 排序好的数据
 */
+ (NSArray *)_getSortedArray:(NSArray *)items result:(NSComparisonResult)result;

+ (NSInteger)_calculateSingleWithBettingNum:(NSArray *)datas;
@end


@implementation FootBallModel
singleton_implementation(FootBallModel)
- (id)init
{
    if ((self = [super init])) {
        _selectDatas = [NSMutableArray array];
        _formatter = [[NSDateFormatter alloc] init];
        _calendar = [NSCalendar currentCalendar];
    }
    return self;
}


#pragma mark - 足彩对阵信息重组（按天分类）
+ (NSArray *)getDatasClassifyForLotteryPlayInformation:(NSArray *)itemDatas timestamp:(NSDate *)timestamp keyword:(NSString *)keyword ;
{
    NSArray *items = [self _getSortedArray:itemDatas result:NSOrderedDescending];
    [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * earlierDate = [FBTool.formatter dateFromString:items[0][@"end_time"]];
    NSDate * laterDate = [FBTool.formatter dateFromString:items[items.count - 1][@"end_time"]];
    NSArray *searchDatas =  [self _searchDatas:items endDate:laterDate timestamp:earlierDate keyword:keyword carrier:[NSMutableArray array]];

    return searchDatas;
}


#pragma mark - 得到不同单场的返回对阵信息
+ (NSArray *)getSingleDatasToItemDatas:(id)datas predicateWithFormats:(NSArray *)predicateWithFormats keyword:(NSString *)keyword;
{
    /*
     得到当前时间戳
     */
    [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timestamp=[FBTool.formatter dateFromString:datas[@"system_time"] ];
    
    //查询条件
    NSMutableArray *predicates = [NSMutableArray array];
    for (NSString *predicateWithFormat in predicateWithFormats)
    {
        NSPredicate* predicate=[NSPredicate predicateWithFormat:predicateWithFormat];
        [predicates addObject:predicate];
    }
    NSPredicate *andCompoundPredicate =[NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    NSArray *singleDatas = [datas[@"item"] filteredArrayUsingPredicate:andCompoundPredicate];
    if (!singleDatas.count) {
        return singleDatas;
    }
    return [self getDatasClassifyForLotteryPlayInformation:singleDatas timestamp:timestamp keyword:keyword];
}



#pragma mark - 得到开奖信息查询;
+ (NSArray *)getTheLotteryInformation:(NSArray *)datas;
{
    NSArray *items = [self _getSortedArray:datas result:NSOrderedAscending];

    [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *earlierDate = [FBTool.formatter dateFromString:items[items.count - 1][@"end_time"]];
        
    NSDate *laterDate = [FBTool.formatter dateFromString:items[0][@"end_time"]];
    NSArray *searchDatas =  [self searchDatas:items earlierDate:earlierDate timestamp:laterDate carrier:[NSMutableArray array]];
    
    return searchDatas;

}

#pragma mark - 开奖递归时间分类
+ (NSArray *)searchDatas:(NSArray *)items earlierDate:(NSDate *)earlierDate timestamp:(NSDate *)timestamp carrier:(NSMutableArray *)carrier
{
    NSMutableArray *temps = [NSMutableArray array];
    for (NSDictionary *item in items)
    {
        NSString *end_time = item[@"end_time"];
        [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [FBTool.formatter dateFromString:end_time];

        if ([self isSameDay:date date2:timestamp])
        {
            [temps addObject:item];
        }
    }
    if (temps.count)
    {
        [FBTool.formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *timestampString = [FBTool.formatter stringFromDate:timestamp];
        NSString *info = [NSString stringWithFormat:@"%@  %@",timestampString,[NSString weekdayStringFromDate:timestamp]];
        NSDictionary *dataDate = @{@"info":info,@"datas":temps};
        [carrier addObject:dataDate];
   
    }
    if (![self isSameDay:earlierDate date2:timestamp])
    {
        NSDateComponents *comp = [FBTool.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:timestamp];
        NSInteger day = [comp day];
        [comp setDay:day - 1];
        NSDate *secondDayDate= [FBTool.calendar dateFromComponents:comp];
        return [self searchDatas:items earlierDate:earlierDate timestamp:secondDayDate carrier:carrier];
    }
    return carrier;
}





#pragma mark - 比分投注详情内容
+ (NSMutableAttributedString *)setScroeTextWithDatas:(NSArray *)datas
{
    
    NSDictionary *finishDatas = [self getScroeDic:datas];
    
    
    if (finishDatas.count)
    {
        NSString *title = [NSString string:finishDatas[@"s"] AppendingString:finishDatas[@"f"] components:finishDatas[@"p"]];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
        [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange(0, [finishDatas[@"s"] length])];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGBA(35, 151, 160, 1) range:NSMakeRange([finishDatas[@"s"] length], [finishDatas[@"p"] length])];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGBA(236, 161, 11, 1) range:NSMakeRange([finishDatas[@"p"] length] + [finishDatas[@"s"] length], [finishDatas[@"f"] length])];
        return attrString;
    }
    else
    {
        return [[NSMutableAttributedString alloc] initWithString:@"点击展开比分投注区"];
    }
    
}


+ (NSDictionary *)getScroeDic:(NSArray *)datas
{
    
    NSMutableArray *Sdatas = [NSMutableArray array];
    NSMutableArray *Pdatas = [NSMutableArray array];
    NSMutableArray *Fdatas = [NSMutableArray array];
    
    NSString *SQT = nil;
    NSString *PQT = nil;
    NSString *FQT = nil;
    
    for (NSDictionary *dic in datas)
    {
        
        NSInteger first = [[dic[@"value_storage"] substringToIndex:1] integerValue];
        NSInteger second = [[dic[@"value_storage"] substringFromIndex:1] integerValue];
        NSString *display = dic[@"value_display"];
        
        if (first > second && ![display isEqualToString:@"胜其他"]) {
            [Sdatas addObject:display];
        }
        else if (first == second && ![display isEqualToString:@"平其他"])
        {
            [Pdatas addObject:display];
        }
        else if (first < second && ![display isEqualToString:@"负其他"])
        {
            [Fdatas addObject:display];
        }
        else if ([display isEqualToString:@"胜其他"]) {
            SQT = @"胜其他";
        }
        else if ([display isEqualToString:@"平其他"]) {
            PQT = @"平其他";
        }
        else if ([display isEqualToString:@"负其他"]) {
            FQT = @"负其他";
        }
        
    }
    
    Sdatas = [self getValue_displaySortedArray:Sdatas result:NSOrderedDescending];
    Pdatas = [self getValue_displaySortedArray:Pdatas result:NSOrderedDescending];
    Fdatas = [self getValue_displaySortedArray:Fdatas result:NSOrderedDescending];
    
    if (SQT) {
        [Sdatas addObject:SQT];
    }
    if (PQT) {
        [Pdatas addObject:PQT];
    }
    if (FQT) {
        [Fdatas addObject:FQT];
    }
    
    NSString *S = nil, *P = nil, *F = nil;
    if (Sdatas.count) {
        S = [NSString string:@"[" AppendingString:@"]" components:[Sdatas componentsJoinedByString:@","]];
    }
    if (Pdatas.count)
    {
        P = [NSString string:@"[" AppendingString:@"]" components:[Pdatas componentsJoinedByString:@","]];
    }
    if (Fdatas.count) {
        F = [NSString string:@"[" AppendingString:@"]" components:[Fdatas componentsJoinedByString:@","]];
    }
    
    NSMutableDictionary *finishDatas = [NSMutableDictionary dictionary];
    finishDatas[@"s"] = S;
    finishDatas[@"p"] = P;
    finishDatas[@"f"] = F;
    
    return finishDatas;
}


+ (NSMutableArray *)getValue_displaySortedArray:(NSMutableArray *)items result:(NSComparisonResult)result
{
    if (!items.count) {
        return items;
    }
    return [NSMutableArray arrayWithArray:[items  sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                           {
                                               
                                               NSComparisonResult comparisonResult = [[obj1 stringByReplacingOccurrencesOfString:@":" withString:@""]compare:[obj2 stringByReplacingOccurrencesOfString:@":" withString:@""]];
                                               return comparisonResult == result;
                                           }]];
}


+ (NSMutableAttributedString *)setBQCTextWithDatas:(NSArray *)datas;
{

    NSMutableAttributedString *title = [self getBQCText:datas];
    return title;
}



#pragma mark - 半全场投注详情内容
+ (NSMutableAttributedString *)getBQCText:(NSArray *)datas
{
    
    datas = [datas  sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                              {
                                  
                                  NSComparisonResult comparisonResult = [obj1[@"value_storage"] compare:obj2[@"value_storage"]];
                                  
                                  return comparisonResult == NSOrderedAscending;
                              }];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in datas)
    {
        NSString *display = dic[@"value_display"];
        [titles addObject:display];
    }
    
    if (titles.count)
    {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString string:@"[" AppendingString:@"]" components:[titles componentsJoinedByString:@","]]];
        [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange(0, [attrString length])];

        return attrString;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"点击展开比分投注区"];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange(0, [attrString length])];
    return attrString;
}

#pragma mark - 混合过关投注详情内容
+ (NSMutableAttributedString *)setHHGGTextWithDatas:(FBDatasModel *)model;
{
    NSMutableArray *titles = [NSMutableArray array];
    if (model.win) [titles addObject:@"主胜"];
    if (model.pin) [titles addObject:@"平"];
    if (model.lose) [titles addObject:@"主负"];
    if (model.rWin) [titles addObject:@"让球胜"];
    if (model.rPin) [titles addObject:@"让球平"];
    if (model.rLose) [titles addObject:@"让球负"];
    if (model.scroes && model.scroes.count) return [self setScroeTextWithDatas:model.scroes];
    if (model.BQCDatas && model.BQCDatas.count) return [self setBQCTextWithDatas:model.BQCDatas];
    if (model.JQS_select_one)[titles addObject:@"1球"];
    if (model.JQS_select_two)[titles addObject:@"2球"];
    if (model.JQS_select_three)[titles addObject:@"3球"];
    if (model.JQS_select_four)[titles addObject:@"4球"];
    if (model.JQS_select_five)[titles addObject:@"5球"];
    if (model.JQS_select_six)[titles addObject:@"6球"];
    if (model.JQS_select_seven)[titles addObject:@"7球"];
    if (model.JQS_select_eight)[titles addObject:@"8球"];
  
    if (titles.count)
    {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString string:@"[" AppendingString:@"]" components:[titles componentsJoinedByString:@","]]];
        [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange(0, [attrString length])];
        
        return attrString;
    }
    
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"点击展开比分投注区"];
//    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange(0, [attrString length])];
    return nil;

}


#pragma mark - 点击选好了投注界面数据筛选
+ (FBDatasModel *)filtrateWithBettingDatas:(NSDictionary *)dic;
{
    FBDatasModel *model = nil;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"position == %@",dic[@"position"]];
    
    /*通过谓语查询，目的是为了找到‘FBTool.selectDatas’里的‘FBDatasModel’数据对象*/
    NSArray *selectDatas = [FBTool.currentDatas filteredArrayUsingPredicate:predicate];
    
    if (selectDatas.count)
    {
        model = selectDatas[0];
    }
    return model;
}

+ (FBDatasModel *)filtrateWithBettingDatas:(NSDictionary *)dic play:(FBBettingPlay)play;
{
    FBDatasModel *dataModel = nil;
  
    NSMutableArray *predicates = [NSMutableArray array];
    
    NSPredicate* firstPredicate=[NSPredicate predicateWithFormat:@"position == %@",dic[@"position"]];
    NSPredicate* secondPredicate=[NSPredicate predicateWithFormat:@"play == %d",play];
    [predicates addObject:firstPredicate];
    [predicates addObject:secondPredicate];
    
    /*双关谓语*/
    NSPredicate *andCompoundPredicate =[NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    /*通过谓语查询，目的是为了找到‘FBTool.selectDatas’里的‘FBDatasModel’数据对象*/
    NSArray *selectDatas = [FBTool.selectDatas filteredArrayUsingPredicate:andCompoundPredicate];
    
    /*‘selectDatas’不为空表示找到,如果为空，就直接初始化*/
    if (selectDatas.count) {
        dataModel = selectDatas[0];
    }
    else
    {
        dataModel = [FBDatasModel new];
    }
    return dataModel;
}



+ (NSArray *)filtrateWithCurrentBettingPlay:(FBBettingPlay)play
{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"play == %d",play];
    NSArray *selectDatas = [FBTool.selectDatas filteredArrayUsingPredicate:predicate];
    return selectDatas;
}

#pragma mark - 同一天的时间判断
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [FBTool.calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [FBTool.calendar components:unitFlags fromDate:date2];
    
    return [comp1 day] == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


#pragma mark - 投注结果
+ (void)calculateSingleDatas:(NSArray *)datas result:(void(^)(NSInteger bettingNum))result;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger bettingNum = [self _calculateSingleWithBettingNum:datas ];;
        dispatch_async(dispatch_get_main_queue(), ^{
            result(bettingNum);
        });
    });
}

#pragma mark - 过关投注结果
+ (void)calculateSkipmatchDatas:(NSArray *)datas scheme:(NSMutableArray *)scheme result:(void(^)(NSInteger bettingNum, CGFloat maxNum, CGFloat minNum))result;
{
    if (datas.count == 1 || datas.count == 0)
    {
        result(0,0,0);
        return ;
    }

    NSMutableArray *temps = [NSMutableArray array];
    for (FBDatasModel *model in datas)
    {
        NSArray *list_value1 = model.datas[@"list_value1"];
        NSArray *list_value2 = model.datas[@"list_value2"];
        NSArray *list_value5 = model.datas[@"list_value5"];

        NSMutableArray *odds = [NSMutableArray array];
        if (model.win) [odds addObject:list_value1[0][@"odds"]];
        if (model.pin) [odds addObject:list_value1[1][@"odds"]];
        if (model.lose) [odds addObject:list_value1[2][@"odds"]];
        if (model.rWin) [odds addObject:list_value2[0][@"odds"]];
        if (model.rPin) [odds addObject:list_value2[1][@"odds"]];
        if (model.rLose) [odds addObject:list_value2[2][@"odds"]];
        if (model.scroes)
        {
            for (NSDictionary *dic in model.scroes)
            {
                [odds addObject:dic[@"odds"]];
            }
        }
        if (model.BQCDatas)
        {
            for (NSDictionary *dic in model.BQCDatas)
            {
                [odds addObject:dic[@"odds"]];
            }
        }
        if (model.JQS_select_one) [odds addObject:list_value5[0][@"odds"]];
        if (model.JQS_select_two) [odds addObject:list_value5[1][@"odds"]];
        if (model.JQS_select_three) [odds addObject:list_value5[2][@"odds"]];
        if (model.JQS_select_four) [odds addObject:list_value5[3][@"odds"]];
        if (model.JQS_select_five) [odds addObject:list_value5[4][@"odds"]];
        if (model.JQS_select_six) [odds addObject:list_value5[5][@"odds"]];
        if (model.JQS_select_seven) [odds addObject:list_value5[6][@"odds"]];
        if (model.JQS_select_eight) [odds addObject:list_value5[7][@"odds"]];
        [temps addObject:odds];
    }
    
    /*表示默认*/
    if (!scheme.count) {
        [scheme addObjectsFromArray:[DataConfigManager getFB_bettingPlay:[datas count]][@"bettings1"]];
    }
    NSInteger bettingNum = 0;
    CGFloat maxNum = 0;
    CGFloat minNum = 0;
    for (NSDictionary *dic in scheme)
    {
        for (NSNumber *num in dic[@"scheme"])
        {
            NSMutableArray *group = [NSMutableArray array];
            [self combine:temps n:[num integerValue] group:group];
            
            for (int i = 0; i < group.count; i++)
            {
                NSInteger rowNum = 1;
                NSArray *row = group[i];
                CGFloat max = 1;
                CGFloat min = 1;
                for (int j = 0; j < row.count; j ++)
                {
                    rowNum = rowNum *[row[j] count];
                    max = max * [[row[j] valueForKeyPath:@"@max.floatValue"] floatValue];
                    min = min * [[row[j] valueForKeyPath:@"@min.floatValue"] floatValue];
                }
                bettingNum = bettingNum + rowNum;
                maxNum = maxNum + max;
              
                if (minNum == 0 || minNum > min) {
                    minNum = min;
                }
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        result(bettingNum,maxNum,minNum);
    });
}
//NSMutableArray *supporter = [NSMutableArray array];
//[self getAllBetting:temps  supporter:supporter start:2];

#if 0
+ (NSArray *)getAllBetting:(NSArray *)datas supporter:(NSMutableArray *)supporter start:(NSInteger)index
{

    NSString *code_id = [NSString stringWithFormat:@"0%d01",index];
    NSMutableArray *group = [NSMutableArray array];
    [self combine:datas n:index group:group];
    NSInteger bettingNum = 0;
    for (int i = 0; i < group.count; i++) {
        NSInteger rowNum = 1;
        NSArray *row = group[i];
       
        
        for (int j = 0; j < [group[i] count]; j ++)
        {
            rowNum = rowNum *[row[j] integerValue];
        }
        bettingNum = bettingNum + rowNum;
    }
    
//    NSInteger bettingNum = [self group:group index:group.count - 1]; // 递归出现压栈异常，啥问题还没搞清楚

    [supporter addObject:@{@"code_id":code_id,@"bettingNum":[NSNumber numberWithInteger:bettingNum],@"title":[NSString stringWithFormat:@"%d串1",index]}];

    if (index == datas.count || index == 8) {
        return supporter;
    }    
    return [self getAllBetting:datas supporter:supporter start:index + 1];
}

#endif  


#pragma mark 计算组合注数
+ (NSInteger)group:(NSArray *)group index:(NSInteger)index
{
    NSArray *row = group[index];
    NSInteger rowNum = [self row:row index:row.count - 1];
    if (index == 0) {
        return rowNum;
    }
    return rowNum + [self group:group index:index - 1];
}

+ (NSInteger)row:(NSArray *)row index:(NSInteger)index
{
    NSInteger num = [row[index] integerValue];
    if (index == 0) {
        return num;
    }
    return num*[self row:row index:index - 1];
}


#pragma mark - 列出所有组合
+ (void)combine:(NSArray *)aArray n:(NSInteger)n group:(NSMutableArray *)group
{
    if(nil == aArray || aArray.count == 0 || n <= 0 || n > aArray.count)
        return;
    
    //辅助空间，保存待输出组合数
    NSMutableArray *bArray = [NSMutableArray arrayWithCapacity:n];
    [self getCombination:aArray n:n begin:0 bArray:bArray index:0 group:group];
}

+ (void)getCombination:(NSArray *)aArray n:(NSInteger)n begin:(NSInteger)begin bArray:(NSMutableArray *)bArray index:(NSInteger)index group:(NSMutableArray *)group
{
 
    if(n == 0){//如果够n个数了，输出b数组
//        for(int i = 0; i < index; i++){
//                        NSLog(@"%d ",[bArray[i] count]);
//        }
        [group addObject:[bArray copy]];
        return;
    }
    
    for(NSInteger i = begin; i < aArray.count; i++){
      
        bArray[index] = aArray[i];
        [self getCombination:aArray n:n-1 begin:i+1 bArray:bArray index:index+1 group:group];
    }
}


@end


@implementation FootBallModel (private)

#pragma mark - 按时间分类查询
+ (NSArray *)_searchDatas:(NSArray *)items endDate:(NSDate *)endDate timestamp:(NSDate *)timestamp keyword:(NSString *)keyword carrier:(NSMutableArray *)carrier
{
    NSMutableArray *temps = [NSMutableArray array];
    for (NSDictionary *item in items)
    {
        NSString *end_time = item[@"end_time"];
        [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [FBTool.formatter dateFromString:end_time];
        if ([self isSameDay:date date2:timestamp])
        {
            if (!keyword)
            {
                [temps addObject:item];
            }
            else if ([item[keyword] count])
            {
                [temps addObject:item];
            }
            
        }
    }
    if (temps.count)
    {
        [FBTool.formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *timestampString = [FBTool.formatter stringFromDate:timestamp];
        NSString *info = [NSString stringWithFormat:@"%@  %@  %d场比赛可投",timestampString,[NSString weekdayStringFromDate:timestamp], temps.count];
        NSDictionary *dataDate = @{@"info":info,@"datas":temps};
        [carrier addObject:dataDate];
        
    }
    if (![self isSameDay:endDate date2:timestamp])
    {
        NSDateComponents *comp = [FBTool.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:timestamp];
        NSInteger day = [comp day];
        [comp setDay:day + 1];
        NSDate *otherDate = [FBTool.calendar dateFromComponents:comp];
        return [self _searchDatas:items endDate:endDate timestamp:otherDate keyword:keyword carrier:carrier];
    }
    return carrier;
    
}



#pragma mark - 通过时间排序
+ (NSArray *)_getSortedArray:(NSArray *)items result:(NSComparisonResult)result
{
    return [items  sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                NSString *end_time1 = obj1[@"end_time"];
                NSString *end_time2 = obj2[@"end_time"];
                
                [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *obj1Date = [FBTool.formatter dateFromString:end_time1];
                NSDate *obj2Date = [FBTool.formatter dateFromString:end_time2];
                
                NSComparisonResult comparisonResult = [obj1Date compare:obj2Date];
                return comparisonResult == result;
            }];
}


+ (NSInteger)_calculateSingleWithBettingNum:(NSArray *)datas;
{
    int i = 0;
    for (FBDatasModel *model in datas)
    {
        if (model.win) i ++;
        if (model.pin) i ++;
        if (model.lose) i ++;
        if (model.rWin) i ++;
        if (model.rPin) i ++;
        if (model.rLose) i ++;
        if (model.scroes) i += model.scroes.count;
        if (model.BQCDatas) i += model.BQCDatas.count;
        if (model.JQS_select_one) i ++;
        if (model.JQS_select_two) i ++;
        if (model.JQS_select_three) i ++;
        if (model.JQS_select_four) i ++;
        if (model.JQS_select_five) i ++;
        if (model.JQS_select_six) i ++;
        if (model.JQS_select_seven) i ++;
        if (model.JQS_select_eight) i ++;
    }
    return i;
}

@end








