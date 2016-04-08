//
//  MineVC.m
//  LotteryUnion
//
//  Created by xhd945 on 15/10/19.
//  Copyright © 2015年 xhd945. All rights reserved.
//

#import "MineVC.h"
#import "LoginVC.h" //登陆界面
#import "ModifyPasswordVC.h" //修改密码
#import "ProfileViewController.h" //修改个人信息
#import "UserInfo.h"
#import "HallVC.h"
#import "WinRecordViewController.h"
#import "CatchNumberViewController.h"
#import "BetViewController.h"
#import "SendLuckyViewController.h"
#import "AccountViewController.h"
#import "CollectViewController.h"
#import "TransferSelViewController.h"
#import "PJNavigationController.h"
#import "MianTabViewController.h"


#define kImageHeight 200
#define kPersonContentFont [UIFont systemFontOfSize:12]
static NSString *_identify = @"MineCell";

@interface MineVC () {
    
    UITableView *_tableView;
    NSArray *titleArray;//标题数组
    UIImageView *_imgView; //背景视图
    UIViewController *next ;
    
    UILabel *teleLabel;//用户名Lab
    UILabel *winMoneyLabel; //中奖余额 (可转账余额)
    UILabel *rechargeMoneyLabel; //充值余额 （不可提现）
    
}

@end

@implementation MineVC

static int isNew = 0; //是否是新用户
+(void)setNew:(int)n
{
    isNew = n;
}


- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"我 的"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"updateHomeView" object:nil];
    }
    return self;
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateHomeView" object:nil];
}

//充值返回 更新首页界面
- (void)updateUI:(NSNotification*)notification
{
    [self refreshButtonAction:nil];
}


//TODO:改变状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//TODO:隐藏导航栏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;

    //异步刷新数据
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self upHeardViewData];
        
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_connection cancel];
    [SVProgressHUD dismiss];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //0 注册登陆状态改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWithViews) name:NotifyLoginStatusChange object:nil];
    
    //1 创建tableview
    [self _createTableview];
    
    //2 创建头视图
    [self _createHeadView];
    
}

//TODO:登陆状态改变的通知
-(void)refreshWithViews
{
    static BOOL login = YES;
    if (login)
    {
    
        if(isNew == 1)
        { // 1表示注册成功
            // 需求改动（不是必须填写个人信息）
           isNew = 0;
            [self performSelector:@selector(jumpToModtifyBasicInfo) withObject:nil afterDelay:1];
        }
        else
        {
            // 如果是由登陆页面进入，则请求一下数据，查询一下中奖信息，然后填充余额Label
            [self refreshButtonAction:nil];
            
            if([UserInfo sharedInstance].Bonus.length>0)
            {
                [self showWinPrizeDialog:[UserInfo sharedInstance].Bonus shareContent:[UserInfo sharedInstance].ShareBonus Lotter_pk:[UserInfo sharedInstance].Lot_PK.intValue];
            }
            
        }
        
    }else
    {
       //注销
       //[self logOutUIChange];
    }
    login = !login;
}

