//
//  DLTViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/8/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "SSQViewController.h"
#import "BetCartViewController.h"

#define RADIOCONTROL_TAG 11111

@implementation SSQViewController

#pragma mark -- 入口
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    // 自选
    _zixuanRedBall = [[NSMutableArray alloc] init];
    _zixuanBlueBall = [[NSMutableArray alloc] init];
    
    // 胆拖
    _redDan = [[NSMutableArray alloc] init];
    _redTuo = [[NSMutableArray alloc] init];
    _blueBall = [[NSMutableArray alloc] init];
    
    _selectedBallArray = [[NSMutableArray alloc] init];
    
    // 创建水平滚动的ScrollView以及其子视图
    [self _initBaseSubViews];
    
    [self bringToFront];
    
    _topOffset = 5.0;

}



#pragma mark -- 创建水平滚动的ScrollView以及其子视图 --
-(void)_initBaseSubViews
{
    NSArray *items = @[LocStr(@"自选"),LocStr(@"胆拖"),LocStr(@"机选")];
    radio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,0, mScreenWidth,37) items:items];
    if (self.selectType == 1) radio.selectedIndex = 2;
    else radio.selectedIndex = 0;
    _selectIdx = (int)radio.selectedIndex;
    radio.tag = RADIOCONTROL_TAG;
    
    [radio addTarget:self action:@selector(radioValueChanged:)
    forControlEvents:UIControlEventTouchUpInside];
    [radio setTitleColor:REDFONTCOLOR forState:UIControlStateSelected];
    [self.titleView addSubview:radio];
    
    _radioBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, radio.bottom-1, mScreenWidth/items.count, 1)];
    _radioBottomImageView.image = [[UIImage imageWithColor:REDFONTCOLOR size:_radioBottomImageView.frame.size] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [self.titleView addSubview:_radioBottomImageView];
    
    // 水平滚动的ScrollView
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, radio.bottom+0.5,  mScreenWidth, mScreenHeight-148)];
    _baseScrollView.clipsToBounds = NO;
    _baseScrollView.backgroundColor = REDFONTCOLOR;
    _baseScrollView.contentSize = CGSizeMake( mScreenWidth*items.count, _baseScrollView.height);
    _baseScrollView.bounces = NO; // 设置不反弹
    _baseScrollView.showsVerticalScrollIndicator = NO; // 隐藏水平条
    _baseScrollView.delegate = self;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseScrollView];
    
    // 创建水平滚动视图的子视图
    for (int i = 0; i < items.count; i++) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake( mScreenWidth*i, 0,  mScreenWidth, _baseScrollView.height-25)];
        [_baseScrollView addSubview:_baseView];
        
        switch (i)
        {
#pragma mark -- 自选
            case 0:
            {
                UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:_baseView.bounds];
                subScrollView.clipsToBounds = YES;
                subScrollView.tag = i;
                [_baseView addSubview:subScrollView];
                
                [self loadFirstViewWithScrollView:subScrollView];
            }break;
#pragma mark -- 胆拖
            case 1:
            {
                CGRect frame = CGRectMake(10,0,mScreenWidth,20);
                UIColor *red = REDFONTCOLOR;
                front_dan=[[ColorLabel alloc] initWithFrame:frame color:red];
                frame.origin.y = 20;
                front_tuo=[[ColorLabel alloc] initWithFrame:frame color:red];
                frame.origin.y = 40;
                fear_dan=[[ColorLabel alloc] initWithFrame:frame color:BLUEBALLCOLOR];
                
                [front_dan setText:LocStr(@"红球胆:")];
                [front_tuo setText:LocStr(@"红球拖:")];
                [fear_dan setText:LocStr(@"蓝球:")];
                
                [_baseView addSubview:front_dan];
                [_baseView addSubview:front_tuo];
                [_baseView addSubview:fear_dan];
                
                UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, fear_dan.bottom+5,  mScreenWidth, _baseView.height-fear_dan.bottom-5)];
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

#pragma mark -- 清除自选中的数据
-(void)clearZixuanData
{
    //清除数组中的值
    [_zixuanRedBall removeAllObjects];
    [_zixuanBlueBall removeAllObjects];
    
    //清除label的值
    zixuan_front.text = @"0";
    zixuan_fear.text = @"0";
    
    // 基本的数据清楚
    [self clearBaseData];
}

