//
//  CatchNumberDetailViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/4.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CatchNumberDetailViewController.h"
#import "NSString+ConvertDate.h"
#import "AddCollectionViewController.h"
#import "RTLabel.h"
#import "NSString+NumberSplit.h"
#import "Util.h"
#import "BetCartViewController.h"
#import "BetResult.h"

@interface CatchNumberDetailViewController () {
    UITableView *_tableView;
    NSString *_selectNumber;
    
}

@end

@implementation CatchNumberDetailViewController


- (instancetype)initWithWinModel:(WinModel *)winModel{
    if (self = [super init]) {
        self.winModel = winModel;
        self.title = @"记录详情";
        self.data = [NSMutableArray new];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        self.hhData = [NSMutableArray new];
        self.number = [NSMutableArray new];
    }
    
    return self;
}


//TODO:返回动作
- (void)back
{
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
//    [self doCancel];
  
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (isLTLottery([self.winModel.lottery_pk intValue]) || isDFLottery([self.winModel.lottery_pk intValue])) {
          _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-64-50-10-5) style:UITableViewStyleGrouped];
    }else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-64-10-10) style:UITableViewStyleGrouped];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [self _createBottomView];
}

//创建底部视图
- (void)_createBottomView {
    
    NSLog(@"%@",_winModel.lottery_pk);
   
        //未结束
        if ([_winModel.follow_status intValue] == 0) {
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,mScreenHeight-65-50-10, mScreenWidth, 60)];
            bottomView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bottomView];
            if (isLTLottery([self.winModel.lottery_pk intValue])) {   //乐透
                //机选投注
                if ([_winModel.number isEqual:@""]) {
                    [self oneButton:bottomView];
                    
                    //当前号码追号
                }else {
                    [self threeButton:bottomView];
                }
            }else if (isDFLottery([self.winModel.lottery_pk intValue])) {         //地方彩
                [self oneButton:bottomView];
                
            }else {
                 bottomView.hidden = YES;
                _tableView.height = mScreenHeight-64-10;
            }
            
            //已取消  及其他状态
        }else {
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,mScreenHeight-65-50-10, mScreenWidth, 50+10)];
            bottomView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bottomView];
            if (isLTLottery([self.winModel.lottery_pk intValue])) {   //乐透
                
                //机选投注
                if ([_winModel.number isEqual:@""]) {
            
                    bottomView.hidden = YES;
                    _tableView.height = mScreenHeight-64-10;
                }else {
                     //当前号码追号
                    [self twoButton:bottomView];
                }
            }else if (isDFLottery([self.winModel.lottery_pk intValue])) {   //地方彩
                bottomView.hidden = YES;
                _tableView.height = mScreenHeight-64-10;
            }
            else {
                bottomView.hidden = YES;
            }
        }
        return;
    
}


//3个按钮
- (void)threeButton:(UIView *)bottomView {
    
    //取消追号
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (bottomView.height-30)/3-2, (mScreenWidth-60)/3, 35)];
    cancelButton.backgroundColor = RGBA(197, 42, 37, 1);
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitle:@"取消追号" forState:UIControlStateNormal];
    [bottomView addSubview:cancelButton];
    
    //投注
    UIButton *betButton = [[UIButton alloc] initWithFrame:CGRectMake(20+cancelButton.width+10, (bottomView.height-30)/3-2, (mScreenWidth-60)/3, 35)];
    betButton.backgroundColor = RGBA(197, 42, 37, 1);
    betButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [betButton setTitle:@"以此号投注" forState:UIControlStateNormal];
    [betButton addTarget:self action:@selector(betButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:betButton];
    
    //收藏
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(20+20+betButton.width*2, (bottomView.height-30)/3-2, (mScreenWidth-60)/3, 35)];
    collectButton.backgroundColor = RGBA(66, 115, 248, 1);
    [collectButton addTarget:self action:@selector(collectButton) forControlEvents:UIControlEventTouchUpInside];
    collectButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [collectButton setTitle:@"收藏选号" forState:UIControlStateNormal];
    [bottomView addSubview:collectButton];
}


- (void)twoButton:(UIView *)bottomView {
    
    //投注
    UIButton *betButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (bottomView.height-30)/2-2, (mScreenWidth-60)/2, 35)];
    betButton.backgroundColor = RGBA(197, 42, 37, 1);
    [betButton setTitle:@"以此号投注" forState:UIControlStateNormal];
    [betButton addTarget:self action:@selector(betButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:betButton];
    
    //收藏
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(20+20+betButton.width, (bottomView.height-30)/2-2, (mScreenWidth-60)/2, 35)];
    collectButton.backgroundColor = RGBA(66, 115, 248, 1);
    [collectButton addTarget:self action:@selector(collectButton) forControlEvents:UIControlEventTouchUpInside];
    [collectButton setTitle:@"收藏选号" forState:UIControlStateNormal];
    [bottomView addSubview:collectButton];
}

