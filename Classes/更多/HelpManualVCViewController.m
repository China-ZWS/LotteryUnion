//
//  HelpManualVCViewController.m
//  LotteryUnion
//
//  Created by xhd945 on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "HelpManualVCViewController.h"
#import "HelpContentViewController.h"

@interface HelpManualVCViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;  //tableView

@end

@implementation HelpManualVCViewController
{
    NSArray *dataArray;  //标题
}
/*---------------------------------*/
- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"帮助指南"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
        _subPos = -1;
    }
    return self;
}


- (id)initWithReadSubMenu:(int)subPos
{
    self = [super init];
    if (self) {
        _subPos = subPos;
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
    }
    return self;
}

//TODO:返回按钮
- (void)back
{
    [self popViewController];
}
/*---------------------------------*/
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    [self createTableView];
    
   //获取plist文件
    NSString *_menuPath = [[NSBundle mainBundle] pathForResource:@"HelpMenu" ofType:@"plist"];
    //[[NSBundle mainBundle] pathForResource:@"internal_servers" ofType:@"plist"]
    //HelpMenu plist
    _dataMenu = [[NSArray alloc] initWithContentsOfFile:_menuPath];
    if (_subPos != -1) {
        [self.navigationItem setNewTitle:[[_dataMenu objectAtIndex:_subPos] objectForKey:@"Title"]];
        _dataMenu = [[_dataMenu objectAtIndex:_subPos] objectForKey:@"Content"];
    }
}
//TODO:创建tableview
- (void)createTableView
{
    //去掉上方空白
    if (iOS7)
    {
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 0.01)];
    }

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setScrollEnabled:YES];
    _tableView.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    
    dataArray = @[@"玩法帮助",@"注册帮助",@"兑奖帮助",@"投注帮助",@"送彩票帮助",
                  @"提现帮助",@"费用流量",@"常见问题"];
    
    
}
//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    cell.textLabel.textColor = NAVITITLECOLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary *aDict = [_dataMenu objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [aDict objectForKey:@"Title"]];
    
    /*改变玄宗的背景颜色*/
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    
    return cell;
}

#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([UIScreen mainScreen].bounds.size.height-65)/_dataMenu.count;
}

//TODO:CELL的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *aDict = [_dataMenu objectAtIndex:indexPath.row];
    id content = [aDict objectForKey:@"Content"];
    if ([content isKindOfClass:[NSArray class]]) {
        // 帮助列表
        HelpManualVCViewController *helpList = [[HelpManualVCViewController alloc] initWithReadSubMenu:(int)indexPath.row];
        [self.navigationController pushViewController:helpList animated:YES];
    }
    else
    {
        // 帮助详情
        HelpContentViewController *helpContent = [[HelpContentViewController alloc] initWithHTMLCode:[aDict objectForKey:@"id"]];
        helpContent.navTitle = [aDict objectForKey:@"Title"];
        [self.navigationController pushViewController:helpContent animated:YES];
    }
}


#pragma mark- private Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
