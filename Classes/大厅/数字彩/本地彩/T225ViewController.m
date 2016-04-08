//
//  T225ViewController.m
//  YaBoCaiPiaoSDK
//
//  Created by jamalping on 14-3-26.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import "T225ViewController.h"
#define RADIOCONTROL_TAG 11111

@interface T225ViewController ()

@end

@implementation T225ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
    }
    return self;
}

//TODO:返回动作
- (void)back
{
    [SVProgressHUD dismiss];
    [self popViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建存储数据的数组
    // 自选
    zixuan_Array = [[NSMutableArray alloc] init];
    // 胆拖
    _danqu = [[NSMutableArray alloc] init];
    _tuoqu = [[NSMutableArray alloc] init];
    
    _selectedBallArray = [[NSMutableArray alloc] init];
    
    // 创建水平滚动的ScrollView以及其子视图
    [self _initBaseSubViews];
    
    [self bringToFront];
    
    _topOffset = 5.0;
}

// 创建水平滚动的ScrollView以及其子视图
-(void)_initBaseSubViews
{
    NSArray *items = @[LocStr(@"自选"),LocStr(@"胆拖"),LocStr(@"机选")];
    radio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,0,mScreenWidth,37) items:items];
    // 设置默认玩法
    if (self.selectType == 1) radio.selectedIndex = 2;
    else radio.selectedIndex = 0;
    //
    _selectIdx = (int)radio.selectedIndex;
    
    radio.tag = RADIOCONTROL_TAG;
    [radio setTitleColor:REDFONTCOLOR forState:UIControlStateSelected];
    [radio addTarget:self action:@selector(radioValueChanged:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:radio];
    
    _radioBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, radio.bottom-1, mScreenWidth/items.count, 1)];
    _radioBottomImageView.image = [[UIImage imageWithColor:REDFONTCOLOR size:_radioBottomImageView.frame.size] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [self.titleView addSubview:_radioBottomImageView];
   
    // 水平滚动的ScrollView
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 37, mScreenWidth, mScreenHeight-148)];
    _baseScrollView.contentSize = CGSizeMake(mScreenWidth*items.count, _baseScrollView.height);
    _baseScrollView.clipsToBounds = NO;
    _baseScrollView.bounces = NO; // 设置不反弹
    _baseScrollView.showsVerticalScrollIndicator = NO; // 隐藏水平条
    _baseScrollView.delegate = self;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseScrollView];
    
    // 创建水平滚动视图的子视图
    for (int i = 0; i < items.count; i++) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(mScreenWidth*i, 0, mScreenWidth, _baseScrollView.height-25)];
        [_baseScrollView addSubview:_baseView];
        
        switch (i) {
            case 0:{
                UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:_baseView.bounds];
                subScrollView.clipsToBounds = NO;
                subScrollView.tag = i;
                [_baseView addSubview:subScrollView];
                
                [self loadFirstViewWithScrollView:subScrollView];
            }break;
            case 1:{
                CGRect frame = CGRectMake(10,0,mScreenWidth-20,20);
                UIColor *red = REDFONTCOLOR;
                label_dan=[[ColorLabel alloc] initWithFrame:frame color:red];
                frame.origin.y = 20;
                label_tuo=[[ColorLabel alloc] initWithFrame:frame color:red];
                
                [label_dan setText:LocStr(@"胆码区:")];
                [label_tuo setText:LocStr(@"拖码区:")];
                
                [_baseView addSubview:label_dan];
                [_baseView addSubview:label_tuo];
                
                UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, label_tuo.bottom+2, mScreenWidth, _baseView.height-label_tuo.bottom-2)];
//                subScrollView.clipsToBounds = NO;
                subScrollView.tag = i;
                [_baseView addSubview:subScrollView];
                [self loadSecondViewWithScrollView:subScrollView];
            }
                break;
            case 2:{
                UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:_baseView.bounds];
                subScrollView.clipsToBounds = NO;
                subScrollView.tag = i;
                [_baseView addSubview:subScrollView];
                isFrist = YES;
                [self loadThirdViewWithScrollView:subScrollView];
                isFrist = NO;
            }break;
            default:
                break;
        }
    }
}

