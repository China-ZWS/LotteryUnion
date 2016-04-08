//
//  MineVC.h
//  LotteryUnion
//
//  Created by xhd945 on 15/10/19.
//  Copyright © 2015年 xhd945. All rights reserved.
//

#import "TopViewController.h"

@interface MineVC : TopViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

+(void)setNew:(int)n;

@end
