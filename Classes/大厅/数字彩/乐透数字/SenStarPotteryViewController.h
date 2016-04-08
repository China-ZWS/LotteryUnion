//
//  SenStarPotteryViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/11/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "TZBaseViewController.h"
#import "UIRadioControl.h"
#import "ColorLabel.h"
#import "BallGroupContianView.h"
#import "UtilMethod.h"
#import "NSArray+Additions.h"

@interface SenStarPotteryViewController : TZBaseViewController <UIScrollViewDelegate>
{
    int _selectIdx;     // 玩法ID
    int _topOffset;     // 顶部偏移
    UIView        * _fristContainView;
    BallGroupContianView *containView;
    
    NSMutableArray *_cArray;
    NSMutableArray *cFrontGroup;         // 存放显示选球个数的label
    NSMutableArray *_selectedBallArray;  // 存放选中的球的
}

//- (void)loadFirstView;
//- (void)loadThirdView;
//- (void)checkTotal;
//- (void)reloadStoreData;

@end
