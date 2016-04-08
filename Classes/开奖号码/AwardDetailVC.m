//
//  AwardDetailVC.m
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AwardDetailVC.h"
#import "NSString+NumberSplit.h"
#import "ShareTools.h"
#import "UIColor+Hex.h"
#import "FootBallModel.h"
#import "AwardDetailCell.h"
#import "MJRefresh.h"
#import "NSString+stringToSpecialNumber.h"
#import "CTFB14ViewController.h"
#import "CTFB6CBQCViewController.h"
#import "CTFB9ViewController.h"
#import "CTFB4CJQViewController.h"
#import "DLTViewController.h"
#import "SSQViewController.h"
#import "PL3ViewController.h"
#import "PL5ViewController.h"
#import "SenStarPotteryViewController.h"
#import "T225ViewController.h"
#import "T317ViewController.h"
#import "T367ViewController.h"
#import "FootballLotteryManagers.h"


#define BG_GRAY_COLOR @"#f7f6ec"


@interface AwardDetailVC () {
    NSNumber *_lottery_pk;
    NSNumber *_period;
    UIView *_topView;
    NSString *_playName;
    UILabel *_ballLabel;
    NSMutableArray *cellArray;
    NSString *_poolLabel;

}

@end

@implementation AwardDetailVC

- (instancetype)initWithJCHModel:(JCHModel *)JCHModel playName:(NSString *)playName{
    if (self = [super init]) {
        
        self.jchModel = JCHModel;
        _playName = playName;
        //        _period = period;
        self.data = [NSMutableArray new];
        self.dataCount = [NSMutableArray new];
        self.DLTArray = [NSMutableArray new];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.navigationItem setNewTitle:@"开奖号码"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        
        //        [self loadData];
        
        NSLog(@"lottery_pk = %@",self.jchModel.lottery_pk);
        NSLog(@"period = %@",self.jchModel.period);
        NSLog(@"playName = %@",_playName);
    }
    
    return self;
    
    
}

#pragma mark -  返回
- (void)back
{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self _initWithSubViews];
    
    [self _setTopViewValue];
    
    [self loadData];
    
}



#pragma mark - 创建视图
- (void)_initWithSubViews
{
    
    //创建分享按钮
    UIButton *sharButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharButton setImage:[UIImage imageNamed:@"kjhm_share.png"] forState:UIControlStateNormal];
    [sharButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    sharButton.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:sharButton];
    self.navigationItem.rightBarButtonItem = rightButton;

    //加载xib文件
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"TopView" owner:nil options:nil] lastObject];
    _topView.frame = CGRectMake(10, 10, mScreenWidth-20, 130);
    [self.view addSubview:_topView];
    
    
    UIColor *orangeColor = [UIColor colorWithHexString:@"#f9cd9c"];
    UIColor *blueColor = [UIColor colorWithHexString:@"6ec3c8"];
    UIColor *redColor = [UIColor colorWithHexString:@"ed7c6a"];
    NSArray *color = @[orangeColor,blueColor,redColor];
    
    
    NSArray *list = @[@"奖等级别",@"中奖注数/注",@"每注奖金/元"];
    
    for (int i = 0; i <3; i++) {
        CGFloat width = (mScreenWidth-20)/3;
        
        //创建底部视图
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10+(i*width), _topView.bottom+10, width, 31)];
        bgView.tag = 200+i;
        bgView.backgroundColor = color[i];
        [self.view addSubview:bgView];
        
        //创建label
        UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 31)];
        listLabel.text = list[i];
        listLabel.font = [UIFont systemFontOfSize:12];
        listLabel.textAlignment = NSTextAlignmentCenter;
        listLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:listLabel];
    }
    
    
    //创建投注按钮
    UIButton *betButton = [[UIButton alloc] initWithFrame:CGRectMake(20,mScreenHeight-30-20-64,mScreenWidth-40,ButtonHeight)];
    [betButton setTitle:@"去投注" forState:UIControlStateNormal];
    betButton.backgroundColor = [UIColor colorWithHexString:@"#c12b1c"];
    [betButton addTarget:self action:@selector(betAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [betButton setTag:10];
    
    UILabel *contentLabel = (UILabel *)[self.view viewWithTag:200];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,contentLabel.bottom,mScreenWidth-20,betButton.top-contentLabel.bottom-20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self.view addSubview:betButton];
    [self tableViewCellType];
    
}

