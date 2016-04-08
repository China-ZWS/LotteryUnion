//
//  TZBaseViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/8/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "TZBaseViewController.h"
#import "PJNavigationController.h"
#import "AwardVC.h"    //开奖号码
#import "RandomBetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIRadioControl.h"
#import "WinModel.h"
#import "AddCollectionViewController.h"

#pragma mark -- 自定制底部工具条按钮
@implementation CustomToolButton
-(void)setNeedsLayout
{
    // TOOL按钮图片和文字的位置
    [super setNeedsLayout];
    CGSize size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    [self.titleLabel setTop:self.height-size.height-1];
    [self.titleLabel setLeft:(self.width-size.width)/2];
    
    CGSize imgSize = self.imageView.size;
    [self.imageView setTop:2];
    [self.imageView setLeft:(self.width-imgSize.width)/2+3];
}

@end

@implementation TZBaseViewController
{
    UIView *divLine_BottomView;//底部分割线
}
@synthesize delegate = _delegate;
@synthesize period = _period;
@synthesize lottery_pk = _lottery_pk;
@synthesize numberLabel = _numberLabel;
@synthesize totalLabel = _totalLabel;
@synthesize selectType = _selectType;  // 是否机选
@synthesize bottomLinerView = _bottomLinerView;
@synthesize toolBarView = _toolBarView;
@synthesize titleView = _titleView;
@synthesize currentPeriod = _currentPeriod;
@synthesize selectPickerIndex = _selectPickerIndex;  // 机选几注（注数）
@synthesize skipClearArray = _skipClearArray;        // 是否清除了数据

- (void)dealloc
{
    
}

#pragma mark -----  初始化 -------------
/*根据彩种初始化内容*/
- (id)initWithLotter_pk:(NSString *)lotter_pk selectedType:(int)selectedType
{
    if (self = [super init])
    {
        self.lottery_pk = lotter_pk;
        self.selectType = selectedType;
        
        _selectPickerIndex = 5;   //默认机选注数
    
        _defaultNumberSelect = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i = 0; i < 20; i++)
        {
            [_defaultNumberSelect addObject:
             [NSString stringWithFormat:@"机选%d注",i + 1]];
        }
        
        //TODO:导航控制器设置
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(cancelClicked:) image:kkBackImage];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(openAwardList:) image:kkRightImage];
        [self.navigationItem setNewTitle:getLotNames(lotter_pk)];
    }
    return self;
}
/* 彩种&期数&是否是第一次&代理 */
- (id)initWithLotter_pk:(NSString *)lotter_pk period:(PreviousInfo *)period
            requestCode:(BOOL)isFirstChoose delegate:(id)delegate
{
    
    if (self = [super init])
    {
        self.lottery_pk = lotter_pk;    // 彩种编号
        self.period = period;           //期数
        _isFirstChoose = isFirstChoose; // 是否时第一次选择
        _delegate = delegate;
        _selectPickerIndex = 5;
        
        _defaultNumberSelect = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i = 0; i < 20; i++)
        {
            [_defaultNumberSelect addObject:
             [NSString stringWithFormat:@"机选%d注",i + 1]];
            
        }
        //TODO:导航控制器设置
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(cancelClicked:) image:kkBackImage];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(openAwardList:) image:kkRightImage];
        [self.navigationItem setNewTitle:getLotNames(lotter_pk)];
    }
    return self;
}


#pragma mark --------------- 左右键动作 ---------------
//右键动作，打开开奖号码
-(void)openAwardList:(id)sender
{

    // push到开奖控制器
    AwardVC *awrd = [[AwardVC alloc]initWithLottery_pk:_lottery_pk playName:getLotNames(_lottery_pk)];
    
    [self.navigationController pushViewController:awrd animated:YES];

}

//TODO:左键动作，取消选号返回上一个控制器
- (void)cancelClicked:(id)sender
{
    if(_isFirstChoose)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController removeViewController:self];
        
    }
    else
    {
        
        //返回
        if(_delegate && [_delegate respondsToSelector:@selector(cancelChoosedNumber)])
        {
            [_delegate cancelChoosedNumber];
        }
    }
}

