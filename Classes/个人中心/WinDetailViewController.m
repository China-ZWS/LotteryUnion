//
//  WinDetailViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "WinDetailViewController.h"
#import "NSString+ConvertDate.h"
#import "ProjectAPI.h"
#import "AddCollectionViewController.h"
#import "RTLabel.h"
#import "JCZQTableView.h"
#import "NSString+NumberSplit.h"
#import "BetCartViewController.h"
#import "BetResult.h"

@interface WinDetailViewController () {
    UITableView *_tableView;
    NSString *_selecteNumber;

}

@end

@implementation WinDetailViewController


- (instancetype)initWithModel:(WinModel *)winModel {
    
    if (self = [super init]) {
        
        self.winModel = winModel;
        self.title = @"记录详情";
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        self.data = [NSMutableArray new];
        self.hhData = [NSMutableArray new];
    }
    return self;
}


//TODO:返回动作
- (void)back
{
    [_connection cancel];
    [SVProgressHUD dismiss];
    [self popViewController];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self _createTableView];
    [self _createBottomView];
}


- (void)_createTableView {
    
    if ([self.winModel.lottery_pk isEqual:@"15"])
    {     //竞彩足球
        
        JCZQTableView *JCZQtableView = [[JCZQTableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-74) style:UITableViewStyleGrouped win:YES betRecord:NO];
        JCZQtableView.isWin = YES;
        JCZQtableView.showsVerticalScrollIndicator = NO;
        JCZQtableView.winModel = self.winModel;
        [self.view addSubview:JCZQtableView];
        NSLog(@"%@",self.winModel.lottery_pk);
        NSLog(@"%@",self.winModel);
    }else {                 //大乐透 七星彩  排列3  排列5   4场进球 胜负十四场 胜平负   半全场胜负   福建
        
        //双色球 大乐透....
        if ([_winModel.lottery_pk isEqual:@"6"]
            || [self.winModel.lottery_pk isEqual:@"1"]
            || [self.winModel.lottery_pk isEqual:@"2"]
            || [self.winModel.lottery_pk isEqual:@"5"]
            || [self.winModel.lottery_pk isEqual:@"31"]){
            
            NSLog(@"self.winModel.lottery_pk = %@",self.winModel.lottery_pk);
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-64-50-10) style:UITableViewStyleGrouped];
            
        }else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-74) style:UITableViewStyleGrouped];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_tableView];
        
        NSLog(@"%@",self.winModel.prize_number);
        
    }
}

#pragma  mark - 创建底部视图
//创建底部视图
- (void)_createBottomView {
    
    if (!([_winModel.lottery_pk isEqual:@"6"]
          || [self.winModel.lottery_pk isEqual:@"1"]
          || [self.winModel.lottery_pk isEqual:@"2"]
          || [self.winModel.lottery_pk isEqual:@"5"]
          || [self.winModel.lottery_pk isEqual:@"31"]
          ) ) {
        return;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,mScreenHeight-65-50, mScreenWidth, 50)];
    NSLog(@"%f",_tableView.bottom);
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomView];
    
    //投注
    UIButton *betButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (bottomView.height-30)/2, (mScreenWidth-60)/2, 30)];
    betButton.backgroundColor = RGBA(197, 42, 37, 1);
    [betButton setTitle:@"以此号投注" forState:UIControlStateNormal];
    [betButton addTarget:self action:@selector(betButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:betButton];
    
    //收藏
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(20+20+betButton.width, (bottomView.height-30)/2, (mScreenWidth-60)/2, 30)];
    collectButton.backgroundColor = RGBA(66, 115, 248, 1);
    [collectButton addTarget:self action:@selector(collectButton) forControlEvents:UIControlEventTouchUpInside];
    [collectButton setTitle:@"收藏选号" forState:UIControlStateNormal];
    [bottomView addSubview:collectButton];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: {
            return 2;
        }
            break;
        case 1: {
            return 5;
        }
            break;
        case 2: {
            
            if ([self.winModel.lottery_pk intValue] == lDLT_lottery) {
                return 4;
            }else {
                return 3;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_identify"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.winModel.lottery_pk isEqual:@"6" ] || [self.winModel.lottery_pk isEqual:@"31" ]) {     //大乐透 双色球
       [self DLTWDetail:indexPath cell:cell];
     
        
    }else if([self.winModel.lottery_pk isEqual:@"2" ] || [self.winModel.lottery_pk isEqual:@"5" ] || [self.winModel.lottery_pk isEqual:@"1" ] ||  [self.winModel.lottery_pk isEqual:@"50" ] || [self.winModel.lottery_pk isEqual:@"51" ] || [self.winModel.lottery_pk isEqual:@"52" ]) {   //排列3 排列5  七星彩  + 福建

       [self PLTWDetail:indexPath cell:cell];
     
        
    }else if([self.winModel.lottery_pk isEqual:@"3" ] || [self.winModel.lottery_pk isEqual:@"4" ] || [self.winModel.lottery_pk isEqual:@"8" ] || [self.winModel.lottery_pk isEqual:@"7" ] ) {   //胜负14场 任选9场  半全场胜负   四场进球
 
            [self OTHWDetail:indexPath cell:cell];
       
        
    }
    return cell;
    
}

