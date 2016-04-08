//
//  SendLuckyViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "SendLuckyViewController.h"
#import "UIColor+RandomColor.h"
#import "WinModel.h"
#import "SendDetailViewController.h"
#import "SendCell.h"
#import "MJRefresh.h"

@interface SendLuckyViewController () {
    
    UITableView *_tableView;
    NSUInteger _page_num;      //页数
    NSUInteger _page_size;    //每一页显示的数量
    NSUInteger _total_num;   //总记录数
    NSUInteger _total_page;   //总页数
    NSString *_identify;
    UIButton *toFirstButton;
}

@end

@implementation SendLuckyViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
         _page_num = 1;
         self.data = [NSMutableArray new];
         [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        
    }
    return self;
}

//TODO:返回动作
- (void)back
{
     [SVProgressHUD dismiss];
    [self popViewController];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //1 导航栏相关设置
    [self.navigationItem setTitle:@"送彩票记录"];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //2 创建视图
    [self _createInitViews];
    
    //3 创建tableview
    UIView *bgView = (UIView *) [self.view viewWithTag:200];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, bgView.bottom, mScreenWidth-20, mScreenHeight-64-bgView.height-10) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self setExtraCellLineHidden:_tableView];
    
    [self _createTop];
    
    
    //4 加载数据
    [self loadData];
    
    
    
    //5 下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page_num = 1;
        [self.data removeAllObjects];
        [self loadData];
        
    }];
    
    
    //6 上拉刷新
    _tableView.footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        NSLog(@"%ld",_total_page);
        if (_page_num < _total_page) {
            _page_num ++;
            NSLog(@"_page_num = %ld",_page_num);
            [self loadData];
        }else {
            
            [_tableView.footer endRefreshing];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - 创建视图
- (void)_createInitViews {
    
    NSArray *list = @[@"彩种",@"期数",@"奖金",@"手机号码"];
    
    UIColor *blueColor = RGBA(111, 137, 189, 1);
    UIColor *greenColor = RGBA(0, 165, 175, 1);
    UIColor *redColor = RGBA(235, 70, 75, 1);
    UIColor *orangeColor = RGBA(249, 177, 116, 1);
    NSArray *color = @[blueColor,greenColor,redColor,orangeColor];
    
    for (int i = 0; i <4; i++) {
        CGFloat width = (mScreenWidth-20)/4;
        
        //创建底部视图
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10+(i*width), 10, width, 30)];
        bgView.tag = 200+i;
        bgView.backgroundColor = color[i];
        [self.view addSubview:bgView];
        
        //创建label
        UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
        listLabel.text = list[i];
        listLabel.font = [UIFont systemFontOfSize:14];
        listLabel.textAlignment = NSTextAlignmentCenter;
        listLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:listLabel];
    }
    
}



- (void)_createTop {
    
    //创建回到顶部的按钮
    toFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toFirstButton.hidden = YES;
    toFirstButton.frame = CGRectMake(mScreenWidth-40-20, mScreenHeight-40-20-64, 40, 40);
    [toFirstButton addTarget:self action:@selector(toFirstAction:) forControlEvents:UIControlEventTouchUpInside];
    [toFirstButton setImage:[UIImage imageNamed:@"kjhm_jd.png"] forState:UIControlStateNormal];
    [self.view insertSubview:toFirstButton atIndex:5];
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


#pragma mark - 加载数据
- (void)loadData {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_QueryLuckyRecord];
    params[@"lottery_pk"] = @"";
    params[@"page_num"] = [NSString stringWithFormat:@"%ld",(unsigned long)_page_num];     //页数  默认为第一页
    params[@"page_size"] = @"15";  //每一页的条数  默认为5条
    
    NSLog(@"%ld",(long)kAPI_QueryLuckyRecord);
    
    _connection = [RequestModel POST:URL(kAPI_QueryLuckyRecord) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       
                       NSLog(@"data = %@",data);
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

//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -  UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SendCell *cell = [[SendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    if (self.data.count > 0) {
        cell.winModel = self.data[indexPath.row];
    }
    return cell;

}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[SendDetailViewController alloc] initWithModel:self.data[indexPath.row]] animated:YES ];
    
}

#pragma mark - 字符串转化成时间显示
- (NSString *)convertTime:(NSString *)timestring {
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyyMMdd"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSDate*date =[[NSDate alloc]init];
    
    NSString *time = timestring;
    date =[df dateFromString:time];
    NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
    [df2 setDateFormat:@"yyyy-MM-dd"];
    NSString* str1 = [df2 stringFromDate:date];
    
    return str1;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y == 0) {
        toFirstButton.hidden = YES;
    }else {
        toFirstButton.hidden = NO;
    }
}

@end
