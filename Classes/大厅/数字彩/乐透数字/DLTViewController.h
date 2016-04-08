//
//  DLTViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/8/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "TZBaseViewController.h"
#import "UIRadioControl.h"
#import "ColorLabel.h"
#import "BallGroupContianView.h"
#import "UtilMethod.h"

@interface DLTViewController : TZBaseViewController <UIScrollViewDelegate>
{
    int _selectIdx;    // 
    int _topOffset;    // 顶部偏移量
    int _numberOfBet;  // 注数
    BOOL _isAppeared;  // 是否显示
    
    // 自选时
    UIView     *_fristContainView;
    
    NSMutableArray *_zixuanQianqu;  // 前区选中的球
    NSMutableArray *_zixuanHouqu;   // 后区选中的球
    
    ColorLabel *zixuan_front;
    ColorLabel *zixuan_fear;
    
    // 胆拖时
    ColorLabel *front_dan;
    ColorLabel *front_tuo;
    
    ColorLabel *fear_dan;
    ColorLabel *fear_tuo;
    
    ColorLabel *cFront0;
    ColorLabel *cFront1;
    
    ColorLabel *cFear0;
    ColorLabel *cFear1;
    
    NSMutableArray *_qianqu0;   // 前区胆选中的球
    NSMutableArray *_qianqu1;   // 前区脱选中的球
    NSMutableArray *_houqu0;    // 后区胆存选中的球
    NSMutableArray *_houqu1;    // 后区脱选中的球
    NSMutableArray *_selectedBallArray;    // 选中的球按钮
    
    BallGroupContianView *containView;
    BOOL isFrist;
}

//- (void)loadFirstView;
//- (void)loadSecondView;
//- (void)loadThirdView;

- (void)checkTotal;

@end
