//
//  BetCartViewController.m
//  YaBoCaiPiao
//
//  Created by liuchan on 12-8-8.
//  Copyright (c) 2012年 DoMobile. All rights reserved.
//

#import "BetCartViewController.h"
#import "TZBaseViewController.h"
#import "UserInfo.h"
#import "ZLPeoplePickerViewController.h"
#import "TransferSelViewController.h"  //充值控制器
#import "CustomIOS7AlertView.h"
#import "LabelButton.h"
#import "PJNavigationController.h"
#import "BaseBettingNumField.h"
#define TAG_BACK_ALERT 10111   //返回

#import "PJTextField.h"

@interface BetCartViewController () <passTextOfTextField,BaseTextFieldDelegate,UITextFieldDelegate,ZLPeoplePickerViewControllerDelegate>

@end

@implementation BetCartViewController
{
    UIView *TopbgView; //顶部视图
}
// 初始化 --- 最先走这个方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (iOS7)
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        // 隐藏返回按钮，tabbar条
        betResults = [NSMutableArray array];
        [self.navigationItem setHidesBackButton:YES];
        [self setHidesBottomBarWhenPushed:YES];
        [self.view setClipsToBounds:YES];
    }
    return self;
}

// 打开购物车投注页面
+(void)openBetCartWithBetResult:(BetResult *)result controller:(UIViewController *)controller from:(NSString *)fromTitle
{
    BetCartViewController *betCart  = [[BetCartViewController alloc]initWithBetResult:result AndBetTag:0];
    [betCart setFromTitle:fromTitle];
    [controller.navigationController pushViewController:betCart animated:YES];
}

#pragma --- 没有投注记录的时候，第一次进入这个函数（从开奖大厅跳过来）
- (id)initWithLotteryCode:(API_LotteryType) lotCode
{
    if ((self = [super init]))
    {
        // 初始化一些基本参数
        zhushu = 0;
        maxAmount = 0;
        beishu = 1;
        qishu = 1;
        lottery_pk = lotCode;
        [self.view setClipsToBounds:YES];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
        [self.navigationItem setNewTitle:getLotNames(GET_STRING_OF_INT(lottery_pk))];
    }
    return self;
}

/*  根据投注结果初始化*/
-(id)initWithBetResult:(BetResult *)curResult AndBetTag:(NSInteger)bntTag
{
    if ((self = [super init]))
    {
        beishu = qishu = 1;
        zhushu = curResult.zhushu;
        maxAmount = zhushu;
        lottery_pk = [curResult.lot_pk intValue];
        _btnTag = bntTag;
        [self.view setClipsToBounds:YES];
        
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
        [self.navigationItem setNewTitle:getLotNames(curResult.lot_pk)];
        
        if(zhushu > 1 && [self isDanshi:curResult.play_code])
        {
            [self splitMultiDanshiResult:curResult];
            
        } else
        {
            [betResults addObject:curResult];
        }
    }
    
    return self;
}


//TODO:返回按钮动作
-(void)back
{
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.47 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *msg = [NSString stringWithFormat:@"您确定要放弃已选中号码，并返回%@吗？", _fromTitle?_fromTitle:@""];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"放弃选号" message:msg delegate:self cancelButtonTitle:LocStr(@"取消")  otherButtonTitles:LocStr(@"确定"), nil];
        [alert setTag:10111];
        [alert show];
        
    });
    
}

//TODO:取消选号
-(void)cancelChoosedNumber
{
    //先取消选号控制器然后删除投注控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    if(_isFirstChoose)
    {
        [self.navigationController removeViewController:self];
    }

}


#pragma mark -- 入口 ------------------------------ ok
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]];
    
    // 添加单击事件取消TextField的第一响应
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleTextFiledFirstResponder)];
    [self.view addGestureRecognizer:tap];
    
    // 顶部的选择按钮
    [self createTopChooseButton];
    
    // 购物车列表
    CGRect mFrame = CGRectMake(20,TopbgView.bottom+20,mScreenWidth-40,self.view.height-230);

    //TODO:根据选好的号初始化订单列表
    resultView = [[ResultScrollView alloc] initWithFrame:mFrame betArray:betResults];
    [resultView setBackgroundColor:[UIColor clearColor]];
    [resultView setDelegate:self];
    [self.view addSubview:resultView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    // 查询期数
#warning 
  //  [self queryPlayPeriodWithTips:NO];
    
    // 号码为空则进入选号页
    if(betResults.count < 1)
    {
        // 进入选号页面
        [self openChoosePage:nil];
        
    }
    else
    {
        NSLog(@"-dakhlsg---%@ ---hjgkj----",betResults[0]);
    }
    
    // 加载底部按钮
    if (_btnTag == TAG_BET_OK)
    { //选好了
        // 加载过(送彩票)底部视图之后不在加载(选好了)底部试图
        if (_loadedSendCPbottom)
        {
            [self loadSendCPBottomUI];
        }
        else
        {
            if (_bottomView)
            {// 下方视图存在就不加载
                
            }
            else
            {
                [self loadOKBottomUI];  //加载选好了试图
            }
        }
    }
    else if (_btnTag == TAG_BET_SEND) // 送彩票
    {
        _loadedSendCPbottom = 1;
        // 重新设置倍数和期数
        beishu = 1;
        qishu = 1;
        [self loadSendCPBottomUI];
    }
    // 键盘上方的工具按钮(点击可收起键盘)
    [XHDHelper addToolBarOnInputFiled:_telField Action:@selector(cancleTextFiledFirstResponder) Target:self];
    [XHDHelper addToolBarOnInputFiled:_infmField Action:@selector(cancleTextFiledFirstResponder) Target:self];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //如果余额不为空就就改变金额注数
    if(![[UserInfo sharedInstance] Balance])
    {
        [self changeMoneyAndMultiple];
    }
   
    // 注册一个键盘高度改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBottonViewPoint:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    // 取消第一响应者
    [self cancleTextFiledFirstResponder];
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    //移除键盘高度变化通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 视图消失时关闭定时器
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     
}