//TODO:设置组头与组头之间的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    if (indexPath.section == 0 && indexPath.row == 1) {
        if ([self.winModel.lottery_pk intValue] == kType_JCZQ) {
            return (3+self.data.count)*20;
        }else if([self.winModel.lottery_pk intValue] == lSSQ_lottery) {
            return [self SSQcalcFormatedNumberHeight];
        }else {
            return [self calcFormatedNumberHeight];
        }
    }else {
        return 45;
    }

}




-(RTLabel*)makeRTLabel{
    RTLabel *label = [[RTLabel alloc] initWithFrame:
                      CGRectMake(85,7+5,mScreenWidth-80-30-20,850)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.lineSpacing = 0;
    return label;
}



//号码处理
- (NSArray *)transFormNumber:(NSString *)number {
    
    int lottery_code = [self.winModel.lottery_code intValue];
    if (lottery_code == kSFP_single
        || lottery_code == kRQ_SFP_single
        || lottery_code == kScore_single
        || lottery_code == kBQC_single
        || lottery_code == kJQS_single
        || lottery_code == KHHGG_single) {
        NSLog(@"%@",number);
        NSArray *array = [number componentsSeparatedByString:@"#"]; //从字符A中分隔成2个元素的数组     #前面的为串关
        NSLog(@"array11 = %@",array);
        NSString *btstring = array[1];
        NSLog(@"array22 = %@",btstring);
        array = [btstring componentsSeparatedByString:@"^"]; //从字符A中分隔成2个元素的数组
        NSLog(@"array33 = %@",array);
        for (NSString *ctstring in array)
        {
            array = [ctstring componentsSeparatedByString:@"$"]; //从字符A中分隔成2个元素的数组
            NSLog(@"array[0] = %@",array[0]);
            
            [self.data addObject:array[0]];
        }
        
        NSLog(@"44 = %@",self.data);
        return self.data;
    }else {
        NSLog(@"%@",number);
        NSRange range = [number rangeOfString:@"#"];
        NSLog(@"range.length = %ld range.location = %ld",range.length,range.location);
        NSString *string = [number substringFromIndex:range.location+1];
        NSLog(@"string = %@",string);
        NSArray *array = [string componentsSeparatedByString:@"^"];
        NSLog(@"array = %@",array);
        for (NSString *ctstring in array) {
            array = [ctstring componentsSeparatedByString:@"$"];
            NSLog(@"array = %@",array[0]);
            [self.data addObject:array[0]];    //0-->放的是号码  1--》放的后面结果
        }
        return self.data;
    }
}




//混合过关
- (NSArray *)HHGGResult:(NSString *)result{
    
    NSArray *array = [result componentsSeparatedByString:@"@"];
    NSLog(@"%@ %@",result,array[1]);
    [self.hhData addObject:array[1]];
    return self.hhData;
}


#pragma mark - 填充内容  大乐透 双色球
- (void)DLTWDetail:(NSIndexPath*)indexPath
              cell:(UITableViewCell *)cell{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0: {
            switch (row) {
                case 0: {
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 80, cell.bounds.size.height)];
                    label.text = @"    开奖号码:";
                    label.font = [UIFont systemFontOfSize:13];
                    label.textColor = [UIColor blackColor];
                    [cell addSubview:label];
                    
                    UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top+5, cell.width-label.width-10, label.height-10)];
                    [cell addSubview:bounsView];
                    
                    [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.bonus_number lot_pk:_winModel.lottery_pk];
                    NSLog(@"bean.lottery_pk%@  self.winModel.prize_number= %@",self.winModel.lottery_pk,self.winModel.prize_number);
                    
                }break;
                case 1: {
                    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 80, 30)];
                    textLabel.text = @"我的选号：";
                    textLabel.font = [UIFont systemFontOfSize:13];
                    [cell addSubview:textLabel];
                    if ([self.winModel.lottery_pk isEqual:@"6"]) {
                        RTLabel *label = [self makeRTLabel];
                        _selecteNumber = _winModel.formatedNumber;
                        NSLog(@"%@",_winModel.formatedNumber);
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:NO];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                    }else {
                        NSLog(@"%@",[self SSQNumber:_winModel.number]);
                        NSLog(@"%@",self.winModel.bonus_number);
                        RTLabel *label = [self makeRTLabel];
                        _selecteNumber = [self SSQNumber:_winModel.number];
                        label.text = [_winModel getWin:[self SSQNumber:_winModel.number] isBet:NO];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                    }
                    
                }break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            switch (row) {
                case 0: {
                    cell.textLabel.text = [NSString stringWithFormat:@"订单号:  %@ ", _winModel.record_pk];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                }
                    break;
                case 1: {
                    cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ",_winModel.lottery_name,_winModel.period];
                    
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 2: {
                     cell.textLabel.text = [NSString stringWithFormat:@"状态:   %@",self.winModel.status? @"已派奖" : @"未派奖"];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 3: {
                    cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@ ",_winModel.desc];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 4: {
                    cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元",self.winModel.money];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                default:
                    break;
            }
            
        }
            break;
        case 2:{
            if ([self.winModel.lottery_pk  intValue] == lDLT_lottery) {
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"追加:  %@" ,_winModel.sup == 0 ? @"不追加":@"追加"];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.buy_money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
                        cell.textLabel.text = [NSString stringWithFormat:@"时间:  %@",[_winModel.create_time toFormatDateString]];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    default:
                        break;
                }
            }else {
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.buy_money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"时间:  %@",[_winModel.create_time toFormatDateString]];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    default:
                        break;
                }
            }
            
        }
            break;
            
        default:
            break;
    }
}