#pragma mark ------------- 控制器 生命周期  ---------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    //顶部标题视图
    [self createTitleView];
    
    //创建工具栏
    [self createBottomToolBar];
    
    //添加注数金额Lab
    [self createNumberLabAndMoneyLab];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //标题视图的修改
    [_titleView setWidth:self.view.width];
    [self.titleView setHeight:35.0];
    [self.view sendSubviewToBack:self.titleView];
    
    
    // 重置底部工具按钮位置
    BOOL isFootBall = isFootBallLottery([_lottery_pk intValue]);
    float tool_btn_width = self.view.width/(isFootBall?3:4);
    [_toolBarView setWidth:self.view.width];
     // 修改了bottom
    [_toolBarView setBottom:self.view.height];
    for (UIView *childView in _toolBarView.subviews)
    {
        [childView setWidth:tool_btn_width-4];
    }
    [bet_ok setLeft:2];
    [bet_send setLeft:tool_btn_width];
    [bet_empty setLeft:2*tool_btn_width];
    [bet_fav setLeft:3*tool_btn_width];
    [bet_random setLeft:3*tool_btn_width];

    //底部视图注数金额的Lab设置
    [_bottomLinerView setBottom:_toolBarView.top];
    [_bottomLinerView setWidth:self.view.width];
    [_totalLabel setWidth:(_bottomLinerView.width-10)/2];
    [_totalLabel setLeft:_totalLabel.width+10];
    [_numberLabel setWidth:_totalLabel.width];
    divLine_BottomView.frame = mRectMake(0,0,mScreenWidth, 0.5);
    
    // 选号内容
    [_scrollVew setOrigin:CGPointMake(0,self.contentOffset)];
    [_scrollVew setSize:CGSizeMake(self.view.width,self.contentHeight)];
    [_scrollVew setContentWidth:_scrollVew.width];
}


#pragma mark ------------- 标题视图 ------------------- ok
- (void)createTitleView
{
    //顶部标题视图
    UIImage *top_liner_bg = [[UIImage imageNamed:@"top_liner.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0];
    _titleView = [[UIImageView alloc] initWithImage:top_liner_bg];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.userInteractionEnabled = YES;
    [_titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_titleView];

}
#pragma mark ------------ 创建多少柱，共多少元的Lab ------------- ok
- (void)createNumberLabAndMoneyLab
{
    // 共投多少注的label
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_bottomLinerView.height/2.0-10,0,20)];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.font = [UIFont systemFontOfSize:13];
    _numberLabel.textColor =  BLUEBALLCOLOR;
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.text = LocStr(@"0 注");
    [_bottomLinerView addSubview:_numberLabel];
    
    // 共花多少元的label
    _totalLabel= [[UILabel alloc] initWithFrame:CGRectMake(0,_bottomLinerView.height/2.0-10,0,20)];
    _totalLabel.textAlignment = NSTextAlignmentLeft;
    _totalLabel.font = [UIFont systemFontOfSize:13];
    _totalLabel.textColor = REDFONTCOLOR;
    _totalLabel.backgroundColor = [UIColor clearColor];
    _totalLabel.text = LocStr(@"共 0 元");
    [_bottomLinerView addSubview:_totalLabel];
    
    _bottomLinerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
}
/*重置注数和金额Label*/
- (void)resetTotalValue
{
    self.numberLabel.text = [NSString stringWithFormat:@"0 注"];
    self.totalLabel.text = [NSString stringWithFormat:@"共 0 元"];
}
/*显示投注后的注数和金额的Label*/
- (void)updateBatchView:(NSArray *)rowArray
{
    self.numberLabel.text = [NSString stringWithFormat:@"%d 注",(int)[rowArray count]];
    self.totalLabel.text = [NSString stringWithFormat:@"共 %d 元",(int)[rowArray count] * 2];
}