//TODO:创建tableview
- (void)_createTableview
{
    titleArray = @[@"投注记录",@"中奖记录",@"送彩票记录",@"追号记录",
                            @"账户明细",@"我的收藏",@"个人信息",@"修改密码",];
    _tableView = [[UITableView alloc] initWithFrame:mRectMake(0, -10, mScreenWidth, mScreenHeight-49) style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(kImageHeight+2,0, 49, 0);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //注册单元格类型 xib加载单元格
    
    [_tableView registerNib:[UINib nibWithNibName:@"Mine" bundle:nil] forCellReuseIdentifier:_identify];
    
    //退出登陆按钮
    [self createExitBntAction];
}


//TODO:创建头视图
- (void)_createHeadView {
    
    //TODO:创建背景视图
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, kImageHeight)];
    _imgView.userInteractionEnabled  = YES;
    _imgView.image = [UIImage imageNamed:@"scenter_bg.png"];
    [self.view addSubview:_imgView];
    
    //TODO:创建用户头像
    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(mScreenWidth/2-35, (kImageHeight-30)/2-50, 70, 70)];
    userImgView.layer.cornerRadius = 32.5;
    userImgView.image = [UIImage imageNamed:@"scenter_ph.png"];
    [_imgView addSubview:userImgView];
    

    //TODO:创建电话号码label
    teleLabel = [[UILabel alloc ] initWithFrame:CGRectMake(mScreenWidth/2-70, CGRectGetMaxY(userImgView.frame)+2, 140, 30)];
    //    teleLabel.backgroundColor = [UIColor redColor];
    teleLabel.textAlignment = NSTextAlignmentCenter;
    teleLabel.textColor = [UIColor whiteColor];
    teleLabel.font = [UIFont systemFontOfSize:13];
    teleLabel.text = [[UserInfo sharedInstance]TelNumber];
    [_imgView addSubview:teleLabel];
    
    //创建下部笼罩视图
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, kImageHeight-90+40, mScreenWidth, 50)];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    maskView.userInteractionEnabled = YES;
    [_imgView addSubview:maskView];
    
    
    //创建左边上面label
    winMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, mScreenWidth/2.0-2, 20)];
    NSString *Mtext = @"0.00元[转账]" ;//@"19.5元[转账]";
    winMoneyLabel.text = Mtext;
    winMoneyLabel.font = kPersonContentFont;
    winMoneyLabel.textAlignment = NSTextAlignmentCenter;
    winMoneyLabel.textColor = [UIColor greenColor];
    //    winMoneyLabel.backgroundColor = [UIColor redColor];
    [maskView addSubview:winMoneyLabel];
    
    //创建可变属性划字符串
    NSMutableAttributedString *mattrstring = [[NSMutableAttributedString alloc] initWithString:Mtext];
    [mattrstring addAttribute:NSForegroundColorAttributeName
                       value:[UIColor whiteColor]
                       range:NSMakeRange(4, 1)];
    
    winMoneyLabel.attributedText = mattrstring;
    
    //TODO:中奖余额
    UILabel *winLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth/2/2)-35, 25, 70, 20)];
    winLabel.text = @"中奖余额";
    winLabel.font = kPersonContentFont;
    winLabel.textAlignment = NSTextAlignmentCenter;
    winLabel.textColor = [UIColor whiteColor];
    //    winLabel.backgroundColor = [UIColor redColor];
    [maskView addSubview:winLabel];
    
    //TODO:余额金额
    rechargeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(mScreenWidth/2.0, 5, mScreenWidth/2.0, 20)];
    NSString *text = @"0.00元[充值]";//@"19.5元[转账]";
    rechargeMoneyLabel.text = text;
    rechargeMoneyLabel.font = kPersonContentFont;
    rechargeMoneyLabel.textAlignment = NSTextAlignmentCenter;
    rechargeMoneyLabel.textColor = [UIColor redColor];
    //    rechargeMoneyLabel.backgroundColor = [UIColor redColor];
    [maskView addSubview:rechargeMoneyLabel];
    
    //创建可变属性划字符串
    NSMutableAttributedString *attrstring = [[NSMutableAttributedString alloc] initWithString:text];
    [attrstring addAttribute:NSForegroundColorAttributeName
                       value:[UIColor whiteColor]
                       range:NSMakeRange(4, 1)];
    
    rechargeMoneyLabel.attributedText = attrstring;
    
    //TODO:充值余额
    UILabel *rechargeLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth/2/2)-35+mScreenWidth/2, 25, 70, 20)];
    rechargeLabel.text = @"充值余额";
    rechargeLabel.font = kPersonContentFont;
    rechargeLabel.textAlignment = NSTextAlignmentCenter;
    rechargeLabel.textColor = [UIColor whiteColor];
    //rechargeLabel.backgroundColor = [UIColor redColor];
    [maskView addSubview:rechargeLabel];
    
    //笼罩视图的分割线
    UIImageView *seperateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(mScreenWidth/2-0.25, 3, 0.3, 40)];
    seperateImgView.image = [UIImage imageNamed:@"scenter_fgx.png"];
    [maskView addSubview:seperateImgView];
    
    //TODO:提现control
    UIControl *balanceCtr = [[UIControl alloc]initWithFrame:mRectMake(0, 0, maskView.width/2.0, maskView.height)];
    [balanceCtr addTarget:self action:@selector(balanceControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:balanceCtr];
    
    
    //TODO:充值control
    UIControl *rechargeCtr = [[UIControl alloc]initWithFrame:mRectMake(maskView.width/2.0, 0, maskView.width/2.0, maskView.height)];
    [rechargeCtr addTarget:self action:@selector(rechargeControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:rechargeCtr];
    
    
    //刷新的button
    [self createRefreshButton];
    
}


//TODO:创建退出登陆按钮
- (void)createExitBntAction
{
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(15,375+45, mScreenWidth-30, ButtonHeight)];
    exitButton.backgroundColor = REDFONTCOLOR;
    [exitButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:exitButton];
}

