//
//  AccountViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/6.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AccountViewController.h"
#import "UIColor+RandomColor.h"
#import "WinModel.h"
#import "AccountCell.h"
#import "AccountDetailViewController.h"
#import "MJRefresh.h"

@interface AccountViewController () {
    UIButton *toFirstButton;
}

@end

@implementation AccountViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self.navigationItem setTitle:@"账户明细"];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
       _page_num = 1;
        self.chargeData= [NSMutableArray new];
        self.deductCostData = [NSMutableArray new];
        self.sendAwardData = [NSMutableArray new];
        self.drawCashData = [NSMutableArray new];
        self.reChargeData = [NSMutableArray new];
    }
    return self;
}


//TODO:返回动作
- (void)back
{
    [self popViewController];
     [SVProgressHUD dismiss];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建5个tableView
    [self _initContentView];
    
    //创建点击回到最上面的按钮
    [self _createTop];
    
    //去掉多余的分割线
    [self extraLine];
    
    //加载数据
    [self queryAccountList];
    
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

- (void)extraLine {
    [self setExtraCellLineHidden:self.chargeTableView];
    [self setExtraCellLineHidden:self.deductCostTableView];
    [self setExtraCellLineHidden:self.sendAwardTableView];
    [self setExtraCellLineHidden:self.drawCashTableView];
    [self setExtraCellLineHidden:self.reChargeTableView];
}



#pragma mark - 创建3个tableView
-(void)_initContentView
{
    //tab
    NSArray *items = [NSArray arrayWithObjects:LocStr(@"充值"),LocStr(@"扣费"),LocStr(@"派奖"),LocStr(@"提现"),LocStr(@"回充"), nil];
    // 高度 IOS7?64+5.0:5.0
    radio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,0,mScreenWidth,34.0) items:items];
    radio.selectedIndex = 0;
    
    _selectIdx = 0;  // 默认选中的是全部
    lasteSelectIndex = 0;// 默认上次选中的ID
    query_type = @"2";
    
    [radio addTarget:self action:@selector(radioValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:radio];
    
    _radioBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, radio.bottom-2, mScreenWidth/items.count, 2)];
    _radioBottomImageView.image = [[UIImage imageNamed:@"red_line@2x.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [self.view addSubview:_radioBottomImageView];
    
    // 表视图有关
    _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, mScreenWidth, mScreenHeight-64-40)];
    _horizontalScrollView.contentSize = CGSizeMake(_horizontalScrollView.width*items.count, _horizontalScrollView.height);
    _horizontalScrollView.delegate = self;
    _horizontalScrollView.pagingEnabled = YES;
    _horizontalScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_horizontalScrollView];
    
    
    NSArray *list = @[@"类型",@"金额",@"时间",@"状态"];
    
    UIColor *blueColor = RGBA(111, 137, 189, 1);
    UIColor *greenColor = RGBA(0, 165, 175, 1);
    UIColor *redColor = RGBA(235, 70, 75, 1);
    UIColor *orangeColor = RGBA(249, 177, 116, 1);
    
    NSArray *color = @[blueColor,greenColor,redColor,orangeColor];
    
    for (int i = 0; i <4; i++) {
        CGFloat width = (mScreenWidth-20)/4;
        
        //创建底部视图
        bgView = [[UIView alloc] initWithFrame:CGRectMake(10+(i*width), radio.bottom, width, 30)];
        bgView.tag = 200+i;
        bgView.backgroundColor = color[i];
        [self.view addSubview:bgView];
        
        //创建label
        UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
        listLabel.text = list[i];
        listLabel.font = [UIFont systemFontOfSize:14];
        listLabel.textAlignment = NSTextAlignmentCenter;
        listLabel.textColor = [UIColor whiteColor];
        [bgView insertSubview:listLabel atIndex:2];
    }
    
    //表格
    //1  充值
    self.chargeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0+10,30, mScreenWidth-20, _horizontalScrollView.height-30) style:UITableViewStylePlain];
    [self.chargeTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.chargeTableView setBackgroundColor:[UIColor clearColor]];
    self.chargeTableView.showsVerticalScrollIndicator = NO;
    [self.chargeTableView setBackgroundView:nil];
    [self.chargeTableView setRowHeight:60.0];
    [self.chargeTableView setDataSource:self];
    [self.chargeTableView setDelegate:self];
    [self loadNewData:self.chargeTableView];
    [self loadNextData:self.chargeTableView];
    [_horizontalScrollView addSubview:self.chargeTableView];
    
    
    //2 扣费
    self.deductCostTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth+10,30, mScreenWidth-20, _horizontalScrollView.height-30) style:UITableViewStylePlain];
    [self.deductCostTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.deductCostTableView setBackgroundColor:[UIColor clearColor]];
    self.deductCostTableView.showsVerticalScrollIndicator = NO;
    [self.deductCostTableView setBackgroundView:nil];
    [self.deductCostTableView setRowHeight:60.0];
    [self.deductCostTableView setDataSource:self];
    [self.deductCostTableView setDelegate:self];
    [self loadNewData:self.deductCostTableView];
    [self loadNextData:self.deductCostTableView];
    [_horizontalScrollView addSubview:self.deductCostTableView];
    
    
    //3 派奖
    self.sendAwardTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth*2+10,30, mScreenWidth-20, _horizontalScrollView.height-30) style:UITableViewStylePlain];
    [ self.sendAwardTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [ self.sendAwardTableView setBackgroundColor:[UIColor clearColor]];
     self.sendAwardTableView.showsVerticalScrollIndicator = NO;
    [ self.sendAwardTableView setBackgroundView:nil];
    [ self.sendAwardTableView setRowHeight:60.0];
    [ self.sendAwardTableView setDataSource:self];
    [ self.sendAwardTableView setDelegate:self];
    [self loadNewData:self.sendAwardTableView];
    [self loadNextData:self.sendAwardTableView];
    [_horizontalScrollView addSubview: self.sendAwardTableView];
    
    
    //4 提现
    self.drawCashTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth*3+10,30, mScreenWidth-20, _horizontalScrollView.height-30) style:UITableViewStylePlain];
    [self.drawCashTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.drawCashTableView setBackgroundColor:[UIColor clearColor]];
    self.drawCashTableView.showsVerticalScrollIndicator = NO;
    [self.drawCashTableView setBackgroundView:nil];
    [self.drawCashTableView setRowHeight:60.0];
    [self.drawCashTableView setDataSource:self];
    [self.drawCashTableView setDelegate:self];
    [self loadNewData:self.drawCashTableView];
    [self loadNextData:self.drawCashTableView];
    [_horizontalScrollView addSubview:self.drawCashTableView];
    
    
    //5 回充
    self.reChargeTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth*4+10,30, mScreenWidth-20, _horizontalScrollView.height-30) style:UITableViewStylePlain];
    [ self.reChargeTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [ self.reChargeTableView setBackgroundColor:[UIColor clearColor]];
    self.reChargeTableView.showsVerticalScrollIndicator = NO;
    [ self.reChargeTableView setBackgroundView:nil];
    [ self.reChargeTableView setRowHeight:60.0];
    [ self.reChargeTableView setDataSource:self];
    [ self.reChargeTableView setDelegate:self];
    [self loadNewData:self.reChargeTableView];
    [self loadNextData:self.reChargeTableView];
    [_horizontalScrollView addSubview: self.reChargeTableView];
}