#pragma mark ------------- 创建工具栏相关 -----------------ok
/*基础选号界面选号工具栏*/
- (void)createBottomToolBar
{
    //TODO:下方工具栏
    UIImage *toolbar_bg = [UIImage imageNamed:@"UITabBar.png"];
    UIImageView *toolBar = [[UIImageView alloc] initWithImage:toolbar_bg];
    [toolBar setFrame:CGRectMake(0,0,self.view.width,50)];;
    toolBar.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    // 打开交互
    [toolBar setUserInteractionEnabled:YES];
    self.toolBarView = toolBar;
    [self.view addSubview:toolBar];
    
    
    UIImage *bet_image = [UIImage imageNamed:@"ctzq_bet"]; // 勾（选好了）
    UIImage *fav_image = [UIImage imageNamed:@"ctzq_soucang"];// 五角星（收藏）
    UIImage *send_image = [UIImage imageNamed:@"ctzq_send"];  // 送彩票
    UIImage *radom_image = [UIImage imageNamed:@"ctzq_jixuanduoqi"];// 机选多期
    UIImage *empty_image = [UIImage imageNamed:@"ctzq_empty"];//垃圾桶（清空）
    
    UIImage *bet_image_H = [UIImage imageNamed:@"ctzq_bet_H"]; // 勾（选好了）
    UIImage *fav_image_H = [UIImage imageNamed:@"ctzq_soucang_H"];// 五角星（收藏）
    UIImage *send_image_H = [UIImage imageNamed:@"ctzq_send_H"];  // 送彩票
    UIImage *radom_image_H = [UIImage imageNamed:@"ctzq_jixuanduoqi_H"];// 机选多期
    UIImage *empty_image_H = [UIImage imageNamed:@"ctzq_empty_H"];//垃圾桶（清空）
    
    // toolBar上面的button的初始化（包括名字，背景图片，tag值）
    bet_send = [self buildToolBarButton:@"送彩票" NomalImage:send_image HightLight:send_image_H];
    [bet_send setTag:TAG_BET_SEND];
    [toolBar addSubview:bet_send];
    
    //投注
    bet_ok = [self buildToolBarButton:@"投注" NomalImage:bet_image HightLight:bet_image_H];
    [bet_ok setTag:TAG_BET_OK];
    [toolBar addSubview:bet_ok];
    
    //清空
    bet_empty = [self buildToolBarButton:@"清空" NomalImage:empty_image HightLight:empty_image_H];
    [bet_empty setTag:TAG_BET_CLEAR];
    [toolBar addSubview:bet_empty];
    

    //收藏
    bet_fav = [self buildToolBarButton:@"收藏" NomalImage:fav_image HightLight:fav_image_H];
    [bet_fav setHidden:isFootBallLottery([_lottery_pk intValue])];
    [bet_fav setTag:TAG_BET_FAV];
    [toolBar addSubview:bet_fav];
    
    //机选多期
    bet_random = [self buildToolBarButton:@"机选多期" NomalImage:radom_image HightLight:radom_image_H];
    [bet_random setHidden:YES];
    [bet_random setTag:TAG_BET_RANDOM];
    [toolBar addSubview:bet_random];
    
    // TODO:金额Lab初始话，投注结果显示
    CGRect bottomLinerFrame = CGRectMake(0,0,0,22);
    self.bottomLinerView = [[UIImageView alloc] initWithFrame:bottomLinerFrame];
    [self.view addSubview:_bottomLinerView];
    
    //添加一条分割线
    divLine_BottomView = [[UIView alloc]initWithFrame:CGRectZero];
    divLine_BottomView.backgroundColor = DIVLINECOLOR;
    [self.toolBarView addSubview:divLine_BottomView];
}

