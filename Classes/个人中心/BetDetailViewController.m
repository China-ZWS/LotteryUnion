//
//  BetDetailViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BetDetailViewController.h"
#import "NSString+ConvertDate.h"
#import "JCZQTableView.h"
#import "UIColor+Hex.h"
#import "NSString+NumberSplit.h"
#import "RTLabel.h"
#import "AddCollectionViewController.h"
#import "BetCartViewController.h"
#import "BetResult.h"

@interface BetDetailViewController () {
    UITableView *_tableView;
    NSString *_selecteNumber;
}

@end

@implementation BetDetailViewController

- (instancetype)initWithModel:(WinModel *)winModel {
    
    if (self = [super init]) {
        
        self.winModel = winModel;
        self.title = @"记录详情";
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        
        NSLog(@"%@ %@",self.winModel.lottery_name,self.winModel.lottery_pk);
        //        self.tabBarController.tabBar.hidden = YES;
    }
    return self;
}

//TODO:返回动作
- (void)back
{
    [SVProgressHUD dismiss];
    [_connection cancel];
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


#pragma  mark - 创建底部视图
//创建底部视图
- (void)_createBottomView {
    
    if (!([_winModel.lottery_pk isEqual:@"6"] || [self.winModel.lottery_pk isEqual:@"1"] || [self.winModel.lottery_pk isEqual:@"2"] || [self.winModel.lottery_pk isEqual:@"5"] || [self.winModel.lottery_pk isEqual:@"31"])) {
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


- (void)_createTableView {
    
    if ([self.winModel.lottery_pk isEqual:@"15"]) {     //竞彩足球
        
        JCZQTableView *JCZQtableView = [[JCZQTableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-74) style:UITableViewStyleGrouped betRecord:YES];
        JCZQtableView.showsVerticalScrollIndicator = NO;
        JCZQtableView.winModel = self.winModel;
        [self.view addSubview:JCZQtableView];
        NSLog(@"%@",self.winModel.lottery_pk);
        NSLog(@"%@",self.winModel);
    }else {                 //大乐透 七星彩  排列3  排列5   4场进球 胜负十四场 胜平负   半全场胜负   福建
       
        if ([self.winModel.lottery_pk intValue] == kType_CTZQ_SF14
            || [self.winModel.lottery_pk intValue] == kType_CTZQ_BQC6
            || [self.winModel.lottery_pk intValue] == kType_CTZQ_JQ4
            || [self.winModel.lottery_pk intValue] == lT225_lottery
            || [self.winModel.lottery_pk intValue] == lT317_lottery
            || [self.winModel.lottery_pk intValue] == lT367_lottery
            || [self.winModel.lottery_pk intValue] == kType_CTZQ_SF9) {
            
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-74) style:UITableViewStyleGrouped];
            
          //双色球 大乐透.......
        }else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-64-50-10) style:UITableViewStyleGrouped];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_tableView];
        
        NSLog(@"%@",self.winModel.prize_number);
        
    }
}


#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.winModel.prize_status isEqualToString:@"2"]) {    //中奖
        return 4;
    }else {
        return 3;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch ([self.winModel.lottery_pk intValue]) {
        case 6:{       //大乐透 双色球
            return [self numberOfDLT:section];
        }
        default:
            return [self numberOfQXC:section];
            break;
    }
}

#pragma mark - 设置个数
//大乐透的个数  双色球
- (NSInteger)numberOfDLT:(NSInteger)section {
    
    if ([self.winModel.prize_status isEqualToString:@"2"]) {   //中奖记录详情
        if (self.winModel.contributor_phone.length == 0) {   //未送彩票
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
                    return 3;
                }
                    break;
                default:
                    return 0;
                    break;
                    
            }
        }else {
            switch (section) {
                case 0: {
                    return 3;
                }
                    break;
                case 1: {
                    return 2;
                }
                    break;
                case 2: {
                    return 5;
                }
                    break;
                case 3: {
                    return 3;
                }
                    break;
                default:
                    return 0;
                    break;
                    
            }
        }
    }else {  //未中奖
        if (self.winModel.contributor_phone.length == 0) {   //未送彩票
            switch (section) {
                    
                case 0: {
                    return 6;
                }
                    break;
                case 1: {
                    return 4;
                }
                    break;
                default:
                    return 0;
                    break;
                    
            }
        }else {
            switch (section) {
                    
                case 0: {
                    return 3;
                }
                    break;
                case 1: {
                    return 6;
                }
                    break;
                case 2: {
                    return 4;
                }
                    break;
                default:
                    return 0;
                    break;
                    
            }
        }
        }
    
    
}