//TODO:刷新按钮
- (void)createRefreshButton
{
    UIButton *refreashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreashButton.frame = CGRectMake(mScreenWidth-50, 20, 40, 40);
    [refreashButton addTarget:self action:@selector(refreshButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *refreshIcon = [[UIImageView alloc]initWithFrame:mRectMake(0, 0, 25, 25)];
    refreshIcon.image = [UIImage imageNamed:@"scenter_sx.png"];
    [refreashButton addSubview:refreshIcon];
    refreshIcon.center = CGPointMake(refreashButton.width/2.0, refreashButton.height/2.0);
    
    [_imgView addSubview:refreashButton];
}

#pragma  mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }else if (section == 1) {
        
        return 1;
    }else {
        
        return 3;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify ];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
   
    if (indexPath.section == 0) {
        
        //赋值图片视图
        UIImageView *imgView = (UIImageView *) [cell.contentView viewWithTag:100];
        NSString *imgName = [NSString stringWithFormat:@"scenter_%ld.png",(long)indexPath.row+1];
        imgView.image = [UIImage imageNamed:imgName];
        
        //赋值labe的值
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:101];
        textLabel.text = titleArray[indexPath.row];
        textLabel.font =  Font(14);
         textLabel.textColor =  CustomBlack;
        
        
    }else if (indexPath.section == 1) {
        
        UIImageView *imgView = (UIImageView *) [cell.contentView viewWithTag:100];
        NSString *imgName = [NSString stringWithFormat:@"scenter_%ld.png",5+indexPath.row];
        imgView.image = [UIImage imageNamed:imgName];
        
        //赋值labe的值
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:101];
        textLabel.text = titleArray[indexPath.row+4];
        textLabel.font =  Font(14);
         textLabel.textColor =  CustomBlack;
        
    }else if (indexPath.section == 2) {
        
        UIImageView *imgView = (UIImageView *) [cell.contentView viewWithTag:100];
        NSString *imgName = [NSString stringWithFormat:@"scenter_%ld.png",(long)6+indexPath.row];
        imgView.image = [UIImage imageNamed:imgName];
        
        //赋值labe的值
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:101];
        textLabel.text = titleArray[indexPath.row+5];
        textLabel.font =  Font(14);
        textLabel.textColor =  CustomBlack;
        
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


//TODO:设置组头与组头之间的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 3;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y + 220;
    
    //1>向下移动，偏移量<0   放大 倍数》1
    if (offsetY < 0&&offsetY>-30) {

        //向下滑动，图片放大的高度
        CGFloat height = ABS(offsetY)+_imgView.bounds.size.height;
        
        //计算放大的倍数
        CGFloat scale = height/_imgView.bounds.size.height;
        
        //修改transform缩放
        _imgView.transform = CGAffineTransformMakeScale(scale, scale);
        //返回顶部
        _imgView.top = 0;
        
    //2>向上移动，偏移量>0
    }else if (offsetY > 0) {
        
       // _imgView.top = -offsetY/2;
        
    }
}


//TODO:---选中单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {   //投注记录
        
        
        next=[[BetViewController alloc] init];
        
    }else if (indexPath.row == 1 && indexPath.section == 0) {  //中奖记录
        
        next=[[WinRecordViewController alloc] init];
        
    }else if (indexPath.row == 2 && indexPath.section == 0) {  //送彩票记录
        
       next=[[SendLuckyViewController alloc] init];
        
    }else if (indexPath.row == 3 && indexPath.section == 0) {   //追号记录
        
       next=[[CatchNumberViewController alloc] init];
        
    }else if (indexPath.row == 0 && indexPath.section == 1) {   //账号明细
        
        next=[[AccountViewController alloc] init];
        
    }else if (indexPath.row == 0 && indexPath.section == 2) {   //我的收藏
        
         next=[[CollectViewController alloc] init];
        
    }else if (indexPath.row == 1 && indexPath.section == 2) {   //个人信息
        next = [[ProfileViewController alloc]init];
    }else if (indexPath.row == 2 && indexPath.section == 2) {   //修改密码
        next  = [[ModifyPasswordVC alloc]init];
    }
    if(next)
    {
        next.hidesBottomBarWhenPushed = YES;
        next.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:next animated:YES];
    }
}
/*----------------------*/
//TODO:退出登录
-(void)logout:(UIButton*)sender
{
    [SVProgressHUD showWithStatus:nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain:kAPI_Logout];
    
    _connection = [RequestModel POST:URL(kAPI_Logout) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [self requestLogoutFinished:data];
                       [SVProgressHUD dismiss];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                       [SVProgressHUD dismiss];
                   }];
}

