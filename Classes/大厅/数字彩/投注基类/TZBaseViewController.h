//
//  TZBaseViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/8/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>  //视频控制
#import "BallGroupContianView.h"
#import "NSString+ConvertDate.h"
#import "NSArray+Additions.h"
#import "BetCartViewController.h"
#import "TKAlertCenter.h"
#import "UIRadioControl.h"
#import "PreviousInfo.h" //
#import "MathUtil.h"     //自定义的随机算法
#import "Record.h"
#import "UtilMethod.h"   //工具方法
#import "BallView.h"  //绘制选球的视图
#import "numberSniperTextFild.h"  //键盘


#define TAG_BET_OK 0      // 选好了
#define TAG_BET_SEND 1    // 送彩票
#define TAG_BET_CLEAR 2   // 清除
#define TAG_BET_FAV 3     // 收藏
#define TAG_BET_RANDOM 4  // 机选


@interface TZBaseViewController : PJViewController <UIAlertViewDelegate,UITextFieldDelegate,NumberSniperProtocol>

{
    NSInteger lasteSelectIndex;      // 上一次选中的玩法编号
    NSString *_lottery_pk;    //彩种
    int _selectType;
    UIRadioControl *radio;       //分段控制器
@protected
    UILabel *_numberLabel;       //注数Lab
    UILabel *_totalLabel;        //总金额Lab
    UIScrollView *_scrollVew;     // 上下滚动的scrollView的视图（足彩）
    UIScrollView *_baseScrollView;// 左右滚动的
    UIView       *_baseView;      // 上下滚动的scrollView的视图（数字彩）
    UIImageView  *_radioBottomImageView;//上方滑动条形图
    
    // toolBar上面的button
    UIButton *bet_ok;   //选好了
    UIButton *bet_fav;  //收藏
    UIButton *bet_send; //送彩票
    UIButton *bet_empty; //清空
    UIButton *bet_random; //随机
    
    NSInteger contentHeight;
    NSInteger contentOffset;
    
    UIView *_bottomLinerView;       //注数&金额
    UIView *_toolBarView;           //底部工具条视图
    UIView *_titleView;             //标题
    
    NSMutableArray *_defaultNumberSelect;
    NSUInteger _selectPickerIndex;
    
    numberSniperTextFild *buttonSpinner;
    UITextField *selectFeild;
    
    BOOL _isSingleBall;     // 是否是单色球
    BOOL _skipClearArray;   // 是否是清除
    BOOL _isFirstChoose;    // 是否是第一次选择
}

@property (nonatomic, strong) NSString *lottery_pk;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIView  *bottomLinerView;
@property (nonatomic, strong) UIView  *toolBarView;
@property (nonatomic, readonly) NSInteger contentHeight;
@property (nonatomic, readonly) NSInteger contentOffset;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic) int selectType;
@property (nonatomic) NSString *currentPeriod;
@property (nonatomic) NSUInteger selectPickerIndex;
@property (nonatomic) BOOL skipClearArray;
@property (nonatomic,weak) id delegate;
@property (nonatomic) PreviousInfo *period;
@property (nonatomic,readonly) int requestCode;

- (id)initWithLotter_pk:(NSString *)lotter_pk period:(PreviousInfo *)period requestCode:(BOOL)isFirstChoose delegate:(id)delegate;

// 底部推出选号页面
-(void)presentModalView:(UIViewController*)parent;

- (void)bringToFront;

- (UIView *)drawBallView:(NSUInteger)numOfBall withPosition:(CGPoint)position redOrBlue:(int)redOrBlue callback:(SEL)selector selectBallArray:(NSArray *)_selectArray;
- (UIView *)drawSamllBallView:(NSUInteger)numOfBall withPosition:(CGPoint)position redOrBlue:(int)redOrBlue callback:(SEL)selector selectBallArray:(NSArray *)_selectArray;

- (UIView *)drawBallView:(NSUInteger)numOfBall withPosition:(CGPoint)position redOrBlue:(int)redOrBlue callback:(SEL)selector;
- (UIView *)drawSamllBallView:(NSUInteger)numOfBall withPosition:(CGPoint)position redOrBlue:(int)redOrBlue callback:(SEL)selector;

- (void)resetTotalValue;

- (UIView *)loadRadomSelectViewTitleView;

- (void)updateSelectPeriod:(Record *)record;

-(BetResult*)readBetResult;

-(void)betAction:(id)sender;

-(BetResult*)randomOneResult;

// 选号时震动
-(void)vibrateWhenSelectBall;

/*继续投注回到自选界面*/
- (void)chooseBySelfView;

@end

@interface CustomToolButton : UIButton

@end
