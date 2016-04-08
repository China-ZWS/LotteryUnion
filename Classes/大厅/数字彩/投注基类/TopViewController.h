//
//  TopViewController.h
//  YaBoCaiPiao
//
//  Created by liuchan on 12-9-5.
//  Copyright (c) 2012年 DoMobile. All rights reserved.
//

#import "PJViewController.h"
#import "PJNavigationController.h"
#import "CustomIOS7AlertView.h"


#define TAG_ALERT_BET 100
#define TouzhuTag 300      //投注
#define SendCaiPiaoTag 301 //送彩票
 
@interface TopViewController : PJViewController<CustomIOS7AlertViewDelegate>
{
    API_LotteryType lottery_pk; // 彩票对应的号码
    NSString *betNote;     // 投注响应提示
    UIImage  *_shareImg;   // 分享的截图
    CustomIOS7AlertView *customAlert;  //自定义提示视图
    NSInteger   betOrSend; // 投注或是送彩票
}


// 打开登录页面
-(void)openLoginController;

// 显示正在投注提示框
-(void)showBettingDialog;
-(void)hideBettingDialog;

/*投注成功*/
- (void)showSuccessWithStatus:(NSString *)msg;
/*投注失败*/
- (void)showFailedWithStatus:(NSString *)msg;

//中奖信息显示
-(void)showWinPrizeDialog:(NSString*)note
             shareContent:(NSString*)shareNote
                Lotter_pk:(int)lot_pk;

// 投注结果处理
-(BOOL)betResponse:(id)response lot_pk:(int)lot_pk buttonTag:(NSInteger)btnTag;

@end
