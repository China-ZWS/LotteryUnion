//
//  BetCartViewController.h
//  YaBoCaiPiao
//
//  Created by liuchan on 12-8-8.
//  Copyright (c) 2012年 DoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"
#import "ColorLabel.h"
#import "ResultScrollView.h"
#import "MultipleBetControl.h"
#import "PopUpOptionView.h"
#import "FollowControl.h"
#import "NSString+ConvertDate.h"
#import "PreviousInfo.h"
#import "BetResult.h"            //请求结果
#import "AttributeColorLabel.h"  //颜色属性label
#import "XHDHelper.h"


@class TelField;  //手机号输入框

@class TZBaseViewController; //基础投注控制器

@class PJTextField;

@class BaseBettingNumField;


//TODO:投注内容发生改变协议
@protocol BetResultChangedDelegate

// 投注内容发生改变
-(void)resultChanged;

@end


@interface BetCartViewController : TopViewController<UIAlertViewDelegate,BetResultChangedDelegate,UITextViewDelegate>
{
    NSInteger zhushu,beishu,qishu,sup,maxAmount; //注数倍数期数等
    NSInteger follow_type,follow_prize;
    BOOL _isFirstChoose;                 //是否是第一次选择


    UIButton *conButton,*ranButton;   // 继续选号和机选一注按钮
    ResultScrollView *resultView;     //结果滑动视图

    UIView *_bottomView,*_betBottomView; //底部视图，底部请求视图
    MultipleBetControl *mulipleView;     //多注请求控制
    FollowControl *followControl;         // 大乐透的追加
    AttributeColorLabel *_bottomLabel;
    UIButton *_betButton;             // 投注按钮
    
    PreviousInfo *period;            //彩种奖池之类的信息
    NSMutableArray *betResults;       // 投注结果数组
    TZBaseViewController *mController;// 基础控制器
    
    NSArray *vsTeam;  //对战的队伍
    
    BOOL _betActioning;
    BOOL _betFinished;
    BOOL _autoSelected;
    NSString *_lastPeriod;
    BOOL _isShowedVieoAlert;
    
    NSInteger _btnTag;             //tag值 选号完成后用来判断是（选好了）还是（送彩票）的按钮
    BOOL     _loadedSendCPbottom;       //初始化0
    PJTextField *_telField;                //电话号码输入TextField
    PJTextField  *_infmField;            // 赠言输入
    NSString    *_telNumber;            // 电话号码
    
    UIButton *_phonePayButton;          // 选择手机支付按钮
    UIButton *_chargePayButton;         // 选择话费支付按钮
    CustomIOS7AlertView *_alertView;    // 提示选择支付方式的alertView
    BOOL     charge;                    // 是否选择了支付方式
    NSInteger betButtonTag;             // 投注按钮tag
    NSInteger     _chargeTpy;           // 支付方式
    UIView   *_selectView;              // 支付选择的视图
    BOOL     allowVisitAlbum;           // 是否允许访问相册
    BOOL     _selectedCharge;           // 是否已选择支付方式
   
    BaseBettingNumField *_multipFeild;          // 期数选择textFeild
    BaseBettingNumField*_beishuFeild;          // 倍数选择textFeild
}

@property (nonatomic) NSString *fromTitle;  //标题
@property (nonatomic) BOOL backToLastMenu;  //

//根据彩种编码初始话
- (id)initWithLotteryCode:(API_LotteryType) lotCode;
//格局请求结果初始化
- (id)initWithBetResult:(BetResult*) curResult AndBetTag:(NSInteger)bntTag;

//TODO:请求投注
- (void)beginBetTranscation:(NSInteger)btnTag;

// 选号成功返回
-(void)choosedNumber:(BetResult*)item withButtonTag:(NSInteger)buttonTag;

// 取消选号返回
-(void)cancelChoosedNumber;

//结果
+(void)openBetCartWithBetResult:(BetResult*)result controller:(UIViewController*)controller from:(NSString*)fromTitle;

@end