//
//  BetViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/4.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "UIRadioControl.h"
#import "PullRefreshTableView.h"


@interface BetViewController : PJViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    
     UIRadioControl *radio;
     PullRefreshTableView *_allTableView;  // 全部页面
     PullRefreshTableView *_winTableView;  // 中奖页面
     PullRefreshTableView *_waitTableView; // 等待开奖页面
    
    int _selectIdx;       //选中的ID
    int lasteSelectIndex; //上次选中的ID
    NSString *query_type;                 // 投注记录的类型 
    
    UIImageView *_radioBottomImageView;//滑动条
    UIScrollView *_horizontalScrollView;// 水平滑动的ScrollView

}


@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *allData;   // 全部页面的数据
@property (nonatomic,strong)NSMutableArray *winData;   //  中奖页面的数据
@property (nonatomic,strong)NSMutableArray *waitData;   // 等待开奖页面的数据

@end
