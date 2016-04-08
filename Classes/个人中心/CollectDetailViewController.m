//
//  CollectDetailViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/8.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CollectDetailViewController.h"
#import "NSString+ConvertDate.h"
#import "ShareTools.h"
#import "RTLabel.h"
#import "NSString+NumberSplit.h"
#import "BetCartViewController.h"
#import "BetResult.h"

@interface CollectDetailViewController () {
    UITableView *_tableView;
    NSString *_selecteNumber;
}

@end

@implementation CollectDetailViewController


- (instancetype)initWithModel:(WinModel *)winModel withLotteryName:(NSString *)lottery withSelectNumber:(NSString *)selecteNumber{
    
    NSLog(@"%@",selecteNumber);
    
    if (self = [super init]) {
        
        self.winModel = winModel;
        self.lottery = lottery;
        self.title = @"收藏详情";
        
        if ([_winModel.lottery_pk intValue] == lSSQ_lottery) {
            _selecteNumber = [_winModel SSNumber:_winModel.number lottery_code:_winModel.lottery_code];
        }else {
            _selecteNumber = selecteNumber;
        }
        
         self.data = [NSMutableArray new];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, -30, mScreenWidth-20, mScreenHeight-49) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self _createViews];
}


- (void)_createViews {
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom-30, mScreenWidth, 50)];
    NSLog(@"%f",_tableView.bottom);
    bottomView.backgroundColor = [UIColor clearColor];
    
    [self.view insertSubview:bottomView atIndex:2];
    
    
    //创建分享按钮
    UIButton *sharButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharButton setImage:[UIImage imageNamed:@"kjhm_share.png"] forState:UIControlStateNormal];
    [sharButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    sharButton.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:sharButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //投注
    UIButton *betButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (bottomView.height-50)/2, (mScreenWidth-60)/2, 35)];
    betButton.backgroundColor = RGBA(197, 42, 37, 1);
    [betButton setTitle:@"以此号投注" forState:UIControlStateNormal];
    [betButton addTarget:self action:@selector(betWithNumber:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:betButton];
    
    //删除
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(20+20+betButton.width, (bottomView.height-50)/2, (mScreenWidth-60)/2, 35)];
    collectButton.backgroundColor = RGBA(66, 115, 248, 1);
    [collectButton setTitle:@"删除" forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(deleteCollectButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:collectButton];
}

#pragma  mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
          
            cell.textLabel.text = [NSString stringWithFormat:@"彩种:   %@ %@",self.lottery,getPlayTypeName([[self.winModel lottery_code] intValue]) ];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            break;
        case 1:{
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 60, 30)];
            textLabel.text = @"号码：";
            textLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:textLabel];
            
            RTLabel *label = [self makeRTLabel];
            label.text = _selecteNumber;
            label.font = [UIFont systemFontOfSize:13];
            [cell addSubview:label];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"时间:   %@",[_winModel.create_time toFormatDateString]];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            break;
        case 3:{
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 60, 30)];
            textLabel.text = @"备注：";
            textLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:textLabel];
            
            RTLabel *label = [self makeRTLabel];
            label.text = _winModel.desc;
            label.font = [UIFont systemFontOfSize:13];
            [cell addSubview:label];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }
            break;
        default:
        break;
    }
    return  cell;
}




#pragma  mark - 按钮点击事件

//删除
- (void)deleteCollectButton {
    
    UIAlertView *tipAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [tipAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:// 取消
            
            break;
        case 1: // 确定删除
            [self doDelete];
            
            break;
            
        default:
            break;
    }
}



// 删除收藏
-(void)doDelete{
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_BookmarkDelete];
    params[@"record_pk"] = self.winModel.record_pk;
    
    NSLog(@"%ld",(long)kAPI_BookmarkDelete);
    
    _connection = [RequestModel POST:URL(kAPI_BookmarkDelete) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       [self.navigationController popViewControllerAnimated:YES];
                       [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:@"删除失败"];
                       
                   }];
   
}


//分享
- (void)shareAction:(UIButton *)button {
    
    [ShareTools shareAllButtonClickHandler:@"彩票联盟客户端" andUser:@"极品珍藏大奖号码，泣血分享，别说我没告诉你，错过可不许哭~" andUrl:kkAPPDownloadURLAddress andDes:@"快来下载吧~"];
    
}

-(RTLabel*)makeRTLabel
{
    RTLabel *label = [[RTLabel alloc] initWithFrame:
                      CGRectMake(57,7+3,mScreenWidth-85,850)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.lineSpacing = 0;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return  [self calcFormatedNumberHeight];
    }else if(indexPath.section == 0 && indexPath.row == 3){
        return [self calcFormatedDescHeight];
    }else {
       return 45;
    }
}


#pragma - 动态设置高度
- (float)calcFormatedDescHeight {
    int hh = [NSObject getSizeWithText:_winModel.desc font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mScreenWidth-60, 800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+30, 45);
}

-(float)calcFormatedNumberHeight {
    if ([_winModel.lottery_pk intValue] == lSSQ_lottery) {
        NSString *number = [_winModel SSNumber:_winModel.number lottery_code:_winModel.lottery_code];
        int hh = [NSObject getSizeWithText:number font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mScreenWidth-60, 800)].height;
        NSLog(@"height = %d",hh);
        return MAX(hh+10, 45);
    }else {
         int hh = [NSObject getSizeWithText:_selecteNumber font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mScreenWidth-60, 800)].height;
         NSLog(@"height = %d",hh);
         return MAX(hh+10, 45);
    }
}

#pragma mark ----  以此号投注响应动作
- (void)betWithNumber:(UIButton*)sender
{
    BetResult *result = [[BetResult alloc] init];
    result.numbers = _winModel.number;
    result.lot_pk = _winModel.lottery_pk;
    result.play_code = _winModel.lottery_code;
    result.zhushu = [_winModel.amount intValue];
    
    [BetCartViewController openBetCartWithBetResult:(BetResult *)result
                                         controller:self from:@"收藏夹"];

}

@end