//七星彩个数
- (NSInteger)numberOfQXC:(NSInteger)section {
    
    if ([self.winModel.prize_status isEqualToString:@"2"]) {  //中奖记录详情
        if (self.winModel.contributor_phone.length == 0) {   //未送彩票
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
                    return 3;
                }
                    break;
                default:
                    return 0;
                    break;
                    
            }
        }else {     //送彩票
            switch (section) {
                case 0: {
                    return 3;
                }
                    break;
                case 1: {
                    return 2;
                }
                    break;
                case 2: {
                    return 5;
                }
                    break;
                case 3: {
                    return 3;
                }
                    break;
                default:
                    return 0;
                    break;
                    
            }
        }
    }else {  //未中奖
        if (self.winModel.contributor_phone.length == 0) {  //未送彩票
            switch (section) {
                case 0: {
                    return 5;
                }
                    break;
                case 1: {
                    return 4;
                }
                    break;
                default:
                    return 0;
                    break;
                    
            }
        }else {
            switch (section) {
                case 0: {
                    return 3;
                }
                case 1: {
                    return 5;
                }
                    break;
                case 2: {
                    return 4;
                }
                    break;
                default:
                    return 0;
                    break;
                    
            }
        }
    }
   
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_identify"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.winModel.lottery_pk isEqual:@"6" ] || [self.winModel.lottery_pk isEqual:@"31" ]) {     //大乐透 双色球
        
        if ([self.winModel.prize_status isEqualToString:@"2"]){
            [self DLTWDetail:indexPath cell:cell];
        }else {
            [self DLTDetail:indexPath cell:cell];
        }
        
    }else if([self.winModel.lottery_pk isEqual:@"2" ] || [self.winModel.lottery_pk isEqual:@"5" ] || [self.winModel.lottery_pk isEqual:@"1" ] ||  [self.winModel.lottery_pk isEqual:@"50" ] || [self.winModel.lottery_pk isEqual:@"51" ] || [self.winModel.lottery_pk isEqual:@"52" ]) {   //排列3 排列5  七星彩  + 福建
        
        if ([self.winModel.prize_status isEqualToString:@"2"]){
            [self PLTWDetail:indexPath cell:cell];
        }else {
            [self PLTDetail:indexPath cell:cell];
            NSLog(@"%@",self.winModel.lottery_code);
        }
        
    }else if([self.winModel.lottery_pk isEqual:@"3" ] || [self.winModel.lottery_pk isEqual:@"4" ] || [self.winModel.lottery_pk isEqual:@"8" ] || [self.winModel.lottery_pk isEqual:@"7" ] ) {   //胜负14场 任选9场  半全场胜负   四场进球
        
        if ([self.winModel.prize_status isEqualToString:@"2"]){
            [self OTHWDetail:indexPath cell:cell];
        }else {
            [self OTHDetail:indexPath cell:cell];
            NSLog(@"%@",self.winModel.lottery_code);
        }
    }
    
    return cell;
    
}


#pragma mark - 填充内容  大乐透 双色球
- (void)DLTWDetail:(NSIndexPath*)indexPath
              cell:(UITableViewCell *)cell{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.winModel.contributor_phone.length == 0) {
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
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.prize_number lot_pk:_winModel.lottery_pk];
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
                            label.text = [_winModel getWin:_winModel.formatedNumber isBet:YES];
                            label.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:label];
                        }else {
                            NSLog(@"%@",[self SSQNumber:_winModel.number]);
                            NSLog(@"self.winModel.prize_number = %@",self.winModel.prize_number);
                            RTLabel *label = [self makeRTLabel];
                            _selecteNumber = [self SSQNumber:_winModel.number];
                            label.text = [_winModel getWin:[self SSQNumber:_winModel.number] isBet:YES];
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 3: {
                        cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@ ",@" "];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 4: {
                        cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元",self.winModel.prize_money];
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
                            cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,self.winModel.money];
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
                            cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,self.winModel.money];
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
    }else {
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者号码:  %@ ", _winModel.contributor_phone];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者姓名:  %@ ",_winModel.contributor_name];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 2: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠言:  %@ ",_winModel.contributor_msg];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 1: {
                switch (row) {
                    case 0: {
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 80, cell.bounds.size.height)];
                        label.text = @"    开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor blackColor];
                        [cell addSubview:label];
                        
                        UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top+5, cell.width-label.width-10, label.height-10)];
                        [cell addSubview:bounsView];
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.prize_number lot_pk:_winModel.lottery_pk];
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
                            NSLog(@"self.winModel.prize_number = %@",self.winModel.prize_number);
                            RTLabel *label = [self makeRTLabel];
                            _selecteNumber = [self SSQNumber:_winModel.number];
                            label.text = [_winModel getWin:[self SSQNumber:_winModel.number] isBet:YES];
                            label.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:label];
                        }
                        
                    }break;
                    default:
                        break;
                }
            }
                break;
            case 2:{
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 3: {
                        cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@ ",@" "];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 4: {
                        cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元",self.winModel.prize_money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 3:{
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
                            cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,self.winModel.money];
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
                            cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,self.winModel.money];
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
   
}