- (void)oneButton:(UIView *)bottomView {
    
    //取消追号
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (bottomView.height-30)/3+2, (mScreenWidth-40), 35)];
    cancelButton.backgroundColor = RGBA(197, 42, 37, 1);
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitle:@"取消追号" forState:UIControlStateNormal];
    [bottomView addSubview:cancelButton];
    
}


#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: {
            return 3;
        }
            break;
        case 1: {
            
            if ([_winModel.lottery_pk isEqual:@"6"]) {
                return 11;
            }else {
                
                return 10;
            }
            
            return 9;
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    switch (section) {
        case 0: {
            switch (row) {
                case 0: {
                    cell.textLabel.text = [NSString stringWithFormat:@"订单号:  %@ ", _winModel.record_pk];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    
                }
                    break;
                case 1: {
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
                        cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@ ",[self getLotNames:_winModel.lottery_pk]];
                    }
                    
                }break;
                case 2: {
                   
                    if (self.winModel.number.length == 0) {
                        cell.textLabel.text = @"我的选号：机选投注";
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        
                    }else {
                      if ([self.winModel.lottery_pk intValue] == kType_JCZQ) {  //竞彩足球
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
                          
                          //选号
                          UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, chuanLabel.bottom+4, 150, cell.bounds.size.height/5+3)];
                          Label.text = @"选号";
                          Label.font = [UIFont systemFontOfSize:13];
                          [cell addSubview:Label];
                          
                          //数字
                          RTLabel *number = [self makeJCRTLabel];
                          number.text = [self transJCZQ];
                          number.font = [UIFont systemFontOfSize:13];
                          [cell addSubview:number];
                
                            
                        }else if ([self.winModel.lottery_pk intValue] == lSSQ_lottery) {    //双色球
                            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 80, 30)];
                            textLabel.text = @"我的选号：";
                            textLabel.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:textLabel];
                            
                            RTLabel *label = [self makeRTLabel];
                            _selectNumber = [self SSQNumber:_winModel.number];
                            label.text = [self SSQNumber:_winModel.number];
                            label.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:label];
                            
                        }else {
                            
                            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 80, 30)];
                            textLabel.text = @"我的选号：";
                            textLabel.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:textLabel];
                            
                            RTLabel *label = [self makeRTLabel];
                            _selectNumber = _winModel.formatedNumber;
                            label.text = _winModel.formatedNumber;
                            label.font = [UIFont systemFontOfSize:13];
                            [cell addSubview:label];
                            
                        }
                    }
 
                }break;
                default:
                    break;
            }
            
        }
            break;

                
            case 1:{
                
                if ([_winModel.lottery_pk isEqual:@"6"]) {       //10行
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
                        cell.textLabel.text = [NSString stringWithFormat:@"追号时间:  %@" ,[_winModel.follow_time toFormatDateString]];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 3:
                        cell.textLabel.text = [NSString stringWithFormat:@"追加:  %@ ",[self.winModel.sup isEqual:@"0"] ? @"不追加":@"追加"];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 4:
                        cell.textLabel.text = [NSString stringWithFormat:@"追号期数:  %@",[_winModel.follow_num isEqualToString:@"-1"]?@"无限期":_winModel.follow_num];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 5:
                        cell.textLabel.text = [NSString stringWithFormat:@"完成期数:  %@",_winModel.finish_num];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 6:
                        cell.textLabel.text = [NSString stringWithFormat:@"剩余期数:  %d",([_winModel.follow_num intValue]-[_winModel.finish_num intValue])];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 7:
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        switch ([_winModel.follow_status intValue]) {
                            case 0:
                                cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"未结束"];
                                break;
                            case 1:
                                cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"已结束"];
                                break;
                            case -1:
                                cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"已取消"];
                                break;
                            case 2:
                                cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"中奖结束"];
                                break;
                        }
                        break;
                    case 8:
                        cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@",_winModel.money];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        if (_winModel.sup) {
                            int s = [_winModel.sup intValue];
                            if (s == 0) {    //追加
                                int money = [_winModel.amount intValue] * 2 * [_winModel.multiple intValue];
                                cell.textLabel.text = [NSString stringWithFormat:@"金额:  %d元",money];
                            } else {       //不追加
                                int money = [_winModel.amount intValue] * 3 * [_winModel.multiple intValue];
                                cell.textLabel.text = [NSString stringWithFormat:@"金额:  %d元",money];
                            }
                        } else {
                            
                            int money = [_winModel.amount intValue] * 2 * [_winModel.multiple intValue];
                            cell.textLabel.text = [NSString stringWithFormat:@"金额:  %d元",money];
                        }
                        break;
                    case 9:
                        cell.textLabel.text = [NSString stringWithFormat:@"追号类型:  %@",[_winModel.follow_type intValue]==0?@"当前号码追号":@"机选追号"];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    case 10:
                        cell.textLabel.text = [NSString stringWithFormat:@"中奖继续追号:  %@",[_winModel.follow_prize intValue]==0?@"是":@"否"];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        break;
                    default:
                        break;
                }

              }else {               //9行
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
                          cell.textLabel.text = [NSString stringWithFormat:@"追号时间:  %@" ,[_winModel.follow_time toFormatDateString]];
                          cell.textLabel.font = [UIFont systemFontOfSize:13];
                          break;
                      case 3:{
                          NSString *text = [NSString stringWithFormat:@"%@期",[_winModel.follow_num isEqualToString:@"-1"]?@"无限":_winModel.follow_num];
                          cell.textLabel.text = [NSString stringWithFormat:@"追号期数:  %@",text];
                          cell.textLabel.font = [UIFont systemFontOfSize:13];
                      }
                          break;
                      case 4:
                          cell.textLabel.text = [NSString stringWithFormat:@"完成期数:  %@",_winModel.finish_num];
                          cell.textLabel.font = [UIFont systemFontOfSize:13];
                          break;
                      case 5: {
                          if ([_winModel.follow_num intValue]-[_winModel.finish_num intValue]==-1) {
                              cell.textLabel.text = [NSString stringWithFormat:@"剩余期数:  %@",@"无限期"];
                          }else if ([_winModel.follow_num intValue] == -1) {
                              cell.textLabel.text = [NSString stringWithFormat:@"剩余期数:  %@",@"无限期"];
                          }else {
                              NSString *text  = [_winModel.follow_num intValue] == -1 ?@"无限期":[NSString stringWithFormat:@"%d期",[_winModel.follow_num intValue]-[_winModel.finish_num intValue]];
                              cell.textLabel.text = [NSString stringWithFormat:@"追号期数:  %@",text];
                          }
                          cell.textLabel.font = [UIFont systemFontOfSize:13];
                          cell.textLabel.font = [UIFont systemFontOfSize:13];
                      }
                          
                          break;
                      case 6:
                          cell.textLabel.font = [UIFont systemFontOfSize:13];
                          switch ([_winModel.follow_status intValue]) {
                              case 0:
                                  cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"未结束"];
                                  break;
                              case 1:
                                  cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"已结束"];
                                  break;
                              case -1:
                                  cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"已取消"];
                                  break;
                              case 2:
                                  cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"中奖结束"];
                                  break;
                          }
                          break;
                      case 7:
                          cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@",_winModel.money];
                          cell.textLabel.font = [UIFont systemFontOfSize:13];
                          if (_winModel.sup) {
                              int s = [_winModel.sup intValue];
                              if (s == 0) {    //追加
                                  int money = [_winModel.amount intValue] * 2 * [_winModel.multiple intValue];
                                  cell.textLabel.text = [NSString stringWithFormat:@"金额:  %d元",money];
                              } else {       //不追加
                                  int money = [_winModel.amount intValue] * 3 * [_winModel.multiple intValue];
                                  cell.textLabel.text = [NSString stringWithFormat:@"金额:  %d元",money];
                              }
                          } else {
                              
                              int money = [_winModel.amount intValue] * 2 * [_winModel.multiple intValue];
                              cell.textLabel.text = [NSString stringWithFormat:@"金额:  %d元",money];
                          }
                          break;
                      case 8:
                          cell.textLabel.text = [NSString stringWithFormat:@"追号类型:  %@",[_winModel.follow_type intValue]==0?@"当前号码追号":@"机选追号"];
                          cell.textLabel.font = [UIFont systemFontOfSize:13];
                          break;
                      case 9:
                          cell.textLabel.text = [NSString stringWithFormat:@"中奖继续追号:  %@",[_winModel.follow_prize intValue]==0?@"是":@"否"];
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
    return cell;
}