//双色球
- (NSString *)SSQNumber:(NSString *)number {
    NSArray *dAry = [number componentsSeparatedByString:@"#"];
    NSMutableString *mStr2 = [NSMutableString string];
    if ([self.winModel.lottery_code intValue] == pSSQ_Dantuo) {
        NSDictionary *aDict = [number splitDantuoS];   //拆分胆拖
        [mStr2 appendFormat:@"前区胆 %@\n",[aDict objectForKey:@"qianqu_dan"]];
        [mStr2 appendFormat:@"前区拖 %@\n",[aDict objectForKey:@"qianqu_tuo"]];
        [mStr2 appendFormat:@"后区    %@\n",[aDict objectForKey:@"houqu_dan"]];
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
        [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:0] componentsSepartedByString:@" " length:2]];
        [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:1] componentsSepartedByString:@" " length:2]];
        return mStr2;
        NSLog(@"2 %@",mStr2);
        return mStr2;
    }
    return nil;
}

//数字彩
#pragma mark - 数字彩
- (void)PLTWDetail:(NSIndexPath*)indexPath
              cell:(UITableViewCell *)cell{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0: {
            switch (row) {
                case 0: {
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 70, cell.bounds.size.height)];
                    label.text = @"   开奖号码:";
                    label.font = [UIFont systemFontOfSize:13];
                    label.textColor = [UIColor blackColor];
                    [cell addSubview:label];
                    
                    UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right+6, label.top+5, cell.width-label.width, label.height)];
                    [cell addSubview:bounsView];
                    
                    [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.bonus_number lot_pk:_winModel.lottery_pk];
                    NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk);
                    
                }break;
                case 1: {
                    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
                    textLabel.text = @"我的选号：";
                    textLabel.font = [UIFont systemFontOfSize:13];
                    [cell addSubview:textLabel];
                    
                    RTLabel *label = [self makeRTLabel];
                    _selecteNumber = _winModel.formatedNumber;
                    if ([self.winModel.lottery_pk intValue] == lSSQ_lottery) {
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:YES];
                    }else {
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:NO];
                    }
                    label.font = [UIFont systemFontOfSize:13];
                    [cell addSubview:label];
                    
                }break;
                default:
                    break;
            }
            
        }
            break;
        case 1:{
            switch (row) {
                case 0: {
                    cell.textLabel.text = [NSString stringWithFormat:@"订单号:  %@ ", _winModel.record_pk];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                }
                    break;
                case 1: {
                    cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ",_winModel.lottery_name,self.winModel.period];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 2: {
                    cell.textLabel.text = [NSString stringWithFormat:@"状态:   %@",self.winModel.status? @"已派奖" : @"未派奖"];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 3: {
                    cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@ ",_winModel.desc];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 4: {
                    cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元 ",self.winModel.money];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                default:
                    break;
            }
            
        }
            break;
        case 2:{
            switch (row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,self.winModel.buy_money];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"时间:  %@",[_winModel.create_time toFormatDateString]];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 足彩
- (void)OTHWDetail:(NSIndexPath*)indexPath
              cell:(UITableViewCell *)cell{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0: {
            switch (row) {
                case 0: {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 70, cell.bounds.size.height)];
                    label.text = @"   开奖号码:";
                    label.font = [UIFont systemFontOfSize:13];
                    label.textColor = [UIColor blackColor];
                    [cell addSubview:label];
                    
                    UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right+4, label.top+5, cell.width-label.width, label.height)];
                    [cell addSubview:bounsView];
                    
                    [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.bonus_number lot_pk:_winModel.lottery_pk];
                    
                }break;
                case 1: {
                    
                    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
                    textLabel.text = @"我的选号：";
                    textLabel.font = [UIFont systemFontOfSize:13];
                    [cell addSubview:textLabel];
                    
                    NSLog(@"%@",[_winModel getWin:_winModel.formatedNumber isBet:YES]);
                    RTLabel *label = [self makeRTLabel];
                    _selecteNumber = _winModel.formatedNumber;
                    label.text = [_winModel getWin:_winModel.formatedNumber isBet:NO];
                    label.font = [UIFont systemFontOfSize:13];
                    [cell addSubview:label];
                    
                }break;
                default:
                    break;
            }
            
        }
            break;
        case 1:{
            switch (row) {
                case 0: {
                    cell.textLabel.text = [NSString stringWithFormat:@"订单号:  %@ ", _winModel.record_pk];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                }
                    break;
                case 1: {
                    cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ",_winModel.lottery_name,self.winModel.period];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 2: {
                    if ([_winModel.money intValue]>= 10000) {
                        cell.textLabel.text = [NSString stringWithFormat:@"状态:   %@",self.winModel.status? @"体彩中心领奖" : @"未派奖"];
                    }else {
                        cell.textLabel.text = [NSString stringWithFormat:@"状态:   %@",self.winModel.status? @"已派奖" : @"未派奖"];
                    }
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 3: {
                    cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@ ",_winModel.desc];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                case 4: {
                    cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元",self.winModel.money];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }break;
                default:
                    break;
            }
            
        }
            break;
        case 2:{
            switch (row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,self.winModel.buy_money];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"时间:  %@",[_winModel.create_time toFormatDateString]];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - 按钮点击事件
//收藏
- (void)collectButton {
    
    self.hidesBottomBarWhenPushed = YES;
    NSString *lotteryName = [self getLotNames:_winModel.lottery_pk] ;
    
    [self.navigationController pushViewController:[[AddCollectionViewController alloc] initWithWinModel:self.winModel WithLotteryName:lotteryName WithSelectNumber:_selecteNumber] animated:YES];
    
    NSLog(@"......");
}


- (void)betButtonAction:(UIButton *)button
{
    
    BetResult *result = [[BetResult alloc] init];
    result.numbers = _winModel.number;
    result.lot_pk = _winModel.lottery_pk;
    result.play_code = _winModel.lottery_code;
    result.zhushu = [_winModel.amount intValue];
    
    [BetCartViewController openBetCartWithBetResult:(BetResult *)result
                                         controller:self from:@"中奖记录"];
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


-(float)calcFormatedNumberHeight {
    NSString *numberDLT = [_winModel getWin:_winModel.formatedNumber isBet:YES];
    int hh = [numberDLT sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth,800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+20, 45);
    
}


-(float)SSQcalcFormatedNumberHeight {
    NSString *numberDLT = [self SSQNumber:_winModel.number];
    int hh = [numberDLT sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth,800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+10, 45);
    
}

@end
