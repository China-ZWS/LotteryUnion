//
//  FBBettingViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/2.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "FBBettingViewController.h"
#import "FBBettingToolView.h"
#import "FBPassToChooseView.h"
#import "DataConfigManager.h"
#import "BaseBettingModel.h"
#import "TransferSelViewController.h"

@interface FBBettingViewController ()
<FBBettingToolViewDelegate>
{
    void(^_clear)();
    FBBettingToolView *_toolView;
}
@property (nonatomic) FBPlayType playType;
@property (nonatomic) FBBettingType bettingType;
@property (nonatomic) NSMutableArray *chooseDatas;
@property (nonatomic) NSInteger bettingNum;
@property (nonatomic) CGFloat maxNum;
@property (nonatomic) CGFloat minNum;
@property (nonatomic, copy) void(^requestBetting)(NSString *period);
@property (nonatomic, copy) void(^requestPlayPeriod)();

@end

@implementation FBBettingViewController
- (id)initWithParameters:(id)parameters playType:(FBPlayType)playType bettingType:(FBBettingType)bettingType clear:(void(^)())clear;
{
    
    if ((self = [super initWithParameters:parameters]))
    {
        _clear = clear;
        _playType = playType;
        _bettingType = bettingType;
        _parameters = [NSMutableArray arrayWithArray:[parameters  sortedArrayUsingComparator:^NSComparisonResult(FBDatasModel *obj1, FBDatasModel *obj2)
                                                      {
                                                          NSString *end_time1 = obj1.endTime;
                                                          NSString *end_time2 = obj2.endTime;
                                                          
                                                          [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                                          
                                                          NSDate *obj1Date = [FBTool.formatter dateFromString:end_time1];
                                                          NSDate *obj2Date = [FBTool.formatter dateFromString:end_time2];
                                                          
                                                          NSComparisonResult comparisonResult = [obj1Date compare:obj2Date];
                                                          return comparisonResult == NSOrderedDescending;
                                                      }]];
        
        FBTool.currentDatas = _parameters;
        [self.navigationItem setNewTitle:@"竞彩足球"];
        _chooseDatas = [NSMutableArray array];
    }
    return self;
}

#pragma mark -返回
- (void)didBack
{
    [super didBack];
    FBTool.currentDatas = nil;
    _toolView.hasSelected = NO;
    [FBPassToChooseView hideHUDForView:_toolView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    switch (_playType) {
        case kSFP:
            break;
        case kRSFP:
            break;
        case kScore:
        {
            CGFloat abstractsHeight = ScaleH(25);
            FBDatasModel *model = _parameters[indexPath.row];
            NSString *text = [[FootBallModel setScroeTextWithDatas:model.scroes] string];
            CGSize textSize = [NSObject getSizeWithText:text font:Font(14) maxSize:CGSizeMake(ScaleW(180), MAXFLOAT)];
            if (textSize.height > ScaleH(25)) {
                abstractsHeight = textSize.height + ScaleH(5) ;
                cellHeight += (abstractsHeight - ScaleH(25));
            }
        }
            break;
        case kBQC:
        {
            CGFloat abstractsHeight = ScaleH(25);
            FBDatasModel *model = _parameters[indexPath.row];
            NSString *text = [[FootBallModel setBQCTextWithDatas:model.BQCDatas] string];
            CGSize textSize = [NSObject getSizeWithText:text font:Font(14) maxSize:CGSizeMake(ScaleW(180), MAXFLOAT)];
            if (textSize.height > ScaleH(25)) {
                abstractsHeight = textSize.height + ScaleH(5) ;
                cellHeight += (abstractsHeight - ScaleH(25));
            }
        }
            break;
        case kJQS:
        {
            return ScaleH(100);
        }
            break;
        case kHHGG:
        {
            CGFloat abstractsHeight = ScaleH(25);
            FBDatasModel *model = _parameters[indexPath.row];
            NSString *text = [[FootBallModel setHHGGTextWithDatas:model] string];
            CGSize textSize = [NSObject getSizeWithText:text font:Font(14) maxSize:CGSizeMake(ScaleW(180), MAXFLOAT)];
            if (textSize.height > ScaleH(25)) {
                abstractsHeight = textSize.height + ScaleH(5) ;
                cellHeight += (abstractsHeight - ScaleH(25));
            }

        }
            break;
            
        default:
            break;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    BettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        
        Class CellClass = [BettingCell class];
        switch (_playType) {
            case kSFP:
            {
                CellClass = [BettingSPFCell class];
            }
                break;
            case kRSFP:
            {
                CellClass = [BettingRQSPFCell class];
            }
                break;
            case kScore:
            {
                CellClass = [BettingScoreCell class];
            }
                break;
            case kBQC:
            {
                CellClass = [BettingBQCCell class];

            }
                break;
            case kJQS:
            {
                CellClass = [BettingJQSCell class];
            }
                break;
            case kHHGG:
                CellClass = [BettingHHGGCell class];
                break;
                
            default:
                break;
        }
        
        cell = [[CellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.cancel addTarget:self action:@selector(eventWithClear:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.datas = _parameters[indexPath.row];
    return cell;
}

#pragma mark - 清空
- (void)eventWithClear:(id)sender
{
    BettingCell *cell = [UIView getView:sender toClass:@"BettingCell"];
    NSIndexPath *indexPath = [_table indexPathForCell:cell];
   /*
    删除用户当前列表对应数据
    */
    FBDatasModel *model = _parameters[indexPath.row];
    [_parameters removeObject:model];
    
    /*
        删除用户所有方案中对应的当条数据
     */
    if ([FBTool.selectDatas containsObject:model])
    {
        [FBTool.selectDatas removeObject:model];
    }
    /*
     刷新当前列表
     */
    [_table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    /*
     设置已添加几场比赛
     */
    [self  setSpendfew];
    
    /*
        刷新用户选的所有信息
     */
    [_chooseDatas removeAllObjects];
    [self refreshSelectedInfo];
    
    /*
     调用Block 刷新上层数据及UI
    */
    _clear();
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   

    [self initToolBar];

    /*
     刷新显示数据
     */
    [self refreshSelectedInfo];
}

#pragma mark - 初始化ToolBar
- (void)initToolBar
{
    /*
     实例化 BaseBettingToolView
     */
    [FBBettingToolView showViewToView:self.view delegate:self];
    
    if (FBTool.multiple)
    {
        [FBBettingToolView setMultiple:FBTool.multiple];
    }
    else
    {
        [FBBettingToolView setMultiple:1];
    }
    [FBBettingToolView setBettingType:_bettingType];

}

#pragma mark - FBBettingToolView 代理
- (void)toolView:(FBBettingToolView *)toolView changeWithMultiple:(NSInteger)multiple
{
    [self refreshViews];
}

- (void)toolView:(FBBettingToolView *)toolView didSelectView:(BOOL)hasSelected
{
    _toolView = toolView;
    if (_bettingType == kSkipmatch) {
        if (hasSelected) {
            [FBPassToChooseView showMenu:[DataConfigManager getFB_bettingPlay:[_parameters count]] toView:toolView chooseDatas:_chooseDatas select:^(id datas)
             {
                 [self refreshSelectedInfo];
             }otherEvent:^{
                 toolView.hasSelected = NO;
                 [FBPassToChooseView hideHUDForView:toolView];
             }];
            [FBPassToChooseView setInfoText:[NSString stringWithFormat:@"奖金范围:%.2f元~%.2f元",_minNum * FBTool.multiple * 2,_maxNum * FBTool.multiple * 2] toView:_toolView];
        }
        else
        {
            [FBPassToChooseView hideHUDForView:toolView];
        }
    }
}


#pragma mark - 计算及显示投注数，倍数，金额 ，投注串数
- (void)refreshSelectedInfo;
{
    if ([_parameters count]) {
        /*
         设置当前投注截止时间
         */
        FBDatasModel *model = _parameters[0];
        [self setEndTime:model.endTime];
    }
    else
    {
        [FBTool.formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *timestampString = [FBTool.formatter stringFromDate:[NSDate date]];
        [self setEndTime:timestampString];
    }

    if (_bettingType == kSingle)
    {
        /*
        单场
        */
        [FootBallModel calculateSingleDatas:_parameters result:^(NSInteger bettingNum)
        {
            _bettingNum = bettingNum;
            [self refreshViews];
        }];
    }
    else
    {

        [FootBallModel calculateSkipmatchDatas:_parameters scheme:_chooseDatas result:^(NSInteger bettingNum, CGFloat maxNum, CGFloat minNum)
         {
             _bettingNum = bettingNum;
             _maxNum = maxNum;
             _minNum = minNum;
             [self refreshViews];
         }];
    }
}


- (void)refreshViews
{
    
    /*用户选择的玩法*/
    if (_bettingType == kSingle)
    {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"单场"];
        [FBBettingToolView setPlayTypeName:attrString];
        [self setInfoAttributedText:[self leftText:_bettingNum]];
    }
    else
    {
        NSMutableAttributedString *attrString = nil;
        NSMutableString *title = [NSMutableString string];

        if (_chooseDatas.count) {
            for (NSDictionary *dic in  _chooseDatas)
            {
                if (title.length) {
                    [title appendString:@","];
                }
                [title appendString:dic[@"title"]];
            }
            attrString = [[NSMutableAttributedString alloc] initWithString:title];
        }
        else
        {
            [title appendFormat:@"投注方式(必选)"];
            attrString = [[NSMutableAttributedString alloc] initWithString:title];
            [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([attrString length] - [@"(必选)" length],[@"(必选)" length])];
        }
        [FBBettingToolView setPlayTypeName:attrString];
       
        /*显示用户选择的投注数、倍数、多少钱*/
        [self setInfoAttributedText:[self leftText:_bettingNum]];
        [FBPassToChooseView setInfoText:[NSString stringWithFormat:@"奖金范围:%.2f元~%.2f元",_minNum * FBTool.multiple * 2,_maxNum * FBTool.multiple * 2] toView:_toolView];
    }
}

- (NSMutableAttributedString *)leftText:(NSInteger)bettingNum
{
    NSString *money = [NSString stringWithFormat:@"%d",2 * bettingNum * FBTool.multiple];

    NSString *text = [NSString stringWithFormat:@"%d注 %d倍 共 %@ 元",bettingNum,FBTool.multiple, money];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([text length] - money.length - 2, [money length])];
    [attrString addAttribute:NSFontAttributeName value:Font(18) range:NSMakeRange([text length] - money.length - 2, [money length])];
    
    return attrString;
}


#pragma mark - 投注
- (void)eventWithFinish
{
    
    if (!UserInfoTool.isLoginedWithVirefi && !UserInfoTool.isLogined) {
        WEAKSELF
        [self gotoLogingWithSuccess:^(BOOL isSuccess)
         {
             if (isSuccess)
             {
                 [weakSelf requestGotoBetting];
             }
         }class:@"LoginVC"];
        return;
    }
    
    [self requestGotoBetting];

}

- (void)requestGotoBetting
{
    
    
    _toolView.hasSelected = NO;
    [FBPassToChooseView hideHUDForView:_toolView];

    
    
    
    
    NSString *money = [NSString stringWithFormat:@"%d",2 * _bettingNum * FBTool.multiple];
    if ([money integerValue] > 20000) {
        [SVProgressHUD showInfoWithStatus:@"单张彩票金额超过上限20000，请重新选择"];
        return;
    }
    
    if([[[UserInfo sharedInstance] Balance] intValue]<[money integerValue] &&[[[UserInfo sharedInstance] Cash] intValue]<[money integerValue])
    {
        //余额不足
        [SVProgressHUD showInfoWithStatus:(@"您的余额不足，请及时充值！")];
        TransferSelViewController *con = [[TransferSelViewController alloc]initWithTran:NO];
        [self pushViewController:con];
        return;
    }
    /*任务一，获取彩票期数*/
    WEAKSELF

//    self.requestPlayPeriod = ^{
//        [weakSelf getPlayPeriod];
//    };
    
    self.requestBetting = ^(NSString *period){
        [weakSelf gotoBetting:period gift_phone:nil greetings:nil];
    };
    
    _requestBetting(@"");
    self.requestBetting = nil;
}

- (void)getPlayPeriod
{
    [SVProgressHUD showWithStatus:@"获取期数"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lottery_pk"] = [NSNumber numberWithInt:kType_JCZQ];
    [params setPublicDomain:kAPI_QueryPlayPeriod];
    _connection = [RequestModel POST:URL(kAPI_QueryPlayPeriod) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       _requestBetting(data[@"item"][0][@"period"]);
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showInfoWithStatus:msg];
                       self.requestBetting = nil;
                   }];
}

- (void)gotoBetting:(NSString *)period gift_phone:(NSString *)gift_phone greetings:(NSString *)greetings
{
    
    [SVProgressHUD showWithStatus:@"正在出票中，请耐心等待……"];

    NSString *code_id = nil;
    /*
     单关
     */
    if (_bettingType == kSingle)
    {
        code_id = @"0101";
    }
    else
    {
        /*
         混合
         */
        if (!_chooseDatas.count) {
            [SVProgressHUD showInfoWithStatus:@"请先选择投注方式"];
            return;
        }
        code_id = _chooseDatas[0][@"code_id"];
    }

    BOOL isHunHe = NO;
    if (_playType == kHHGG) {
        isHunHe = YES;
    }
    [BaseBettingModel  gotoBettingWithZCJJ_single:_parameters  isHunhe:isHunHe result:^(NSString *bettingString, BOOL hasCompound)
     {
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
         params[@"lottery_pk"] = [NSNumber numberWithInt:kType_JCZQ];
//         params[@"period"] = period;
         API_play playType = [self getDetailednessWithPlayType:hasCompound];
         NSString *number = [NSString stringWithFormat:@"%d|%@#%@",playType,code_id,bettingString];
         params[@"number"] = number;
         params[@"multiple"] = [NSNumber numberWithInt:FBTool.multiple];
         params[@"money"] = [NSString stringWithFormat:@"%d",2 * _bettingNum * FBTool.multiple];
         params[@"charge_type"] = [NSNumber numberWithInteger:4];
        
         if (greetings && gift_phone) {
             params[@"gift_phone"] = gift_phone;
             params[@"greetings"] = greetings;
         }
         
         [params setPublicDomain:kAPI_BetCartAction];
         _connection = [RequestModel POST:URL(kAPI_BetCartAction) parameter:params   class:[RequestModel class]
                                  success:^(id data)
                        {
                            [SVProgressHUD dismiss];
                            [self showSuccessWithStatus:data[@"note"]
                                                 Period:period
                                                  LotPK:1
                                                BetType:gift_phone.length?2:1];
                            [[UserInfo sharedInstance]getUserBonusSuccess:nil failure:nil];
                        }
                                  failure:^(NSString *msg, NSString *state)
                        {
                            if ([state integerValue] == Status_Code_User_Not_Login)
                            {
                                [SVProgressHUD dismiss];
                                [super gotoLoging];
                                return;
                            }
                            [self showFailedWithStatus:msg];
                            [SVProgressHUD dismiss];
                        }];
        }];

}

- (void)refreshWithViews
{
    [self requestGotoBetting];
}

- (void)showSuccessWithStatus:(NSString *)msg
                       Period:(NSString *)period
                        LotPK:(API_LotteryType)lotPK
                      BetType:(NSInteger)type
{
    [BettingSuccessedView showWithContent:msg returnEvent:^{
        [self didBack];
    } shareEvent:^{
        NSString *shareStr;
        
        if(type == 1)  //投注
        {
            shareStr = [NSString stringWithFormat:@"轻轻一点，500万梦想到手。 刚刚在彩票联盟APP客户端上买了第%@期体彩%@,500万快点到我的口袋里来吧",period,@"竞彩足球"];
        }else{
            
            shareStr = @"独有的彩票联盟APP，特别的送彩票服务。刚刚给小伙伴送了一个500万的梦想,眼馋了吧,速速下载彩票联盟APP,梦想即将照进现实。";
        }
        
        [ShareTools shareAllButtonClickHandler:@"彩票联盟客户端" andUser:shareStr andUrl:kkShareURLAddress andDes:@"快来加入彩票联盟吧~"];

        [self didBack];
    }];
    
}

- (void)showFailedWithStatus:(NSString *)msg
{
    [BettingFailedView showWithContent:msg finishedEvent:^{
        
    }];
}


- (API_play)getDetailednessWithPlayType:(BOOL)hasCompound
{
    API_play playType = NSNotFound;
    switch (_playType) {
        case kSFP:
        {
            if (hasCompound) {
                playType = kSFP_compound;
            }
            else
            {
                playType = kSFP_single;
            }
        }
            break;
        case kRSFP:
        {
            if (hasCompound) {
                playType = kRQ_SFP_compound;
            }
            else
            {
                playType = kRQ_SFP_single;
            }
        }

            break;
        case kScore:
        {
            if (hasCompound) {
                playType = kScore_compound;
            }
            else
            {
                playType = kScore_single;
            }
        }
 
            break;
        case kBQC:
        {
            if (hasCompound) {
                playType = kBQC_compound;
            }
            else
            {
                playType = kBQC_single;
            }
        }
  
            break;
        case kJQS:
        {
            if (hasCompound) {
                playType = kJQS_compound;
            }
            else
            {
                playType = kJQS_single;
            }
        }
  
            break;
        case kHHGG:
        {
            if (hasCompound) {
                playType = kHHGG_compound;
            }
            else
            {
                playType = KHHGG_single;
            }
        }
  
            break;
            
        default:
            break;
    }
    return playType;

}


@end