#pragma mark -- 顶部选择按钮 --------------------- ok
- (void)createTopChooseButton
{
    CGFloat fontSize  = 14.1;
    //背景
    TopbgView = [[UIView alloc]initWithFrame:mRectMake(0, 10,mScreenWidth, 35)];
    TopbgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:TopbgView];
    
    UIImage *buttonLeftOff = [[UIImage imageNamed:@"radio_left_off1"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 10)];
    UIImage *buttonRightOff = [[UIImage imageNamed:@"radio_right_off"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 30)];
    UIImage *buttonLeftOn = [[UIImage imageNamed:@"radio_left_off_hover"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 10)];
    UIImage *buttonRightOn = [[UIImage imageNamed:@"radio_right_off_hover"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 30)];
    
    //自选按钮
    conButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 2.5,TopbgView.width/2.0-20,TopbgView.height-5)];
    [conButton setImage:mImageByName(@"jczq_add") forState:UIControlStateNormal];
    [conButton setImage:mImageByName(@"jczq_add_red") forState:UIControlStateHighlighted];
    [conButton setTitle:LocStr(@"自选一注") forState:UIControlStateNormal];
    [conButton setBackgroundImage:buttonLeftOff forState:UIControlStateNormal];
    [conButton setBackgroundImage:buttonLeftOn forState:UIControlStateHighlighted];
    [conButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    [conButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [conButton setTitleColor:REDFONTCOLOR forState:UIControlStateHighlighted];
    [conButton addTarget:self action:@selector(openChoosePage:) forControlEvents:UIControlEventTouchUpInside];
    [conButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    
    //机选按钮
    ranButton = [[UIButton alloc] initWithFrame:CGRectMake(TopbgView.width/2.0+10, 2.5, TopbgView.width/2.0-20, TopbgView.height-5)];
    [ranButton setTop:conButton.top];
     [ranButton setImage:mImageByName(@"jczq_add") forState:UIControlStateNormal];
    [ranButton setImage:mImageByName(@"jczq_add_red") forState:UIControlStateHighlighted];
    [ranButton setTitle:LocStr(@"机选一注") forState:UIControlStateNormal];
    [ranButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    [ranButton setBackgroundImage:buttonRightOff forState:UIControlStateNormal];
    [ranButton setBackgroundImage:buttonRightOff forState:UIControlStateDisabled];
    [ranButton setBackgroundImage:buttonRightOn forState:UIControlStateHighlighted];
    [ranButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ranButton setTitleColor:REDFONTCOLOR forState:UIControlStateHighlighted];
    [ranButton addTarget:self action:@selector(randomOneNumber) forControlEvents:UIControlEventTouchUpInside];
    [ranButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    
    // 中间的分割线
    UIImageView *lineBlackView = [[UIImageView alloc] initWithFrame:CGRectMake(TopbgView.width/2-0.25, 0, 0.35, TopbgView.height)];
    lineBlackView.alpha = 0.6;
    lineBlackView.backgroundColor = [UIColor lightGrayColor];
    
    [TopbgView addSubview:conButton];
    [TopbgView addSubview:ranButton];
    [TopbgView addSubview:lineBlackView];

}

#pragma mark -- 如果还未选号，就在这里进入选号界面--------- ok
-(void)openChoosePage:(id)sender
{
    [mNotificationCenter removeObserver:self name:NotifyBetConfirmSafari object:nil];
    _isFirstChoose = !sender;
    
    // push到继续选号页面的方法，根据期数跳入
    NSString *vcStr = getLotVCString(lottery_pk);
    Class class =  NSClassFromString(vcStr);
    mController = [(TZBaseViewController*)[class alloc] initWithLotter_pk:GET_INT(lottery_pk) period:period requestCode:_isFirstChoose delegate:self];
    //建导航控制器
    PJNavigationController *myNavController = [[PJNavigationController alloc] initWithRootViewController:mController];
    myNavController.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
    
    /***设为NO的话，送彩票界面没了！！！*/
  //  [self.navigationController addChildViewController:myNavController];
   [self presentViewController:myNavController animated:NO completion:nil];
    
}

#pragma mark -- 初始化基础控制器，机选一注返回给结果控制器 ------ok
-(void)randomOneNumber
{
    // 机选一注按钮点完之后要0.6秒之后允许再点
    [ranButton setEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(enableRandomButton) userInfo:nil repeats:NO];
    
    //初始化基础控制器，返回一注机选结果
    TZBaseViewController *tzCon = [[NSClassFromString(getLotViewController(lottery_pk)) alloc] init];
    BetResult *result = [tzCon randomOneResult];
    [result setZhushu:1];
    [result setLot_pk:GET_INT(lottery_pk)];
    [resultView insertBetResult:result atPositon:0];
}

/*---------------------------------*/
//TODO:允许再次机选
-(void)enableRandomButton
{
    [ranButton setEnabled:YES];
}

#pragma mark -- 追号按钮得响应方法
- (void)showPicker:(id)sender
{
    BOOL showFollow = !isFootBallLottery(lottery_pk); // 判断是否为足彩

    // 显示上方的倍数和期数视图
    PopUpOptionView *popup = [[PopUpOptionView alloc] initWithFrame:CGRectMake(0,mScreenHeight-50,mScreenWidth,50) mutiple:[NSString stringWithFormat:@"%02ld", beishu] period:[NSString stringWithFormat:@"%02ld", qishu-1]  showFollowOption:showFollow];
    
    [popup addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    [popup showInWindow];
}


#pragma --mark 选号成功或取消 ---------------------- ok
-(void)choosedNumber:(BetResult*)item withButtonTag:(NSInteger)buttonTag
{

    if(!item)
    {
        return;
    }
    
    // tag值的传递（判断是“送彩票”还是“选好了”）
    _btnTag = buttonTag;

    if(!betResults)
    {
       betResults = [NSMutableArray array];
    }
    if(item.zhushu > 1 && [self isDanshi:item.play_code])
    {
        // 单式多注拆分成单式一注的形式显示
        [self splitMultiDanshiResult:item];
    }
    else  //只有一注
    {
        [betResults insertObject:item atIndex:0];
    }
    //将投注结果拆分成结果Model，结果视图重新刷新表
    [resultView reloadTableData];
    
    //选号界面dismiss
    [self dismissViewController];
    
}

#pragma mark -------- 判断是不是单式玩法 -----------------ok
-(BOOL)isDanshi:(NSString*)playcode
{
    switch ([playcode intValue])
    {
        case pDLT_Danshi:
        case pSenvenStarLottery_Danshi:
        case pPL3_DirectChoice_Danshi:
        case pPL5_Danshi:
        case pT225_Danshi:
        case pT317_Danshi:
        case pT367_Danshi:
        case pSSQ_Danshi:
            
        return YES;
    }
    return NO;
}

#pragma mark -------- 单式多注拆分成单式一注的形式显示 ----------ok
-(void)splitMultiDanshiResult:(BetResult*)srcResult
{
    NSArray *numArray = [srcResult.numbers componentsSeparatedByString:@"#"];
   
    //组装投注结果
    for (NSString *number in numArray)
    {
        BetResult *result = [[BetResult alloc] init];
        [result setLot_pk:srcResult.lot_pk];
        [result setPlay_code:srcResult.play_code];
        [result setNumbers:number];
        [result setZhushu:1];
        [betResults insertObject:result atIndex:0];
    }
}
#pragma mark -------- 送彩票的底部视图  ----------------要修改赠言界面
-(void)loadSendCPBottomUI
{
    // 先移除，再加载
    if (!_loadedSendCPbottom)
    {
        // 没有加载过送彩票就先移除，加载了就不用移除
        [_bottomView removeAllSubviews];
        [_bottomView removeFromSuperview];
    }
    
    // 移除继续选号，机选一注两个按钮(重新调整resultView的frame)
    if (conButton&&ranButton)
    {
          [resultView setTop:TopbgView.bottom+20];
    }
    
    // 整个底部视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth,80)];
    _bottomView.backgroundColor = [UIColor colorWithRed:0.98  green:0.98 blue:0.98 alpha:1];
    [self addDivlineWithFrame:mRectMake(0, 0, mScreenWidth, 0.4) FatherView:_bottomView];
    
    // 底部视图的中间视图
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, _bottomView.width, 80)];
    [self addDivlineWithFrame:mRectMake(0, middleView.height-2.4, middleView.width, 0.4) FatherView:middleView];
    
    /****** 电话号码 *****/
    if (!_telField)
    {
        // 对方手机号
        UILabel *telLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 80, 30)];
        telLab.tag = 1100;
        telLab.text = @"对方手机号:";
        telLab.font = [UIFont systemFontOfSize:14];
        telLab.backgroundColor = [UIColor clearColor];
        telLab.textAlignment = NSTextAlignmentRight;
        telLab.textColor = [UIColor darkGrayColor];
        
        // 不存在则重新加载，存在则不重新加载（针对于选择联系人设计）
        _telField = [[PJTextField alloc] initWithFrame:CGRectMake(0, telLab.origin.y, middleView.width-10, 30)];
        _telField.placeholder = @"请输入对方手机号";
        _telField.font = [UIFont systemFontOfSize:14];
        _telField.returnKeyType = UIReturnKeyNext;
        _telField.leftView = telLab;
        _telField.backgroundColor  = [UIColor clearColor];
        _telField.keyboardType = UIKeyboardTypeNumberPad;
        _telField.delegate = self;
        _telField.clearButtonMode = UITextFieldViewModeWhileEditing;//编辑的时候显示删除按钮
        _telField.borderStyle = UITextBorderStyleNone;
        
        //[self addDivlineWithFrame:mRectMake(_telField.origin.x, _telField.bottom, _telField.width, 0.4) FatherView:middleView];
    }
    
    /*****调用联系人的按钮*****/
    UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telButton.frame = CGRectMake(_telField.width-40,0,30, 30);
    telButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [telButton setTitleColor:REDFONTCOLOR forState:UIControlStateNormal];
    [telButton setTitleColor:REDFONTCOLOR forState:UIControlStateHighlighted];
    [telButton addTarget:self action:@selector(telButonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *contectBnt = [[UIImageView alloc]initWithFrame:mRectMake(0, 0, 20, 20)];
    contectBnt.image = mImageByName(@"ctzq_link_red");
    contectBnt.center = CGPointMake(telButton.width/2.0, telButton.height/2.0);
    
    [telButton addSubview:contectBnt];
    [_telField addSubview:telButton];
    
    
    /******赠送留言*****/
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, middleView.height/2.0, 80, 30)];
    label2.tag = 1101;
    label2.text = @"赠 送 留 言:";
    label2.font = [UIFont systemFontOfSize:14];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = [UIColor darkGrayColor];
    // 赠言
   _infmField = [[PJTextField alloc] initWithFrame:CGRectMake(0, _telField.bottom, middleView.width-10, label2.height)];
    _infmField.returnKeyType = UIReturnKeyDone;
    _infmField.leftViewMode = UITextFieldViewModeAlways;
    _infmField.font = Font(14);
    _infmField.leftView = label2;
    _infmField.placeholder = @"请输入60字内的赠言（可不填）";
    

    
    [middleView addSubview:_telField];
    [middleView addSubview:_infmField];
    
    // 大乐透追加投注
    if (lottery_pk == lDLT_lottery)
    {
        //追加
        followControl = [[FollowControl alloc] initWithFrame:CGRectMake(_bottomView.width/4.0+7,middleView.bottom+1,_bottomView.width/2.0,30) title:@"追加投注" aDefaultOn:NO];
        [followControl addTarget:self action:@selector(followChanged:)
                forControlEvents:UIControlEventTouchUpInside];
        followControl.backgroundColor = [UIColor clearColor];
        [_bottomView addSubview:followControl];
        [_bottomView setHeight:_bottomView.height+30]; // 底部视图高度加30
        [resultView changeResultHeight:-20];           // 表示图高度减少30
        [_bottomView addSubview:followControl];        //
        
        //分割线
        UIView *divLine = [[UIView alloc]initWithFrame:mRectMake(_bottomView.origin.x, followControl.bottom, _bottomView.width, 0.5)];
        divLine.backgroundColor = DIVLINECOLOR;
        [_bottomView addSubview:divLine];
    }
    
    // 下方3级
    _betBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _bottomView.bottom-40, _bottomView.width, 40)];
    _betBottomView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    // 下方 （注数，倍数，金额，剩余）label
    CGRect bFrame = CGRectMake(20,(40-20)/2,240,20);
    _bottomLabel = [[AttributeColorLabel alloc] initWithFrame:bFrame];
    [_bottomLabel setFont:[UIFont systemFontOfSize:14]];
    [_bottomLabel setTextColor:[UIColor darkGrayColor]];
    [_bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [_bottomLabel setBackgroundColor:[UIColor clearColor]];
    [self changeMoneyAndMultiple];
    
    // 送彩票按钮
    _betButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _betButton.tag = SendCaiPiaoTag;
    [_betButton setFrame:CGRectMake(0,(_betBottomView.height-25)/2.0,60,25)];
    [_betButton setTitle:LocStr(@"送彩票") forState:UIControlStateNormal];
    [_betButton addTarget:self action:@selector(betAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_betButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    _betButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_betButton setRight:mScreenWidth-15];
    
    _betButton.backgroundColor = REDFONTCOLOR;
    _betButton.layer.cornerRadius = 5;
    
    [_betBottomView addSubview:_betButton];
    [_betBottomView addSubview:_bottomLabel];
    [_betBottomView setBottom:self.view.height];
    [self.view addSubview:_betBottomView];
    
    
    [_bottomView setBottom:_betBottomView.top];
    [_bottomView addSubview:middleView];
    [self.view addSubview:_bottomView];
}
//TODO:调用联系人列表按钮响应
-(void)telButonAction:(UIButton *)button
{
    ZLPeoplePickerViewController *se = [[ZLPeoplePickerViewController alloc] init];
    se.delegate = self;             // 设置代理（传电话号码）
    se.allowAddPeople = NO;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:se];
    [self presentViewController:navi animated:YES completion:nil];
}
//TODO: TelField delegate回传电话号码-----ok
-(void)setTextField:(NSString *)text
{
    NSLog(@"%ld",text.length);
    if (text.length > 11)
    {
        text = [text replaceAll:@"-" withString:@""];
    }
    _telField.text = text;
}

