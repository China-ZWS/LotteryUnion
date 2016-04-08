//
//  CollectViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/6.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CollectViewController.h"
#import "WinModel.h"
#import "CollectCell.h"
#import "CollectDetailViewController.h"
#import "MJRefresh.h"
#import "NSString+NumberSplit.h"

@interface CollectViewController () {
    UITableView *_tableView;
    NSUInteger _page_num;      //页数
    NSUInteger _page_size;    //每一页显示的数量
    NSUInteger _total_num;   //总记录数
    NSUInteger _total_page;   //总页数
    NSString *_identify;
    NSInteger _row;
    NSInteger _section;
    NSString *_selecteNumber;
    WinModel *_winModel;
    BOOL _isNext;
    UIButton *toFirstButton;
    UIScrollView *_scrollView;

}

@end

@implementation CollectViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self.navigationItem setTitle:@"收藏夹"];
        _page_num = 1;
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
         self.data = [NSMutableArray new];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
  
    }
    return self;
}

//TODO:返回动作
- (void)back
{
    [self popViewController];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //3 创建tableview
    UIView *bgView = (UIView *) [self.view viewWithTag:200];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, bgView.bottom, mScreenWidth, mScreenHeight-64-bgView.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, bgView.bottom, mScreenWidth, mScreenHeight-64-bgView.height) style:UITableViewStylePlain];
    [_scrollView addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self _createTop];
    
    //5 下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page_num = 1;
        [self.data removeAllObjects];
        [self loadData];
        
    }];
    
    
    //6 上拉刷新
    _tableView.footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        _isNext = YES;
        NSLog(@"%ld",(unsigned long)_total_page);
        if (_page_num < _total_page) {
            _page_num ++;
            NSLog(@"_page_num = %ld",(unsigned long)_page_num);
            [self requestNetWork];
        }else {
            
            [_tableView.footer endRefreshing];
        }
    }];
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

//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - 按钮点击事件
//回到最上面
- (void)toTopAction:(UIButton *)button {
    
    if (self.data.count != 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else {
        return;
    }
    
}


#pragma mark - 加载数据
- (void)loadData {
    
    [self.data removeAllObjects];
    [self requestNetWork];
 
}

- (void)requestNetWork {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_BookmarkList];
    params[@"lottery_pk"] = @"";
    params[@"page_num"] = [NSString stringWithFormat:@"%ld",(unsigned long)_page_num];     //页数  默认为第一页
    params[@"page_size"] = @"10";  //每一页的条数  默认为5条
    
    NSLog(@"%ld",(long)kAPI_BookmarkList);
    
    _connection = [RequestModel POST:URL(kAPI_BookmarkList) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       
                       NSLog(@"收藏列表：%@ ",data);
                       
                       NSArray *itemArray = data[@"item"];
                       _total_page = [data[@"total_page"] intValue];
                       [itemArray enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
                           
                           WinModel *winModel = [[WinModel alloc] initWithDataDic:item];
                           [self.data addObject:winModel];
                       }];
                       
                       NSLog(@"self.data = %@",self.data);
                       [_tableView.header endRefreshing];
                       [_tableView.footer endRefreshing];
                       [SVProgressHUD dismiss];
                       [_tableView reloadData];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       if ([state integerValue] == Status_Code_User_Not_Login)
                       {
                           [super gotoLoging];
                           [SVProgressHUD dismiss];
                           return;
                       }
                       [_tableView.header endRefreshing];
                       [_tableView.footer endRefreshing];
                       [SVProgressHUD showErrorWithStatus:msg];
                       
                   }];
}


- (void)refreshWithViews
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


#pragma mark -  UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectCell *cell = [[CollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    
    if(_data.count>0)
    {
        cell.winModel = self.data[indexPath.row];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    _winModel = self.data[indexPath.row] ;
    if ([_winModel.lottery_pk intValue] == lSSQ_lottery) {
        _selecteNumber = [_winModel SSNumber:_winModel.number lottery_code:_winModel.lottery_code];
    }else {
        _selecteNumber = [_winModel formatedNumber];
    }
    [self.navigationController pushViewController:[[CollectDetailViewController alloc] initWithModel:self.data[indexPath.row] withLotteryName:[self getLotNames:_winModel.lottery_pk] withSelectNumber:_selecteNumber] animated:YES];
}

#pragma mark - 通过彩种获得名字
- (NSString *)getLotNames:(NSString *)lot_pk {
    
    return  [[self getLotteryDictionary:lot_pk] objectForKey:@"PlayName"];
}

- (NSDictionary *)getLotteryDictionary:(NSString *)lottery_pk {
    
    if(!lots_dictionary){
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"PlayType" ofType:@"plist"];
        lots_dictionary = [NSDictionary dictionaryWithContentsOfFile:plist];
        NSLog(@"lots_dictionary = %@",lots_dictionary);
    }
    return [lots_dictionary objectForKey:lottery_pk];
    
}

#pragma mark -  UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y == 0) {
        toFirstButton.hidden = YES;
    }else {
        toFirstButton.hidden = NO;
    }
}




@end