/*toolBar上面按钮的初始化方法（包括名字以及背景图片）*/
-(UIButton*)buildToolBarButton:(NSString*)b_title
                    NomalImage:(UIImage*)Nimage
                    HightLight:(UIImage*)Himage
{
    BOOL isFootball = isFootBallLottery([_lottery_pk intValue]);

    CustomToolButton *button=[CustomToolButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:REDFONTCOLOR forState:UIControlStateHighlighted];
    [button setImage:Nimage forState:UIControlStateNormal];
    [button setImage:Himage forState:UIControlStateHighlighted];
    
    [button setTitle:b_title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(betAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,5,76,45)];
   
    //设置偏移
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -16, -25, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
    
    [button setWidth:button.width+(isFootball?30:0)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12.5]];
    
    return button;
}

#pragma mark --- toolBar上面按钮的响应方法------修改
-(void)betAction:(id)sender
{
    switch ([sender tag])
    {
        case TAG_BET_SEND: // 帮助 (送彩票的功能)
        case TAG_BET_OK:
        {
            // 通知选号结果返回（包括 注数，号码，彩种编号）
            BetResult *result = [self readBetResult];
            
            if(result)
            {
                if(result.zhushu > 1000)
                {
                    [SVProgressHUD showErrorWithStatus:@"单次投注金额不能高于2000元"];
                    return;
                }
                
              /*如果没有初始化投注界面就初始化，添加到self之前的控制器，有就走代理方法*/
               if(_isFirstChoose == YES)
               {
                   /*获取当前的控制tab*/
                   UITabBarController *tabbarController = (UITabBarController *)self.presentingViewController;
                   
                   UINavigationController *navController = tabbarController.viewControllers[tabbarController.selectedIndex];
                   
                   /*获取顶部控制器*/
                   UIViewController *viewController= navController.topViewController;
                   
                   //如果最顶部的控制器不是投注控制器，就新建一个控制器，然后推过去，再dismiss自身
                   if (![viewController isKindOfClass:[BetCartViewController class]])
                   {
                       BetCartViewController *bettiogController = [[BetCartViewController alloc]initWithBetResult:result AndBetTag:[sender tag]];
                       
                       self.delegate = bettiogController;
                       
                       //传入彩种编号到基类投注器里面
                       [bettiogController setValue:@(_lottery_pk.integerValue) forKey:@"lottery_pk"];
                       
                       [viewController.navigationController pushViewController:bettiogController animated:NO];
                   }
                  
                   [self dismissViewControllerAnimated:YES completion:^{
                        _isFirstChoose = NO;
                   }];
                   
               }
               else
               {
                   //代理方法调用选号成功或者取消
                   [self.delegate choosedNumber:result withButtonTag:[sender tag]];
               }
            }
        }
            break;
        case TAG_BET_RANDOM: // 打开机选多期控制器
        {
             [self openRandomBetViewController];
        }
            break;
       
        case TAG_BET_FAV:
        {  //收藏
            BetResult *result = [self readBetResult];
            if(result)
            {
                if(result.zhushu>1000)
                {
                    [SVProgressHUD showErrorWithStatus:@"单次投注金额不能高于2000元"];
                    return;
                }
               if([[UserInfo sharedInstance]isLogined]==NO && [[UserInfo sharedInstance]isLoginedWithVirefi]==NO)
               {
                   [self gotoLogingWithSuccess:^(BOOL isSuccess)
                    {
                        [self saveFavoriteNumberWithResult:result];
                        
                    }class:@"LoginVC"];
               
               }else
               {
                  [self saveFavoriteNumberWithResult:result];
               }
            
            }
        }
            break;
    }
}

#pragma mark -- 保存收藏
- (void)saveFavoriteNumberWithResult:(BetResult *)result
{
    WinModel *win = [[WinModel alloc]init];
    win.lottery_name =  getLotNames(result.lot_pk);
    win.lottery_code =  [NSString stringWithFormat:@"%03ld",(result.play_code).integerValue];
    win.lottery_pk = result.lot_pk;
    win.number = result.numbers;
    NSString *resultNumber;
    if(_lottery_pk.integerValue == lSSQ_lottery)
    {
        resultNumber = [win SSNumber:result.numbers  lottery_code:result.play_code];
    }else
    {
        resultNumber =  [win formatedNumber];
    }
    AddCollectionViewController *add = [[AddCollectionViewController alloc]initWithWinModel:win WithLotteryName:getLotNames(_lottery_pk) WithSelectNumber:resultNumber];
    [self.navigationController pushViewController:add animated:YES];

}

