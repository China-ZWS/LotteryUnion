//
//  PL5ViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/11/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "PL5ViewController.h"

#define RADIOCONTROL_TAG 111111

@implementation PL5ViewController

- (void)viewDidLoad
{
    _isSingleBall = YES;   //是否是单式
    [super viewDidLoad];
    
    // 创建存放数据的数组
    [self reloadStoreData];
    
    cFrontGroup = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++)
    {
        // i的最大数和玩法的种数有关
        NSMutableArray *array = [NSMutableArray array];
        [cFrontGroup addObject:array];
    }
    _selectedBallArray = [[NSMutableArray alloc] init];
    
    
    // 创建左右滚动的ScrollView
    [self _initBaseSubViews];
    [self bringToFront];
    for (UIView *view in self.view.subviews)
    {
        NSLog(@"--------%@----------",view);
    }
    _topOffset = 5.0;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (UIView *view in self.view.subviews)
    {
        NSLog(@"--------%@----------",view);
    }
}

//TODO:清除所有数据
-(void)clearAllData
{
    [self clearAllDataAndGetNewFiveNumber];
    _selectIdx = 0;
    [[containView valueForKey:@"ballGroup"]removeAllObjects];
}

//TODO:清除所有数据并重新得到5组数据
-(void)clearAllDataAndGetNewFiveNumber
{
    if (_selectIdx == 1)
    {
        self.numberLabel.text = [NSString stringWithFormat:@" %d 注",(int)self.selectPickerIndex];
        self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",(int)self.selectPickerIndex* 2];
    } else
    {
        [self resetTotalValue];
    }
    
    for (BallView *ballView in _selectedBallArray)
    {
        ballView.selected = NO;
        // 是否选中的UI状态的改变
        [ballView isSelectedWithChange];
    }
    [_selectedBallArray removeAllObjects];
    // 将上一次选好的重新设置为0
    for (ColorLabel *label in cFrontGroup[lasteSelectIndex])
    {
        label.text = @"0";
    }
    [self reloadStoreData];
}

#pragma mark -- 创建水平滚动的ScrollView以及其子视图
-(void)_initBaseSubViews
{
    // 上方的选择按钮
    NSArray *items = [NSArray arrayWithObjects:LocStr(@"自选"),LocStr(@"机选"), nil];
    radio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,0,mScreenWidth,35) items:items];
    if (self.selectType == 1)
    {
       radio.selectedIndex = 1;
    } else
    {
       radio.selectedIndex = 0;
    }
    [radio setTitleColor:NAVITITLECOLOR forState:UIControlStateNormal];
    [radio setTitleColor:REDFONTCOLOR forState:UIControlStateSelected];
    
    _selectIdx = (int)radio.selectedIndex;
    radio.tag = RADIOCONTROL_TAG;
    [radio addTarget:self action:@selector(radioValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:radio];
    
    _radioBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, radio.bottom-1, mScreenWidth/items.count, 1)];
    _radioBottomImageView.image = [[UIImage imageWithColor:REDFONTCOLOR size:_radioBottomImageView.frame.size] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [self.titleView addSubview:_radioBottomImageView];
    
    
    // 水平滚动的ScrollView
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, radio.bottom+10, mScreenWidth, mScreenHeight-100)];
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
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(mScreenWidth*i, 0, mScreenWidth, _baseScrollView.height)];
        [_baseScrollView addSubview:_baseView];
        
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:_baseView.bounds];
        subScrollView.clipsToBounds = NO;
        subScrollView.tag = i;
        [_baseView addSubview:subScrollView];
        switch (i) {
            case 0:
                [self loadFirstViewWithScrollView:subScrollView];
                break;
            case 1:
                [self loadThirdViewWithScrollView:subScrollView];
                break;
            default:
                break;
        }
    }
}
//TODO:重新加载存储的数据
- (void)reloadStoreData
{
    _cArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++)
    {
        NSMutableArray *array = [NSMutableArray array];
        [_cArray addObject:array];
    }
}