-(void)clearZixuanData
{
    //清除数组中的值
    [zixuan_Array removeAllObjects];
    
    //清除label的值
    zixuan_Label.text = @"0";
    
    // 基本的数据清楚
    [self clearBaseData];
}

-(void)clearDantuoData
{
    //清除数组中的值
    [_danqu removeAllObjects];
    [_tuoqu removeAllObjects];
    
    //清除label的值
    cFront0.text = cFront1.text = @"0";
    
    label_dan.text = @"胆码区:"; label_tuo.text = @"拖码区:";
    
    // 基本的数据清楚
    [self clearBaseData];
}

-(void)clearBaseData
{
    _numberOfBet = 0;
    self.numberLabel.text = @"0 注";
    self.totalLabel.text = @"共 0 元";
    
    // 将选中的球的状态全都改变，并全部移除
    for (BallView *ballView in _selectedBallArray) {
        ballView.selected = NO;
        [ballView isSelectedWithChange];
    }
    [_selectedBallArray removeAllObjects];
}
// 清除所有数据
-(void)clearAllData
{
    [self clearZixuanData];
    [self clearDantuoData];
    _selectIdx = 0;
}

// 自选时视图的加载
- (void)loadFirstViewWithScrollView:(UIScrollView *)scrollView
{
    _fristContainView = [UIView viewWithFrame:CGRectZero];
    
    ColorLabel *l2 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, _topOffset+10) text:LocStr(@"  已选      个 (可选5-15个)") color:NAVITITLECOLOR];
    [_fristContainView addSubview:l2];
    
    UIButton *conShake = [[UIButton alloc]initWithFrame:mRectMake(mScreenWidth-90, l2.origin.y-5, 90, l2.height+8)];
    [conShake setImage:mImageByName(@"ctzq_yaoyiyao1") forState:UIControlStateNormal];
    [conShake addTarget:self action:@selector(getOneResultWithClick) forControlEvents:UIControlEventTouchUpInside];
    [_fristContainView addSubview:conShake];
    
    
    zixuan_Label = [[ColorLabel alloc] initWithFrame:CGRectMake(l2.left + 35.0,l2.top,25.0,l2.height) number:0 aligment:NSTextAlignmentCenter];
    [_fristContainView addSubview:zixuan_Label];
    
    // 画球
    UIView *c1 = [self drawBallView:22 withPosition:ccp(_topOffset+5,l2.bottom + 5.0) redOrBlue:kColorRed callback:@selector(zixuanBallSelected:) selectBallArray:zixuan_Array];
    [_fristContainView addSubview:c1];
    
    [_fristContainView setHeight:c1.bottom];
    [_fristContainView setWidth:c1.width];
    [scrollView addSubview:_fristContainView];
    [scrollView setContentHeight:_fristContainView.height];
}

// 胆托时视图的加载
- (void)loadSecondViewWithScrollView:(UIScrollView *)scrollView
{
    CGRect frame = CGRectMake(_topOffset,0,mScreenWidth-20,20);
    
    UIView *container = [UIView viewWithFrame:CGRectZero];
    ColorLabel *l1 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, _topOffset) text:LocStr(@"胆码区:") color:REDFONTCOLOR];
    [container addSubview:l1];
    ColorLabel *l2 = [[ColorLabel alloc] initWithPosition:ccp(l1.right, _topOffset) text:LocStr(@"  已选      个 (可选1-4个)") color:NAVITITLECOLOR];
    [container addSubview:l2];
    
    // 记录选了多少个
    frame = CGRectMake(l2.left+35,l2.top,25,l2.height);
    cFront0 = [[ColorLabel alloc] initWithFrame:frame number:0
                                       aligment:NSTextAlignmentCenter];
    [container addSubview:cFront0];
    
    UIView *c1 = [self drawBallView:22 withPosition:ccp(_topOffset+5,l2.bottom + 5.0) redOrBlue:kColorRed callback:@selector(dantuo_dan_selected:) selectBallArray:_danqu];
    [container addSubview:c1];

    ColorLabel *l3 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, c1.bottom + 10.0) text:LocStr(@"拖码区:") color:REDFONTCOLOR];
    [container addSubview:l3];
    
    ColorLabel *l4 = [[ColorLabel alloc] initWithPosition:ccp(l3.right, c1.bottom + 10.0) text:LocStr(@"  已选      个 (胆+拖>＝6个)") color:NAVITITLECOLOR];
    [container addSubview:l4];
    
    cFront1 = [[ColorLabel alloc] initWithFrame:CGRectMake(l4.left + 35.0,l4.top,25.0,l4.height) number:0 aligment:NSTextAlignmentCenter];
    [container addSubview:cFront1];
    
    UIView *c2 = [self drawBallView:22 withPosition:ccp(_topOffset+5,l4.bottom + 5.0) redOrBlue:kColorRed callback:@selector(dantuo_tuo_selected:) selectBallArray:_tuoqu];
    
    [container addSubview:c2];
    [container setHeight:c2.bottom];
    [container setWidth:c2.width];
    [scrollView addSubview:container];
    [scrollView setContentHeight:container.height];
}