- (void)DLTDetail:(NSIndexPath*)indexPath
        cell:(UITableViewCell *)cell{
                    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.winModel.contributor_phone.length == 0) {
        switch (section) {
            case 0: {
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 3: {
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 80, 30)];
                        textLabel.text =  @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        if ([self.winModel.lottery_pk isEqual:@"6"]) {
                            NSLog(@"大乐透：%@",self.winModel.number);
                            NSLog(@"%@",[self DLTNumber:_winModel.number]);
                            RTLabel *label = [self makeRTLabel];
                            _selecteNumber = _winModel.formatedNumber;
                            NSLog(@"%@",_winModel.formatedNumber);
//                            label.text = [self DLTNumber:_winModel.number];
                            label.text = [_winModel getWin:[self DLTNumber:_winModel.number] isBet:YES];
                            label.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:label];
                        }else {
                            NSLog(@"%@",[self SSQNumber:_winModel.number]);
                            RTLabel *label = [self makeRTLabel];
                            _selecteNumber = [self SSQNumber:_winModel.number];
                            label.text = [self SSQNumber:_winModel.number];
                            label.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:label];
                        }
                    }break;
                    case 4: {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 80, cell.bounds.size.height)];
                        label.text = @"    开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor blackColor];
                        [cell addSubview:label];
                        
                        UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top+5, cell.width-label.width, label.height)];
                        [cell addSubview:bounsView];
                        
                        NSLog(@"%@",_winModel.number);
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.prize_number lot_pk:_winModel.lottery_pk];
                        NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk );
                        
                    }break;
                    case 5: {
                        NSLog(@"sup = %@",self.winModel.sup);
                        cell.textLabel.text = [NSString stringWithFormat:@"追加:  %@ ",[self.winModel.sup isEqual:@"0"] ? @"不追加":@"追加"];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 1:{
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"注数:  %@ ", _winModel.amount];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
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
    }else {
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者号码:  %@ ", _winModel.contributor_phone];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者姓名:  %@ ",_winModel.contributor_name];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 2: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠言:  %@ ",_winModel.contributor_msg];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 1: {
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 3: {
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 80, 30)];
                        textLabel.text =  @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        if ([self.winModel.lottery_pk isEqual:@"6"]) {
                            NSLog(@"大乐透：%@",self.winModel.number);
                            NSLog(@"%@",[self DLTNumber:_winModel.number]);
                            RTLabel *label = [self makeRTLabel];
                            _selecteNumber = _winModel.formatedNumber;
                            NSLog(@"%@",_winModel.formatedNumber);
                            label.text = [self DLTNumber:_winModel.number];
                            label.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:label];
                        }else {
                            NSLog(@"%@",[self SSQNumber:_winModel.number]);
                            RTLabel *label = [self makeRTLabel];
                            _selecteNumber = [self SSQNumber:_winModel.number];
                            label.text = [self SSQNumber:_winModel.number];
                            label.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:label];
                        }
                    }break;
                    case 4: {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 80, cell.bounds.size.height)];
                        label.text = @"    开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor blackColor];
                        [cell addSubview:label];
                        
                        UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top+5, cell.width-label.width, label.height)];
                        [cell addSubview:bounsView];
                        
                        NSLog(@"%@",_winModel.number);
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.bonus_number lot_pk:_winModel.lottery_pk];
                        NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk );
                        
                    }break;
                    case 5: {
                        NSLog(@"sup = %@",self.winModel.sup);
                        cell.textLabel.text = [NSString stringWithFormat:@"追加:  %@ ",[self.winModel.sup isEqual:@"0"] ? @"不追加":@"追加"];
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
                        cell.textLabel.text = [NSString stringWithFormat:@"注数:  %@ ", _winModel.amount];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
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
    
   
 }