//TODO:设置组头与组头之间的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        if ([self.winModel.lottery_pk intValue] == kType_JCZQ) {    //竞彩足球
            if (self.winModel.number.length == 0) {
                return 45;
            }else {
                return [self calcForJCmatedNumberHeight];
            }
        }else if([self.winModel.lottery_pk intValue] == lSSQ_lottery) {   //双色球
            if (self.winModel.number.length == 0) {
                return 45;
            }else {
                return [self SSQcalcFormatedNumberHeight];
            }
        }else {
            if (self.winModel.number.length == 0) {
                return 45;
            }else {
                return [self calcFormatedNumberHeight];
            }
        }
    }else {
        return 45;
    }
}


#pragma mark - 按钮点击事件
//收藏
- (void)collectButton {
    
    self.hidesBottomBarWhenPushed = YES;
     NSString *lotteryName = [self getLotNames:_winModel.lottery_pk] ;
    [self.navigationController pushViewController:[[AddCollectionViewController alloc] initWithWinModel:self.winModel WithLotteryName:lotteryName WithSelectNumber:_selectNumber] animated:YES];
}

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

//取消追号
- (void)cancel {
    
    
    UIAlertView *tipAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消追号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [tipAlert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:// 取消
            
            break;
        case 1:{ // 确定取消追号
            [self doCancel];
        }
            break;
            
        default:
            break;
    }
}

