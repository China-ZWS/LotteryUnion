//
//  AwardVC.m
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AwardVC.h"
#import "JCHModel.h"
#import "BaseCell.h"
#import "AwardDetailVC.h"
#import "FootBallModel.h"
#import "MJRefresh.h"


@interface AwardVC ()<UITableViewDataSource,UITableViewDelegate> {
    NSString *_lottery_pk;
    NSString *_playName;
    UITableView *_tableView ;
    NSUInteger _page_num;   //第几页
    NSUInteger _page_size;   //每一页的条数

    NSUInteger _total_page;
    NSUInteger _totalNumber;
    
    UIActivityIndicatorView *_activityView;
    UIButton *toFirstButton;
}

@end

@implementation AwardVC


#pragma mark -  返回
- (void)back
{
    [SVProgressHUD dismiss];
    [_connection cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma amrk 点击开奖号码页面跳转到开奖公告页面时将id传过去
- (id)initWithLottery_pk:(NSString *)lottery_pk playName:(NSString *)playName{
    
    if (self = [super init]) {
        
        _lottery_pk = lottery_pk;
        _playName = playName;
        _page_num = 1;
        
        self.view.backgroundColor = [UIColor clearColor];
        [self.navigationItem setNewTitle:@"开奖号码"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        self.data = [NSMutableArray new];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    //1>创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-64)];
    [self.view addSubview:_tableView];
    
    
    //2>设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    
    //3>去掉多余的线条
    [self setExtraCellLineHidden:_tableView];
    

    //4>创建点击回到最上面的按钮
    toFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toFirstButton.frame = CGRectMake(mScreenWidth-40-20, mScreenHeight-40-20-64, 40, 40);
    toFirstButton.hidden = YES;
    [toFirstButton addTarget:self action:@selector(toFirstAction:) forControlEvents:UIControlEventTouchUpInside];
    [toFirstButton setImage:[UIImage imageNamed:@"kjhm_jd.png"] forState:UIControlStateNormal];
    [self.view insertSubview:toFirstButton aboveSubview:_tableView];
    [self loadData];
    
    //5 下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page_num = 1;
        [self.data removeAllObjects];
        [self loadData];
        
    }];
    
    
    //6 上拉刷新
    _tableView.footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        if (_page_num < _total_page) {
            _page_num ++;
            [self loadData];
        }else {
            
            [_tableView.footer endRefreshing];
        }
    }];
    
    
}


//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}





#pragma mark - 加载数据
- (void)loadData {
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_QueryRevendList];
    params[@"lottery_pk"] = _lottery_pk;
    params[@"period"] = @"";
    params[@"page_num"] = [NSString stringWithFormat:@"%ld",(unsigned long)_page_num];
    params[@"page_size"] = @"10";
    
    NSLog(@"%ld",(long)kAPI_QueryRevendList);
    
    _connection = [RequestModel POST:URL(kAPI_QueryRevendList) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       if([data[@"code"] integerValue] == 0)
                       {
                           NSArray *itemArray = data[@"item"];
                           NSLog(@"itemArray = %@",itemArray);
                           _total_page = _total_page = [data[@"total_page"] intValue];
                           NSLog(@"%ld",(unsigned long)_total_page);
                           
                           if(itemArray.count>0)
                           {
                               for (NSDictionary *dic in itemArray) {
                                   
                                   JCHModel *jchModel = [[JCHModel alloc] init];
                                   jchModel.period = dic[@"period"];
                                   jchModel.lottery_pk = dic[@"lottery_pk"];
                                   jchModel.bonus_number = dic[@"bonus_number"];
                                   jchModel.bonus_time = dic[@"bonus_time"];
                                   [self.data addObject:jchModel];
                               }
                           
                           }
                          
                       }
                       [_tableView.header endRefreshing];
                       [_tableView.footer endRefreshing];
                       NSLog(@"%@",self.data);
                       [SVProgressHUD dismiss];
                       [_tableView reloadData];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [_tableView.header endRefreshing];
                       [_tableView.footer endRefreshing];
                       [SVProgressHUD showErrorWithStatus:msg];
                      
                   }];
    
}


#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseCell *cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lottery_pk = _lottery_pk;
    cell.playName = _playName;
    if(_data.count>0)
    {
       cell.jchModel = self.data[indexPath.row];
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}


//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AwardDetailVC *awardDetailVC = [[AwardDetailVC alloc] initWithJCHModel:self.data[indexPath.row]
                                                                  playName:_playName];
    [self.navigationController pushViewController:awardDetailVC animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y == 0) {
        toFirstButton.hidden = YES;
    }else {
        toFirstButton.hidden = NO;
    }
}

#pragma mark - 按钮点击事件
//回到最上面
- (void)toFirstAction:(UIButton *)button {

    if (self.data.count != 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else {
        return;
    }
    
}




@end