#pragma mark - 排列3 排列5 七彩星  + 福建
//排列3
- (void)PLTDetail:(NSIndexPath*)indexPath
             cell:(UITableViewCell *)cell{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.winModel.contributor_phone.length == 0) {
        switch (section) {
            case 0: {
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 3: {
                        
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
                        textLabel.text = @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        NSLog(@"%@",_winModel.formatedNumber);
                        RTLabel *label = [self makeRTLabel];
                        _selecteNumber = _winModel.formatedNumber;
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:YES];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        
                    }break;
                    case 4: {
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 70, cell.bounds.size.height)];
                        label.text = @"   开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor blackColor];
                        [cell addSubview:label];
                        
                        UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top+5, cell.width-label.width, label.height)];
                        [cell addSubview:bounsView];
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.prize_number lot_pk:_winModel.lottery_pk];
                        NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk);
                        
                    }break;
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case 1:{
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"注数:  %@ ", _winModel.amount];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
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
    }else {
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者号码:  %@ ", _winModel.contributor_phone];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者姓名:  %@ ",_winModel.contributor_name];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 2: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠言:  %@ ",_winModel.contributor_msg];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 1: {
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 3: {
                        
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
                        textLabel.text = @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        NSLog(@"%@",_winModel.formatedNumber);
                        RTLabel *label = [self makeRTLabel];
                        _selecteNumber = _winModel.formatedNumber;
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:YES];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        
                    }break;
                    case 4: {
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 70, cell.bounds.size.height)];
                        label.text = @"   开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor blackColor];
                        [cell addSubview:label];
                        
                        UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top+5, cell.width-label.width, label.height)];
                        [cell addSubview:bounsView];
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.bonus_number lot_pk:_winModel.lottery_pk];
                        NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk);
                        
                    }break;
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case 2:{
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"注数:  %@ ", _winModel.amount];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
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
    
   
}


- (void)PLTWDetail:(NSIndexPath*)indexPath
              cell:(UITableViewCell *)cell{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.winModel.contributor_phone.length == 0) {
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
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.prize_number lot_pk:_winModel.lottery_pk];
                        NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk);
                        
                    }break;
                    case 1: {
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
                        textLabel.text = @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        RTLabel *label = [self makeRTLabel];
                        _selecteNumber = _winModel.formatedNumber;
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:YES];
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 3: {
                        cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@ ",@" "];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 4: {
                        cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元 ",self.winModel.prize_money];
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
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,self.winModel.money];
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
    }else {
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者号码:  %@ ", _winModel.contributor_phone];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者姓名:  %@ ",_winModel.contributor_name];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 2: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠言:  %@ ",_winModel.contributor_msg];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 1: {
                switch (row) {
                    case 0: {
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 70, cell.bounds.size.height)];
                        label.text = @"   开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor blackColor];
                        [cell addSubview:label];
                        
                        UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right+6, label.top+5, cell.width-label.width, label.height)];
                        [cell addSubview:bounsView];
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.prize_number lot_pk:_winModel.lottery_pk];
                        NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk);
                        
                    }break;
                    case 1: {
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
                        textLabel.text = @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        RTLabel *label = [self makeRTLabel];
                        _selecteNumber = _winModel.formatedNumber;
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:YES];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 2:{
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 3: {
                        cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@ ",@" "];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 4: {
                        cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元 ",self.winModel.prize_money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 3:{
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,self.winModel.money];
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
    
}