// 机选时视图的加载
- (void)loadThirdViewWithScrollView:(UIScrollView *)scrollView
{
    NSMutableArray *rowArray = [NSMutableArray array];
    
    for (int row = 0; row < self.selectPickerIndex; row ++) {
        NSMutableArray *ball = [NSMutableArray array];
        // 两个参数分别表示为（几个、在多少个数里面选）
        NSArray *red =  getUnRepeatRadomNumber(5, 22);
        [ball addObjectsFromArray:[red sort]];
        [rowArray addObject:ball];
    }
    
    UIView *subView = [self loadRadomSelectViewTitleView];
    [scrollView addSubview:subView];
    
    // 内容视图
    containView = [[BallGroupContianView alloc] initWithFrame:CGRectMake(5, subView.bottom+10, scrollView.width-10, scrollView.height-subView.height-10) ballGroup:rowArray];
    containView.target = self;
    [scrollView addSubview:containView];
    [scrollView setContentHeight:subView.bottom+containView.height];
    if (!isFrist) {   
        _numberOfBet = (int)rowArray.count; // 设置注数
    }
}

// 机选一注响应225
-(BetResult *)randomOneResult
{
    BetResult *result = [[BetResult alloc] init];
    NSMutableArray *ball = [NSMutableArray array];
    NSArray *red =  getUnRepeatRadomNumber(5, 22);
    [ball addObjectsFromArray:[red sort]];
    //NSArray *blue = getUnRepeatRadomNumber(2, 12);
    //[ball addObjectsFromArray:[blue sort]];
    [result setNumbers:[ball componentsJoinedByFormat:@"%02d"]];
    [result setPlay_code:GET_INT(pT225_Danshi)];
    return result;
}
#pragma mark --- 点击按钮获取单独一注机选
- (void)getOneResultWithClick
{

    // 清除自选时的数据数据
    if (zixuan_Array.count != 0) {
        [self clearZixuanData];
    }
    // 首先拿到放小球的父视图
    UIView *baseView = [[_fristContainView subviews] objectAtIndex:3];
    for (int i = 0; i < 5; i++) {// 随机出五个
        int m = randomValueBetween(1, 22);
        NSMutableArray *array = [NSMutableArray arrayWithArray:zixuan_Array];
        for (NSNumber *element in array) {
            if (m == [element intValue]) {// 如果有选择一样的
                // 重复选一次，并将上次一样的数据删除
                i--;
                [zixuan_Array removeObject:[NSNumber numberWithInt:m]];
                BallView *ballView = (BallView *)[baseView viewWithTag:m];
                [_selectedBallArray removeObject:ballView];
                continue;
            }
        }
        BallView *ballView = (BallView *)[baseView viewWithTag:m];
        ballView.selected = YES;
        [ballView isSelectedWithChange];
        // 将号码存入数组
        [zixuan_Array addObject:[NSNumber numberWithInt:m]];
        [_selectedBallArray addObject:ballView];
    }
    zixuan_Label.text = [NSString stringWithFormat:@"%d",(int)[zixuan_Array count]];
    // 计算注数
    [self checkTotal];

}