#pragma mark ------- 机选投注相关 --------------- 导入控制器
//TODO:打开自由投注控制器
-(void)openRandomBetViewController
{
    RandomBetViewController *controller = [[RandomBetViewController alloc]
                                           initWithLotteryPK:[_lottery_pk intValue]];
    
    [self.navigationController pushViewController:controller animated:YES];

}

//TODO:选号时震动
-(void)vibrateWhenSelectBall
{
    if([NS_USERDEFAULT boolForKey:pk_vibrate_when_choose_number])
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
}

#pragma mark --  机选时，加载TitleView
- (UIView *)loadRadomSelectViewTitleView
{
    //背景
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0,0,mScreenWidth,30)];
    subView.backgroundColor = [UIColor whiteColor];
    
    //头视图
    UIImage *share_phone = [UIImage imageNamed:@"ctzq_yaoyiyao@2x"];
    UIButton *buttonShake = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonShake setImage:share_phone forState:UIControlStateNormal];
    [buttonShake setTitle:LocStr(@"摇一摇") forState:UIControlStateNormal];
    [buttonShake setTitleColor:NAVITITLECOLOR forState:UIControlStateNormal];
    buttonShake.frame = CGRectMake(0.0,0,share_phone.width+70,30);
    buttonShake.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [buttonShake setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [subView addSubview:buttonShake];
    
    //机选注数
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-130,3,120,24.0)];
    label.text = @"机选                注";
    label.textColor = NAVITITLECOLOR;
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:14];
    
    //注数侦查按钮
    buttonSpinner = [[numberSniperTextFild alloc]initWithFrame:CGRectMake(36.5,0,40,24) toView:self.view.subviews.lastObject];
    buttonSpinner.layer.borderWidth = 0.3;
    buttonSpinner.layer.borderColor = DIVLINECOLOR.CGColor;
    buttonSpinner.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    buttonSpinner.font = [UIFont systemFontOfSize:14];
    buttonSpinner.text = [NSString stringWithFormat:@"%d",(int)_selectPickerIndex];
    buttonSpinner.tag = 252525;
    buttonSpinner.textColor=REDFONTCOLOR;
    buttonSpinner.tintColor =REDFONTCOLOR;
    buttonSpinner.NumberSniperDelegate = self;
    buttonSpinner.delegate = self;
    buttonSpinner.textAlignment = NSTextAlignmentCenter;
    
    [label addSubview:buttonSpinner];
    [subView addSubview:label];
    [subView setWidth:self.view.width];
    return subView;
}


/* 将视图重新分布层次 */
- (void)bringToFront
{
    [self.view bringSubviewToFront:_titleView];
    [self.view bringSubviewToFront:_bottomLinerView];
    [self.view bringSubviewToFront:_toolBarView];
}

#pragma mark ------------ 画球的方法相关 -------------------- ok
/* 画小球的方法 */
- (UIView *)drawBallView:(NSUInteger)numOfBall withPosition:(CGPoint)position redOrBlue:(int)redOrBlue callback:(SEL)selector
{
    return [self drawBallView:numOfBall withPosition:position redOrBlue:redOrBlue
                     callback:selector selectBallArray:nil];
}