#pragma mark - 胜负14场 任选9场  半全场胜负   四场进球
- (void)OTHDetail:(NSIndexPath*)indexPath
             cell:(UITableViewCell *)cell{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.winModel.contributor_phone.length == 0) {
        switch (section) {
            case 0: {
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:14];
                        
                    }break;
                    case 3: {
                        
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
                        textLabel.text = @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        NSLog(@"%@",[_winModel getWin:_winModel.formatedNumber isBet:YES]);
                        RTLabel *label = [self makeRTLabel];
                        _selecteNumber = _winModel.formatedNumber;
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:YES];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        
                    }break;
                    case 4: {
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 70, cell.bounds.size.height)];
                        label.text = @"   开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor blackColor];
                        [cell addSubview:label];
                        
                        UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top+5, cell.width-label.width, label.height)];
                        [cell addSubview:bounsView];
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.prize_number lot_pk:_winModel.lottery_pk];
                        NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk);
                        
                    }break;
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case 1:{
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"注数:  %@ ", _winModel.amount];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
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
    }else {
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者号码:  %@ ", _winModel.contributor_phone];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者姓名:  %@ ",_winModel.contributor_name];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 2: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠言:  %@ ",_winModel.contributor_msg];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 1: {
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:14];
                        
                    }break;
                    case 3: {
                        
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
                        textLabel.text = @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        NSLog(@"%@",[_winModel getWin:_winModel.formatedNumber isBet:YES]);
                        RTLabel *label = [self makeRTLabel];
                        _selecteNumber = _winModel.formatedNumber;
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:YES];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        
                    }break;
                    case 4: {
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 70, cell.bounds.size.height)];
                        label.text = @"   开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor blackColor];
                        [cell addSubview:label];
                        
                        UIView *bounsView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top+5, cell.width-label.width, label.height)];
                        [cell addSubview:bounsView];
                        
                        [_winModel makeBonusViewWithSuperView:bounsView bounsNumber:self.winModel.prize_number lot_pk:_winModel.lottery_pk];
                        NSLog(@"bean.lottery_pk%@",self.winModel.lottery_pk);
                        
                    }break;
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case 2:{
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"注数:  %@ ", _winModel.amount];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@ ",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
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
}


- (void)OTHWDetail:(NSIndexPath*)indexPath
              cell:(UITableViewCell *)cell{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.winModel.contributor_phone.length == 0) {
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
                        _selecteNumber = [_winModel getWin:_winModel.formatedNumber isBet:NO];
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
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
    }else {
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者号码:  %@ ", _winModel.contributor_phone];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者姓名:  %@ ",_winModel.contributor_name];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    case 2: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠言:  %@ ",_winModel.contributor_msg];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 1: {
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
                        _selecteNumber = [_winModel getWin:_winModel.formatedNumber isBet:NO];
                        label.text = [_winModel getWin:_winModel.formatedNumber isBet:NO];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 2:{
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
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
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
            case 3:{
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
    
}

//TODO:设置组头与组头之间的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}


#pragma mark - 大乐透选号转换
- (NSString *)DLTNumber:(NSString *)number {
    
    NSArray *dAry = [number componentsSeparatedByString:@"#"];
    NSMutableString *mStr2 = [NSMutableString string];
    if ([self.winModel.lottery_code intValue] == 524) {
        NSDictionary *aDict = [number splitDantuo];   //拆分胆拖
        [mStr2 appendFormat:@"前区胆 %@\n",[aDict objectForKey:@"qianqu_dan"]];
        [mStr2 appendFormat:@"前区拖 %@\n",[aDict objectForKey:@"qianqu_tuo"]];
        [mStr2 appendFormat:@"后区胆 %@\n",[aDict objectForKey:@"houqu_dan"]];
        [mStr2 appendFormat:@"后区拖 %@\n",[aDict objectForKey:@"houqu_tuo"]];
        NSLog(@"1 %@",mStr2);
        return mStr2;
    } else if ([self.winModel.lottery_code intValue] == 523) {    //复式
        [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:0] componentsSepartedByString:@" " length:2]];
        [mStr2 appendFormat:@"后区 %@\n",[[dAry objectAtIndex:1] componentsSepartedByString:@" " length:2]];
        return mStr2;
        NSLog(@"2 %@",mStr2);
    }else {   //单式
        if ([self.winModel.lottery_pk isEqual:@"6"]) {
            for (int i = 0; i < [dAry count]; i++) {
                NSString *subNumber = [dAry objectAtIndex:i];
                subNumber = [subNumber componentsSepartedByString:@" " length:2];
                NSLog(@"%@",subNumber);
                subNumber = [NSString stringWithFormat:@"%@+%@",[subNumber substringToIndex:14],[subNumber substringFromIndex:15]];
                NSLog(@"%@",subNumber);
                [mStr2 appendFormat:@"%@\n", subNumber];
                NSLog(@"3 %@",mStr2);
            }
            return mStr2;
        }else {
            for (int i = 0; i < [dAry count]; i++) {
                NSString *subNumber = [dAry objectAtIndex:i];
                subNumber = [subNumber componentsSepartedByString:@" " length:2];
                NSLog(@"%@",subNumber);
                
                subNumber = [NSString stringWithFormat:@"%@+%@",[subNumber substringToIndex:17],[subNumber substringFromIndex:18]];
                [mStr2 appendFormat:@"%@\n", subNumber];
                NSLog(@"3 %@",mStr2);
            }
            return mStr2;
        }
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
        [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:0] componentsSepartedByString:@" " length:2]];
        [mStr2 appendFormat:@"前区 %@\n",[[dAry objectAtIndex:1] componentsSepartedByString:@" " length:2]];
        return mStr2;
        NSLog(@"2 %@",mStr2);
        return mStr2;
    }
    return nil;
}


