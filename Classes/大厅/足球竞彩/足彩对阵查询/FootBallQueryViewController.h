//
//  FootBallQueryViewController.h
//  LotteryUnion
//
//  Created by 周文松 on 15/10/27.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewController.h"
#import "FTHelp.h"

@interface FootBallQueryViewController : PJTableViewController  
- (id)initWithPlayType:(FBPlayType)playType match_no:(NSString *)match_no;

@end
