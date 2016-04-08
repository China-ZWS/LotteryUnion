//
//  RunLotteryVC.m
//  LotteryUnion
//
//  Created by happyzt on 15/10/29.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "RunLotteryVC.h"
#import "AwardVC.h"
#import "FootBallQueryViewController.h"

@interface RunLotteryVC () {
    FBPlayType _playType; // 足彩类型
}

@end

@implementation RunLotteryVC
- (id) init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"开奖号码"];
    
    }
    return self;
}

- (void)back
{
    [self popViewController];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //1 创建tableview
    UITableView *_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    
    
    //2 加载数据
    [self loadData];
    
    
}

- (void)loadData {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hall_setting.plist" ofType:nil];
    self.dataArray = [NSArray arrayWithContentsOfFile:filePath];
    
    self.data = [NSMutableArray new];
    self.lottery_pk = [NSMutableArray new];
    for (NSDictionary *dic in self.dataArray) {
        
        NSString *playName = dic[@"PlayName"];
        NSString *lottery_pk = dic[@"lottery_pk"];
        [self.data addObject:playName];
        [self.lottery_pk addObject:lottery_pk];
    }
    
}


//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(self.data.count>0)
    {
        cell.textLabel.text = self.data[indexPath.row];
    }
    cell.textLabel.font = Font(14);
    cell.textLabel.textColor =  CustomBlack;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(iPhone4)
    {
        return 37;
    }else{
        
        return 44;
    }
}


//点击选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        if (_playType == kHHGG)
        {
            _playType = kSFP;
        }
        FootBallQueryViewController*next =  [[FootBallQueryViewController alloc] initWithPlayType:_playType match_no:@""];
        next.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:next animated:YES];
        
    }else {
        
        //将id和彩名传过去
        AwardVC *awardVC = [[AwardVC alloc] initWithLottery_pk:self.lottery_pk[indexPath.row]
                                                      playName:self.data[indexPath.row]];
        awardVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:awardVC animated:YES];
    }
    
}



@end