//TODO:注销请求完成的响应
- (void)requestLogoutFinished:(id)data
{
    [keychainItemManager deleteSessionId];
    [[UserInfo sharedInstance]clearUserInfo:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLoginStatusChange object:nil];
    
    [(MianTabViewController *)self.tabBarController setSelected:0];
    
}


/*----------------------*/
//TODO:充值
- (void)rechargeControlAction:(UIControl*)sender
{
    next  = [[TransferSelViewController alloc]initWithTran:NO];
    ((TransferSelViewController *)next).fromType = 5;
    if(next)
    {
        next.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:next animated:YES];
    }
    
}

//TODO:提现
- (void)balanceControlAction:(UIControl*)sender
{
 
    next  = [[TransferSelViewController alloc]initWithTran:YES];
    ((TransferSelViewController *)next).fromType = 5;
    if(next)
    {
        next.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:next animated:YES];
    }
}

/*------------------------------*/
#pragma mark -- 刷新按钮动作
- (void)refreshButtonAction:(UIButton*)sender
{
    if(sender)
    {
        [SVProgressHUD showWithStatus:@"努力刷新中..."];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain:kAPI_QueryAccount];
    
    _connection = [RequestModel POST:URL(kAPI_QueryAccount) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       
                       [self refreshFinished:data];
                       [SVProgressHUD dismiss];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       if ([state integerValue] == Status_Code_User_Not_Login)
                       {
                           [super gotoLoging];
                           [SVProgressHUD dismiss];
                           return;
                       }
                       [SVProgressHUD showErrorWithStatus:msg];
                       [SVProgressHUD dismiss];
                   }];
  
}

//TODO:余额查询刷新完成的响应
- (void)refreshFinished:(id)data
{
    NSLog(@"%@",data);
    if (!data) {
        [SVProgressHUD showErrorWithStatus:LocStr(@"无网络连接")];
        return;
    }
    if ([[data objectForKey:@"code"] isEqualToString:@"000"])
    {
        UserInfo *mod = [UserInfo sharedInstance];
        mod.RealName =  [data objectForKey:@"customer_name"];
        mod.Cash =  [data objectForKey:@"cash_money"];
        NSArray *accouts = [data objectForKey:@"item"];// 获得个人账户余额信息

        for (NSDictionary *element in accouts)
        {
            // 账户类型
            NSString *chargeType = [element objectForKey:@"charge_type"];
            if ([chargeType isEqualToString:@"5"])
            { // molo账户
                
                // 开通则显示余额，否则显示未开通
                [[UserInfo  sharedInstance] setCash:[element objectForKey:@"balance"]];
            }
            else if ([chargeType isEqualToString:@"4"]) // 手机支付账户
            {
                [[UserInfo sharedInstance]setBalance:[element objectForKey:@"balance"]];
            }
        }
        // 设置数据头部数据
         [self upHeardViewData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[data objectForKey:@"note"]];
    }
}

//TODO:更新头部UI
- (void)upHeardViewData
{
    //充值余额
    NSMutableAttributedString *mattrstring_charge = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元[充值]",[[UserInfo sharedInstance]Balance]]];
    [mattrstring_charge addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(mattrstring_charge.length-5, 1)];
    rechargeMoneyLabel .attributedText = mattrstring_charge;
    
    //中奖余额
    NSMutableAttributedString *mattrstring_win = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元[转账]",[[UserInfo sharedInstance]Cash]]];
    [mattrstring_win addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(mattrstring_win.length-5, 1)];
    winMoneyLabel.attributedText = mattrstring_win;
    
    teleLabel .text =  [[UserInfo sharedInstance] RealName].length?[[UserInfo sharedInstance] RealName]:[[UserInfo sharedInstance]TelNumber];
}

//TODO:跳入信息修改
- (void)jumpToModtifyBasicInfo
{
    ProfileViewController *pro = [[ProfileViewController alloc]init];
    [self.navigationController pushViewController:pro animated:YES];
}





@end
