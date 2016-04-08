//
//  PL3ViewController.h
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

@interface PL3ViewController : TZBaseViewController<UIScrollViewDelegate>
{
    int _selectIdx;
    int _topOffset;
    
    UIView *_fristContainView;
    
    BallGroupContianView *containView;

    // 存放数据的数组
    NSMutableArray *_cArray;           // 
    NSMutableArray *cFrontGroup;       // 存放显示选球个数的label
    NSMutableArray *_gArray;           // 存放选中的球的个数
    NSMutableArray *_selectedBallArray;  // 存放选中的球的
}

- (void)reloadStoreData;
- (void)checkTotal;

@end