#pragma mark -- 摇一摇响应
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (event.subtype == UIEventSubtypeMotionShake && _selectIdx == 2)
    {
        // Put in code here to handle shake
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIScrollView *scrollView = (UIScrollView *)[_baseView viewWithTag:2];
        [scrollView removeAllSubviews];
        [self loadThirdViewWithScrollView:scrollView];
    }
    if (event.subtype == UIEventSubtypeMotionShake && _selectIdx == 0)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        // 清除自选时的数据数据
        if (zixuan_Array.count != 0) {
            [self clearZixuanData];
        }
        // 首先拿到放小球的父视图
        UIView *baseView = [[_fristContainView subviews] objectAtIndex:3];
        for (int i = 0; i < 5; i++) {// 随机出五个
            int m = randomValueBetween(1, 22);
            NSMutableArray *array = [NSMutableArray arrayWithArray:zixuan_Array];
            for (NSNumber *element in array) {
                if (m == [element intValue]) {// 如果有选择一样的
                    // 重复选一次，并将上次一样的数据删除
                    i--;
                    [zixuan_Array removeObject:[NSNumber numberWithInt:m]];
                    BallView *ballView = (BallView *)[baseView viewWithTag:m];
                    [_selectedBallArray removeObject:ballView];
                    continue;
                }
            }
            BallView *ballView = (BallView *)[baseView viewWithTag:m];
            ballView.selected = YES;
            [ballView isSelectedWithChange];
            // 将号码存入数组
            [zixuan_Array addObject:[NSNumber numberWithInt:m]];
            [_selectedBallArray addObject:ballView];
        }
        zixuan_Label.text = [NSString stringWithFormat:@"%d",(int)[zixuan_Array count]];
        // 计算注数
        [self checkTotal];
    }
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

// 成为第一响应者
- (BOOL)canBecomeFirstResponder
{ return YES; }

// 自选时响应得方法
- (void)zixuanBallSelected:(BallView *)button
{
    if ([zixuan_Array count] >= 15 && !button.selected)
    {
        [SVProgressHUD showInfoWithStatus:@"已选球数已超过限制"];
        return;
    }
    button.selected = !button.selected;
    // 选号时震动
    [super vibrateWhenSelectBall];
    
    // 是否选中后的UI变化
    [button isSelectedWithChange];
    
    if (button.selected){
        [zixuan_Array addObject:[NSNumber numberWithInt:(int)button.tag]];
        [_selectedBallArray addObject:button];
    }
    else{
        [zixuan_Array removeObject:[NSNumber numberWithInt:(int)button.tag]];
        [_selectedBallArray removeObject:button];
    }
    zixuan_Label.text = [NSString stringWithFormat:@"%d",(int)[zixuan_Array count]];
    // 计算注数
    [self checkTotal];
}