- (void)tableViewCellType {
   
       //注册单元格类型
    if ([self.jchModel.lottery_pk intValue] == lDLT_lottery) {
        _identify = @"identify";
        [_tableView registerNib:[UINib nibWithNibName:@"DLTAwardDetailCell" bundle:nil]
         forCellReuseIdentifier:_identify];
    }else {
        _identify = @"identify";
        [_tableView registerNib:[UINib nibWithNibName:@"AwardDetailCell" bundle:nil]
         forCellReuseIdentifier:_identify];
    }

}


#pragma mark - 赋值顶部视图的控件值
- (void)_setTopViewValue {
    
    //赋值
    UILabel *periodLabel = (UILabel *)[_topView viewWithTag:401];
    periodLabel.text = [NSString stringWithFormat:@"第%@期",self.jchModel.period];
    
    UILabel *playNameLabel = (UILabel *)[_topView viewWithTag:400];
    playNameLabel.text = _playName;
    
    UILabel *timeLabel = (UILabel *)[_topView viewWithTag:402];
    timeLabel.text = [self convertTime];

    
    NSLog(@"_lottery_pk=%@",self.jchModel.lottery_pk);
    NSLog(@"self.jchModel.bonus_number = %@",self.jchModel.bonus_number);
    
    NSArray *numberArray =  [self transformData];
    
    if ([self.jchModel.lottery_pk intValue ]== kType_CTZQ_SF14
        || [ self.jchModel.lottery_pk intValue] == kType_CTZQ_SF9
        || [ self.jchModel.lottery_pk intValue] == kType_CTZQ_BQC6
        || [ self.jchModel.lottery_pk intValue] == kType_CTZQ_JQ4) {
        
        [self createBalls:numberArray];
        
    }else if ([self.jchModel.lottery_pk intValue] == lDLT_lottery
              || [self.jchModel.lottery_pk intValue] == lT225_lottery
              || [self.jchModel.lottery_pk intValue] == lSSQ_lottery) {
        
        [self _createDLTBalls:numberArray];
        
    }else if ([self.jchModel.lottery_pk intValue] == lT367_lottery
              || [self.jchModel.lottery_pk intValue] == lT317_lottery){
        
        [self _createSBalls:numberArray];
        
    }else {
        
        [self _createOtherBalls:numberArray];
    }
    
}


#pragma mark - 字符串转化成时间显示
- (NSString *)convertTime {
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyyMMddHHmm"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSDate*date =[[NSDate alloc]init];
    
    NSString *time = [self.jchModel.bonus_time substringWithRange:NSMakeRange(0, 12)];
    
    NSLog(@"%@",self.jchModel.bonus_time);
    NSLog(@"%@",time);
    
    date =[df dateFromString:time];
    NSString *str = [NSString stringWithFormat:@"%@",date];
    
    NSLog(@"%@",str);
    
    NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* str1 = [df2 stringFromDate:date];
    NSLog(@"%@",str1);
    
    return str1;
}


#pragma mark - 将字符串--》数组
- (NSArray *)transformData {
    NSString *textString = [NSString stringWithFormat:@"%@",self.jchModel.bonus_number];
    textString  = [textString replaceAll:@"[^0-9]" withString:@""];
    NSString *textStr = [textString commonString:@" " length:1];
    NSArray  *textArray = [textStr componentsSeparatedByString:@" "];
    NSLog(@"textArray=%@",textArray);
    
    return textArray;
}


//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - 创建放置开奖号码的球视图
//创建开奖号码的球
- (void)createBalls:(NSArray *)textArray {
    
//    UIView *ballView = (UIView *) [_topView viewWithTag:404];
    
    //创建开奖号码label
    for (int i = 0; i<textArray.count; i++) {
        
        CGFloat item = textArray.count*15/2;
        CGFloat items = textArray.count*1;
        _ballLabel = [[UILabel alloc] initWithFrame:CGRectMake((15+1)*i+mScreenWidth/2-item-items, _topView.height/2.5, 15, 20)];
        [_ballLabel setBackgroundColor:[UIColor clearColor]];
        [_ballLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_ballLabel setTextColor:[UIColor whiteColor]];
        _ballLabel.backgroundColor = [UIColor colorWithHexString:@"#00b2c0"];
        _ballLabel.text = textArray[i];
        _ballLabel.textAlignment = NSTextAlignmentCenter;
        [_topView addSubview:_ballLabel];
    }
}