#pragma mark --------  追加&加倍相关 ----------------------- ok
- (void)loadOKBottomUI
{
    // 整个底部视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(-0.5,mScreenHeight-114-50, mScreenWidth+1,50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.layer.borderWidth = 0.4;
    _bottomView.layer.borderColor = DIVLINECOLOR.CGColor;
    [self.view addSubview:_bottomView];
    
    // 不是足彩，定制按钮
    if (!isFootBallLottery(lottery_pk))
    {
        //TODO:期数选择按钮
        UILabel *multipLabel = [[UILabel alloc] initWithFrame:CGRectMake((iPhone6||iPhone6Plus)?23:14, 0, 50 ,_bottomView.height)];
        multipLabel.backgroundColor = [UIColor clearColor];
        multipLabel.text = @"连续买";
        multipLabel.userInteractionEnabled = YES;
        multipLabel.textAlignment = NSTextAlignmentRight;
        multipLabel.textColor = BLACKFONTCOLOR1;
        multipLabel.font = [UIFont systemFontOfSize:14];
        
        //输入框
         _multipFeild =[[BaseBettingNumField alloc] initWithFrame:CGRectMake(multipLabel.right+5,(multipLabel.height-25)/2.0, 50, 25) toView:_bottomView];
        [ _multipFeild getCornerRadius:2 borderColor:REDFONTCOLOR borderWidth:0.8 masksToBounds:YES];
        _multipFeild.delegate = self;
        _multipFeild.textColor = REDFONTCOLOR;
        _multipFeild.text = [NSString stringWithFormat:@"%ld",qishu];
        
        //期
        UILabel *qiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_multipFeild.right+5, 0, 15 ,_bottomView.height)];
        qiLabel.backgroundColor = [UIColor clearColor];
        qiLabel.text = @"期";
        qiLabel.userInteractionEnabled = YES;
        qiLabel.textAlignment = NSTextAlignmentLeft;
        qiLabel.textColor = BLACKFONTCOLOR1;
        qiLabel.font = [UIFont systemFontOfSize:14];
        
        [_bottomView addSubview:multipLabel];
        [_bottomView addSubview:_multipFeild];
        [_bottomView addSubview:qiLabel];
        
        //分割线
        UIView *divLine = [[UIView alloc]initWithFrame:mRectMake(_bottomView.width/2.0-0.2, 0, 0.5, _bottomView.height)];
        divLine.backgroundColor = DIVLINECOLOR;
        [_bottomView addSubview:divLine];
    }
    
    //TODO:倍数按钮
    UILabel *beishuLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.width/2.0+((iPhone6||iPhone6Plus)?23:15), 0,20,_bottomView.height)];
    beishuLabel.text = @"投";
    beishuLabel.userInteractionEnabled = YES;
    beishuLabel.textColor = BLACKFONTCOLOR1;
    beishuLabel.textAlignment = NSTextAlignmentRight;
    beishuLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:beishuLabel];
    
    //倍数输入框
   _beishuFeild =[[BaseBettingNumField alloc] initWithFrame:CGRectMake(beishuLabel.right+5,(beishuLabel.height-25)/2.0, 50, 25) toView:_bottomView];
    [_beishuFeild getCornerRadius:2 borderColor:REDFONTCOLOR borderWidth:0.8 masksToBounds:YES];
    _beishuFeild.text = [NSString stringWithFormat:@"%ld",beishu];
    _beishuFeild.delegate = self;
    _beishuFeild.textColor = REDFONTCOLOR;
    [_bottomView addSubview:_beishuFeild];
    
    //倍
    UILabel *beiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_beishuFeild.right+5, 0, 20,_bottomView.height)];
    beiLabel.text = @"倍";
    beiLabel.userInteractionEnabled = YES;
    beiLabel.textColor = BLACKFONTCOLOR1;
    beiLabel.textAlignment = NSTextAlignmentLeft;
    beiLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:beiLabel];
    
    
    // 大乐透追加投注
    if (lottery_pk == lDLT_lottery)
    {
        //分割线
        UIView *divLine = [[UIView alloc]initWithFrame:mRectMake(_bottomView.origin.x, _bottomView.bounds.origin.y+50, _bottomView.width, 0.4)];
        divLine.backgroundColor = DIVLINECOLOR;
        [_bottomView addSubview:divLine];
        
        //追加
        followControl = [[FollowControl alloc] initWithFrame:CGRectMake(_bottomView.width/4.0+7,_bottomView.bounds.origin.y+50.5,_bottomView.width/2.0,40) title:@"追加投注" aDefaultOn:NO];
        [followControl addTarget:self action:@selector(followChanged:)
                forControlEvents:UIControlEventTouchUpInside];
        followControl.backgroundColor = [UIColor clearColor];
        [_bottomView addSubview:followControl];
    
        
        //改变滑动视图的高度
        [resultView changeResultHeight:-followControl.height];
        //重设底部视图的初始值
        [_bottomView setOrigin:CGPointMake(_bottomView.origin.x, _bottomView.origin.y-followControl.height)];
        //重设底部视图的高度
        [_bottomView setHeight:_bottomView.height+followControl.height];
    }
    
    //添加多选
    [_bottomView addSubview:mulipleView];
    //添加底部投注
    [self createBetBottomView];
    
}
#pragma mark ------  底部投注控件相关 -------------------- ok
- (void)createBetBottomView
{
    _betBottomView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, _bottomView.bottom, _bottomView.width+1, 50)];
    _betBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_betBottomView];
    
    //TODO:投注按钮
    _betButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _betButton.tag = TouzhuTag;
    _betButton.backgroundColor = REDFONTCOLOR;
    [_betButton setFrame:CGRectMake(0,(_betBottomView.height-35)/2.0,60,35)];
    _betButton.layer.cornerRadius = 5;
    _betButton.clipsToBounds = YES;
    _betButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_betButton setTitle:LocStr(@"投注") forState:UIControlStateNormal];
    [_betButton addTarget:self action:@selector(betAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_betButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    [_betButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    //TODO:下方 （注数，倍数，金额，剩余）label
    CGRect bFrame = CGRectMake(20,13,_bottomView.width-_betButton.width-60,_betBottomView.height-13);
    _bottomLabel = [[AttributeColorLabel alloc] initWithFrame:bFrame];
    [_bottomLabel setFont:[UIFont systemFontOfSize:17]];
    [_bottomLabel setTextColor:[UIColor blueColor]];
    [_bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [_bottomLabel setBackgroundColor:[UIColor clearColor]];
    [self changeMoneyAndMultiple];  //改变Lab上的值
    
    //分割线
    UIView *divLine = [[UIView alloc]initWithFrame:mRectMake(0,_betBottomView.height-0.5, _betBottomView.width, 0.4)];
    divLine.backgroundColor = BLACKFONTCOLOR1;
    [_betBottomView addSubview:divLine];
    
    [_betBottomView addSubview:_betButton];
    [_betBottomView addSubview:_bottomLabel];
    [_betButton.titleLabel setMinimumScaleFactor:10];
    [_betButton setRight:mScreenWidth-15];

}

//TODO:追号类型与中奖即停
- (void)pickerValueChange:(MultipleBetControl *)control
{
    follow_prize = control.follow_prize; // 是否中奖继续追号
    follow_type = control.follow_type;   // 追号类型
}
//TODO:追号选项
- (void)followChanged:(FollowControl *)sender
{
    sender.selected = !sender.isSelected;
    sup = sender.isSelected;  // 是否追加（大乐透）
    [self changeMoneyAndMultiple];
}
//TODO:是否中奖继续追号
-(void)winAndFollowChanged:(FollowControl *)sender
{
    follow_prize = sender.isSelected;// 是否中奖继续追号
}

//TODO:当投注结果改变时，更改注数和金额
-(void)resultChanged
{
    zhushu = 0;
    for (BetResult *result in betResults)
    {
        maxAmount = MAX(result.zhushu,maxAmount);
        zhushu += result.zhushu;
    }
    // 改变注数、倍数、金额
    [self changeMoneyAndMultiple];
}

//TODO:改变注数、倍数、金额
-(void)changeMoneyAndMultiple
{
    NSInteger money = beishu*qishu*zhushu*(sup?3:2);
    NSString *moneyText = [NSString stringWithFormat:@"共| %li |元",money];
    if(qishu <= 0)
    {
      moneyText = @"无限期";
    }
    
    NSString *bottom_text = [NSString stringWithFormat:@"%ld注 %ld倍 %@ ",
                             zhushu,beishu,moneyText/*,IsEmpty(uBalance)?@"0":uBalance*/];
    // 将字符串切割成数组（包括 注数，倍数，金额）
    NSArray *textArray = [bottom_text componentsSeparatedByString:@"|"];
    
     [_bottomLabel clearText];
     [_bottomLabel addText:[textArray objectAtIndex:0] color:BLACKFONTCOLOR1 font:nil];
     [_bottomLabel addText:[textArray objectAtIndex:1] color:REDFONTCOLOR font:nil];
    [_bottomLabel addText:[textArray objectAtIndex:2] color:BLACKFONTCOLOR1 font:nil];
    
   // 余额显示已去掉
    //[_bottomLabel addText:[textArray objectAtIndex:2] color:nil font:nil];
     [_bottomLabel drawColorString];  //重绘
    float width = [bottom_text sizeWithAttributes:@{NSFontAttributeName:_bottomLabel.font}].width+30;
     [_bottomLabel setWidth:(width>mScreenWidth-90?mScreenWidth-90:width)];
    
}
#pragma mark ----------- 投注 ----------- ok
- (void)betAction:(UIButton *)button
{
    _betButton.enabled = NO;
      [self performSelector:@selector(changeBetButtonEnable) withObject:nil afterDelay:1.2];
       _btnTag = button.tag;

    
    /* 没有彩期信息则再次查询 */
    if(!period)
    {
        [self queryPlayPeriodWithTips:YES];
        return;
    }
    
    // 取消第一响应
    [self cancleTextFiledFirstResponder];
    
    if(zhushu<1)
    {
        [SVProgressHUD showInfoWithStatus:LocStr(@"至少选择一注")];
        return;
    }
    
    if (qishu != 0)
    {
        if (!follow_prize)
        {
           follow_prize = 0;
        }
        
        if (!follow_type)
        {
           follow_type = 0;
        }
    }
    
    /*未登录，则去登陆*/
    if ([[UserInfo sharedInstance] isLogined]==NO&&[[UserInfo sharedInstance]isLoginedWithVirefi]==NO)
    {
        [SVProgressHUD showInfoWithStatus:(LocStr(@"未登录~"))];
        _betButton.enabled = YES;
        [self gotoLogingWithSuccess:^(BOOL success)
         {
             [self performSelector:@selector(betAction:) withObject:nil afterDelay:2];
             
         }class:@"LoginVC"];
        return;
    }
    
    NSInteger money = beishu * maxAmount;
    if(money>10000 && !sup)
    {
        [SVProgressHUD showErrorWithStatus:@"单张彩票金额超过上限20000元，请重新选择!"];
        return;
    }
    
    if(money>10000 && sup)
    {
        [SVProgressHUD showErrorWithStatus:@"单张彩票金额超过上限30000元，请重新选择！"];
        return;
    }
    //TODO: 账户余额（是否追加）
    money = zhushu*beishu*(sup?3:2);
   

    /*检测余额，余额不足就跳到充值界面去*/
    if([[[UserInfo sharedInstance] Balance] intValue]<money&&[[[UserInfo sharedInstance] Cash] intValue]<money)
    {
        //余额不足
        [SVProgressHUD showInfoWithStatus:(@"您的余额不足，请及时充值！")];
        _betButton.enabled = YES;
        TransferSelViewController *con = [[TransferSelViewController alloc]initWithTran:NO];
        [self.navigationController pushViewController:con animated:YES];
        return;
    }
    
    
    /*送彩票检测手机号*/
    if (button.tag==SendCaiPiaoTag)
    {
        if ( ![XHDHelper isphoneStyle:_telField.text])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            _betButton.enabled = YES;
            return;
        }
    }
    [self beginBetTranscation:_btnTag];
}
- (void)changeBetButtonEnable
{
    _betButton.enabled = YES;
}
#pragma mark -- 提交投注结果  button的响应-----------网络请求还有问题
- (void)beginBetTranscation:(NSInteger)btnTag
{
    /*第一起版本只有余额支付*/
     _chargeTpy = 4;
    
    /*显示等待投注界面*/
    [self showBettingDialog];
    
    /* 组装投注号码 */
    NSMutableString *betNumber = [NSMutableString string];
    for (BetResult *result in betResults)
    {
        if(betNumber.length!=0)
        {
            [betNumber appendString:@";"];
        }
        [betNumber appendString:[NSString stringWithFormat:@"%03i",
                                 [result.play_code intValue]]];
        [betNumber appendString:@"|"];
        [betNumber appendString:result.numbers];
        
    }
    
    /*投注号码不存在*/
    if(!betNumber)
    {
        [self hideBettingDialog];
        [SVProgressHUD showErrorWithStatus:@"投注号码有误！"];
        return;
    }
    
     /*隐藏提示视图*/
    [self hideBettingDialog];
    
    _betButton.enabled =NO;
    
    /*填写投注请求参数*/
    NSInteger money = (qishu== 0?1:qishu) * beishu * zhushu * (sup==1?3:2);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lottery_pk"] = GET_INT(lottery_pk);  //彩种
    params[@"period"] = period.period;  //彩期
    params[@"multiple"] = GET_INT(beishu);  //倍数
    params[@"number"] = betNumber; //号码
    params[@"follow_num"] = GET_INT(qishu);  //追号期
    params[@"follow_prize"] = GET_INT(follow_prize); //中奖继续追号
    params[@"follow_type"] =  GET_INT(follow_type); //追号类型
    params[@"sup"] = GET_INT(sup); //是否追加
    params[@"money"] = GET_INT(money); //金额
    params[@"charge_type"] = GET_INT(_chargeTpy); //支付方式
    
    if (btnTag==SendCaiPiaoTag)  // 如果是送彩票
    {
        NSLog(@"_telField.text;电话号码%@",_telField.text);
        params[@"gift_phone"] = _telField.text; //对方手机号码
        
        params[@"greetings"] = _infmField.text; //赠言
        
    }
    [params setPublicDomain:kAPI_BetCartAction];
    
    
    _connection = [RequestModel POST:URL(kAPI_BetCartAction) parameter:params   class:[RequestModel class]
                success:^(id data)
                   {
                       _betButton.enabled = YES;
                       [SVProgressHUD dismiss];
                       /*调用父控制器处理投注结果的方法*/
                       [self betResponse:data lot_pk:lottery_pk buttonTag:_btnTag];
                       [[UserInfo sharedInstance]getUserBonusSuccess:nil failure:nil];
                      
                   }
                   
                failure:^(NSString *msg, NSString *state)
                   {
                       _betButton.enabled =YES;
                       if ([state integerValue] == Status_Code_User_Not_Login)
                       {
                           [super gotoLoging];
                           [SVProgressHUD dismiss];
                           return;
                       }
                       [self hideBettingDialog];
                       // 失败提示
                       [self showFailedWithStatus:msg];
                   }];
}

/*未登录则登录，然后重新请求投注接口*/
- (void)refreshWithViews
{
   [self betAction:nil];
}

#pragma ---------------------输入相关-----------------------
#pragma mark keyboard Notification Method键盘高度改变的通知方法
-(void)changeBottonViewPoint:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标(这是相对于窗口的高度)
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//动画时间
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        //修改投注控件的高度&倍数的高度
        _betBottomView.bottom = iOS7? keyBoardEndY-64:keyBoardEndY-64;
        _bottomView.bottom = _betBottomView.origin.y;
        
    }];
}
// 取消第一响应者(收起键盘)
-(void)cancleTextFiledFirstResponder
{
    // 取消第一响应者
    if ([_telField becomeFirstResponder]) {
        [_telField resignFirstResponder];
    }
    if ([_infmField becomeFirstResponder]) {
        [_infmField resignFirstResponder];
    }
    [self.view endEditing:YES];
}
#pragma mark - UITextView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入60字以内的赠言(可不填)"])
    {
        textView.text = @"";
    }
    textView.textColor = [UIColor darkGrayColor];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=60)
    {
        [SVProgressHUD showErrorWithStatus:LocStr(@"最多输入六十个字")];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView1
{
    if (textView1.text.length == 0) {
        
        textView1.text = @"请输入60字以内的赠言(可不填)";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length<1)
    {
        textView.text = @"请输入60字以内的赠言(可不填)";
        textView.textColor = [UIColor lightGrayColor];
    }
}
#pragma mark - UITextField delegate ---
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = textField.text.length+string.length-range.length;
    // 控制输入的最多字符串长度
    if(textField == _telField)
    { // 电话号码
        return ((newLength > 11) ? NO : YES);
    }
    if(textField == _multipFeild)
    {// 期数
        return (newLength > 2) ? NO : YES;
    }
    if(textField == _beishuFeild)
    {// 注数
        return (newLength > 2) ? NO : YES;
    }else
    {
        return YES;
    }
}

