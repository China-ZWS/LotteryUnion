//
//  SendDetailViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "SendDetailViewController.h"
#import "NSString+ConvertDate.h"
#import "RTLabel.h"
#import "AddCollectionViewController.h"
#import "BetResult.h"
#import "BetCartViewController.h"

@interface SendDetailViewController () {
     UITableView *_tableView;
     NSString *_selectNumber;
    NSMutableArray *dataArray;

}

@end

@implementation SendDetailViewController



- (instancetype)initWithModel:(WinModel *)winModel {
    
    if (self = [super init]) {
        
        self.winModel = winModel;
        self.title = @"记录详情";
         [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        self.hhData = [NSMutableArray new];
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
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, mScreenHeight-49) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self _createBottomView];

}


#pragma  mark - 创建底部视图
//创建底部视图
- (void)_createBottomView {
    
    if (!([_winModel.lottery_pk isEqual:@"6"] || [self.winModel.lottery_pk isEqual:@"1"] || [self.winModel.lottery_pk isEqual:@"2"] || [self.winModel.lottery_pk isEqual:@"5"]) ) {
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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: {
            
            if ([self.winModel.lottery_pk isEqualToString:@"6"]) {     //大乐透
                return 4;
            }else {
                return 3;
            }
        }
            break;
        case 1: {
            return 6;
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
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ",[self getLotNames:_winModel.lottery_pk],_winModel.period];
                    if ([_winModel.lottery_pk isEqual:@"15"]) {
                        if ([_winModel.lottery_code isEqual:@"11"] || [_winModel.lottery_code isEqual:@"12"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ", @"胜平负",_winModel.period];
                        }else if ([_winModel.lottery_code isEqual:@"21"] || [_winModel.lottery_code isEqual:@"22"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ", @"让球胜平负",_winModel.period];
                        }else if ([_winModel.lottery_code isEqual:@"31"] || [_winModel.lottery_code isEqual:@"32"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ", @"比分",_winModel.period];
                        }else if ([_winModel.lottery_code isEqual:@"41"] || [_winModel.lottery_code isEqual:@"42"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ", @"半全场",_winModel.period];
                        }else if ([_winModel.lottery_code isEqual:@"51"] || [_winModel.lottery_code isEqual:@"52"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ", @"总进球数",_winModel.period];
                        }else if ([_winModel.lottery_code isEqual:@"61"] || [_winModel.lottery_code isEqual:@"62"]) {
                            cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ", @"混合过关",_winModel.period];
                        }
                    }else {
                        cell.textLabel.text = [NSString stringWithFormat:@"彩种:  %@(%@期) ",_winModel.lottery_name,_winModel.period];
                    }
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 1:
                    switch ([_winModel.status intValue]) {
                        case 0:
                            cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"投注中..."];
                            break;
                        case 1:
                            cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"成功"];
                            break;
                        case 2:
                            cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"状态:  %@",@"失败"];
                            break;
                    }
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 2: {
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
                        label.text = [self.winModel SSNumber:_winModel.number lottery_code:_winModel.lottery_code];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                    }else {
                        
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 80, 30)];
                        textLabel.text = @"我的选号：";
                        textLabel.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:textLabel];
                        
                        RTLabel *label = [self makeRTLabel];
                        label.text = _winModel.formatedNumber;
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                    }
                    
                    
                    
                }break;
                case 3: {
                    if ([self.winModel.lottery_pk isEqualToString:@"6"]) {      //大乐透
                        cell.textLabel.text = [NSString stringWithFormat:@"追加:  %@ ", [_winModel.sup isEqual:@"0"]? @"不追加":@"追加" ];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }else {
                        return nil;
                    }
                    
                }break;
                default:
                    break;
            }
            
        }
            break;
        case 1:{
            switch (row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"对方手机号:  %@ ", _winModel.gift_phone];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"赠言:  %@ ",_winModel.greetings];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"注数:  %@" ,_winModel.amount];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 3:
                    cell.textLabel.text = [NSString stringWithFormat:@"倍数:  %@",_winModel.multiple];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    break;
                case 4:
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元",_winModel.money];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                }
                    break;
                case 5:
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"时间:  %@",[_winModel.create_time toFormatDateString]];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}



//TODO:设置组头与组头之间的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}


-(RTLabel*)makeRTLabel{
    RTLabel *label = [[RTLabel alloc] initWithFrame:
                      CGRectMake(85,7+5,mScreenWidth,850)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.lineSpacing = 0;
    return label;
}

#pragma mark - 按钮点击事件
//收藏
- (void)collectButton {
    
    self.hidesBottomBarWhenPushed = YES;
    NSString *lotteryName = [self getLotNames:_winModel.lottery_pk] ;

    NSLog(@"%@",_selectNumber);
    if ([self.winModel.lottery_pk intValue] == lSSQ_lottery) {
        _selectNumber = [self.winModel SSNumber:self.winModel.number lottery_code:self.winModel.lottery_code];
    }else {
        _selectNumber = self.winModel.formatedNumber;
    }
    [self.navigationController pushViewController:[[AddCollectionViewController alloc] initWithWinModel:self.winModel WithLotteryName:lotteryName WithSelectNumber:_selectNumber] animated:YES];
    
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


//混合过关
- (NSArray *)HHGGResult:(NSString *)result{
    
    NSArray *array = [result componentsSeparatedByString:@"@"];
    NSLog(@"%@ %@",result,array[1]);
    [self.hhData addObject:array[1]];
    return self.hhData;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        if ([self.winModel.lottery_pk intValue] == kType_JCZQ) {    //竞彩足球
                return [self calcForJCmatedNumberHeight];
          
        }else if([self.winModel.lottery_pk intValue] == lSSQ_lottery) {   //双色球
                return [self SSQcalcFormatedNumberHeight];
            return 45;
        }else {
            return [self calcFormatedNumberHeight];
            return 45;
        }
    }else {
        return 45;
    }
}


-(float)SSQcalcFormatedNumberHeight {
    NSString *numberDLT = [self.winModel SSNumber:_winModel.number lottery_code:self.winModel.lottery_code];
    int hh = [numberDLT sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth,800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+10, 45);
    
}


-(float)calcFormatedNumberHeight {
    NSString *numberDLT = [_winModel getWin:_winModel.formatedNumber isBet:YES];
    int hh = [numberDLT sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth,800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+20, 45);
    
}

-(float)calcForJCmatedNumberHeight {
    int hh = [NSObject getSizeWithText:[self transJCZQ] font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mScreenWidth-110, 850)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+80, 40);
    
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