//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



#pragma mark - 加载数据
- (void)queryAccountList {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_QueryTrade];
    params[@"page_num"] = [NSString stringWithFormat:@"%ld",(long)_page_num];      //页数  默认为第一页
    params[@"page_size"] = @"10";    //每一页的条数  默认为5条
    params[@"type"] = query_type;
    
    _connection = [RequestModel POST:URL(kAPI_QueryTrade) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       
                       NSLog(@"data = %@",data);
                       [NSThread detachNewThreadSelector:@selector(setAccountData:) toTarget:self withObject:data];
                       [SVProgressHUD dismiss];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       NSLog(@"%@",msg);
                       if ([state integerValue] == Status_Code_User_Not_Login)
                       {
                           [super gotoLoging];
                           [SVProgressHUD dismiss];
                           return;
                       }
                       [self stopRefreshing];
                       [SVProgressHUD showErrorWithStatus:msg];
                       
                   }];
    
}


- (void)refreshWithViews
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

// 设置数据
- (void)setAccountData:(NSDictionary *)aDict
{
    _total_page = [[aDict objectForKey:@"total_page"] intValue];
    _total_num = [[aDict objectForKey:@"total_num"] intValue];
    NSArray *items = [aDict objectForKey:@"item"];
    NSLog(@"_selectIdx = %d",_selectIdx);
    
    for (NSDictionary *item in items) {
        if (_selectIdx == 0) {// 充值
            [_chargeData addObject:[[WinModel alloc] initWithDataDic:item]];
        } else if(_selectIdx == 1) {// 扣费
            [_deductCostData addObject:[[WinModel alloc] initWithDataDic:item]];
        } else if(_selectIdx == 2){// 派奖
            [_sendAwardData addObject:[[WinModel alloc] initWithDataDic:item]];
        }else if(_selectIdx == 3){// 提现
            [_drawCashData addObject:[[WinModel alloc] initWithDataDic:item]];
        }else if(_selectIdx == 4){// 回扣
            [_reChargeData addObject:[[WinModel alloc] initWithDataDic:item]];
        }
    
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:NO];
}

