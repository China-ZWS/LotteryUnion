//
//  AccountDetailViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/6.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "NSString+ConvertDate.h"

@interface AccountDetailViewController () {
     UITableView *_tableView;
}

@end

@implementation AccountDetailViewController


- (instancetype)initWithWinModel:(WinModel *)winModel{
    if (self = [super init]) {
        self.winModel = winModel;
        self.title = @"记录详情";
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
    }
    
    return self;
}

//TODO:返回动作
- (void)back
{
    [self popViewController];
     [SVProgressHUD dismiss];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, -25, mScreenWidth-20, mScreenHeight-49-80) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_identify"];
    NSInteger row = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"订单号:  %@ ", _winModel.record_pk];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            break;
        case 1:
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            if ([_winModel.pay_type isEqual:@"支付宝"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@ ",_winModel.pay_type ];
            }else {
                switch ([_winModel.pay_type intValue]) {
                    case 0:                //处理中
                        cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@ ",@"处理中"];
                        break;
                    case 2:                 //2：现金
                        cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@ ",@"现金"];
                        break;
                    case 4:                 //4：账户
                       cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@ ",@"账户"];
                        break;
                    case 5:                 //5：账户
                         cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@ ",@"账户"];
                        break;
                    case 6:                  //6：手机支付
                        cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@ ",@"手机支付"];
                        break;
                    case 8:                  //8：银行卡
                        cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@ ",@"银行卡"];
                        break;
                    case 30:                  //30：话费
                        cell.textLabel.text = [NSString stringWithFormat:@"类型:  %@ ",@"话费"];
                        break;
                }
            }
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"金额:  %@元" ,_winModel.money];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"时间:  %@",[_winModel.create_time toFormatDateString]];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            break;
        case 4:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"说明:  %@",_winModel.desc];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }
            break;
        default:
            break;
    }

    
    return cell;
    
}










@end
