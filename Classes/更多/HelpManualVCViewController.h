//
//  HelpManualVCViewController.h
//  LotteryUnion
//
//  Created by xhd945 on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"

@interface HelpManualVCViewController : PJViewController
{
    NSArray *_dataMenu;
    int _subPos;
}
- (id)initWithReadSubMenu:(int)subPos;

@end
