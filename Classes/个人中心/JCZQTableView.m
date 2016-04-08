//
//  JCZQTableView.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/10.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "JCZQTableView.h"
#import "NSString+ConvertDate.h"
#import "FootballLotteryManagers.h"
#import "BaseViewController.h"
#import "UIView+ViewController.h"
#import "FootBallQueryViewController.h"
#import "RTLabel.h"

@implementation JCZQTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style betRecord:(BOOL)isBet{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        _isBet = isBet;
        self.data = [NSMutableArray new];
        self.chuangData = [NSMutableArray new];
        self.hhData = [NSMutableArray new];
        
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style win:(BOOL)isWin betRecord:(BOOL)isBet{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        _isWin = isWin;
        _isBet = isBet;
        self.delegate = self;
        self.dataSource = self;
        self.data = [NSMutableArray new];
        self.chuangData = [NSMutableArray new];
        self.hhData = [NSMutableArray new];
        
    }
    
    return self;
}


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    if ([self.winModel.prize_status isEqualToString:@"2"] || _isWin == YES){    //中奖的竞彩足球
        if (self.winModel.contributor_phone.length == 0) {   //不是送彩票
            return 3;
        }else {
            return 4;
        }
    }else {  //未中奖
        if (self.winModel.contributor_phone.length == 0) {   //不是送彩票
            return 2;
        }else {
            return 3;
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     if ([self.winModel.prize_status isEqualToString:@"2"] || _isWin == YES){    //中奖的竞彩足球
         
         if (self.winModel.contributor_phone.length == 0) {   //不是送彩票
             switch (section) {
                 case 0:
                     return 2;
                     break;
                 case 1:
                     return 5;
                     break;
                 case 2:
                     return 3;
                     break;
                 default:
                     return 0;
                     break;
             }
         }else {
             switch (section) {
                 case 0:
                     return 3;
                     break;
                 case 1:
                     return 2;
                     break;
                 case 2:
                     return 5;
                     break;
                 case 3:
                     return 3;
                     break;
                 default:
                     return 0;
                     break;
         }
            
    }
     }else {
         
         if (self.winModel.contributor_phone.length == 0) {   //不是送彩票
             switch (section) {
                 case 0:
                     return 5;
                     break;
                 case 1:
                     return 4;
                     break;
                 default:
                     return 0;
                     break;
             }
         }else {
             switch (section) {
                 case 0:
                     return 3;
                     break;
                 case 1:
                     return 5;
                     break;
                 case 2:
                     return 4;
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
    if ([self.winModel.prize_status isEqualToString:@"2"] || _isWin == YES){    //竞彩足球中奖
        [self JCZQWDetail:indexPath cell:cell];
    }else {
        [self JCZQDetail:indexPath cell:cell];   //竞彩足球未中奖
    }
        return cell;
}


#pragma mark - 填充内容
//竞彩足球
- (void)JCZQDetail:(NSIndexPath*)indexPath
              cell:(UITableViewCell *)cell{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.winModel.contributor_phone.length == 0) {  //未送彩票
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"订单号:  %@ ", _winModel.record_pk];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",_winModel.lottery_name];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        NSString *lottery_code = _winModel.lottery_code;
                        if ([lottery_code isEqual:@"11"] || [lottery_code isEqual:@"12"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"胜平负"];
                        }else if ([lottery_code isEqual:@"21"] || [lottery_code isEqual:@"22"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"让球胜平负"];
                            
                        }else if ([lottery_code isEqual:@"31"] || [lottery_code isEqual:@"32"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"比分"];
                            
                        }else if ([lottery_code isEqual:@"41"] || [lottery_code isEqual:@"42"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"半全场"];
                            
                        }else if ([lottery_code isEqual:@"51"] || [lottery_code isEqual:@"52"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"进球数"];
                            
                        }else if ([lottery_code isEqual:@"61"] || [lottery_code isEqual:@"62"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"混合过关"];
                            
                        }
                        
                        
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
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 80, cell.bounds.size.height)];
                        label.text = @"    我的选号:";
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        //玩法
                        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5,15, 150, cell.bounds.size.height/5+3)];
                        detailLabel.text = [NSString stringWithFormat:@"玩法(%@)", [ProjectAPI transformNumber:self.winModel.lottery_code]];
                        detailLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:detailLabel];
                        
                        //串关
                        UILabel *chuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, detailLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                        chuanLabel.text = [NSString stringWithFormat:@"串关(%@)", [self.winModel chuangGuan:self.winModel.number]];
                        chuanLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:chuanLabel];
                        
                        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, chuanLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                        Label.text = @"选号";
                        Label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:Label];
                        
                        //数字
                        RTLabel *number = [self makeRTLabel];
                        number.text = [self transJCZQ];
                        number.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:number];
                    }break;
                    case 4: {
                        cell.textLabel.text = [NSString stringWithFormat:@"开奖号码:  %@ ",_winModel.prize_number];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 80, 30)];
                        [button setTitle:@"【开奖详情】" forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
                        [button setTintColor:[UIColor redColor]];
                        [cell addSubview:button];
                        
                    }break;
                    case 5: {
                        cell.textLabel.text = [NSString stringWithFormat:@"追加:  %@ ",_winModel.sup ? @"追加":@"不追加"];
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
    }else {  //送彩票
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者号码:  %@ ", _winModel.contributor_phone];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者姓名:  %@ ", _winModel.contributor_name];
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
                        cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",_winModel.lottery_name];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        NSString *lottery_code = _winModel.lottery_code;
                        if ([lottery_code isEqual:@"11"] || [lottery_code isEqual:@"12"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"胜平负"];
                        }else if ([lottery_code isEqual:@"21"] || [lottery_code isEqual:@"22"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"让球胜平负"];
                            
                        }else if ([lottery_code isEqual:@"31"] || [lottery_code isEqual:@"32"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"比分"];
                            
                        }else if ([lottery_code isEqual:@"41"] || [lottery_code isEqual:@"42"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"半全场"];
                            
                        }else if ([lottery_code isEqual:@"51"] || [lottery_code isEqual:@"52"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"进球数"];
                            
                        }else if ([lottery_code isEqual:@"61"] || [lottery_code isEqual:@"62"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",@"混合过关"];
                            
                        }
                        
                        
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
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 80, cell.bounds.size.height)];
                        label.text = @"    我的选号:";
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        //玩法
                        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5,15, 150, cell.bounds.size.height/5+3)];
                        detailLabel.text = [NSString stringWithFormat:@"玩法(%@)", [ProjectAPI transformNumber:self.winModel.lottery_code]];
                        detailLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:detailLabel];
                        
                        //串关
                        UILabel *chuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, detailLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                        chuanLabel.text = [NSString stringWithFormat:@"串关(%@)", [self.winModel chuangGuan:self.winModel.number]];
                        chuanLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:chuanLabel];
                        
                        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, chuanLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                        Label.text = @"选号";
                        Label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:Label];
                        
                        //数字
                        RTLabel *number = [self makeRTLabel];
                        number.text = [self transJCZQ];
                        number.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:number];
                    }break;
                    case 4: {
                        cell.textLabel.text = [NSString stringWithFormat:@"开奖号码:  %@ ",_winModel.prize_number];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 80, 30)];
                        [button setTitle:@"【开奖详情】" forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
                        [button setTintColor:[UIColor redColor]];
                        [cell addSubview:button];
                        
                    }break;
                    case 5: {
                        cell.textLabel.text = [NSString stringWithFormat:@"追加:  %@ ",_winModel.sup ? @"追加":@"不追加"];
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


//竞彩足球中奖
- (void)JCZQWDetail:(NSIndexPath*)indexPath
              cell:(UITableViewCell *)cell{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.winModel.contributor_phone.length == 0) {   //未送彩票
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 75, cell.bounds.size.height)];
                        label.text = @"    开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(label.right, label.top+10, 100, label.height-20)];
                        [button setTitle:@"【开奖详情】" forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
                        [button setTintColor:[UIColor redColor]];
                        [cell addSubview:button];
                        
                    }
                        break;
                    case 1: {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 80, cell.bounds.size.height)];
                        label.text = @"    我的选号:";
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        //玩法
                        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5,15, 150, cell.bounds.size.height/5+3)];
                        detailLabel.text = [NSString stringWithFormat:@"玩法(%@)", [ProjectAPI transformNumber:self.winModel.lottery_code]];
                        detailLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:detailLabel];
                        
                        //串关
                        UILabel *chuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, detailLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                        chuanLabel.text = [NSString stringWithFormat:@"串关(%@)", [self.winModel chuangGuan:self.winModel.number]];
                        chuanLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:chuanLabel];
                        
                        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, chuanLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                        Label.text = @"选号";
                        Label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:Label];
                        
                        //数字
                        RTLabel *number = [self makeRTLabel];
                        number.text = [self transJCZQ];
                        number.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:number];
                        
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 1:{
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"订单号:  %@ ", _winModel.record_pk];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                        if ([_winModel.lottery_pk isEqual:@"15"]) {
                            if ([_winModel.lottery_code isEqual:@"11"] || [_winModel.lottery_code isEqual:@"12"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"胜平负"];
                            }else if ([_winModel.lottery_code isEqual:@"21"] || [_winModel.lottery_code isEqual:@"22"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"让球胜平负"];
                            }else if ([_winModel.lottery_code isEqual:@"31"] || [_winModel.lottery_code isEqual:@"32"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"比分"];
                            }else if ([_winModel.lottery_code isEqual:@"41"] || [_winModel.lottery_code isEqual:@"42"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"半全场"];
                            }else if ([_winModel.lottery_code isEqual:@"51"] || [_winModel.lottery_code isEqual:@"52"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"进球数"];
                            }else if ([_winModel.lottery_code isEqual:@"61"] || [_winModel.lottery_code isEqual:@"62"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"混合过关"];
                            }
                        }else {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",_winModel.lottery_name];
                        }
                        
                        break;
                    case 2:
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
                        cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@",_isBet == NO ? _winModel.desc : @" "];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 4:
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元",_isBet == NO ? _winModel.money : _winModel.prize_money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case 2:
            {
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元",_isBet == NO ? _winModel.buy_money : _winModel.money];
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
    }else {   //送彩票
        switch (section) {
            case 0: {
                switch (row) {
                    case 0: {
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者号码:  %@ ", _winModel.contributor_phone];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    case 1: {
                        
                        cell.textLabel.text = [NSString stringWithFormat:@"赠送者姓名:  %@ ", _winModel.contributor_name];
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
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 75, cell.bounds.size.height)];
                        label.text = @"    开奖号码:";
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(label.right, label.top+10, 100, label.height-20)];
                        [button setTitle:@"【开奖详情】" forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
                        [button setTintColor:[UIColor redColor]];
                        [cell addSubview:button];
                        
                    }
                        break;
                    case 1: {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 80, cell.bounds.size.height)];
                        label.text = @"    我的选号:";
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        //玩法
                        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5,15, 150, cell.bounds.size.height/5+3)];
                        detailLabel.text = [NSString stringWithFormat:@"玩法(%@)", [ProjectAPI transformNumber:self.winModel.lottery_code]];
                        detailLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:detailLabel];
                        
                        //串关
                        UILabel *chuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, detailLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                        chuanLabel.text = [NSString stringWithFormat:@"串关(%@)", [self.winModel chuangGuan:self.winModel.number]];
                        chuanLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:chuanLabel];
                        
                        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, chuanLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                        Label.text = @"选号";
                        Label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:Label];
                        
                        //数字
                        RTLabel *number = [self makeRTLabel];
                        number.text = [self transJCZQ];
                        number.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:number];
                        
                        
                    }break;
                    default:
                        break;
                }
                
            }
                break;
            case 2:{
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"订单号:  %@ ", _winModel.record_pk];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 1:
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                        if ([_winModel.lottery_pk isEqual:@"15"]) {
                            if ([_winModel.lottery_code isEqual:@"11"] || [_winModel.lottery_code isEqual:@"12"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"胜平负"];
                            }else if ([_winModel.lottery_code isEqual:@"21"] || [_winModel.lottery_code isEqual:@"22"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"让球胜平负"];
                            }else if ([_winModel.lottery_code isEqual:@"31"] || [_winModel.lottery_code isEqual:@"32"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"比分"];
                            }else if ([_winModel.lottery_code isEqual:@"41"] || [_winModel.lottery_code isEqual:@"42"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"半全场"];
                            }else if ([_winModel.lottery_code isEqual:@"51"] || [_winModel.lottery_code isEqual:@"52"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"进球数"];
                            }else if ([_winModel.lottery_code isEqual:@"61"] || [_winModel.lottery_code isEqual:@"62"]) {
                                cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ", @"混合过关"];
                            }
                        }else {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",_winModel.lottery_name];
                        }
                        
                        break;
                    case 2:
                        if ([self.winModel.status isEqual:@"0"]) {          //投注中
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注中"];
                        }else if ([self.winModel.status isEqual:@"1"]) {     //投注成功
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注成功"];
                        }else if ([self.winModel.status isEqual:@"2"]) {   //投注失败
                            cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@" ,@"投注失败"];
                        }
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
                        cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@",_isBet == NO ? _winModel.desc : @" "];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 4:
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"奖金:  %@元",_isBet == NO ? _winModel.money : _winModel.prize_money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case 3:
            {
                switch (row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@",_winModel.multiple];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元",_isBet == NO ? _winModel.buy_money : _winModel.money];
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




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.winModel.prize_status isEqualToString:@"2"] || _isWin == YES) {   //中奖
        
        if (self.winModel.contributor_phone.length == 0) {  //未送彩票
            if (indexPath.section == 0 && indexPath.row == 1) {
                
                return [self calcFormatedNumberHeight];
            }
            
            return 40;
        }else {   //送彩票
            if (indexPath.section == 1 && indexPath.row == 1) {
                
                return [self calcFormatedNumberHeight];
            }
            
            return 40;
        }
    }else {   //未中奖
        
        if (self.winModel.contributor_phone.length == 0) {
            if (indexPath.section == 0 && indexPath.row == 3) {
                
                return [self calcFormatedNumberHeight];
            }
            
            return 40;
        }else {
            if (indexPath.section == 1 && indexPath.row == 3) {
                
                return [self calcFormatedNumberHeight];
            }
            
            return 40;
        }
    }
    
}