#pragma mark ----- *****  在这改变球的布局  ***** ------------
//TODO:画球的方法
- (UIView *)drawBallView:(NSUInteger)numOfBall withPosition:(CGPoint)position redOrBlue:(int)redOrBlue callback:(SEL)selector selectBallArray:(NSArray *)_selectArray
{
    UIImage *ball_n = [UIImage imageNamed:@"Whiteball"]; // 一般的颜色
    UIImage *ball_h = [UIImage imageNamed:@"ball_focus.png"];   // 选中时的颜色
    // 红色或蓝色
    UIImage *ball_p =  redOrBlue ? [UIImage imageNamed:@"Redball"] : [UIImage imageNamed:@"Blueball"];
    
    UIImage *magnifierImg = redOrBlue ? [UIImage imageNamed:@"Redball_hover@2x"] : [UIImage imageNamed:@"Blueball_hover@2x"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    
    CGFloat devide_height = IsPad?12.0:5.0;    // 上下两球之间的间隔
    CGFloat button_width = 38;
    if(iPhone6)
    {
        button_width = 45.51;
    }
    if(iPhone6Plus)
    {
        button_width = 50;
    }
    CGFloat button_height = button_width;
    CGFloat padding = IsPad?12.0:5.0;   // 水平两球之间的间隔
    CGFloat viewHeight = 0.0;
    for (int i = 0; i < numOfBall; i ++) {
        NSString *number = [NSString stringWithFormat:@"%02d",i + 1];
        // 创建球视图
        BallView *ballview = [BallView ballViewWithFrame:CGRectMake((i%7)*button_width + (i%7) * devide_height + padding,(floor(i/7)*button_height) + (floor(i/7)*devide_height) + padding,button_width,button_height) target:self action:selector tag:(i+1) normalTitle:number normalImage:ball_n highlightImage:ball_h selectImage:ball_p selectArray:_selectArray magnifierImage:magnifierImg isSmall:NO];
        ballview.label.textColor = redOrBlue?REDFONTCOLOR:BLUEBALLCOLOR;
        ballview.isRedBall = redOrBlue;
        [view addSubview:ballview];
        
        if (i % 7 == 0)
            viewHeight += button_height + devide_height;
    }
    
    float bgWidth = IsPad?(7*(button_width+padding)+12):mScreenWidth-10;
    view.frame = CGRectMake(position.x,position.y,bgWidth,viewHeight+padding);
    return view;
}

//TODO:画小球的方法
- (UIView *)drawSamllBallView:(NSUInteger)numOfBall withPosition:(CGPoint)position redOrBlue:(int)redOrBlue callback:(SEL)selector
{
    return [self drawSamllBallView:numOfBall withPosition:position redOrBlue:redOrBlue callback:selector selectBallArray:nil];
}

//TODO:画小球的方法
- (UIView *)drawSamllBallView:(NSUInteger)numOfBall withPosition:(CGPoint)position redOrBlue:(int)redOrBlue callback:(SEL)selector selectBallArray:(NSArray *)_selectArray
{
    UIImage *ball_n = [UIImage imageNamed:@"Whiteball"];
    UIImage *ball_h = [UIImage imageNamed:@"ball_focus.png"];
    UIImage *ball_p = redOrBlue?[UIImage imageNamed:@"Redball"]:
                                [UIImage imageNamed:@"Blueball"];
    UIImage *magnifierImg = redOrBlue ? [UIImage imageNamed:@"ball_hover_small_red"] : [UIImage imageNamed:@"ball_hover_small_blue"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];

#pragma mark -- 在这里改变球的大小
    CGFloat devide_height = IsPad?8.5:3.0;
    CGFloat button_width = 28;
    if(iPhone6)
    {
       button_width = 32.8;
    }
    if(iPhone6Plus)
    {
        button_width = 36.1;
    }
    CGFloat button_height = button_width;
    CGFloat padding = IsPad?8.5:3.0;
    CGFloat viewHeight = 0.0;
    for (int i = 0; i < numOfBall; i ++) {
        NSString *number = [NSString stringWithFormat:@"%d",i];
        
        BallView *ballview = [BallView ballViewWithFrame:CGRectMake((i%10)*button_width + (i%10) * devide_height + padding,(floor(i/10)*button_height) + (floor(i/10)*devide_height) + padding ,button_width,button_height) target:self action:selector tag:i normalTitle:number normalImage:ball_n highlightImage:ball_h selectImage:ball_p selectArray:_selectArray magnifierImage:magnifierImg isSmall:YES];
        
        ballview.label.textColor = redOrBlue?REDFONTCOLOR:BLUEBALLCOLOR;
        ballview.isRedBall = redOrBlue;
        [view addSubview:ballview];
        
        if (i % 10 == 0)
            viewHeight += button_height + devide_height;
    }
    
    float bgWidth = IsPad?(10*(button_width+padding)+10):mScreenWidth-10;
    [view setFrame:CGRectMake(position.x,position.y,bgWidth,viewHeight+padding+(IsPad?0:2))];
    return view;
}
#pragma mark  -- textField代理方法
- (void)numberHadChange:(numberSniperTextFild *)numberStr
{
    if (numberStr.text.integerValue ==20)
    {
        numberStr.text = @"20"; // 已近加上可个位数，所以在此还原。
        [SVProgressHUD showInfoWithStatus:@"注数不能超过20"];
    }

}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.text.integerValue == 0 ||textField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请至少选择一注"];
        return NO;
    }

    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
        _selectPickerIndex = textField.text.integerValue;
        [self actionSelected:nil];
    

}


