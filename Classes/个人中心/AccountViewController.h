//
//  AccountViewController.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/6.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"
#import "UIRadioControl.h"
#import "PullRefreshTableView.h"

@interface AccountViewController : PJViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    
    UIRadioControl *radio;
 
    int _selectIdx;       //选中的ID
    int lasteSelectIndex; //上次选中的ID
    NSString *query_type;                 // 投注记录的类型
    
    UIImageView *_radioBottomImageView;//滑动条
    UIScrollView *_horizontalScrollView;// 水平滑动的ScrollView
    UIView *bgView;
    NSInteger _page_num;      //页数
    NSUInteger _page_size;    //每一页显示的数量
    NSUInteger _total_num;   //总记录数
    NSUInteger _total_page;   //总页数
}


@property (nonatomic,strong)UITableView *chargeTableView;         //充值
@property (nonatomic,strong)UITableView *deductCostTableView;     //扣费
@property (nonatomic,strong)UITableView *sendAwardTableView;      //派奖
@property (nonatomic,strong)UITableView *drawCashTableView;       //提现
@property (nonatomic,strong)UITableView *reChargeTableView;      //回充

@property (nonatomic,strong)NSMutableArray *chargeData;         //充值
@property (nonatomic,strong)NSMutableArray *deductCostData;     //扣费
@property (nonatomic,strong)NSMutableArray *sendAwardData;      //派奖
@property (nonatomic,strong)NSMutableArray *drawCashData;       //提现
@property (nonatomic,strong)NSMutableArray *reChargeData;      //回充


@end