#pragma  mark - 按钮点击事件
//跳转到开奖详情
- (void)toDetail:(UIButton *)button {
    int lottery_code = [self.winModel.lottery_code intValue];
    if (lottery_code == kSFP_single || lottery_code == kSFP_compound) {   // 胜平负
        [self gotoFootballQuery:kSFP];
    }else if (lottery_code == kRQ_SFP_single || lottery_code == kRQ_SFP_compound) {   // 让球胜平负
        [self gotoFootballQuery:kRSFP];
    }else if (lottery_code == kScore_single || lottery_code == kScore_compound) {     // 比分
        [self gotoFootballQuery:kScore];
    }else if (lottery_code == kBQC_single || lottery_code == kBQC_compound) {     //半全场
        [self gotoFootballQuery:kBQC];
    }else if (lottery_code == kJQS_single || lottery_code == kJQS_compound) {    //进球数
        [self gotoFootballQuery:kJQS];
    }else if (lottery_code == KHHGG_single || lottery_code == kHHGG_compound) {    // 混合过关
        [self gotoFootballQuery:kSFP];
    }
}

#pragma mark - 竞彩足球
- (void)gotoFootballQuery:(FBPlayType)lotterytype
{
    FootBallQueryViewController *manager;
    if ([self.winModel.lottery_code intValue] == KHHGG_single || [self.winModel.lottery_code intValue] == kHHGG_compound) {  //混合过关
        manager = [[FootBallQueryViewController alloc] initWithPlayType:lotterytype match_no:hunheNumber];
    }else {  //其他
       manager = [[FootBallQueryViewController alloc] initWithPlayType:lotterytype match_no:stringnumber];
    }
    manager.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:manager animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


//竞彩足球号码处理
- (NSString *)transJCZQ {
    NSArray *numberData = [self transFormNumber:self.winModel.number];
    NSLog(@"%@",numberData);
    NSMutableString *mStrHH = [NSMutableString string];
    NSMutableString *mStr = [NSMutableString string];
    NSArray *selectNumber = [self.winModel transNumber:self.winModel.number lottery_code:self.winModel.lottery_code];
    for (int i = 0; i <selectNumber.count; i++)
    {
        if ([self.winModel.lottery_code intValue] == KHHGG_single || [self.winModel.lottery_code intValue] == kHHGG_compound) {
            hhNumber = [self HHGGResult:numberData[i]];
            NSString *hhString = [NSString stringWithFormat:@"%@: %@\n",hhNumber[i],selectNumber[i]];
            [mStrHH appendString:hhString];
        }else {
            NSString *string= [NSString stringWithFormat:@"%@: %@\n",numberData[i],selectNumber[i]];
            [mStr appendString:string];
        }
    }
    
   stringnumber = [numberData componentsJoinedByString:@"#"];
    NSLog(@"%@",stringnumber);
    
   hunheNumber = [hhNumber componentsJoinedByString:@"#"];
    NSLog(@"%@",hunheNumber);

    
    if ([self.winModel.lottery_code intValue] == KHHGG_single || [self.winModel.lottery_code intValue] == kHHGG_compound) {
        NSLog(@"%@",mStrHH);
        return mStrHH;
    }else {
        NSLog(@"%@",mStr);
        return mStr;
    }
    return nil;
}


-(RTLabel*)makeRTLabel{
    
    RTLabel *label = [[RTLabel alloc] initWithFrame:
                      CGRectMake(83,65,mScreenWidth-110,850)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.lineSpacing = 0;
    return label;
}

//混合过关
- (NSArray *)HHGGResult:(NSString *)result{
    
    NSArray *array = [result componentsSeparatedByString:@"@"];
    NSLog(@"%@ %@",result,array[1]);
    [self.hhData addObject:array[1]];
    return self.hhData;
}


-(float)calcFormatedNumberHeight {
    int hh = [NSObject getSizeWithText:[self transJCZQ] font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mScreenWidth-110, 850)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+100, 40);
}



@end