#pragma mark ------------ 自定义键盘回调方法 --------- ok
#if 0
- (void)showPicker:(id)sender
{
    ((UIButton*)sender).enabled = NO;
    [self performSelector:@selector(changeButtonEnable) withObject:nil afterDelay:0.8];
    _keyBoard = [[KeyBoard alloc] initWithFrame:CGRectMake(0, mScreenHeight, mScreenWidth, mScreenHeight)];
    // 数字按钮回调
    [_keyBoard numberButtonResult:^(UIButton *numberButton) {
        int number;
        number = (int)numberButton.tag;
        _selectPickerIndex = number + _selectPickerIndex*10;
        
        if (_selectPickerIndex >20) {
            _selectPickerIndex = 20; // 已近加上可个位数，所以在此还原。
            [SVProgressHUD showErrorWithStatus:@"注数不能超过20"];
             [sender setTitle:[NSString stringWithFormat:@"%d",(int)_selectPickerIndex] forState:UIControlStateNormal];
        }else{
            [sender setTitle:[NSString stringWithFormat:@"%d",(int)_selectPickerIndex] forState:UIControlStateNormal];
        }
    }];
    // 删除按钮回调
    [_keyBoard deletesButtonResult:^(UIButton *deleteButton) {
        _selectPickerIndex = _selectPickerIndex/10;
        [sender setTitle:[NSString stringWithFormat:@"%d",(int)_selectPickerIndex] forState:UIControlStateNormal];
    }];
    // 确定按钮回调
    [_keyBoard truesntruesButtonResult:^(UIButton *truesButton) {
        if (_selectPickerIndex == 0) {
            [SVProgressHUD showErrorWithStatus:@"请至少选择一注"];
            return ;
        }
        [_keyBoard dismiss];
        
    }];
    
    [_keyBoard show];
}
#endif


- (void)changeButtonEnable
{
    UIButton * bnt  =  [(UIButton*)self.view viewWithTag:252525];
    bnt.enabled = YES;

}

- (void)actionSelected:(id)sender
{
    
}

-(BetResult *)readBetResult
{
    return nil;
}

-(NSInteger)contentHeight
{
    return self.bottomLinerView.top-_titleView.bottom+(!IsPad?5:0);
}

-(NSInteger)contentOffset
{
    return _titleView.bottom;
}

-(BOOL)skipPanGesture
{
    return YES;
}

/*继续投注回到自选界面*/
- (void)chooseBySelfView
{
    [radio setSelectedIndex:0];
    _selectType = 0;
    [bet_fav setHidden:NO];
    [bet_random setHidden:YES];
    lasteSelectIndex = 0;
    [_baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    /*还要清除多余的数据*/
    [self clearAllData];
}
/* 清除所有数据 */
-(void)clearAllData
{
    
}
@end