#pragma mark  -- 清除胆拖中的数据
-(void)clearDantuoData
{
    //清除数组中的值
    [_redDan removeAllObjects];
    [_redTuo removeAllObjects];
    [_blueBall removeAllObjects];
    
    //清除label的值
    cFront0.text = @"0";
    cFront1.text = @"0";
    cFear0.text = @"0";
    
    front_dan.text = @"红球胆:";
    front_tuo.text = @"红球拖:";
    fear_dan.text  = @"蓝球:";
    
    // 基本的数据清楚
    [self clearBaseData];
}

#pragma mark -- 基本的数据清楚
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

#pragma mark -- 创建自选视图
- (void)loadFirstViewWithScrollView:(UIScrollView *)scrollView
{
    _fristContainView = [UIView viewWithFrame:CGRectZero];
    ColorLabel *l1 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, _topOffset+10) text:LocStr(@"红球:") color:REDFONTCOLOR];
    [_fristContainView addSubview:l1];
    ColorLabel *l2 = [[ColorLabel alloc] initWithPosition:ccp(l1.right, _topOffset+10) text:LocStr(@"  已选      个 (可选6-18个)") color:NAVITITLECOLOR];
    [_fristContainView addSubview:l2];
    
    //TODO:摇一摇按钮
        UIButton *conShake = [[UIButton alloc]initWithFrame:mRectMake(mScreenWidth-90, l1.origin.y-8, 90, l1.height+18)];
        [conShake setImage:mImageByName(@"ctzq_yaoyiyao1") forState:UIControlStateNormal];
    [conShake addTarget:self action:@selector(getOneResultWithClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fristContainView addSubview:conShake];
    
    zixuan_front = [[ColorLabel alloc] initWithFrame:CGRectMake(l2.left + 35.0,l2.top,25.0,l2.height) number:0 aligment:NSTextAlignmentCenter];
    [_fristContainView addSubview:zixuan_front];
    
    //画33个红球
    UIView *c1 = [self drawBallView:33 withPosition:ccp(_topOffset+5,l2.bottom + 5.0) redOrBlue:kColorRed callback:@selector(qianqu0BallSelected:) selectBallArray:_zixuanRedBall];
    [_fristContainView addSubview:c1];
    
    //    //分割线
    //    [XHDHelper addDivLineWithFrame:mRectMake(0,l3.origin.y-10 -0.5, c1.width, 0.5) SuperView:c1];
    
    ColorLabel *l3 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, c1.bottom + 10.0) text:LocStr(@"蓝球:") color:BLUEBALLCOLOR];
    [_fristContainView addSubview:l3];
    

    //画篮球
    ColorLabel *l4 = [[ColorLabel alloc] initWithPosition:ccp(l3.right, c1.bottom + 10.0) text:LocStr(@"  已选      个 (可选1-16个)") color:NAVITITLECOLOR];
    [_fristContainView addSubview:l4];
    
    zixuan_fear = [[ColorLabel alloc] initWithFrame:CGRectMake(l4.left + 35.0,l4.top,25.0,l4.height) number:0 aligment:NSTextAlignmentCenter];
    zixuan_fear.textColor = BLUEBALLCOLOR;
    [_fristContainView addSubview:zixuan_fear];
    
    //画16个人蓝球
    UIView *c2 = [self drawBallView:16 withPosition:ccp(_topOffset+5,l4.bottom + 5.0) redOrBlue:kColorBlue callback:@selector(houqu0BallSelected:) selectBallArray:_zixuanBlueBall];
    [_fristContainView addSubview:c2];
    [_fristContainView setHeight:c2.bottom];
    [_fristContainView setWidth:c2.width];
    [scrollView addSubview:_fristContainView];
    [scrollView setContentHeight:_fristContainView.height];
}
#pragma mark -- 胆拖的选择视图
- (void)loadSecondViewWithScrollView:(UIScrollView *)scrollView
{
    CGRect frame = CGRectMake(_topOffset,0,mScreenWidth-20,20);
    
    UIView *container = [UIView viewWithFrame:CGRectZero];
    ColorLabel *l1 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, _topOffset) text:LocStr(@"红球胆:") color:REDFONTCOLOR];
    
    [container addSubview:l1];
    ColorLabel *l2 = [[ColorLabel alloc] initWithPosition:ccp(l1.right, _topOffset) text:LocStr(@"  已选      个 (可选1-5个)") color:NAVITITLECOLOR];
    [container addSubview:l2];
    
    frame = CGRectMake(l2.left+35,l2.top,25,l2.height);
    cFront0 = [[ColorLabel alloc] initWithFrame:frame number:0
                                       aligment:NSTextAlignmentCenter];
    [container addSubview:cFront0];
    
    UIView *c1 = [self drawBallView:33 withPosition:ccp(_topOffset+5,l2.bottom + 5.0) redOrBlue:kColorRed callback:@selector(dantuo_qianqu_dan_selected:) selectBallArray:_redDan];
    [container addSubview:c1];
    
    ColorLabel *l3 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, c1.bottom + 10.0) text:LocStr(@"红球拖:") color: REDFONTCOLOR ];
    [container addSubview:l3];
    
    ColorLabel *l4 = [[ColorLabel alloc] initWithPosition:ccp(l3.right, c1.bottom + 10.0) text:LocStr(@"  已选      个 (前胆+前拖>＝7个)") color:NAVITITLECOLOR];
    [container addSubview:l4];
    
    cFront1 = [[ColorLabel alloc] initWithFrame:CGRectMake(l4.left + 35.0,l4.top,25.0,l4.height) number:0 aligment:NSTextAlignmentCenter];
    [container addSubview:cFront1];
    
    UIView *c2 = [self drawBallView:33 withPosition:ccp(_topOffset+5,l4.bottom + 5.0) redOrBlue:kColorRed callback:@selector(dantuo_qianqu_tuo_selected:) selectBallArray:_redTuo];
    [container addSubview:c2];
    
    //TODO:篮球
    ColorLabel *f1 = [[ColorLabel alloc] initWithPosition:ccp(_topOffset+10, c2.bottom + 5.0) text:LocStr(@"蓝球:") color:BLUEBALLCOLOR];
    [container addSubview:f1];
    ColorLabel *f2 = [[ColorLabel alloc] initWithPosition:ccp(f1.right, c2.bottom + 5.0) text:LocStr(@"  已选      个 (可选1-16个)") color:NAVITITLECOLOR];
   
    [container addSubview:f2];
    
    cFear0 = [[ColorLabel alloc] initWithFrame:CGRectMake(f2.left + 35.0,f2.top,25.0,f2.height) number:0 aligment:NSTextAlignmentCenter];
    cFear0.textColor = BLUEBALLCOLOR;
    [container addSubview:cFear0];
    
    UIView *v1 = [self drawBallView:16 withPosition:ccp(_topOffset+5,f2.bottom + 5.0) redOrBlue:kColorBlue callback:@selector(dantuo_houqu_dan_selected:) selectBallArray:_blueBall];
    [container addSubview:v1];
    
    
    [container setHeight:v1.bottom];
    [container setWidth:v1.width];
    [scrollView addSubview:container];
    [scrollView setContentHeight:container.height];
}
#pragma mark -- 机选视图
- (void)loadThirdViewWithScrollView:(UIScrollView *)scrollView
{
    NSMutableArray *rowArray = [NSMutableArray array];
    for (int row = 0; row < self.selectPickerIndex; row ++)
    {
        NSMutableArray *ball = [NSMutableArray array];
        NSArray *red =  getUnRepeatRadomNumber(6, 33);
        [ball addObjectsFromArray:[red sort]];
       [ball addObject:[NSString stringWithFormat:@"%d",-1]];
        NSArray *blue = getUnRepeatRadomNumber(1, 16);
        [ball addObjectsFromArray:[blue sort]];
        [rowArray addObject:ball];
    }
    //段头
    UIView *subView = [self loadRadomSelectViewTitleView];
    [scrollView addSubview:subView];
    [subView setTop:0];
    
    containView = [[BallGroupContianView alloc] initWithFrame:CGRectMake(5, subView.bottom+10, scrollView.width-10, scrollView.height-subView.height) ballGroup:rowArray];
    [containView setTarget:self];
    [scrollView addSubview:containView];
    [scrollView setContentHeight:subView.bottom+containView.height];
    if (!isFrist)
    {
        _numberOfBet = (int)rowArray.count;
    }
}