//胆拖action
- (void)dantuo_dan_selected:(BallView *)button
{
    // 标记拖码中选中的球
    BOOL isRepeat = NO;
    for (int i = 0; i < [_tuoqu count]; i++) {
        if (button.tag == [[_tuoqu objectAtIndex:i] intValue]) {
            isRepeat = YES;
            break;
        }
    }
    
    if (isRepeat && !button.selected) {
        [SVProgressHUD showInfoWithStatus:@"拖码中已包含此球"];
        return;
    } else if ([_danqu count] >= 4 && !button.selected)
    {
        [SVProgressHUD showInfoWithStatus:@"胆码区最多4个"];
        return;
    }
    button.selected = !button.selected;
    
    [button isSelectedWithChange];
    // 选号时震动
    [super vibrateWhenSelectBall];
    if (button.selected){
        [_danqu addObject:[NSNumber numberWithInt:(int)button.tag]];
        [_selectedBallArray addObject:button];
    }
    else{
        [_danqu removeObject:[NSNumber numberWithInt:(int)button.tag]];
        [_selectedBallArray removeObject:button];
    }
    
    // 赋值
    cFront0.text = [NSString stringWithFormat:@"%d",(int)[_danqu count]];
    label_dan.text = [NSString stringWithFormat:@"胆码区:  %@", [[_danqu sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
    // 计算注数
    [self checkTotal];
}

- (void)dantuo_tuo_selected:(BallView *)button
{
    BOOL isRepeat = NO;
    for (int i = 0; i < [_danqu count]; i++) {
        if (button.tag == [[_danqu objectAtIndex:i] intValue]) {
            isRepeat = YES;
            break;
        }
    }
    
    if (isRepeat && !button.selected)
    {
        [SVProgressHUD showInfoWithStatus:@"胆码中已包含此球"];
        return;
    }
    
    [super vibrateWhenSelectBall];
    button.selected = !button.selected;
    [button isSelectedWithChange];
    if (button.selected){
        [_tuoqu addObject:[NSNumber numberWithInt:(int)button.tag]];
        [_selectedBallArray addObject:button];
    }
    else{
        [_tuoqu removeObject:[NSNumber numberWithInt:(int)button.tag]];
        [_selectedBallArray removeObject:button];
    }
    
    cFront1.text = [NSString stringWithFormat:@"%d",(int)[_tuoqu count]];
    label_tuo.text = [NSString stringWithFormat:@"拖码区:  %@", [[_tuoqu sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
    
    // 计算注数
#warning 得修改
    [self checkTotal];
}

// 计算注数的方法
- (void)checkTotal
{
    _numberOfBet = 0;      // 注数
    if(_selectIdx == 0) {  // 自选时
        if ([zixuan_Array count] >= 5) {
            // 计算注数
            _numberOfBet = combination((int)[zixuan_Array count],5);
            
        }
    } else if(_selectIdx == 1) { // 胆托时
        int danCount=(int)_danqu.count,tuoCount=(int)_tuoqu.count;
        if (danCount+tuoCount >= 6 && danCount >=1) {
            _numberOfBet = combination(tuoCount, 5-danCount);
        }
    }
    
    // 赋值
    [_numberLabel setText:[NSString stringWithFormat:@"%d 注",_numberOfBet]];
    [_totalLabel setText:[NSString stringWithFormat:@"共 %d 元",_numberOfBet*2]];
}

// 选好了按钮的结果返回
-(BetResult *)readBetResult
{
    if(_numberOfBet<=0)
    {
        [SVProgressHUD showInfoWithStatus:@"至少选择一注"];
        return nil;
    }
    
    NSString *_betString = NULL;   // 记录选好的号码
    int _amount = 0,_subCode = 0;  // 记录注数，彩种编号
    // 投注结果
    BetResult *result = [[BetResult alloc] init];
    [result setLot_pk:_lottery_pk];
    
    if (_selectIdx == 0) {
        _amount = _numberOfBet;
        
        // 大于一注
        if (_numberOfBet > 1) {
            NSMutableString *mStr = [NSMutableString string];
            [mStr appendFormat:@"%@",[[zixuan_Array sort] getNumberStringByFormat:@"%02d" joinedByString:@""]];
            
            _betString = mStr;
            _subCode = pT225_Fushi;
        } else {
            NSMutableArray *_cArray = [NSMutableArray array];
            [_cArray addObjectsFromArray:[zixuan_Array sort]];
            
            _betString = [_cArray getNumberStringByFormat:@"%02d"
                                           joinedByString:@""];
            _subCode = pT225_Danshi;
        }
        
    } else if (_selectIdx == 1) { // 胆托（胆码区号码#拖码区号码）
        if ([_danqu count]+[_tuoqu count] < 6) {
            [SVProgressHUD showInfoWithStatus:@"胆+拖必须大于5个"];
            return nil;
        }
        
        _subCode = pT225_Dantuo;
        _amount = _numberOfBet;
        
        NSMutableString *mStr = [NSMutableString string];
        // 字符串拼接
        [mStr appendFormat:@"%@",[[_danqu sort] getNumberStringByFormat:@"%02d"
                                                         joinedByString:@""]];
        [mStr appendString:@"#"];
        [mStr appendFormat:@"%@",[[_tuoqu sort] getNumberStringByFormat:@"%02d"
                                                         joinedByString:@""]];
        
        _betString = mStr;
    } else if (_selectIdx == 2) {
        _subCode = pT225_Danshi;
        _amount = (int)[[containView getBallGroup] count];
        
        //        NSMutableArray *adjustArry = [NSMutableArray array];
        NSArray *oldA = [containView getBallGroup];
        //        for (NSArray *a in oldA) {
        //            NSMutableArray *redBlueA = [NSMutableArray array];
        //            NSArray *redA = [[a subarrayWithRange:NSMakeRange(0, 5)] sort];
        //            NSArray *blueA = [[a subarrayWithRange:NSMakeRange(6, 2)] sort];
        //            [redBlueA addObjectsFromArray:redA];
        //            [redBlueA addObjectsFromArray:blueA];
        //
        //            [adjustArry addObject:redBlueA];
        //        }
        if (_amount < 1) {
            [SVProgressHUD showInfoWithStatus:@"请最少选择一注"];
            return nil;
        }
        
        _betString = [oldA formatArrayByString:@"%02d"
                                joinedByString:@"#"
                                      needSort:NO];
    }
    // 注数，号码，彩种编号
    [result setZhushu:_amount];
    [result setNumbers:_betString];
    [result setPlay_code:GET_INT(_subCode)];
    return result;
}

// toolBar按钮的响应方法
- (void)betAction:(id)sender
{
    int tag = (int)[sender tag];
    
    if (tag == TAG_BET_CLEAR) {
        [self resetTotalValue];
        if (_selectIdx == 0)
            [self clearZixuanData];
        else if (_selectIdx == 1) {
            [self clearDantuoData];
        } else if (_selectIdx == 2)
            [containView removeScrollView];
    }else{
        [super betAction:sender];
    }
}

// 机选几注按钮的响应方法
- (void)actionSelected:(UISegmentedControl *)sender
{
    UIScrollView *scrollView = (UIScrollView *)[_baseView viewWithTag:2];
    [scrollView removeAllSubviews];
    self.numberLabel.text = [NSString stringWithFormat:@"%d 注",(int)self.selectPickerIndex];
    self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",(int)self.selectPickerIndex* 2];
    [self loadThirdViewWithScrollView:scrollView];
}

// 重新生成 按默认5注
- (void)resetThirdViewWithScrollView
{
    // 重新设置为5注
    self.selectPickerIndex = 5;
    UIScrollView *scrollView = (UIScrollView *)[_baseView viewWithTag:2];
    [scrollView removeAllSubviews];
    self.numberLabel.text = [NSString stringWithFormat:@"%d 注",(int)self.selectPickerIndex];
    self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",(int)self.selectPickerIndex* 2];
    [self loadThirdViewWithScrollView:scrollView];
}

#warning 有待研究
- (void)updateSelectPeriod:(Record *)record
{
    int lottery_code = [record.lottery_code intValue]; // 玩法编号
    NSString *number = record.number;                  // 投注号码
    
    self.skipClearArray = YES;
    
    [_danqu removeAllObjects];
    [_tuoqu removeAllObjects];
    
    if (lottery_code == pT225_Danshi) {
        // 判断＃得个数是否大于0
        if ([number rangeOfString:@"#"].length > 0) {
            _selectIdx = 2;
            ((UIRadioControl*)[self.titleView viewWithTag:RADIOCONTROL_TAG]).selectedIndex = 2;
            // 切割投注号码为数组
            NSArray *allBets = [number componentsSeparatedByString:@"#"];
            NSMutableArray *mArray = [NSMutableArray array];
            for (NSString *str in allBets) {
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:0];
                [tmp addObjectsFromArray:[[str splitToNumberArrayByLength:2] subarrayWithRange:NSMakeRange(0,5)]];
                [tmp addObject:[NSNumber numberWithInt:-1]];
                [tmp addObjectsFromArray:[[str splitToNumberArrayByLength:2] subarrayWithRange:NSMakeRange(5,2)]];
                
                [mArray addObject:tmp];
            }
            
//            [self loadThirdViewByExistsBet:mArray];
        } else {
            _selectIdx = 0;
            ((UIRadioControl*)[self.titleView viewWithTag:RADIOCONTROL_TAG]).selectedIndex = 0;
            
            NSArray *_f = [number splitToNumberArrayByLength:2];
            [_danqu addObjectsFromArray:[_f subarrayWithRange:NSMakeRange(0, 5)]];
            [_tuoqu addObjectsFromArray:[_f subarrayWithRange:NSMakeRange(5, 2)]];
            
            [self loadFirstViewWithScrollView:nil];
            [self checkTotal];
        }
    } else if (lottery_code == pT225_Fushi) {
        _selectIdx = 0;
        ((UIRadioControl*)[self.titleView viewWithTag:RADIOCONTROL_TAG]).selectedIndex = 0;
        
        NSArray *tmp = [number componentsSeparatedByString:@"#"];
        NSArray *_f0 = [[tmp objectAtIndex:0] splitToNumberArrayByLength:2];
        NSArray *_f1 = [[tmp objectAtIndex:1] splitToNumberArrayByLength:2];
        
        [_danqu addObjectsFromArray:_f0];
        [_tuoqu addObjectsFromArray:_f1];
        
        [self loadFirstViewWithScrollView:nil];
        [self checkTotal];
    } else if (lottery_code == pT225_Dantuo) {
        _selectIdx = 1;
        ((UIRadioControl*)[self.titleView viewWithTag:RADIOCONTROL_TAG]).selectedIndex = 1;
        
        NSDictionary *aDict = [number splitDantuo];
        NSArray *_f0 = [[aDict objectForKey:@"qianqu_dan"] splitToNumberArrayByLength:2];
        NSArray *_f1 = [[aDict objectForKey:@"qianqu_tuo"] splitToNumberArrayByLength:2];
        //        NSArray *_f3 = [[aDict objectForKey:@"houqu_dan"] splitToNumberArrayByLength:2];
        //        NSArray *_f4 = [[aDict objectForKey:@"houqu_tuo"] splitToNumberArrayByLength:2];
        
        [_danqu addObjectsFromArray:_f0];
        [_tuoqu addObjectsFromArray:_f1];
        
        self.titleView.frame = CGRectMake(self.titleView.left,self.titleView.top,self.titleView.width,35.0);
        
        [self loadSecondViewWithScrollView:nil];
        
        //        fear_tuo.text = [NSString stringWithFormat:@"后区拖:  %@", [[_houqu1 sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
        //        fear_dan.text = [NSString stringWithFormat:@"后区胆:  %@", [[_houqu0 sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
        label_tuo.text = [NSString stringWithFormat:@"前区拖:  %@", [[_tuoqu sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
        label_dan.text = [NSString stringWithFormat:@"前区胆:  %@", [[_danqu sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
        
        [self checkTotal];
    }
    
    [super updateSelectPeriod:nil];
    
}

#pragma mark  UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    _radioBottomImageView.left = x/mScreenWidth*_radioBottomImageView.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    _selectIdx = x/mScreenWidth;
    
    // 滑动完后逻辑取消前面所选数据
    if (lasteSelectIndex != _selectIdx) {
        if (_selectIdx == 2) {
            [self clearZixuanData];
            [self clearDantuoData];
        }else{
            if (_selectIdx != 0) {
                // 清除自选时的数据
                [self clearZixuanData];
            }else {
                // 清除胆拖时的数据
                [self clearDantuoData];
            }
        }
        
        for (int i = 0; i <= _selectIdx; i++) {
            [radio setSelectedIndex:i];
            [bet_fav setHidden:i==2];
            [bet_random setHidden:i!=2];
            if (_selectIdx == 2) {
                [self resetThirdViewWithScrollView];
            }
        }
    }else{
        
    }
    lasteSelectIndex = _selectIdx;
}

// 玩法响应
- (void)radioValueChanged:(UIRadioControl *)sender
{
    _selectIdx = (int)sender.selectedIndex;
    if (lasteSelectIndex != _selectIdx) {
        
        // 清除数据
        if (_selectIdx == 2) {
            [self clearZixuanData];
            [self clearDantuoData];
            [self resetThirdViewWithScrollView];
        }else{
            if (_selectIdx != 0) {
                // 清除自选时的数据
                [self clearZixuanData];
            }else {
                // 清除胆拖时的数据
                [self clearDantuoData];
            }
        }
        
        _radioBottomImageView.left = _radioBottomImageView.width*_selectIdx;
        [_baseScrollView setContentOffset:CGPointMake(_baseScrollView.width*_selectIdx, 0) animated:YES];
        
        // 机选则显示机选多期按钮
        [[self.toolBarView viewWithTag:TAG_BET_FAV] setHidden:(_selectIdx==2)];
        [[self.toolBarView viewWithTag:TAG_BET_RANDOM] setHidden:(_selectIdx!=2)];
    } else {
    }
    // 记录上次选中的ID
    lasteSelectIndex = _selectIdx;
}

@end