#pragma mark -- 加载自选界面
- (void)loadFirstViewWithScrollView:(UIScrollView *)scrollView {
    CGFloat varHeight = 0.0;
    _fristContainView = [UIView viewWithFrame:CGRectZero];
    for (int i = 1; i < 6; i++)
    {
        ColorLabel *l1 = NULL;
        l1 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, varHeight + _topOffset) text:[NSString stringWithFormat:@"%@位",getChinseHundred(i)]  color:REDFONTCOLOR];
        [_fristContainView addSubview:l1];
   
        ColorLabel *l2 = [[ColorLabel alloc] initWithPosition:ccp(l1.right,varHeight + _topOffset) text:LocStr(@"  已选        个 (可选1-10个)") color:NAVITITLECOLOR];
        [_fristContainView addSubview:l2];
        
        //TODO:摇一摇按钮
        if(i==1)
        {
            
        UIButton *conShake = [[UIButton alloc]initWithFrame:mRectMake(mScreenWidth-90, l1.origin.y-5, 90, l1.height+8)];
        [conShake setImage:mImageByName(@"ctzq_yaoyiyao1") forState:UIControlStateNormal];
            [conShake addTarget:self action:@selector(getOneResultWithClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fristContainView addSubview:conShake];
            
        }
        
        ColorLabel *cFront = [[ColorLabel alloc] initWithFrame:CGRectMake(l2.left + 35.0,l2.top,25.0,l2.height) number:0 aligment:NSTextAlignmentCenter];
        [cFront setTag:i];
        [_fristContainView addSubview:cFront];
        [cFrontGroup[0] addObject:cFront];

        //TODO:画球的方法
        UIView *c1=[self drawSamllBallView:10 withPosition:ccp(_topOffset+2,l2.bottom+5) redOrBlue:kColorRed callback:@selector(ballSelected:) selectBallArray:[_cArray objectAtIndex:i - 1]];
        [c1 setTag:i*1000];
        [_fristContainView addSubview:c1];
        [_fristContainView setWidth:c1.width];
        [_fristContainView setHeight:c1.bottom];

        varHeight = i * (c1.height+l1.height+8);
    }
    
    // 缩放到适应屏幕
    [scrollView addSubview:_fristContainView];
    [scrollView setContentHeight:_fristContainView.height];
}

#pragma mark -- 加载机选视图
- (void)loadThirdViewWithScrollView:(UIScrollView *)scrollView
{
    NSMutableArray *rowArray = [NSMutableArray array];
    for (int row = 0; row < self.selectPickerIndex; row ++)
    {
        NSMutableArray *ball = getRadomNumberFromZero(5, 9);
        [rowArray addObject:ball];
    }
    //摇一摇段头
    UIView *subView = [self loadRadomSelectViewTitleView];
    subView.frame = mRectMake(mScreenWidth, -10, subView.width, subView.height);
    [_baseScrollView addSubview:subView];
    
    
    //球组视图
    containView = [[BallGroupContianView alloc] initWithFrame:CGRectMake(5,subView.bottom+10, scrollView.width-10, scrollView.height-subView.height+10) ballGroup:rowArray format:@"d"];
    [containView setTarget:self];
    [scrollView addSubview:containView];
    // 缩放适应屏幕大小
    [scrollView setContentHeight:subView.bottom+containView.height];
}

//TODO:机选一注
-(BetResult *)randomOneResult
{
    NSMutableArray *ball = getRadomNumberFromZero(5, 9);
    BetResult *result = [[BetResult alloc] init];
    [result setNumbers:[ball componentsJoinedByFormat:@"%i"]];
    [result setPlay_code:GET_INT(pPL5_Danshi]);
    return result;
}

#pragma mark --- 
- (void)getOneResultWithClick:(UIButton*)sender
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //  清楚所有数据
    [self clearAllDataAndGetNewFiveNumber];
    // 拿到每个球按钮的父视图
    for (int i = 1; i < 6; i++) {
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
        for (ColorLabel *label in cFrontGroup[0])
        {
            if (label.tag == ballView.superview.tag/1000) {
                label.text = [NSString stringWithFormat:@"%d",(int)[_ary count]];
            }
        }
    }
    // 计算注数
    [self checkTotal];
    
}
     
