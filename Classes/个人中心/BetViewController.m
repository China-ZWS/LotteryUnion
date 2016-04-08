//
//  BetViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/4.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BetViewController.h"
#import "WinModel.h"
#import "BetCell.h"
#import "BetDetailViewController.h"
#import "MJRefresh.h"

@interface BetViewController () {
    
    UITableView *_tableView;
    NSInteger _page_num;      //页数
    NSUInteger _page_size;    //每一页显示的数量
    NSUInteger _total_num;   //总记录数
    NSUInteger _total_page;   //总页数
    NSString *_identify;
    UIButton *toFirstButton;
}

@end

@implementation BetViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
      
        _page_num = 1;
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        self.allData= [NSMutableArray new];
        self.waitData= [NSMutableArray new];
        self.winData= [NSMutableArray new];
        [self.navigationItem setTitle:@"投注记录"];
        
    }
    return self;
}


//TODO:返回动作
- (void)back{
    
    [_connection cancel];
    [SVProgressHUD dismiss];
    [self popViewController];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //创建3个tableView
    [self _initContentView];
    
    //去掉多余的分割线
    [self extraLine];
    
    //创建点击回到最上面的按钮
    [self _createTop];
    
    //加载数据
    [self queryBetRecordList];
    
}


- (void)extraLine {
    [self setExtraCellLineHidden:_allTableView];
    [self setExtraCellLineHidden:_winTableView];
    [self setExtraCellLineHidden:_waitTableView];
}


- (void)_createTop {
    
    //创建回到顶部的按钮
    toFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toFirstButton.hidden = YES;
    toFirstButton.frame = CGRectMake(mScreenWidth-40-20, mScreenHeight-40-20-64, 40, 40);
    [toFirstButton addTarget:self action:@selector(toTopAction:) forControlEvents:UIControlEventTouchUpInside];
    [toFirstButton setImage:[UIImage imageNamed:@"kjhm_jd.png"] forState:UIControlStateNormal];
    [self.view insertSubview:toFirstButton atIndex:5];
}



//回到最上面
- (void)toTopAction:(UIButton *)button {
    
    [self tab:_allTableView];
    [self tab:_winTableView];
    [self tab:_waitTableView];
}


- (void)tab:(UITableView *)tableView {
    
    if (tableView == _allTableView) {
        if (self.allData.count != 0) {
            [_allTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            return;
        }
        
    }else if (tableView == _winTableView) {
        if (self.winData.count != 0) {
            [_winTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            return;
        }
        
    }else if (tableView == _waitTableView) {
        if (self.waitData.count != 0) {
            [_waitTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            return;
        }
        
    }
}


//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - 创建3个tableView
-(void)_initContentView
{
    //tab
    NSArray *items = [NSArray arrayWithObjects:LocStr(@"全部"),LocStr(@"中奖"),LocStr(@"等待开奖"), nil];
    // 高度 IOS7?64+5.0:5.0
    radio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,0,mScreenWidth,34.0) items:items];
    radio.selectedIndex = 0;
    
    _selectIdx = 0;  // 默认选中的是全部
    lasteSelectIndex = 0;// 默认上次选中的ID
    query_type = @"0";
    
    [radio addTarget:self action:@selector(radioValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:radio];
    
    _radioBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, radio.bottom-2, mScreenWidth/items.count, 1)];
    _radioBottomImageView.image = [[UIImage imageNamed:@"red_line@2x.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [self.view addSubview:_radioBottomImageView];
    
    // 表视图有关
    _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, mScreenWidth, mScreenHeight-64-38)];
    _horizontalScrollView.contentSize = CGSizeMake(_horizontalScrollView.width*items.count, _horizontalScrollView.height);
    _horizontalScrollView.delegate = self;
    _horizontalScrollView.pagingEnabled = YES;
    _horizontalScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_horizontalScrollView];
    
    //表格
    _allTableView= [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0,0, mScreenWidth, _horizontalScrollView.height) style:UITableViewStylePlain];
    [_allTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_allTableView setBackgroundColor:[UIColor clearColor]];
    _allTableView.showsVerticalScrollIndicator = NO;
    [_allTableView setBackgroundView:nil];
    [_allTableView setRowHeight:60.0];
    [_allTableView setDataSource:self];
    [_allTableView setDelegate:self];
    [self loadNewData:_allTableView];
    [self loadNextData:_allTableView];
    [_horizontalScrollView addSubview:_allTableView];
  
    
    _winTableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(mScreenWidth,0, mScreenWidth, _horizontalScrollView.height) style:UITableViewStylePlain];
    [_winTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_winTableView setBackgroundColor:[UIColor clearColor]];
    _winTableView.showsVerticalScrollIndicator = NO;
    [_winTableView setBackgroundView:nil];
    [_winTableView setRowHeight:60.0];
    [_winTableView setDataSource:self];
    [_winTableView setDelegate:self];
    [self loadNewData:_winTableView];
    [self loadNextData:_winTableView];
    [_horizontalScrollView addSubview:_winTableView];
    
    _waitTableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(mScreenWidth*2,0, mScreenWidth, _horizontalScrollView.height) style:UITableViewStylePlain];
    [_waitTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_waitTableView setBackgroundColor:[UIColor clearColor]];
    _waitTableView.showsVerticalScrollIndicator = NO;
    [_waitTableView setBackgroundView:nil];
    [_waitTableView setRowHeight:60.0];
    [_waitTableView setDataSource:self];
    [_waitTableView setDelegate:self];
    [self loadNewData:_waitTableView];
    [self loadNextData:_waitTableView];
    [_horizontalScrollView addSubview:_waitTableView];
}

