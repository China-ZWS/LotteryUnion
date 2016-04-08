//
//  SenStarPotteryViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/11/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "SenStarPotteryViewController.h"

@implementation SenStarPotteryViewController

- (void)viewDidLoad
{
    _isSingleBall = YES;
    [super viewDidLoad];
    
    
    // 创建存放数据的数组
    [self reloadStoreData];
    
    cFrontGroup = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {// i的最大数和玩法的种数有关
        NSMutableArray *array = [NSMutableArray array];
        [cFrontGroup addObject:array];
    }
    _selectedBallArray = [[NSMutableArray alloc] init];
    
    // 创建左右滚动的ScrollView
    [self _initBaseSubViews];
    
    [self bringToFront];
    _topOffset = 5.0;
}


#pragma mark -- 重新加载存储的数据
- (void)reloadStoreData
{
    _cArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i++) {
        NSMutableArray *array = [NSMutableArray array];
        [_cArray addObject:array];
    }
}

//TODO:清除所有数据
-(void)clearAllData
{
    [self clearAllDataAndGetFiveNewNumber];
    _selectIdx = 0;
    [[containView valueForKey:@"ballGroup"]removeAllObjects];
}
//TODO:清除所有数据并且得到5注新的
-(void)clearAllDataAndGetFiveNewNumber
{
    if (_selectIdx == 1)
    {
        self.numberLabel.text = [NSString stringWithFormat:@"%d 注",(int)self.selectPickerIndex];
        self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",(int)self.selectPickerIndex* 2];
    } else {
        [self resetTotalValue];
    }
    
    for (BallView *ballView in _selectedBallArray) {
        ballView.selected = NO;
        // 是否选中的UI状态的改变
        [ballView isSelectedWithChange];
    }
    [_selectedBallArray removeAllObjects];
    // 将上一次选好的重新设置为0
    for (ColorLabel *label in cFrontGroup[lasteSelectIndex]) {
        label.text = @"0";
    }
    [self reloadStoreData];
}

//TODO:创建水平滚动的ScrollView以及其子视图
-(void)_initBaseSubViews
{
    NSArray *items = @[LocStr(@"自选"),LocStr(@"机选")];
    CGRect radioFrame = CGRectMake(0,0, mScreenWidth,37);
    radio = [[UIRadioControl alloc] initWithFrame:radioFrame items:items];
    if (self.selectType == 1)
    {
       radio.selectedIndex = 1;
    }
    
    else{
          radio.selectedIndex = 0;
    }
    _selectIdx = (int)radio.selectedIndex;
    radio.tag = 11111;
    [radio setTitleColor:REDFONTCOLOR forState:UIControlStateSelected];
    [radio addTarget:self action:@selector(radioValueChanged:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:radio];
    
    _radioBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, radio.bottom-1, mScreenWidth/items.count, 1)];
    _radioBottomImageView.image = [[UIImage imageWithColor:REDFONTCOLOR size:_radioBottomImageView.frame.size] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [self.titleView addSubview:_radioBottomImageView];
    
    // 水平滚动的ScrollView
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 37,  mScreenWidth, mScreenHeight-148)];
    _baseScrollView.contentSize = CGSizeMake( mScreenWidth*items.count, _baseScrollView.height);
    _baseScrollView.bounces = NO; // 设置不反弹
    _baseScrollView.showsVerticalScrollIndicator = NO; // 隐藏水平条
    _baseScrollView.delegate = self;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseScrollView];
    
    // 创建水平滚动视图的子视图
    for (int i = 0; i < items.count; i++)
    {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake( mScreenWidth*i, 0,  mScreenWidth, _baseScrollView.height-25)];
        [_baseScrollView addSubview:_baseView];
        
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:_baseView.bounds];
        subScrollView.tag = i;
        [_baseView addSubview:subScrollView];
        switch (i)
        {
            case 0:  //自选
                [self loadFirstViewWithScrollView:subScrollView];
                break;
            case 1:  //机选
                [self loadThirdViewWithScrollView:subScrollView];
                break;
            default:
                break;
        }
    }
}