#pragma mark -- 机选一注
-(BetResult *)randomOneResult
{
    BetResult *result = [[BetResult alloc] init];
    NSMutableArray *ball = [NSMutableArray array];
    NSArray *red =  getUnRepeatRadomNumber(6, 33);
    [ball addObjectsFromArray:[red sort]];
    NSArray *blue = getUnRepeatRadomNumber(1, 16);
    [ball addObjectsFromArray:[blue sort]];
    [result setNumbers:[ball componentsJoinedByFormat:@"%02d"]];
    [result setPlay_code:GET_INT(pSSQ_Danshi)];
    return result;
}

#pragma mark -- 点击摇一摇按钮获取机选一注
- (void) getOneResultWithClick:(UIButton*)sender
{
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    // 清除自选时的数据数据
    if (_zixuanRedBall.count != 0)
    {
        [self clearZixuanData];
    }
    UIView *baseView_qianQu = [[_fristContainView subviews] objectAtIndex:4];
    for (int i = 0; i < 6; i++)
    {// 随机出6个
        int m = randomValueBetween(1, 33);
        NSMutableArray *array = [NSMutableArray arrayWithArray:_zixuanRedBall];
        for (NSNumber *element in array)
        {
            if (m == [element intValue])
            {// 如果有选择一样的
                // 重复选一次，并将上次一样的数据删除
                i--;
                [_zixuanRedBall removeObject:[NSNumber numberWithInt:m]];
                BallView *ballView = (BallView *)[baseView_qianQu viewWithTag:m];
                [_selectedBallArray removeObject:ballView];
                continue;
            }
        }
        BallView *ballView = (BallView *)[baseView_qianQu viewWithTag:m];
        ballView.selected = YES;
        [ballView isSelectedWithChange];
        // 将号码存入数组
        [_zixuanRedBall addObject:[NSNumber numberWithInt:m]];
        [_selectedBallArray addObject:ballView];
    }
    zixuan_front.text = [NSString stringWithFormat:@"%d",(int)[_zixuanRedBall count]];
    
    // 自选蓝球
    UIView *baseView_houQu = [[_fristContainView subviews] objectAtIndex:8];
    for (int i = 0; i < 1; i++)
    {// 随机出1个
        int m = randomValueBetween(1, 16);
        NSMutableArray *array = [NSMutableArray arrayWithArray:_zixuanBlueBall];
        for (NSNumber *element in array)
        {
            if (m == [element intValue])
            {// 如果有选择一样的
                // 重复选一次，并将上次一样的数据删除
                i--;
                [_zixuanBlueBall removeObject:[NSNumber numberWithInt:m]];
                BallView *ballView = (BallView *)[baseView_houQu viewWithTag:m];
                [_selectedBallArray removeObject:ballView];
                continue;
            }
        }
        BallView *ballView = (BallView *)[baseView_houQu viewWithTag:m];
        ballView.selected = YES;
        [ballView isSelectedWithChange];
        // 将号码存入数组
        [_zixuanBlueBall addObject:[NSNumber numberWithInt:m]];
        [_selectedBallArray addObject:ballView];
    }
    zixuan_fear.text = [NSString stringWithFormat:@"%d",(int)[_zixuanBlueBall count]];
    // 计算注数
    [self checkTotal];

}
#pragma mark -- 传感器结束
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
        if (_zixuanRedBall.count != 0)
        {
            [self clearZixuanData];
        }
        // 自选红球
        // 首先拿到放小球的父视图