// 刷新UI
- (void)updateUI
{
    if (_selectIdx == 0) {// 充值
        [_chargeTableView reloadData];
        [_chargeTableView.header endRefreshing];
        [_chargeTableView.footer endRefreshing];
    } else if(_selectIdx == 1) {// 扣费
        [_deductCostTableView reloadData];
        [_deductCostTableView.header endRefreshing];
        [_deductCostTableView.footer endRefreshing];
    } else if(_selectIdx == 2){// 派奖
        [_sendAwardTableView reloadData];
        [_sendAwardTableView.header endRefreshing];
        [_sendAwardTableView.footer endRefreshing];
    }else if(_selectIdx == 3){// 提现
        [_drawCashTableView reloadData];
        [_drawCashTableView.header endRefreshing];
        [_drawCashTableView.footer endRefreshing];
    }else if(_selectIdx == 4){// 回扣
        [_reChargeTableView reloadData];
        [_reChargeTableView.header endRefreshing];
        [_reChargeTableView.footer endRefreshing];
    }
}

//请求失败后停止刷新
- (void)stopRefreshing {
    [_chargeTableView.header endRefreshing];
    [_chargeTableView.footer endRefreshing];
    [_deductCostTableView.header endRefreshing];
    [_deductCostTableView.footer endRefreshing];
    [_sendAwardTableView.header endRefreshing];
    [_sendAwardTableView.footer endRefreshing];
    [_drawCashTableView.header endRefreshing];
    [_drawCashTableView.footer endRefreshing];
    [_reChargeTableView.header endRefreshing];
    [_reChargeTableView.footer endRefreshing];
}

#pragma  mark - 刷新
- (void)loadNewData:(UITableView *)tableView {
    
    //5 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page_num = 1;   //重新置为1
        
        if (tableView == self.chargeTableView) {
            
            [self.chargeData removeAllObjects];
            [self queryAccountList];
            
        }else if (tableView == self.deductCostTableView ) {
            
            [self.deductCostData removeAllObjects];
            [self queryAccountList];
            
        }else if (tableView == self.sendAwardTableView ) {
            
            [self.sendAwardData removeAllObjects];
            [self queryAccountList];
            
        }else if (tableView == self.drawCashTableView ) {
            
            [self.drawCashData removeAllObjects];
            [self queryAccountList];
            
        }else if (tableView == self.reChargeTableView ) {
            
            [self.reChargeData removeAllObjects];
            [self queryAccountList];
            
        }
        
    }];
}


//上拉刷新
- (void)loadNextData:(UITableView *)tableView {
    
    tableView.footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        _page_num ++;
        [self queryAccountList];
    }];
}