#pragma mark -- 加载自选控制器 ----
- (void)loadFirstViewWithScrollView:(UIScrollView *)scrollView
{
    CGFloat varHeight = 0.0;
    _fristContainView = [UIView viewWithFrame:CGRectZero];
    for (int i = 1; i < 8; i++)
    {
        ColorLabel *l1 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, varHeight + _topOffset+10) text:[NSString stringWithFormat:@"第%@位:", getChineseNumber(i)] color:REDFONTCOLOR];
        [_fristContainView addSubview:l1];
        
        
        ColorLabel *l2 = [[ColorLabel alloc] initWithPosition:ccp(l1.right,varHeight+ _topOffset+10) text:LocStr(@"  已选      个 (可选1-10个)") color:NAVITITLECOLOR];
        [_fristContainView addSubview:l2];
        
        if(i==1)
        {
         // 添加机选一注图标
         UIButton *conShake = [[UIButton alloc]initWithFrame:mRectMake(mScreenWidth-90, l1.origin.y-8, 90, l1.height+14)];
         [conShake setImage:mImageByName(@"ctzq_yaoyiyao1") forState:UIControlStateNormal];
            [conShake addTarget:self action:@selector(getOneRandomResultWithClick:) forControlEvents:UIControlEventTouchUpInside];
         [_fristContainView addSubview:conShake];
        }
        
        ColorLabel *cFront = [[ColorLabel alloc] initWithFrame:CGRectMake(l2.left + 35.0,l2.top,25.0,l2.height) number:0 aligment:NSTextAlignmentCenter];
        [cFront setTag:i];
        [_fristContainView addSubview:cFront];
        [cFrontGroup[0] addObject:cFront];
        
        UIView *c1 = [self drawSamllBallView:10 withPosition:ccp(_topOffset+2.5,l2.bottom + 5) redOrBlue:kColorRed callback:@selector(ballSelected:) selectBallArray:[_cArray objectAtIndex:i - 1]];
        [c1 setTag:i*1000];
        [_fristContainView addSubview:c1];
        
        [_fristContainView setWidth:c1.width];
        [_fristContainView setHeight:c1.bottom];
        varHeight = i * (c1.height+l1.height+8);
    }

    [scrollView addSubview:_fristContainView];
    [scrollView setContentHeight:_fristContainView.height];
}

#pragma mark ---- 加载机选控制器 ------
- (void)loadThirdViewWithScrollView:(UIScrollView *)scrollView
{
    NSMutableArray *rowArray = [NSMutableArray array];
    for (int row = 0; row < self.selectPickerIndex; row ++)
    {
        NSMutableArray *ball = getRadomNumberFromZero(7, 9);
        [rowArray addObject:ball];
    }
    
    UIView *subView = [self loadRadomSelectViewTitleView];
    [scrollView addSubview:subView];
    [subView setTop:0];
    
    containView = [[BallGroupContianView alloc] initWithFrame:CGRectMake(5,subView.bottom + 8, scrollView.width-10, scrollView.height-subView.height-10) ballGroup:rowArray format:@"d"];
    [containView setTarget:self];
    [scrollView addSubview:containView];
    [scrollView setContentHeight:subView.bottom+containView.height];
}
#pragma mark -- 自由选号结果 ---
-(BetResult *)randomOneResult
{
    NSMutableArray *ball = getRadomNumberFromZero(7, 9);
    BetResult *result = [[BetResult alloc] init];
    [result setNumbers:[ball componentsJoinedByFormat:@"%i"]];
    [result setPlay_code:GET_INT(pSenvenStarLottery_Danshi]);
    return result;
}
     
-(void)getOneRandomResultWithClick:(UIButton*)sender
{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //  清楚所有数据
    [self clearAllDataAndGetFiveNewNumber];
    // 拿到每个球按钮的父视图
    for (int i = 1; i < 8; i++) {
        // 拿到ballView的父视图（条形视图）
        UIView *view = [[_fristContainView subviews] objectAtIndex:4*i];
        // 随机选球
        BallView *ballView = (BallView*)[view viewWithTag:randomValueBetween(0, 9)];
        // 将选中的球标记并存入数组
        ballView.selected = YES;
        [ballView isSelectedWithChange];
        [_selectedBallArray addObject:ballView];
        NSMutableArray *_ary = [_cArray objectAtIndex:i-1];
        if (ballView.selected){
            [_ary addObject:[NSNumber numberWithInt:(int)ballView.tag]];
        }
        for (ColorLabel *label in cFrontGroup[0]) {
            if (label.tag == ballView.superview.tag/1000) {
                label.text = [NSString stringWithFormat:@"%d",(int)[_ary count]];
            }
        }
    }
    // 计算注数
    [self checkTotal];
    
}
     
