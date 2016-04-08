//
//  CTFBModel.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/13.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFBModel.h"

@implementation CTFBDataModels

- (id)initWithDatas:(NSDictionary *)dic index:(NSInteger)index
{
    if ((self = [super init]))
    {
        _index = [NSString stringWithFormat:@"%01d",index];
        _team1 = dic[@"team1"];
        _team2 = dic[@"team2"];
        _star_time = dic[@"start_time"];
    }
    return self;
}

+ (NSMutableArray *)getDatas:(NSArray *)datas
{
    NSMutableArray *models = [NSMutableArray array];
   
    NSInteger i = 0;
    for (NSDictionary *dic in datas)
    {
        NSUInteger loc1 = [dic[@"team1"] length];
        NSUInteger loc2 = [dic[@"team2"] length];
        if (!loc1 || !loc2) continue;
        [models addObject:[[CTFBDataModels alloc] initWithDatas:dic index:i]];
        i ++;
    }
    return models;
}

+ (void )createData:(NSString *)responseString success:(void (^)(id data))success failure:(void (^)(NSString *msg, NSString *state))failure;
{
    NSLog(@"%@",responseString);
    NSLog(@"成功");
    NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *code = dict[@"code"];
    NSString * jsessionid = dict[@"jsessionid"];
    [keychainItemManager writeSessionId:jsessionid];
    NSString *msg = dict[@"note"];
    if ([code integerValue] == Status_Code_Request_Success)
    {
        NSArray *datas = dict[@"item"];
        datas = [self getDatas:datas];
        success(datas);
    }
    else
    {
        
        failure(msg,code);
    }
}


@end


@interface CTFBModel (private)
/**
 *  @brief  随机数
 *
 *  @param from 约束1
 *  @param to   约束2
 *  @param cacheDatas   约束3
 *
 *  @return 返回随机数
 */
+ (NSInteger )_getRandomNumber:(int)from to:(int)to cacheDatas:(NSArray *)cacheDatas;

@end

@implementation CTFBModel
singleton_implementation(CTFBModel)
- (id)init
{
    if ((self = [super init])) {
        _value_storages = [NSMutableArray array];
        _betting_results = [NSMutableArray array];
    }
    return self;
}

+ (void)calculateWithBettingNum:(NSInteger)num result:(void(^)(NSInteger bettingNum))result hasSelectDouble:(BOOL)hasSelectDouble;
{
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *temps = [NSMutableArray array];
        
        for (CTFBDataModels *model in CTFBTool.value_storages)
        {
            int i = 0;
            if (model.win) i ++;
            if (model.pin) i ++;
            if (model.lose) i ++;
            
            if (hasSelectDouble && i != 0 && num == 6)
            {
                [temps addObject:[NSNumber numberWithInt:i]];
                i = 0;
            }

            
            if (model.bWin) i ++;
            if (model.bPin) i ++;
            if (model.bLose) i ++;
            
            if (model.team1_select_one) i ++;
            if (model.team1_select_two) i ++;
            if (model.team1_select_three) i ++;
            if (model.team1_select_four) i ++;
            if (hasSelectDouble && i != 0 && num == 4)
            {
                [temps addObject:[NSNumber numberWithInt:i]];
                i = 0;
            }

            if (model.team2_select_one) i ++;
            if (model.team2_select_two) i ++;
            if (model.team2_select_three) i ++;
            if (model.team2_select_four) i ++;

            [temps addObject:[NSNumber numberWithInt:i]];
        }
        
        NSMutableArray *group = [NSMutableArray array];
        
        [self combine:temps n:hasSelectDouble?num * 2:num group:group];
     
//        NSInteger bettingNum = 0;
//        for (int i = 0; i < group.count; i++) {
//            NSInteger rowNum = 1;
//            NSArray *row = group[i];
//            for (int j = 0; j < [group[i] count]; j ++)
//            {
//                rowNum = rowNum *[row[j] integerValue];
//            }
//            bettingNum = bettingNum + rowNum;
//        }

        NSInteger bettingNum = [self group:group index:group.count - 1]; // 递归出现压栈异常，啥问题还没搞清楚
        
        dispatch_async(dispatch_get_main_queue(), ^{
            result(bettingNum);
        });
    });
}

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
        //            //            NSLog(@"%ld ",[bArray[i] integerValue]);
        //        }
        [group addObject:[bArray copy]];
        return;
    }
    for(NSInteger i = begin; i < aArray.count; i++){
        bArray[index] = aArray[i];
        [self getCombination:aArray n:n-1 begin:i+1 bArray:bArray index:index+1 group:group];
    }
}