#pragma mark -- 获取机选球数
        UIView *baseView_qianQu = [[_fristContainView subviews] objectAtIndex:4];
        for (int i = 0; i < 6; i++)
        {// 随机出6个
            int m = randomValueBetween(1, 33);
            NSMutableArray *array = [NSMutableArray arrayWithArray:_zixuanRedBall];
            for (NSNumber *element in array)
            {
                if (m == [element intValue])
                {// 如果有选择一样的
                    // 重复选一次，并将上次一样的数据删除
                    i--;
                    [_zixuanRedBall removeObject:[NSNumber numberWithInt:m]];
                    BallView *ballView = (BallView *)[baseView_qianQu viewWithTag:m];
                    [_selectedBallArray removeObject:ballView];
                    continue;
                }
            }
            BallView *ballView = (BallView *)[baseView_qianQu viewWithTag:m];
            ballView.selected = YES;
            [ballView isSelectedWithChange];
            // 将号码存入数组
            [_zixuanRedBall addObject:[NSNumber numberWithInt:m]];
            [_selectedBallArray addObject:ballView];
        }
        zixuan_front.text = [NSString stringWithFormat:@"%d",(int)[_zixuanRedBall count]];
        
#pragma mark -- 获取机选篮球数
        // 自选蓝球
        UIView *baseView_houQu = [[_fristContainView subviews] objectAtIndex:8];
        for (int i = 0; i < 1; i++)
        {// 随机出1个
            int m = randomValueBetween(1, 16);
            NSMutableArray *array = [NSMutableArray arrayWithArray:_zixuanBlueBall];
            for (NSNumber *element in array)
            {
                if (m == [element intValue])
                {// 如果有选择一样的
                    // 重复选一次，并将上次一样的数据删除
                    i--;
                    [_zixuanBlueBall removeObject:[NSNumber numberWithInt:m]];
                    BallView *ballView = (BallView *)[baseView_houQu viewWithTag:m];
                    [_selectedBallArray removeObject:ballView];
                    continue;
                }
            }
            BallView *ballView = (BallView *)[baseView_houQu viewWithTag:m];
            ballView.selected = YES;
            [ballView isSelectedWithChange];
            // 将号码存入数组
            [_zixuanBlueBall addObject:[NSNumber numberWithInt:m]];
            [_selectedBallArray addObject:ballView];
        }
        zixuan_fear.text = [NSString stringWithFormat:@"%d",(int)[_zixuanBlueBall count]];
        // 计算注数
        [self checkTotal];
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
    {
        [super motionEnded:motion withEvent:event];
    }
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark -- 自选红球球不能超过多少的限制---
- (void)qianqu0BallSelected:(BallView *)ballView
{
    if ([_zixuanRedBall count] >= 18 && !ballView.selected)
    {
        [SVProgressHUD showInfoWithStatus:@"已选球数已超过限制"];
        return;
    }
   // 选号震动
    [super vibrateWhenSelectBall];
    
    ballView.selected = !ballView.selected;
    [ballView isSelectedWithChange];
    
    if (ballView.selected)
    {
        [_zixuanRedBall addObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray addObject:ballView];
    } else
    {
        [_zixuanRedBall removeObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray removeObject:ballView];
    }
    zixuan_front.text = [NSString stringWithFormat:@"%d",(int)[_zixuanRedBall count]];
    
    [self checkTotal];
}
#pragma mark -- 自选蓝球球不能超过多少的限制----
- (void)houqu0BallSelected:(BallView *)ballView
{
    // 选号震动
    [super vibrateWhenSelectBall];
    
    ballView.selected = !ballView.selected;
    [ballView isSelectedWithChange];
    
    if (ballView.selected)
    {
        [_zixuanBlueBall addObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray addObject:ballView];
        
    } else
    {
        [_zixuanBlueBall removeObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray removeObject:ballView];
    }
    
    zixuan_fear.text = [NSString stringWithFormat:@"%d",(int)[_zixuanBlueBall count]];
    
    [self checkTotal];
}

