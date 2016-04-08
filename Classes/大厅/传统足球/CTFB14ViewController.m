//
//  CTFB14ViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/12.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFB14ViewController.h"

@interface CTFB14Cell :PJTableViewCell

@end

@implementation CTFB14Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = Font(14);
    }
    return self;
}

- (void)setDatas:(id)datas
{
    NSString *text = [NSString stringWithFormat:@"%@  vs  %@",datas[@"team1"],datas[@"team2"]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([datas[@"team1"] length] + [@"占位" length],[@"vs" length])];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([datas[@"team1"] length] + [@"占位" length],[@"vs" length])];

    self.textLabel.attributedText = attrString;
}

@end

@interface CTFB14ViewController ()
{

}

@property (nonatomic, copy) void(^requestFootballVS)(NSString *period);
@property (nonatomic, copy) void(^requestPlayPeriod)();
@end

@implementation CTFB14ViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"胜负14场"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(eventWithRight) image:@"jczq_no.png"];
    }
    return self;
}

- (void)back
{
    [_connection cancel];
    [SVProgressHUD dismiss];
    [self popViewController];
}

- (void)eventWithRight
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    CTFB14Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CTFB14Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.datas = _datas[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithBetting
{

}

- (void)eventWithSCP
{

}

- (void)eventWithClear
{

}

- (void)setUpDatas
{
  
    /*任务一，获取彩票期数*/
    self.requestPlayPeriod = ^{
        /*
         数据加载延迟处理
         */
        [SVProgressHUD show];

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_SF14];
        [params setPublicDomain:kAPI_QueryPlayPeriod];
        _connection = [RequestModel POST:URL(kAPI_QueryPlayPeriod) parameter:params   class:[RequestModel class]
                                 success:^(id data)
                       {
                           [SVProgressHUD dismiss];
                           _requestFootballVS(data[@"item"][0][@"period"]);
                           self.requestFootballVS = nil;
                       }
                                 failure:^(NSString *msg, NSString *state)
                       {
                           [SVProgressHUD showErrorWithStatus:msg];
                       }];

    };
    
    /*任务二，拉取14对阵信息*/
    self.requestFootballVS = ^(NSString *period){
        /*
         数据加载延迟处理
         */
        [SVProgressHUD show];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_SF14];
        params[@"period"] = period;
        
        [params setPublicDomain:kAPI_QueryFootballVS];
        _connection = [RequestModel POST:URL(kAPI_QueryFootballVS) parameter:params   class:[RequestModel class]
                                 success:^(id data)
                       {
                           _datas = data[@"item"];
                           [self reloadTabData];
                           [SVProgressHUD dismiss];
                       }
                                 failure:^(NSString *msg, NSString *state)
                       {
                           
                           [SVProgressHUD showErrorWithStatus:msg];
                       }];
        
    };
    _requestPlayPeriod();
    self.requestPlayPeriod = nil;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