//取消追号记录
-(void)doCancel{
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_CancelFollow];
    params[@"record_pk"] = self.winModel.record_pk;
    
    NSLog(@"%ld",(long)kAPI_CancelFollow);
    
    _connection = [RequestModel POST:URL(kAPI_CancelFollow) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       
                       NSLog(@"取消追号：data = %@",data);
                       NSArray *itemArray = data[@"item"];
                       [itemArray enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
                           
                           WinModel *winModel = [[WinModel alloc] initWithDataDic:item];
                           [self.data addObject:winModel];
                       }];
                       
                       NSLog(@"self.data = %@",self.data);
                       [_tableView reloadData];
                       [SVProgressHUD showSuccessWithStatus:@"取消追号成功"];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCatchStatus"
                                                                           object:nil];
                       [self.navigationController popViewControllerAnimated:YES];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:@"取消追号失败"];
                       
                   }];
    
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
    //    CGSize sizeToFit = [NSObject getSizeWithText:numberDLT font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(60, 800)];
    int hh = [numberDLT sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth,800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+10, 45);
    
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


//号码处理
- (NSArray *)transFormNumber:(NSString *)number {
    
    dataArray = [NSMutableArray new];
    int lottery_code = [self.winModel.lottery_code intValue];
    if (lottery_code == kSFP_single
        || lottery_code == kRQ_SFP_single
        || lottery_code == kScore_single
        || lottery_code == kBQC_single
        || lottery_code == kJQS_single
        || lottery_code == KHHGG_single) {
        NSArray *array = [number componentsSeparatedByString:@"#"]; //从字符A中分隔成2个元素的数组     #前面的为串关
        NSString *btstring = array[1];
        array = [btstring componentsSeparatedByString:@"^"]; //从字符A中分隔成2个元素的数组
        for (NSString *ctstring in array)
        {
            array = [ctstring componentsSeparatedByString:@"$"]; //从字符A中分隔成2个元素的数组
            
            [dataArray addObject:array[0]];
        }
        return dataArray;
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
            [dataArray addObject:array[0]];    //0-->放的是号码  1--》放的后面结果
        }
        return dataArray;
    }
    
}


//混合过关
- (NSArray *)HHGGResult:(NSString *)result{
    
    NSArray *array = [result componentsSeparatedByString:@"@"];
    NSLog(@"%@ %@",result,array[1]);
    [self.hhData addObject:array[1]];
    return self.hhData;
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
            NSArray *hhNumber = [self HHGGResult:numberData[i]];
            //            NSLog(@"hhNumber = %@",hhNumber);
            NSString *hhString = [NSString stringWithFormat:@"%@: %@\n",hhNumber[i],selectNumber[i]];
            [mStrHH appendString:hhString];
        }else {
            NSString *string= [NSString stringWithFormat:@"%@: %@\n",numberData[i],selectNumber[i]];
            [mStr appendString:string];
        }
    }
    
    if ([self.winModel.lottery_code intValue] == KHHGG_single || [self.winModel.lottery_code intValue] == kHHGG_compound) {
        NSLog(@"%@",mStrHH);
        return mStrHH;
    }else {
        NSLog(@"%@",mStr);
        return mStr;
    }
    return nil;
}


-(float)calcForJCmatedNumberHeight {
    int hh = [NSObject getSizeWithText:[self transJCZQ] font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mScreenWidth-110, 850)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+80, 40);
    
}

-(RTLabel*)makeJCRTLabel{
    
    RTLabel *label = [[RTLabel alloc] initWithFrame:
                      CGRectMake(83,65,mScreenWidth-110,850)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.lineSpacing = 0;
    return label;
}

@end