#pragma mark --摇一摇动作响应 ---
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    // Put in code here to handle shake
    
    if (event.subtype == UIEventSubtypeMotionShake && _selectIdx == 1)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIScrollView *scrollView = (UIScrollView *)[_baseView viewWithTag:1];
        [scrollView removeAllSubviews];
        [self loadThirdViewWithScrollView:scrollView];
        // 计算注数和钱数
        [self actionSelected:nil];
    }
    
    // 自选时的摇一摇
    if (event.subtype == UIEventSubtypeMotionShake && _selectIdx == 0)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //  清楚所有数据
        [self clearAllDataAndGetFiveNewNumber];
        // 拿到每个球按钮的父视图
        for (int i = 1; i < 8; i++) {
            // 拿到ballView的父视图（条形视图）
            UIView *view = [[_fristContainView subviews] objectAtIndex:4*i];
            // 随机选球
            BallView *ballView = (BallView*)[view viewWithTag:randomValueBetween(0, 9)];
            // 将选中的球标记并存入数组
            ballView.selected = YES;
            [ballView isSelectedWithChange];
            [_selectedBallArray addObject:ballView];
            NSMutableArray *_ary = [_cArray objectAtIndex:i-1];
            if (ballView.selected){
                [_ary addObject:[NSNumber numberWithInt:(int)ballView.tag]];
            }
            for (ColorLabel *label in cFrontGroup[0]) {
                if (label.tag == ballView.superview.tag/1000) {
                    label.text = [NSString stringWithFormat:@"%d",(int)[_ary count]];
                }
            }
        }
        // 计算注数
        [self checkTotal];

    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }

#pragma mark -- 选号是震动 ----
- (void)ballSelected:(BallView *)ballView
{
    // 选号震动
    [super vibrateWhenSelectBall];
    ballView.selected = !ballView.selected;
    [ballView isSelectedWithChange];
    
    if (ballView.selected) {//将选中的球放入数组
        [_selectedBallArray addObject:ballView];
    }else{
        [_selectedBallArray removeObject:ballView];
    }
    
    NSMutableArray *_ary = [_cArray objectAtIndex:(ballView.superview.tag - 1)/1000];
    
    if (ballView.selected)
        [_ary addObject:[NSNumber numberWithInt:(int)ballView.tag]];
    else 
        [_ary removeObject:[NSNumber numberWithInt:(int)ballView.tag]];
    
    for (ColorLabel *label in cFrontGroup[0]) {
        if (label.tag == ballView.superview.tag/1000) {
            label.text = [NSString stringWithFormat:@"%d",(int)[_ary count]];
        }
    }
    
    [self checkTotal];
}
#pragma mark -- 技术注数和金额 ---
- (void)checkTotal
{
    if ([_cArray subCount] >= 1) {
        int _numberOfBet = 1;
        for (int i = 0; i < [_cArray count]; i++) {
            int jishu = (int)[[_cArray objectAtIndex:i] count];
            int total = 0;
            if (jishu > 1)
                total += jishu;
            
            _numberOfBet *= total ?:1;
        }
        self.numberLabel.text = [NSString stringWithFormat:@"%d 注",_numberOfBet];
        self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",_numberOfBet * 2];
    } else {
        [self resetTotalValue];
    }
}
#pragma mark -- 读取选号结果 ----
-(BetResult *)readBetResult
{
    NSInteger _amount = 0;
    NSInteger _subCode = 0;
    NSString *_betString = NULL;
    BetResult *result = [[BetResult alloc] init];
    [result setLot_pk:_lottery_pk];
    
    if (_selectIdx == 0)
    {//直选
        if ([_cArray subCount] < 1)
        {
            [SVProgressHUD showInfoWithStatus:@"请最少选择一注"];
            return nil;
        }
        
        int _numberOfBet = 1;
        for (int i = 0; i < [_cArray count]; i++) {
            int jishu = (int)[_cArray[i] count],total=0;
            if (jishu > 1) total += jishu;
            _numberOfBet *= total ?:1;
        }
        _amount = _numberOfBet;
        
        if (_numberOfBet > 1) {
            _subCode = pSenvenStarLottery_Fushi;
            _betString = [_cArray formatArrayByString:@"%d" joinedByString:@"#"
                                             needSort:YES];
        } else {
            _betString = [_cArray formatArrayByString:@"%d" joinedByString:@""
                                             needSort:YES];
            _subCode = pSenvenStarLottery_Danshi;
        }
        
    }
    else if (_selectIdx == 1)
    {//机选
        _subCode = pSenvenStarLottery_Danshi;
        _amount = (int)[[containView getBallGroup] count];
        if (_amount < 1)
        {
            [SVProgressHUD showInfoWithStatus:@"请最少选择一注"];
            return nil;
        }
        
        NSArray *balls = [containView getBallGroup];
        _betString = [balls formatArrayByString:@"%d" joinedByString:@"#"
                                       needSort:YES];
    }
    
    [result setZhushu:_amount];
    [result setNumbers:_betString];
    [result setPlay_code:GET_INT(_subCode)];
    return result;
}

