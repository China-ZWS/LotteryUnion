//
//  T367ViewController.h
//  YaBoCaiPiaoSDK
//
//  Created by jamalping on 14-3-26.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import "TZBaseViewController.h"

@interface T367ViewController : TZBaseViewController <UIScrollViewDelegate>
{
    NSInteger _selectIdx;    // 玩法按钮选中的是第几个按钮
    NSInteger _topOffset;    // 顶部偏移量
    NSInteger _numberOfBet;  // 注数
    BOOL _isAppeared;  // 是否显示
    
    // 自选时
    NSMutableArray *zixuan_Array;  // 前区选中的球
    UIView    *_fristContainView;
    
    ColorLabel *zixuan_Label;
    // 胆拖
    NSMutableArray *_danqu;  // (存储胆码区)
    NSMutableArray *_tuoqu;  // (存储拖码区)
    
    ColorLabel *label_dan;  // 胆码区
    ColorLabel *label_tuo;  // 拖码区
    
    ColorLabel *cFront0;
    ColorLabel *cFront1;
    
    NSMutableArray *_selectedBallArray;    // 选中的球按钮
    
    BallGroupContianView *containView;
    BOOL isFrist;
}

//- (void)loadFirstView;
//- (void)loadSecondView;
//- (void)loadThirdView;

- (void)checkTotal;


@end
