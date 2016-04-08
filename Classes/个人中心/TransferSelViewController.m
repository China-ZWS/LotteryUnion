//
//  TransferSelViewController.m
//  YaBoCaiPiaoSDK
//
//  Created by jamalping on 14-7-17.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import "TransferSelViewController.h"
#import "PJViewController.h"
#import "TransAccountViewController.h"
#import "AccountViewController.h"

@interface TransferSelViewController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView ;
    NSString *_identify;
    BOOL _trans;

}

@end

@implementation TransferSelViewController


- (instancetype)initWithTran:(BOOL)trans
{
    if (self) {
        _trans = trans;
        if (_trans == YES)
        {
            self.title = @"转账";
        }else {
            self.title = @"充值";
        }
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_fromType == 5) {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

#pragma mark -  返回
- (void)back
{
    [SVProgressHUD dismiss];
    [_connection cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1>创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, mScreenWidth-20, mScreenHeight-64)];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    
    
    //2>设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    
    //3>去掉多余的线条
    [self setExtraCellLineHidden:_tableView];
    
    //注册单元格类型
    _identify = @"identify";
    [_tableView registerNib:[UINib nibWithNibName:@"TransFerCell" bundle:nil]
     forCellReuseIdentifier:_identify];
    
    [self _createRecordButton];
}

//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)_createRecordButton {
    if (_trans == YES) {
        return;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(mScreenWidth/2-30, 170, 60, 20)];
//    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"充值记录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(toChargeAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:RGBA(0, 159, 215, 1) forState:UIControlStateNormal];
    [self.view addSubview:button];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imgView = (UIImageView *) [cell viewWithTag:900];
    UILabel *label = (UILabel *)[cell viewWithTag:901];
    UILabel *alarmLel = (UILabel *)[cell viewWithTag:902];
    if (_trans == YES) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"转账方式";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }else if(indexPath.row == 1){
            imgView.image = [UIImage imageNamed:@"grzx_zhifubao@2x.png"];
            label.text = @"转支付宝";
        }else if (indexPath.row == 2) {
            imgView.image = [UIImage imageNamed:@"grzx_yinlian@2x.png"];
            label.text = @"转银行卡";
            alarmLel.text = @"";
        }
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"充值方式";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }else if(indexPath.row == 1){
            imgView.image = [UIImage imageNamed:@"grzx_zhifubao@2x.png"];
            label.text = @"支付宝充值";
        }else if (indexPath.row == 2) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            imgView.image = [UIImage imageNamed:@"grzx_weixin@2x.png"];
            label.text = @"微信充值";
            alarmLel.text = @"即将开通";
        }
    }
 
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 30;
    }
    return 55;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_trans == YES) {
        if (indexPath.row == 1) {   //转支付宝
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[[TransAccountViewController alloc] initWithAlipay:YES withTrans:YES] animated:YES];
        }else if (indexPath.row == 2) {   //转银行卡
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[[TransAccountViewController alloc] initWithAlipay:NO withTrans:YES] animated:YES];
        }
        
    }else {
        if (indexPath.row == 1) {   //支付宝充值
            [self.navigationController pushViewController:[[TransAccountViewController alloc] initWithAlipay:YES withTrans:NO] animated:YES];
        }else if (indexPath.row == 2) {   //微信充值
           
        }
    }
    
}


#pragma mark - 按钮点击事件
- (void)toChargeAction:(UIButton *)button {
    [self.navigationController pushViewController:[[AccountViewController alloc] init] animated:YES];
}





@end