#pragma mark - UITableView  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.chargeTableView) { //充值
        return self.chargeData.count;
        
    }else if (tableView == self.deductCostTableView) {     //扣费
        
        return self.deductCostData.count;
        
    }else if (tableView == self.sendAwardTableView){
        
        return self.sendAwardData.count;
        
    }else if (tableView == self.drawCashTableView) {
        
        return self.drawCashData.count;
    }else {
        
        return self.reChargeData.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountCell *cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    
    if (tableView == self.chargeTableView) {        //充值
        
        if (self.chargeData.count > 0) {
            [cell winModel:self.chargeData[indexPath.row] sign:NO tag:1];
        }
        
    }else if (tableView == self.deductCostTableView) {    //扣费
        
        if (self.deductCostData.count > 0) {
            [cell winModel:self.deductCostData[indexPath.row] sign:YES tag:2];
        }
        
    }else if (tableView == self.sendAwardTableView){     //派奖
        if (self.sendAwardData.count > 0) {
            [cell winModel:self.sendAwardData[indexPath.row] sign:NO tag:3];
        }
        
    }else if (tableView == self.drawCashTableView) {       //提现
        
        if (self.drawCashData.count > 0) {
            [cell winModel:self.drawCashData[indexPath.row] sign:NO tag:4];
        }
        
    }else if (tableView == self.reChargeTableView) {      //回充
        
        if (self.reChargeData.count > 0) {
            [cell winModel:self.reChargeData[indexPath.row] sign:NO tag:5];
        }
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (tableView == self.chargeTableView) {        //充值
        
        [self.navigationController pushViewController:[[AccountDetailViewController alloc] initWithWinModel:self.chargeData[indexPath.row]] animated:YES];
        
        
    }else if (tableView == self.deductCostTableView) {    //扣费
        
        [self.navigationController pushViewController:[[AccountDetailViewController alloc] initWithWinModel:self.deductCostData[indexPath.row]] animated:YES];
        
    }else if (tableView == self.sendAwardTableView){     //派奖
        
        [self.navigationController pushViewController:[[AccountDetailViewController alloc] initWithWinModel:self.sendAwardData[indexPath.row]] animated:YES];
        
    }else if (tableView == self.drawCashTableView) {       //提现
        
        [self.navigationController pushViewController:[[AccountDetailViewController alloc] initWithWinModel:self.drawCashData[indexPath.row]] animated:YES];
        
    }else {      //回充
        
        [self.navigationController pushViewController:[[AccountDetailViewController alloc] initWithWinModel:self.reChargeData[indexPath.row]] animated:YES];
    }
    
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
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
         NSLog(@"hahaha = %d",_selectIdx);
        if (lasteSelectIndex != _selectIdx) {
            radio.selectedIndex = _selectIdx;
            query_type = [self getQuery_type:_selectIdx];
            switch (_selectIdx) {
                case 0:{   //
                    if (_chargeData.count == 0) {
                         [self queryAccountList];
                    }else {
                    }
                }
                    break;
                case 1:{   //
                    if (_deductCostData.count == 0) {
                         [self queryAccountList];
                    }else {
                    }
                }
                    break;
                case 2: {  //
                    if (_sendAwardData.count == 0) {
                         [self queryAccountList];
                    }else {
                    }
                }
                    break;
                case 3: {  //
                    if (_drawCashData.count == 0) {
                        [self queryAccountList];
                    }else {
                    }
                }
                    break;
                case 4: {  //
                    if (_reChargeData.count == 0) {
                        [self queryAccountList];
                    
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
    NSLog(@"hahaha = %d",_selectIdx);
    if (lasteSelectIndex != _selectIdx) {
        _radioBottomImageView.left = mScreenWidth/3*sender.selectedIndex;
        [_horizontalScrollView setContentOffset:CGPointMake(_horizontalScrollView.width*_selectIdx, 0) animated:YES];
        query_type = [self getQuery_type:_selectIdx];
        switch (_selectIdx) {
            case 0:{   //
                if (_chargeData.count == 0) {
                    [self queryAccountList];
                }else {
                }
            }
                break;
            case 1:{   //
                if (_deductCostData.count == 0) {
                    [self queryAccountList];
                }else {
                }
            }
                break;
            case 2: {  //
                if (_sendAwardData.count == 0) {
                    [self queryAccountList];
                }else {
                }
            }
                break;
            case 3: {  //
                if (_drawCashData.count == 0) {
                    [self queryAccountList];
                }else {
                }
            }
                break;
            case 4: {  //
                if (_reChargeData.count == 0) {
                    [self queryAccountList];
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
            return @"2";  //充值
            break;
        case 1:
            return @"1";
            break;
        case 2:
            return @"4";
            break;
        case 3:
            return @"3";
            break;
        case 4:
            return @"5";
            break;
        default:
            return @"2";
            break;
    }
}


#pragma mark - 按钮点击事件
//回到最上面
- (void)toTopAction:(UIButton *)button {
    
    [self tab:self.chargeTableView];
    [self tab:self.deductCostTableView];
    [self tab:self.sendAwardTableView];
    [self tab:self.drawCashTableView];
    [self tab:self.reChargeTableView];
    
}


- (void)tab:(UITableView *)tableView {
    
    if (tableView == self.chargeTableView) {
        if (self.chargeData.count != 0) {
            [self.chargeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            return;
        }
        
    }else if (tableView == self.deductCostTableView) {
        if (self.deductCostData.count != 0) {
            [self.deductCostTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            return;
        }
        
    }else if (tableView == self.sendAwardTableView) {
        if (self.sendAwardData.count != 0) {
            [self.sendAwardTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            return;
        }
        
    }else if (tableView == self.drawCashTableView) {
        
        if (self.drawCashData.count != 0) {
            [self.drawCashTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            return;
        }
        
    }else if (tableView == self.reChargeTableView) {
        
        if (self.reChargeData.count != 0) {
            [self.reChargeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            return;
        }
        
    }
}


@end