//创建圆形的球
- (void)_createOtherBalls:(NSArray *)textArray {
    
    CGFloat item = textArray.count*30/2;
    CGFloat items = textArray.count*1;
    
    for (int i = 0; i < textArray.count; i++) {
        
        UILabel *otherBallLabel = [[UILabel alloc] initWithFrame:CGRectMake((30+1)*i+mScreenWidth/2-item-items, _topView.height/3, 30, 30)];
        otherBallLabel.backgroundColor = [UIColor colorWithHexString:@"#c12b1c"];
        otherBallLabel.layer.cornerRadius = otherBallLabel.size.width/2;
        otherBallLabel.layer.masksToBounds = YES;
        otherBallLabel.text = textArray[i];
        otherBallLabel.textAlignment = NSTextAlignmentCenter;
        otherBallLabel.textColor = [UIColor whiteColor];
        [_topView addSubview:otherBallLabel];
    }
}


//创建大乐透
- (void)_createDLTBalls:(NSArray *)textArray {
    
    
    for (int i = 0; i < textArray.count; i++) {
        NSString *text = [NSString stringWithFormat:@"%@%@",textArray[i],textArray[i+1]];
        [self.data addObject:text];
        i++;
    }
    
    NSLog(@"self.data = %@",self.data);
    
    CGFloat item = textArray.count/2*30/2;
    CGFloat items = textArray.count/2*1;
    
    
    for (int i = 0; i < textArray.count/2; i++) {
        
        UILabel *LBallLabel = [[UILabel alloc] initWithFrame:CGRectMake((30+1)*i+mScreenWidth/2-item-items, _topView.height/3, 30, 30)];
        LBallLabel.layer.cornerRadius = LBallLabel.size.width/2;
        LBallLabel.layer.masksToBounds = YES;
        LBallLabel.text = [NSString stringWithFormat:@"%@",self.data[i]];
        LBallLabel.textAlignment = NSTextAlignmentCenter;
        LBallLabel.textColor = [UIColor whiteColor];
        [_topView addSubview:LBallLabel];
        
        if ([self.jchModel.lottery_pk isEqual:@"6"] || [self.jchModel.lottery_pk isEqual:@"52"]) {
            
            if (i >= 5) {
                LBallLabel.backgroundColor = RGBA(66, 115, 249, 1);
            }else {
                LBallLabel.backgroundColor = [UIColor colorWithHexString:@"c12b1c"];
                
            }
        }else {
            if (i >= 6) {
                LBallLabel.backgroundColor = RGBA(66, 115, 249, 1);
            }else {
                LBallLabel.backgroundColor = [UIColor colorWithHexString:@"c12b1c"];
                
            }
        }
    }
    
}

//创建选7
- (void)_createSBalls:(NSArray *)textArray {
    
    
    for (int i = 0; i < textArray.count; i++) {
        NSString *text = [NSString stringWithFormat:@"%@%@",textArray[i],textArray[i+1]];
        [self.data addObject:text];
        i++;
    }
    
    NSLog(@"self.data = %@",self.data);
    
    CGFloat item = textArray.count/2*30/2;
    CGFloat items = textArray.count/2*1;
    
    
    for (int i = 0; i < textArray.count/2; i++) {
        
        UILabel *LBallLabel = [[UILabel alloc] initWithFrame:CGRectMake((30+1)*i+mScreenWidth/2-item-items, _topView.height/3, 30, 30)];
        LBallLabel.layer.cornerRadius = LBallLabel.size.width/2;
        LBallLabel.layer.masksToBounds = YES;
        LBallLabel.text = [NSString stringWithFormat:@"%@",self.data[i]];
        LBallLabel.textAlignment = NSTextAlignmentCenter;
        LBallLabel.textColor = [UIColor whiteColor];
        [_topView addSubview:LBallLabel];
        
        if (i >= 7) {
            LBallLabel.backgroundColor = RGBA(66, 115, 249, 1);
        }else {
            LBallLabel.backgroundColor = [UIColor colorWithHexString:@"c12b1c"];
            
        }
    }
    
}