#pragma mark - 胜负14场比赛随机
+ (void)get14RandomGames:(NSArray *)datas result:(void(^)(NSArray *datas))result;
{
    if (CTFBTool.value_storages.count)
    {
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] removeAllObjects];
        
    }
    
    for (CTFBDataModels *model in datas)
    {
        model.win = model.pin = model.lose = NO;
        NSInteger randomGameResult = [self _getRandomNumber:0 to:3 cacheDatas:@[[NSNumber numberWithInteger:2]]];
        switch (randomGameResult) {
            case 3:
                model.win = YES;
                break;
            case 1:
                model.pin = YES;
                break;
            case 0:
                model.lose = YES;
                break;
            default:
                break;
        }
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] addObject:model];
    }
    result(datas);
}

+ (void)get9RandomGames:(NSArray *)datas  result:(void(^)(NSArray *datas))result;
{
    if (CTFBTool.value_storages.count)
    {
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] removeAllObjects];
        
        for (CTFBDataModels *model in datas)
        {
            model.win = model.pin = model.lose = NO;
        }

    }
    NSMutableArray *cacheDatas = [NSMutableArray array];
    for (int i = 0; i < 9; i ++)
    {
        NSInteger randomNum = [self _getRandomNumber:0 to:13 cacheDatas:cacheDatas];
        [cacheDatas addObject:[NSNumber numberWithInteger:randomNum]];
        CTFBDataModels *model = datas[randomNum];
        model.win = model.pin = model.lose = NO;
       
        NSInteger randomGameResult = [self _getRandomNumber:0 to:3 cacheDatas:@[[NSNumber numberWithInteger:2]]];
        switch (randomGameResult) {
            case 3:
                model.win = YES;
                break;
            case 1:
                model.pin = YES;
                break;
            case 0:
                model.lose = YES;
                break;
            default:
                break;
        }
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] addObject:model];
   
    }
    
    result(datas);
}


+ (void)get6RandomGames:(NSArray *)datas  result:(void(^)(NSArray *datas))result;
{
    if (CTFBTool.value_storages.count)
    {
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] removeAllObjects];
    }
    
    for (CTFBDataModels *model in datas)
    {
        model.win = model.pin = model.lose = model.bWin = model.bPin = model.bLose = NO;
        NSInteger randomGameResult1 = [self _getRandomNumber:0 to:3 cacheDatas:@[[NSNumber numberWithInteger:2]]];
        switch (randomGameResult1) {
            case 3:
                model.win = YES;
                break;
            case 1:
                model.pin = YES;
                break;
            case 0:
                model.lose = YES;
                break;
            default:
                break;
        }
        
        NSInteger randomGameResult2 = [self _getRandomNumber:0 to:3 cacheDatas:@[[NSNumber numberWithInteger:2]]];
        switch (randomGameResult2) {
            case 3:
                model.bWin = YES;
                break;
            case 1:
                model.bPin = YES;
                break;
            case 0:
                model.bLose = YES;
                break;
            default:
                break;
        }

        [[CTFBTool mutableArrayValueForKey:@"value_storages"] addObject:model];
    }
    result(datas);

}