#pragma mark RootViewContorller Event

- (void)betAction:(id)sender
{
    int tag = (int)[sender tag];
    
    if (tag == TAG_BET_CLEAR) {
        
        if (_selectIdx == 0)
            [self clearAllDataAndGetFiveNewNumber];
        else if (_selectIdx == 1){
            self.numberLabel.text = @"0 注";
            self.totalLabel.text =  @"0 元";
            [containView removeScrollView];
        }
    } else {
        [super betAction:sender];
    }
}

 
- (void)actionSelected:(UISegmentedControl *)sender
{
    UIScrollView *scrollView = (UIScrollView *)[_baseView viewWithTag:1];
    [scrollView removeAllSubviews];
    self.numberLabel.text = [NSString stringWithFormat:@"%d 注",(int)self.selectPickerIndex];
    self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",(int)self.selectPickerIndex* 2];
    [self loadThirdViewWithScrollView:scrollView];
}
     
#pragma mark -- 重新生成 按默认5注
- (void)resetThirdViewWithScrollView
{
    // 重新设置为5注
    self.selectPickerIndex = 5;
    UIScrollView *scrollView = (UIScrollView *)[_baseView viewWithTag:1];
    [scrollView removeAllSubviews];
    self.numberLabel.text = [NSString stringWithFormat:@"%d 注",(int)self.selectPickerIndex];
    self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",(int)self.selectPickerIndex* 2];
    [self loadThirdViewWithScrollView:scrollView];
}

#pragma mark -- ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    _radioBottomImageView.left = x/ mScreenWidth*_radioBottomImageView.width;
}
     
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    _selectIdx = x/ mScreenWidth;
    
    // 滑动完后逻辑取消前面所选数据
    if (lasteSelectIndex != _selectIdx) {
            // 清楚数据
             [self clearAllDataAndGetFiveNewNumber];
        for (int i = 0; i <= _selectIdx; i++)
        {
            [radio setSelectedIndex:i];
            [bet_fav setHidden:i==1];
            [bet_random setHidden:i!=1];
            if (_selectIdx == 1)
            {
                [self resetThirdViewWithScrollView];
            }
        }
    }
    else
    {
        
    }
    lasteSelectIndex = _selectIdx;
}
#pragma 分段控制器按钮改变
- (void)radioValueChanged:(UIRadioControl *)sender
{
    _selectIdx = (int)sender.selectedIndex;
    if (lasteSelectIndex != _selectIdx) {
        [self clearAllDataAndGetFiveNewNumber];
        // 图片动画
        _radioBottomImageView.left = _radioBottomImageView.width*_selectIdx;
        [_baseScrollView setContentOffset:CGPointMake(_baseScrollView.width*_selectIdx, 0) animated:YES];
        
        if (_selectIdx == 1) {
            [self resetThirdViewWithScrollView];
        }
        // 机选则显示机选多期按钮
        [bet_fav setHidden:_selectIdx==1];
        [bet_random setHidden:_selectIdx!=1];
    } else {
        
    }
    // 记录上次选中的ID
    lasteSelectIndex = _selectIdx;
}
@end