#pragma mark - 加载数据
- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_QueryRewardNotice];
    params[@"lottery_pk"] = self.jchModel.lottery_pk;
    params[@"period"] = self.jchModel.period;
    
    
    self.detailArray = [NSMutableArray new];    //奖等级别
    
    NSLog(@"lottery = %@, period = %@",self.jchModel.lottery_pk,self.jchModel.period);
    
    NSLog(@"kAPI_GetRevendDetail = %ld",(long)kAPI_QueryRewardNotice);
    [SVProgressHUD show];
    _connection = [RequestModel POST:URL(kAPI_QueryRewardNotice) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       NSLog(@"data = %@",data);
                       
                       _poolLabel = data[@"prize_pool"];
                       NSLog(@"%@",_poolLabel);
                       UILabel *poolLabel = (UILabel *)[_topView viewWithTag:403];
                       NSString *money = [NSString stringToNumberWithDot:[_poolLabel floatValue]];
                       poolLabel.text = [NSString stringWithFormat:@"奖池: %@元",[money substringToIndex:money.length-3]];
                       
                       //创建可变属性划字符串
                       NSMutableAttributedString *mattrstring = [[NSMutableAttributedString alloc] initWithString:poolLabel.text];
                       [mattrstring addAttribute:NSForegroundColorAttributeName
                                           value:[UIColor colorWithHexString:@"6ec3c8"]
                                           range:NSMakeRange(4,poolLabel.text.length-5)];
                       poolLabel.attributedText = mattrstring;
                       
                       NSLog(@"%@",poolLabel.text);
                       for (int i = 0; i < 7; i++) {
                           NSMutableArray *_ary = [NSMutableArray array];
                           
                           if ([self.jchModel.lottery_pk intValue] != lDLT_lottery) {
                               //中奖注数/注 每注奖金/元
                               NSString *amount = [data objectForKey:[NSString stringWithFormat:@"level_%d_amount",i+1]];
                               NSString *money = [data objectForKey:[NSString stringWithFormat:@"level_%d_money",i+1]];
                               if (!([amount isEqual:@"0"] && [money isEqual:@"0"])) {
                                   [_ary addObject:amount];   //注数
                                   [_ary addObject:money];    //奖金
                               }
                               NSString *level_name = [data objectForKey:[NSString stringWithFormat:@"level_name_%d",i+1]];
                               if (!([amount isEqual:@"0"] && [money isEqual:@"0"])) {
                                   [_ary addObject:level_name];  //等级
                               }
                               [self.detailArray addObject:_ary];
                               
                               NSMutableArray *array = self.detailArray[i];
                               if (array.count != 0) {
                                   [self.dataCount addObject:array];
                               }
                                NSLog(@"%@",self.detailArray);
                           }else {     //大乐透
                               //等级名字
                               NSString *level_name = [data objectForKey:[NSString stringWithFormat:@"level_name_%d",i+1]];
                               [_ary addObject:isValidateStr(level_name)?level_name:@"0"];
                               [_ary addObject:[data objectForKey:[NSString stringWithFormat:@"level_%d_amount",i+1]]];
                               [_ary addObject:[data objectForKey:[NSString stringWithFormat:@"level_%d_money",i+1]]];
                               
                               //中奖注数/注
                               NSString *level_zj_amount = [data objectForKey:[NSString stringWithFormat:@"level_%d_zj_amount",i+1]];
                               [_ary addObject:isValidateStr(level_zj_amount)?level_zj_amount:@"0"];
                               
                               
                               //每注奖金/元
                               NSString *level_zj_money = [data objectForKey:[NSString stringWithFormat:@"level_%d_zj_money",i+1]];
                               [_ary addObject:isValidateStr(level_zj_money)?level_zj_money:@"0"];
                               [self.DLTArray addObject:_ary];
                             }
                       
                           }
                       
                       NSLog(@"self.detailArray = %@",self.dataCount);
                       NSLog(@"self.DLTArray = %@",self.DLTArray);
                        NSLog(@"%@",self.detailArray);
                        [SVProgressHUD dismiss];
                        [_tableView reloadData];
                       
                   }
                      failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                       
                   }];
    
}


#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.jchModel.lottery_pk intValue] != lDLT_lottery) {
        return self.dataCount.count;
    }
    return self.DLTArray.count-1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AwardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"%@",self.jchModel.lottery_pk);
    // 设置cell的数据
    if ([self.jchModel.lottery_pk intValue] == lDLT_lottery) {
        [cell DLTArray:[self.DLTArray objectAtIndex:indexPath.row] lottery_pk:self.jchModel.lottery_pk];
    }else {
        [cell detailArray:[self.dataCount objectAtIndex:indexPath.row] lottery_pk:self.jchModel.lottery_pk];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.jchModel.lottery_pk intValue] == lDLT_lottery) {
        
        if (indexPath.row == 5) {
            return 45;
        }
        return 65;
    }else {
        
        return 45;
    }
}