#pragma mark -- 胆拖action
- (void)dantuo_qianqu_dan_selected:(BallView *)ballView {
    // 将拖码区选中的球用isRepeat标记
    BOOL isRepeat = NO;
    for (int i = 0; i < [_redTuo count]; i++)
    {
        if (ballView.tag == [[_redTuo objectAtIndex:i] intValue])
        {
            isRepeat = YES;
            break;
        }
    }
    //
    if (isRepeat && !ballView.selected)
    {
        [SVProgressHUD showInfoWithStatus:@"红球拖码中已经包含此球"];
        return;
    } else if ([_redDan count] >= 5 && !ballView.selected)
    {
        [SVProgressHUD showInfoWithStatus:@"红球胆码最多5个"];
        return;
    }
    
    [super vibrateWhenSelectBall];
     ballView.selected = !ballView.selected;
    [ballView isSelectedWithChange];
    
    if (ballView.selected)
    {
        [_redDan addObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray addObject:ballView];
    }
    else
    {
        [_redDan removeObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray removeObject:ballView];
    }
    
    cFront0.text = [NSString stringWithFormat:@"%d",(int)[_redDan count]];
    front_dan.text = [NSString stringWithFormat:@"红球胆:  %@", [[_redDan sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
    
    // 计算注数
    [self checkTotal];
}
#pragma mark -- 红球拖码选择
- (void)dantuo_qianqu_tuo_selected:(BallView *)ballView
{
    BOOL isRepeat = NO;
    for (int i = 0; i < [_redDan count]; i++)
    {
        if (ballView.tag == [[_redDan objectAtIndex:i] intValue])
        {
            isRepeat = YES;
            break;
        }
    }
    
    if (isRepeat && !ballView.selected)
    {
        [SVProgressHUD showInfoWithStatus:@"红球胆码中已经包含此球"];
        return;
    }
    
    [super vibrateWhenSelectBall];
    ballView.selected = !ballView.selected;
    [ballView isSelectedWithChange];
    
    if (ballView.selected){
        [_redTuo addObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray addObject:ballView];
    } else {
        [_redTuo removeObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray removeObject:ballView];
    }
    
    cFront1.text = [NSString stringWithFormat:@"%d",(int)[_redTuo count]];
    front_tuo.text = [NSString stringWithFormat:@"红球拖:  %@", [[_redTuo sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
    
    [self checkTotal];
}

#pragma mark---胆拖蓝球(篮球)选择 ---
- (void)dantuo_houqu_dan_selected:(BallView *)ballView
{
    BOOL isRepeat = NO;
    for (int i = 0; i < [_blueBall count]; i++)
    {
        if (ballView.tag==[[_blueBall objectAtIndex:i] intValue])
        {
            isRepeat = YES;
            break;
        }
    }
    
    [super vibrateWhenSelectBall];
    
    ballView.selected = !ballView.selected;
    [ballView isSelectedWithChange];
    
    if (ballView.selected)
    {
        [_blueBall addObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray addObject:ballView];
    }
    else
    {
        [_blueBall removeObject:[NSNumber numberWithInt:(int)ballView.tag]];
        [_selectedBallArray removeObject:ballView];
    }
    
    cFear0.text = [NSString stringWithFormat:@"%d",(int)[_blueBall count]];
    fear_dan.text = [NSString stringWithFormat:@"蓝球:  %@", [[_blueBall sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
    
    [self checkTotal];
}

#pragma mark -- 计算注数 ------
- (void)checkTotal
{
    _numberOfBet = 0;
    
#pragma mark -- 自选注数计算
    if(_selectIdx == 0)
    {
        if ([_zixuanRedBall count] >= 6 && [_zixuanBlueBall count] >= 1)
        {
            int _numberOfBet0 = combination((int)[_zixuanRedBall count],6);
            int _numberOfBet1 = combination((int)[_zixuanBlueBall count],1);
            
            _numberOfBet = _numberOfBet0 * _numberOfBet1;
        }
    }
#pragma mark -- 胆拖注数计算
    else if(_selectIdx == 1)
    {
        int qiandan=(int)_redDan.count;
        int qiantuo=(int)_redTuo.count;
        int houdan=(int)_blueBall.count;
        
        if (qiandan+qiantuo >= 6 && houdan>0)
        {
            if(qiandan>0 || houdan>0)
            {
                _numberOfBet = combination(qiantuo, 6-qiandan);
                _numberOfBet *= houdan;
            }
        }
    }
    //结果
    [_numberLabel setText:[NSString stringWithFormat:@"%d 注",_numberOfBet]];
    [_totalLabel setText:[NSString stringWithFormat:@"共 %d 元",_numberOfBet*2]];
}

#pragma mark -- 选好了按钮的结果返回 ------
-(BetResult *)readBetResult
{
    if(_numberOfBet<=0)
    {
        [SVProgressHUD showInfoWithStatus:@"至少选择一注"];
        return nil;
    }
    
    NSString *_betString = NULL;
    NSInteger _amount = 0,_subCode = 0;
    BetResult *result = [[BetResult alloc] init];
    [result setLot_pk:_lottery_pk];
    
    //TODO:自选
    if (_selectIdx == 0)
    {
        _amount = _numberOfBet;
        
        if (_numberOfBet > 1) //复式
        {
            NSMutableString *mStr = [NSMutableString string];
            [mStr appendFormat:@"%@",[[_zixuanRedBall sort] getNumberStringByFormat:@"%02d" joinedByString:@""]];
            [mStr appendString:@"#"];
            [mStr appendFormat:@"%@",[[_zixuanBlueBall sort] getNumberStringByFormat:@"%02d" joinedByString:@""]];
            
            _betString = mStr;
            _subCode = pSSQ_Fushi;
        }
        else  //双色球单式
        {
            NSMutableArray *_cArray = [NSMutableArray array];
            [_cArray addObjectsFromArray:[_zixuanRedBall sort]];
            [_cArray addObjectsFromArray:[_zixuanBlueBall sort]];
            
            _betString = [_cArray getNumberStringByFormat:@"%02d" joinedByString:@""];
            _subCode = pSSQ_Danshi;
        }
        
    }
    //TODO:胆拖
    else if (_selectIdx == 1)
    {
        if ([_redDan count]+[_redTuo count] < 6)
        {
            [SVProgressHUD showInfoWithStatus:@"前胆+前拖必须大于等于6个！"];
            return nil;
        }
        
        if ([_blueBall count] < 1)
        {
            [SVProgressHUD showInfoWithStatus:@"蓝球必须大于0个！"];
            return nil;
        }
        _subCode = pSSQ_Dantuo;
        _amount = _numberOfBet;
        
#pragma mark -- 拼接结果
        
        NSMutableString *mStr = [NSMutableString string];
        [mStr appendFormat:@"%@",[[_redDan sort] getNumberStringByFormat:@"%02d"
                                                           joinedByString:@""]];
        [mStr appendString:@"#"]; //胆拖分割
        
        [mStr appendFormat:@"%@",[[_redTuo sort] getNumberStringByFormat:@"%02d"
                                                           joinedByString:@""]];
        [mStr appendString:@"#"]; //红蓝分割
        [mStr appendFormat:@"%@",[[_blueBall sort] getNumberStringByFormat:@"%02d"
                                                          joinedByString:@""]];
        
        _betString = mStr;
    }
    else if (_selectIdx == 2)  //单式自选
    {
        _subCode = pSSQ_Danshi;
        _amount = (int)[[containView getBallGroup] count];
        NSMutableArray *adjustArry = [NSMutableArray array];
        NSArray *oldA = [containView getBallGroup];
        for (NSArray *a in oldA)
        {
            NSMutableArray *redBlueA = [NSMutableArray array];
            NSArray *redA = [[a subarrayWithRange:NSMakeRange(0, 6)] sort];
            NSArray *blueA = [[a subarrayWithRange:NSMakeRange(7, 1)] sort];
            [redBlueA addObjectsFromArray:redA];
            [redBlueA addObjectsFromArray:blueA];
            
            [adjustArry addObject:redBlueA];
        }
        
        _betString = [adjustArry formatArrayByString:@"%02d"
                                      joinedByString:@"#"  //单注分割符
                                            needSort:NO];
    }
    [result setZhushu:_amount];
    [result setNumbers:_betString];
    [result setPlay_code:GET_INT(_subCode)];
    return result;
}

// toolBar上按钮的响应方法
- (void)betAction:(id)sender
{
    int tag = (int)[sender tag];
    
    if (tag == TAG_BET_CLEAR) //清除
    {
        [self resetTotalValue];
        
        if (_selectIdx == 0)
        {
           [self clearZixuanData];
        }
        else if (_selectIdx == 1)
        {
            [self clearDantuoData];
        }
        else if (_selectIdx == 2)
        {
            [containView removeScrollView];
            [self clearBaseData];
        }
        
    }else
    {
        [super betAction:sender];  //送彩票&投注
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
#pragma mark -- 更新期数 ----- 要修改
- (void)updateSelectPeriod:(Record *)record
{
    int lottery_code = [record.lottery_code intValue];
    NSString *number = record.number;
    
    self.skipClearArray = YES;
    
    [_redDan removeAllObjects];
    [_redTuo removeAllObjects];
    [_blueBall removeAllObjects];
    
    if (lottery_code == pSSQ_Danshi)
    {
        if ([number rangeOfString:@"#"].length > 0)
        {
            _selectIdx = 2;
            ((UIRadioControl*)[self.titleView viewWithTag:RADIOCONTROL_TAG]).selectedIndex = 2;
            
            NSArray *allBets = [number componentsSeparatedByString:@"#"];
            NSMutableArray *mArray = [NSMutableArray array];
            for (NSString *str in allBets) {
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:0];
                [tmp addObjectsFromArray:[[str splitToNumberArrayByLength:2] subarrayWithRange:NSMakeRange(0,5)]];
                [tmp addObject:[NSNumber numberWithInt:-1]];
                [tmp addObjectsFromArray:[[str splitToNumberArrayByLength:2] subarrayWithRange:NSMakeRange(5,2)]];
                
                [mArray addObject:tmp];
            }
        }
        else {
            _selectIdx = 0;
            ((UIRadioControl*)[self.titleView viewWithTag:RADIOCONTROL_TAG]).selectedIndex = 0;
            
            NSArray *_f = [number splitToNumberArrayByLength:2];
            [_redDan addObjectsFromArray:[_f subarrayWithRange:NSMakeRange(0, 5)]];
            [_redTuo addObjectsFromArray:[_f subarrayWithRange:NSMakeRange(5, 2)]];
            
            [self loadFirstViewWithScrollView:nil];
            [self checkTotal];
        }
    }
    else if (lottery_code == pSSQ_Fushi)
    {
        _selectIdx = 0;
        ((UIRadioControl*)[self.titleView viewWithTag:RADIOCONTROL_TAG]).selectedIndex = 0;
        
        NSArray *tmp = [number componentsSeparatedByString:@"#"];
        NSArray *_f0 = [[tmp objectAtIndex:0] splitToNumberArrayByLength:2];
        NSArray *_f1 = [[tmp objectAtIndex:1] splitToNumberArrayByLength:2];
        
        [_redDan addObjectsFromArray:_f0];
        [_redTuo addObjectsFromArray:_f1];
        
        [self loadFirstViewWithScrollView:nil];
        [self checkTotal];
    }
    else if (lottery_code == pSSQ_Dantuo)
    {
        _selectIdx = 1;
        ((UIRadioControl*)[self.titleView viewWithTag:RADIOCONTROL_TAG]).selectedIndex = 1;
        
        NSDictionary *aDict = [number splitDantuo];
        NSArray *_f0 = [[aDict objectForKey:@"qianqu_dan"] splitToNumberArrayByLength:2];
        NSArray *_f1 = [[aDict objectForKey:@"qianqu_tuo"] splitToNumberArrayByLength:2];
        NSArray *_f3 = [[aDict objectForKey:@"houqu_dan"] splitToNumberArrayByLength:2];
        
        [_redDan addObjectsFromArray:_f0];
        [_redTuo addObjectsFromArray:_f1];
        [_blueBall addObjectsFromArray:_f3];
       
        
        self.titleView.frame = CGRectMake(self.titleView.left,self.titleView.top,self.titleView.width,35.0);
        
        [self loadSecondViewWithScrollView:nil];
        
        fear_dan.text = [NSString stringWithFormat:@"蓝球:  %@", [[_blueBall sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
        front_tuo.text = [NSString stringWithFormat:@"红球拖:  %@", [[_redTuo sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
        front_dan.text = [NSString stringWithFormat:@"红球胆:  %@", [[_redDan sort] getNumberStringByFormat:@"%02d" joinedByString:@" "]];
        
        [self checkTotal];
    }
    [super updateSelectPeriod:nil];
}

#pragma mark  UIScrollView Delegate
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
        // 清楚数据
        if (_selectIdx == 2) {
            [self clearZixuanData];
            [self clearDantuoData];
            [self resetThirdViewWithScrollView];
        }else{
            if (_selectIdx != 0)
            {
                // 清除自选时的数据
                [self clearZixuanData];
            }else
            {
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