#pragma mark - 加载数据
- (void)queryBetRecordList {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_QueryBetRecord];
    params[@"lottery_pk"] = @"";
    params[@"period"] = @"";
    params[@"page_num"] = [NSString stringWithFormat:@"%ld",(long)_page_num];      //页数  默认为第一页
    params[@"page_size"] = @"15";    //每一页的条数  默认为5条
    params[@"query_type"] = query_type;    //全部
    NSLog(@"%ld",(long)kAPI_QueryBetRecord);
    
    _connection = [RequestModel POST:URL(kAPI_QueryBetRecord) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       [NSThread detachNewThreadSelector:@selector(setBetData:) toTarget:self withObject:data];
                       [SVProgressHUD dismiss];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       if ([state integerValue] == Status_Code_User_Not_Login)
                       {
                           [super gotoLoging];
                           [SVProgressHUD dismiss];
                           return;
                       }
                       [SVProgressHUD showErrorWithStatus:msg];
                       [_allTableView.header endRefreshing];
                       [_allTableView.footer endRefreshing];
                       [_winTableView.header endRefreshing];
                       [_winTableView.footer endRefreshing];
                       [_waitTableView.header endRefreshing];
                       [_waitTableView.footer endRefreshing];
                   }];
    
}

- (void)refreshWithViews
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}



// 设置数据
- (void)setBetData:(NSDictionary *)aDict
{
    _total_page = [[aDict objectForKey:@"total_page"] intValue];
    _total_num = [[aDict objectForKey:@"total_num"] intValue];
    NSArray *items = [aDict objectForKey:@"item"];
    NSLog(@"%d",_selectIdx);
    if(items){
        int count = items.count;
        for(int i=0;i<count;i++){
            if (_selectIdx == 0) {// 全部
                [_allData addObject:[[WinModel alloc] initWithDataDic:[items objectAtIndex:i]]];
            } else if(_selectIdx == 2) {// 等待开奖
                [_waitData addObject:[[WinModel alloc] initWithDataDic:[items objectAtIndex:i]]];
            } else {// 已中奖
                [_winData addObject:[[WinModel alloc] initWithDataDic:[items objectAtIndex:i]]];
            }
        }
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:NO];
}

// 刷新UI
- (void)updateUI
{
    if (_selectIdx == 0) {
        [_allTableView reloadData];
        [_allTableView.header endRefreshing];
        [_allTableView.footer endRefreshing];
    } else if (_selectIdx == 1) {
        [_winTableView reloadData];
        [_winTableView.header endRefreshing];
        [_winTableView.footer endRefreshing];
    } else {
        [_waitTableView reloadData];
        [_waitTableView.header endRefreshing];
        [_waitTableView.footer endRefreshing];
    }
}

#pragma  mark - 刷新
- (void)loadNewData:(UITableView *)tableView {
    
    //5 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page_num = 1;   //重新置为1
        
        if (tableView == _allTableView) {
            [_allData removeAllObjects];
            [self queryBetRecordList];
            
        }else if (tableView == _winTableView) {
            
            [self.winData removeAllObjects];
            [self queryBetRecordList];
            
        }else if (tableView == _waitTableView) {
            
            [self.waitData removeAllObjects];
            [self queryBetRecordList];
        }
       
    }];
}


//上拉刷新
- (void)loadNextData:(UITableView *)tableView {
    
    tableView.footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        _page_num ++;
        [self queryBetRecordList];
    }];
}