#pragma mark - 按钮点击事件
//分享
- (void)shareAction:(UIButton *)button {
    
    NSString * shareStr = [NSString stringWithFormat:@"中奖了吗？彩票联盟{%@}第{%@}期中奖号码为：{%@}，小伙伴们记得及时兑奖哦。",_playName,self.jchModel.period,@"12113378"];
    [ShareTools shareAllButtonClickHandler:@"彩票联盟客户端" andUser:shareStr andUrl:kkShareURLAddress andDes:@"快来下载吧~"];
    
}




//投注
- (void)betAction:(UIButton *)button {
    
    if ([self.jchModel.lottery_pk intValue] == lDLT_lottery) {   //大乐透
        
        [self gotoLeTouNumber:lDLT_lottery];
        
    }else if ([self.jchModel.lottery_pk intValue] == lSSQ_lottery) {  //双色球
        
         [self gotoLeTouNumber:lSSQ_lottery];
        
    }else if ([self.jchModel.lottery_pk intValue] == lSenvenStar_lottery) {  //七星彩
        
         [self gotoLeTouNumber:lSenvenStar_lottery];
        
    }else if ([self.jchModel.lottery_pk intValue] == lPL3_lottery) {   //排列3
        
        [self gotoLeTouNumber:lPL3_lottery];
        
    }else if ([self.jchModel.lottery_pk intValue] == lPL5_lottery) {  //排列5
        
         [self gotoLeTouNumber:lPL5_lottery];
    }
    else if ([self.jchModel.lottery_pk intValue] == lT225_lottery) {  //22选5
        
        [self gotoLeTouNumber:lT225_lottery];
    }
    else if ([self.jchModel.lottery_pk intValue] == lT317_lottery) {  //31选7
        
        [self gotoLeTouNumber:lT317_lottery];
    }
    else if ([self.jchModel.lottery_pk intValue] == lT367_lottery) {  //36选7
        
        [self gotoLeTouNumber:lT367_lottery];
    }
    else if ([self.jchModel.lottery_pk intValue] == kType_CTZQ_SF14) {  //足彩
        
        [self gotoCTNumberClass:@"CTFB14ViewController"];
    }
    else if ([self.jchModel.lottery_pk intValue] == kType_CTZQ_SF9) {
        
        [self gotoCTNumberClass:@"CTFB9ViewController"];
    }
    else if ([self.jchModel.lottery_pk intValue] == kType_CTZQ_BQC6) {
        
        [self gotoCTNumberClass:@"CTFB6CBQCViewController"];
    }
    else if ([self.jchModel.lottery_pk intValue] == kType_CTZQ_JQ4) {
        
        [self gotoCTNumberClass:@"CTFB4CJQViewController"];
    }


}


#pragma mark 传统足球
- (void)gotoCTNumberClass:(NSString *)classStr
{
    Class class = NSClassFromString(classStr);
    for(UIViewController *bet in self.navigationController.viewControllers)
    {
        if([bet isKindOfClass:[class class]])
        {
            [self.navigationController popToViewController:bet animated:YES];
            return;
        }
        
    }
    UIViewController *controller = [class new];
    controller.hidesBottomBarWhenPushed = YES;
    [self addNavigationWithPresentViewController:controller];

}


#pragma mark - 乐透数字
- (void)gotoLeTouNumber:(NSInteger)lotteryType
{
    
    NSString *vcStr = getLotVCString(lotteryType);
    Class class =  NSClassFromString(vcStr);
    
    for(UIViewController *bet in self.navigationController.viewControllers)
    {
        if([bet isKindOfClass:[class class]])
        {
            [((TZBaseViewController*)bet) chooseBySelfView];
            
            [self.navigationController popToViewController:bet animated:YES];
            return;
        }
    }
    TZBaseViewController*  mController = [(TZBaseViewController*)[class alloc] initWithLotter_pk:GET_INT((long)lotteryType) period:nil requestCode:YES delegate:nil];
    PJNavigationController *nav = [[PJNavigationController alloc]initWithRootViewController:mController];
    [self presentViewController:nav];
}




@end