-(RTLabel*)makeRTLabel{
    RTLabel *label = [[RTLabel alloc] initWithFrame:
                      CGRectMake(80,7+3+2,mScreenWidth,850)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.lineSpacing = 0;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self.winModel.prize_status isEqualToString:@"2"]){
        if (self.winModel.contributor_phone.length == 0) {   //未送彩票
            if (indexPath.section == 0 && indexPath.row == 1) {
                if ([self.winModel.lottery_pk intValue] == lSSQ_lottery ) {     //双色球
                    
                    return [self SSQcalcFormatedNumberHeight];
                }else if ([self.winModel.lottery_pk intValue] == lDLT_lottery){   //大乐透
                    
                    
                    return [self DLTcalcFormatedNumberHeight];
                    
                }else {
                    return [self calcFormatedNumberHeight];
                }
            }
        }else {
            if (indexPath.section == 1 && indexPath.row == 1) {
                if ([self.winModel.lottery_pk intValue] == lSSQ_lottery ) {     //双色球
                    
                    return [self SSQcalcFormatedNumberHeight];
                }else if ([self.winModel.lottery_pk intValue] == lDLT_lottery){   //大乐透
                    
                    
                    return [self DLTcalcFormatedNumberHeight];
                    
                }else {
                    return [self calcFormatedNumberHeight];
                }
            }
        }
        
    }else {
        if (self.winModel.contributor_phone.length == 0) {    //未送彩票
            if (indexPath.section == 0 && indexPath.row == 3) {
                if ([self.winModel.lottery_pk intValue] == lDLT_lottery) {     //大乐透
                    
                    return [self DLTcalcFormatedNumberHeight];
                    
                }else if([self.winModel.lottery_pk intValue] == lSSQ_lottery){
                    
                    return [self SSQcalcFormatedNumberHeight];
                }else {
                    return [self calcFormatedNumberHeight];
                }
            }
        }else {
            if (indexPath.section == 1 && indexPath.row == 3) {
                if ([self.winModel.lottery_pk intValue] == lDLT_lottery) {     //大乐透
                    
                    return [self DLTcalcFormatedNumberHeight];
                    
                }else if([self.winModel.lottery_pk intValue] == lSSQ_lottery){
                    
                    return [self SSQcalcFormatedNumberHeight];
                }else {
                    return [self calcFormatedNumberHeight];
                }
            }
        }
    }
    
    return 45;
}



#pragma mark -   文本高度自适应（最低高度45）
// 文本高度自适应（最低高度45）
-(float)DLTcalcFormatedNumberHeight {
    NSString *numberDLT = [self DLTNumber:_winModel.number];
//    CGSize sizeToFit = [NSObject getSizeWithText:numberDLT font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(60, 800)];
    int hh = [numberDLT sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth,800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+10, 45);

}


-(float)calcFormatedNumberHeight {
    NSString *numberDLT = _winModel.formatedNumber;
    int hh = [numberDLT sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth,800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+20, 45);
}

-(float)SSQcalcFormatedNumberHeight {
    NSString *numberDLT = [self SSQNumber:_winModel.number];
    //    CGSize sizeToFit = [NSObject getSizeWithText:numberDLT font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(60, 800)];
    int hh = [numberDLT sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth,800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+10, 45);
    
}


#pragma mark - 按钮点击事件
//收藏
- (void)collectButton {
    
    self.hidesBottomBarWhenPushed = YES;
    NSString *lotteryName = [self getLotNames:_winModel.lottery_pk] ;
    [self.navigationController pushViewController:[[AddCollectionViewController alloc] initWithWinModel:self.winModel WithLotteryName:lotteryName WithSelectNumber:_selecteNumber] animated:YES];
    
    NSLog(@"......");
}

#pragma mark ----  以此号投注响应动作
- (void)betButtonAction:(UIButton *)button
{
    
    BetResult *result = [[BetResult alloc] init];
    result.numbers = _winModel.number;
    result.lot_pk = _winModel.lottery_pk;
    result.play_code = _winModel.lottery_code;
    result.zhushu = [_winModel.amount intValue];
    
    [BetCartViewController openBetCartWithBetResult:(BetResult *)result
                                         controller:self from:@"收藏夹"];
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








@end