// 按确定时的代理方法自动切换响应者
- (BOOL)textFieldShouldReturn:(PJTextField*)textField
{
    if(textField == _telField){
        [_infmField becomeFirstResponder];
    }
    return YES;
}

// 结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _telField)
    {
        
    }
    if(textField == _multipFeild)
    {
        qishu = [_multipFeild.text intValue];
        [self changeMoneyAndMultiple];
    }
    if(textField == _beishuFeild)
    {
        beishu = [_beishuFeild.text intValue];
        
        [self changeMoneyAndMultiple];
    }
    NSLog(@"%ld.......%ld",qishu,beishu);
}
#pragma ----------------------------------------------------ok
//TODO:加下划线的方法
- (void)addDivlineWithFrame:(CGRect)frame FatherView:(UIView*)fatherView
{
    UIView *div = [[UIView alloc]initWithFrame:frame];
    div.backgroundColor = DIVLINECOLOR;
    [fatherView addSubview:div];
}

#pragma mark -- 根据采种编号查询期数 ----------------- ok
- (void)queryPlayPeriodWithTips:(BOOL)isTip
{
    if(isTip)
    {
        [SVProgressHUD showInfoWithStatus:@"正在查询彩期，请耐心等待..."];
    }
    
    if (!period)
    {
        [_betButton setTitle:@"查询中..." forState:UIControlStateNormal];
        [_betButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_betButton setEnabled:NO];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lottery_pk"] = GET_INT(lottery_pk);
    [params setPublicDomain:kAPI_QueryPlayPeriod];
    
    _connection = [RequestModel POST:URL(kAPI_QueryPlayPeriod) parameter:params   class:[RequestModel class] success:^(id data)
                   {
                       [_betButton setEnabled:YES];
                       if (!data)
                       {
                           [SVProgressHUD showInfoWithStatus:@"彩期查询失败，暂时无法投注，请稍后重试！"];
                           [_betButton setTitle:@"投注" forState:UIControlStateNormal];
                           return;
                       }
                       
                       NSArray *periodDict = [data objectForKey:@"item"];
                       [_betButton setTitle:@"投注" forState:UIControlStateNormal];
                       if (periodDict.count > 0 )
                       {
                           //TODO:初始化彩期信息
                           period = [[PreviousInfo alloc] initWithDictionary:[periodDict objectAtIndex:0]];
                           NSLog(@"--------  %@  -------",period.next_period);
                           NSDate *serverTime = [[data objectForKey:@"system_time"] toNSDate];
                           
                           if(period)
                           {
                               [period setFixed_delta_time:[serverTime timeIntervalSinceNow]];
                               
                           }
                           if (betResults.count>0)
                           {
                               [self betAction:_betButton];
                           }
                       }
                        _lastPeriod = period.before_period;
                   }
                   failure:^(NSString *msg, NSString *state)
                   {
                        [_betButton setTitle:@"投注" forState:UIControlStateNormal];
                       [_betButton setEnabled:YES];
                        [SVProgressHUD showInfoWithStatus:LocStr(@"彩期查询失败，暂时无法投注，请稍后重试！")];
                   }];
}


/*返回的方法*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==TAG_BACK_ALERT&&buttonIndex==alertView.firstOtherButtonIndex)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

@end