+ (void)get4RandomGames:(NSArray *)datas  result:(void(^)(NSArray *datas))result;
{
    if (CTFBTool.value_storages.count)
    {
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] removeAllObjects];
    }
    
    for (CTFBDataModels *model in datas)
    {
        model.team1_select_one = model.team1_select_two = model.team1_select_three = model.team1_select_four
        =
        model.team2_select_one = model.team2_select_two = model.team2_select_three = model.team2_select_four =NO;
        NSInteger randomGameResult1 = [self _getRandomNumber:0 to:3 cacheDatas:nil];
        switch (randomGameResult1) {
            case 0:
                model.team1_select_one = YES;
                break;
            case 1:
                model.team1_select_two = YES;
                break;
            case 2:
                model.team1_select_three = YES;
                break;
            case 3:
                model.team1_select_four = YES;
                break;

            default:
                break;
        }
        
        NSInteger randomGameResult2 = [self _getRandomNumber:0 to:3 cacheDatas:nil];
       
        switch (randomGameResult2) {
            case 0:
                model.team2_select_one = YES;
                break;
            case 1:
                model.team2_select_two = YES;
                break;
            case 2:
                model.team2_select_three = YES;
                break;
            case 3:
                model.team2_select_four = YES;
                break;
            default:
                break;
        }
        
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] addObject:model];
    }
    result(datas);

}

+ (NSString *)getBettingResultBettingType:(NSInteger)bettingType;
{
    NSMutableString *betting = [NSMutableString new];

    int i = 0;
    for (CTFBDataModels *model in CTFBTool.value_storages)
    {
        i ++;
        if (model.win) [betting appendString:@"3"];
        if (model.pin) [betting appendString:@"1"];
        if (model.lose) [betting appendString:@"0"];
        if (bettingType == 1 && (model.bWin || model.bPin || model.bLose) && (model.win || model.pin || model.lose))
        {
            [betting appendString:@"#"];
        }
        if (model.bWin) [betting appendString:@"3"];
        if (model.bPin) [betting appendString:@"1"];
        if (model.bLose) [betting appendString:@"0"];
        if (model.team1_select_one) [betting appendString:@"0"];
        if (model.team1_select_two) [betting appendString:@"1"];
        if (model.team1_select_three) [betting appendString:@"2"];
        if (model.team1_select_four) [betting appendString:@"3"];
        if (bettingType == 1  && ( model.team2_select_one || model.team2_select_two | model.team2_select_three || model.team2_select_four) && ( model.team1_select_one || model.team1_select_two | model.team1_select_three || model.team1_select_four))
        {
            [betting appendString:@"#"];
        }
        if (model.team2_select_one) [betting appendString:@"0"];
        if (model.team2_select_two) [betting appendString:@"1"];
        if (model.team2_select_three) [betting appendString:@"2"];
        if (model.team2_select_four) [betting appendString:@"3"];
        
        if (!(model.bWin || model.bPin || model.bLose || model.win || model.pin || model.lose || model.team2_select_one || model.team2_select_two | model.team2_select_three || model.team2_select_four || model.team1_select_one || model.team1_select_two | model.team1_select_three || model.team1_select_four))
        {
            [betting appendString:@"A"];
        }
        
        if (bettingType == 1 && i != CTFBTool.value_storages.count)
        {
            [betting appendString:@"#"];
        }
     }
    return betting;
}

@end

@implementation CTFBModel (private)


+ (NSInteger)_getRandomNumber:(int)from to:(int)to cacheDatas:(NSMutableArray *)cacheDatas
{
    NSInteger randomNum = (NSInteger)(from + (arc4random() % (to - from + 1)));
    if (cacheDatas && [cacheDatas containsObject:[NSNumber numberWithInteger:randomNum]])
    {
        return [self _getRandomNumber:from to:to cacheDatas:cacheDatas];
    }
    return randomNum;
}

@end