#pragma mark - UITableView  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _allTableView) {
        return self.allData.count;
    }else if (tableView == _winTableView) {
        return _winData.count;
    }else{
        return self.waitData.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BetCell *cell = [[BetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    if (tableView == _allTableView) {
        
        if (self.allData.count > 0) {
          [cell setWinModel:self.allData[indexPath.row]];
        }
        
    }else if (tableView == _winTableView) {
        
        if (self.winData.count > 0) {
            [cell setWinModel:self.winData[indexPath.row]];
        }
        
    }else if (tableView == _waitTableView){
        
        if (self.waitData.count > 0) {
            [cell setWinModel:self.waitData[indexPath.row]];
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _allTableView) {
        
        if (indexPath.row<_allData.count) {
            
             BetDetailViewController *betDetailVC = [[BetDetailViewController alloc] initWithModel:self.allData[indexPath.row]];
            [self.navigationController pushViewController:betDetailVC animated:YES];
            [_allTableView deselectRowAtIndexPath:indexPath animated:NO];
            
        }else{
            NSLog(@"error!!");
        }
    }else if (tableView == _winTableView) {
        
        if (indexPath.row<_winData.count) {
            //push 到中奖详细页面
            
            BetDetailViewController *betDetailVC = [[BetDetailViewController alloc] initWithModel:self.winData[indexPath.row]];
            [self.navigationController pushViewController:betDetailVC animated:YES];
            [_winTableView deselectRowAtIndexPath:indexPath animated:NO];
        } else {
            NSLog(@"error!!");
        }
    }else{
        if (indexPath.row<_waitData.count) {
        BetDetailViewController *betDetailVC = [[BetDetailViewController alloc] initWithModel:self.waitData[indexPath.row]];
        [self.navigationController pushViewController:betDetailVC animated:YES];
        [_waitTableView deselectRowAtIndexPath:indexPath animated:NO];
        } else {
            NSLog(@"error!!");
        }
    }
}



#pragma mark - 按钮点击事件
//回到最上面
- (void)toFirstAction:(UIButton *)button {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}


#pragma mark  UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //左右滑动时下面的imgView跟着滑动
    if (scrollView == _horizontalScrollView) {
        int x = scrollView.contentOffset.x;
        _radioBottomImageView.left = x/mScreenWidth*_radioBottomImageView.width;
    }
    
    if (scrollView.contentOffset.y == 0) {
        toFirstButton.hidden = YES;
    }else {
        toFirstButton.hidden = NO;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _horizontalScrollView) {
        
        int x = scrollView.contentOffset.x;
        _selectIdx = x/mScreenWidth;
        
        if (lasteSelectIndex != _selectIdx) {
            radio.selectedIndex = _selectIdx;
            query_type = [self getQuery_type:_selectIdx];
            switch (_selectIdx) {
                case 0:{   //全部
                    if (_allData.count == 0) {
                        [self queryBetRecordList];
                    }else {
                    }
                }
                    break;
                case 1:{   //中奖
                    if (_winData.count == 0) {
                        [self queryBetRecordList];
                    }else {
                    }
                }
                    break;
                case 2: {  //等待开奖
                    if (_waitData.count == 0) {
                        [self queryBetRecordList];
                    }else {
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            
        }
        lasteSelectIndex = _selectIdx;
    }
}


// 改变title
- (void)radioValueChanged:(UIRadioControl *)sender
{
    _selectIdx = (int)sender.selectedIndex;
    
    if (lasteSelectIndex != _selectIdx) {
        _radioBottomImageView.left = mScreenWidth/3*sender.selectedIndex;
        [_horizontalScrollView setContentOffset:CGPointMake(_horizontalScrollView.width*_selectIdx, 0) animated:YES];
        query_type = [self getQuery_type:_selectIdx];
        switch (_selectIdx) {
            case 0:{   //全部
                if (_allData.count == 0) {
                    [self queryBetRecordList];
                }else {
                }
            }
                break;
            case 1:{   //中奖
                if (_winData.count == 0) {
                    [self queryBetRecordList];
                }else {
                }
            }
                break;
            case 2: {  //等待开奖
                if (_waitData.count == 0) {
                    [self queryBetRecordList];
                }else {
                }
            }
                break;
                
            default:
                break;
        }
    } else {
        NSLog(@"和上次一样");
    }
    lasteSelectIndex = _selectIdx;
}


-(NSString *)getQuery_type:(int)selected
{
    switch (_selectIdx) {
        case 0:
            return @"0";
            break;
        case 1:
            return @"2";
            break;
        case 2:
            return @"1";
            break;
        default:
            return @"0";
            break;
    }
}


@end