#pragma mark ---- 摇一摇响应的方法 ----------
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
   
    if (event.subtype == UIEventSubtypeMotionShake && _selectIdx == 1)
    {
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        // Put in code here to handle shake
        UIScrollView *scrollView = (UIScrollView *)[_baseView viewWithTag:1];
        // 先移除，再重新加载界面
        [scrollView removeAllSubviews];
        [self loadThirdViewWithScrollView:scrollView];
        // 计算注数和钱数
        [self actionSelected:nil];
    }
    
    if (event.subtype == UIEventSubtypeMotionShake && _selectIdx == 0)
    {
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //  清楚所有数据
        [self clearAllDataAndGetNewFiveNumber];
        // 拿到每个球按钮的父视图
        for (int i = 1; i < 6; i++) {
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
{
    return YES;
}

#pragma mark --- 球的选择 ------------
- (void)ballSelected:(BallView *)ballView
{
    [super vibrateWhenSelectBall];
    ballView.selected = !ballView.selected;
    [ballView isSelectedWithChange];
    
    // 取出二维数组里的数组
    NSMutableArray *_ary = [_cArray objectAtIndex:(ballView.superview.tag - 1)/1000];

    if (ballView.selected)
    {
        [_ary addObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray addObject:ballView];
    }
    else{
        [_ary removeObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray removeObject:ballView];
    }
    
    for (ColorLabel *label in cFrontGroup[0])
    {
        if (label.tag == ballView.superview.tag/1000)
        {
            label.text = [NSString stringWithFormat:@"%d",(int)[_ary count]];
        }
    }
    
    [self checkTotal];
}
#pragma 检测总额 ------------
- (void)checkTotal
{
    if ([_cArray subCount] >= 1)
    {
        // 注数
        int _numberOfBet = 1;
        for (int i = 0; i < [_cArray count]; i++)
        {
            int jishu = (int)[[_cArray objectAtIndex:i] count];
            int total = 0;
            if (jishu > 1)
                total += jishu;
            
            _numberOfBet *= total ?:1;
            
        }
        self.numberLabel.text = [NSString stringWithFormat:@"%d 注",_numberOfBet];
        self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",_numberOfBet * 2];
    }
    else
    {
        [self resetTotalValue];
    }
}
#pragma mark -------- 读取请求结果 ------------
-(BetResult *)readBetResult
{
    NSInteger _amount = 0;
    NSInteger _subCode = 0;
    NSString *_betString = NULL;
    BetResult *result = [[BetResult alloc] init];
    [result setLot_pk:_lottery_pk];
    
    if (_selectIdx == 0)
    {
        //直选
        if ([_cArray subCount] < 1)
        {
            [SVProgressHUD showInfoWithStatus:(@"请最少选择一注")];
            return nil;
        }
        int _numberOfBet = 1;
        
        for (int i = 0; i < [_cArray count]; i++)
        {
            int jishu = (int)[[_cArray objectAtIndex:i] count];
            int total = 0;
            if (jishu > 1)
                total += jishu;
            _numberOfBet *= total ?:1;
        }
        
        if (_numberOfBet < 1)
        {
            [SVProgressHUD showInfoWithStatus:(@"请最少选择一注")];
            return nil;
        }
        
        if (_numberOfBet > 1)
        {
            _subCode = pPL5_Fushi;
            _betString = [_cArray formatArrayByString:@"%d" joinedByString:@"#"
                                             needSort:YES];
        } else
        {
            _subCode = pPL5_Danshi;
            _betString = [_cArray formatArrayByString:@"%d" joinedByString:@""
                                             needSort:NO];
        }
        
        _amount = _numberOfBet;
    }
    else if (_selectIdx == 1)
    {
        //机选
        _subCode = pPL5_Danshi;
        _amount = (int)[[containView getBallGroup] count];
        if (_amount < 1)
        {
            [SVProgressHUD showInfoWithStatus:(@"请最少选择一注")];
            return nil;
        }
        _betString = [[containView getBallGroup] formatArrayByString:@"%d"
                                                      joinedByString:@"#"
                                                            needSort:NO];
    }
    
    // 通知选号结果返回
    [result setZhushu:_amount];            // 选择的注数
    [result setNumbers:_betString];         // 选择的倍数
    [result setPlay_code:GET_INT(_subCode)];  // 复式还是胆托
    return result;
}

#pragma mark ---------RootViewContorller Event------------
- (void)betAction:(id)sender
{
    int tag = (int)[sender tag];
    
    if (tag == TAG_BET_CLEAR) {
        
        if (_selectIdx == 0)
        {
            [self clearAllDataAndGetNewFiveNumber];
        }
        else if (_selectIdx == 1)
        {
            self.numberLabel.text = @"0 注";
            self.totalLabel.text =  @"0 元";
            [containView removeScrollView];
        }
    }
    else
    {
        [super betAction:sender];
    }
}

//TODO:选择玩注数的变化
- (void)actionSelected:(UISegmentedControl *)sender {
    UIScrollView *scrollView = (UIScrollView *)[_baseView viewWithTag:1];
    [scrollView removeAllSubviews];
    self.numberLabel.text = [NSString stringWithFormat:@"%d 注",(int)self.selectPickerIndex];
    self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",(int)self.selectPickerIndex* 2];
    [self loadThirdViewWithScrollView:scrollView];
}
     
 //TODO:重新生成 按默认5注
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
        // 清楚数据
        [self clearAllDataAndGetNewFiveNumber];
        
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
    }else{
        
    }
    lasteSelectIndex = _selectIdx;
}
     
//TODO:UIRadioControl点击方法
- (void)radioValueChanged:(UIRadioControl *)sender
{
    _selectIdx = (int)sender.selectedIndex;
    if (lasteSelectIndex != _selectIdx)
    {// 和上次选中的不一样
        // 清除数据
        [self clearAllDataAndGetNewFiveNumber];
        // 图片动画
        _radioBottomImageView.left = _radioBottomImageView.width*_selectIdx;
        [_baseScrollView setContentOffset:CGPointMake(_baseScrollView.width*_selectIdx, 0) animated:YES];
        
        if (_selectIdx == 1)
        {
            [self resetThirdViewWithScrollView];
        }
        // 机选则显示机选多期按钮
        [bet_fav setHidden:_selectIdx==1];
        [bet_random setHidden:_selectIdx!=1];
    }
    else
    {
        
    }
    // 记录上次选中的ID
    lasteSelectIndex = _selectIdx;
}

@end
