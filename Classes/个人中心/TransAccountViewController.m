//
//  TransAccountViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/18.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "TransAccountViewController.h"
#import "XHDHelper.h"
#import "CityTableView.h"
#import "Graphic.h"
#import "BottomView.h"
#import "UserInfo.h"
#import "Order.h"
#import "NSString+Regex.h"
#import "LineView.h"
#import<CoreText/CoreText.h>


@interface TransAccountViewController () {
    UITableView *_tableView ;
    UILabel *prizeMoney;
    UITextField *transMoney;
    UITextField *aliAccount;
    UITextField *name;
    UITextField *rechargeMoney;
    UITextField *cardNumber;
    UIButton *regbutton;
    WXLabel *cardTextLabel;
    UILabel *textLabel;
    BOOL _aliPay;
    BOOL _trans;
    UILabel *bankButton;
    CityTableView *cityTableView;
    UIView *maskView;
    UILabel *headLabel;
    UIButton *footCancelButton;
    UIButton *footOkButton;
    Graphic *gView;
    BottomView *view;
    NSInteger _page_num;
    NSString *_bankID;
    UIScrollView *_scrollView;
    NSString *bankName;
    LineView *lineView;
    

}


@property (nonatomic, copy) void(^requestSignature)();
@property (nonatomic, copy) void(^requestMobilepay)(id datas);
@end

@implementation TransAccountViewController

- (instancetype)initWithAlipay:(BOOL)aliPay  withTrans:(BOOL)trans
{
    self = [super init];
    if (self) {
        _aliPay = aliPay;
        _trans = trans;
        if (_trans == YES) {
            if (_aliPay == YES) {
                self.title = @"转支付宝账号";
            }else {
                self.title = @"转银行卡";
            }
        }else {
            self.title = @"支付宝充值";
        }
        
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification:) name:@"ChangeNameNotification" object:nil];
        _page_num = 1;
    }
    return self;
}



#pragma mark -  返回
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  -- 视图循环
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1>创建tableView
    [self createTableView];
    
    //3>去掉多余的线条
    [self setExtraCellLineHidden:_tableView];
    
    //设置输入框
    [self setupTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}




//TODO:创建表
- (void)createTableView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    if (iPhone4) {
        _scrollView.contentSize = CGSizeMake(mScreenWidth, mScreenHeight);
    }else {
         _scrollView.contentSize = CGSizeMake(mScreenWidth, mScreenHeight);
    }

    if (_aliPay == YES && _trans == YES) {
          self.tableView = [[UITableView alloc]initWithFrame:mRectMake(10, 20, mScreenWidth-20,44*4) style:UITableViewStylePlain];
    }else if(_aliPay == NO && _trans == YES){
          self.tableView = [[UITableView alloc]initWithFrame:mRectMake(10, 20, mScreenWidth-20,44*5) style:UITableViewStylePlain];
    }else if(_trans == NO) {
        self.tableView = [[UITableView alloc]initWithFrame:mRectMake(10, 20, mScreenWidth-20,44) style:UITableViewStylePlain];
    }

    [self.view setBackgroundColor:kAppBgColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.layer.borderColor = DIVLINECOLOR.CGColor;
    _tableView.layer.borderWidth = 0.35;
    
    [self.tableView setBackgroundColor:[UIColor redColor]];
    self.tableView.scrollEnabled  = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:self.tableView];
    
    if (_trans == NO) {
        [self createAlarmText];
        [self createRegistButton];
    }else {
        if (_aliPay == NO) {
            [self createCardText];
            [self createRegistButton];
        }else {
             [self createRegistButton];
        }
    }
    
}

//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_aliPay == YES) {
        return 4;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int section = (int)indexPath.section;
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:14.4];
    //添加分隔线
    UIView  *divline = [[UIView alloc]initWithFrame:mRectMake(5, cell.height-0.35,mScreenWidth-10, 0.35)];
    divline.backgroundColor = DIVLINECOLOR;
    [cell addSubview:divline];
    
    if (_aliPay == YES &&_trans == YES) {
        if (section == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"奖金金额")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:prizeMoney];
                prizeMoney.text = [NSString stringWithFormat:@"%@元",[[UserInfo sharedInstance] Cash]];
            } else if (indexPath.row == 1) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"转账金额")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:transMoney];
                
                
            } else if (indexPath.row == 2) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"支付宝账号")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:aliAccount];
            } else if (indexPath.row == 3) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"收款人姓名")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:name];
                name.text = [[UserInfo sharedInstance] RealName];
            }
        }
        return cell;
    }else if(_aliPay == NO && _trans == YES){
        if (section == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"账户余额")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:prizeMoney];
                 prizeMoney.text = [NSString stringWithFormat:@"%@元",[[UserInfo sharedInstance] Cash]];
            } else if (indexPath.row == 1) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"转账金额")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:transMoney];
                
            } else if (indexPath.row == 2) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"开户名称")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:aliAccount];

                 aliAccount.text = [[UserInfo sharedInstance] RealName];
            } else if (indexPath.row == 3) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"开户银行")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                
                bankButton = [[UILabel alloc] initWithFrame:CGRectMake(100.0,2,160,40.0)];
                bankButton.text = @"其他";
                bankButton.textColor = NAVITITLECOLOR;
                bankButton.font = [UIFont systemFontOfSize:13];
                bankButton.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBank:)];
                [bankButton addGestureRecognizer:tap];
                [cell.contentView addSubview:bankButton];
                
            }else if (indexPath.row == 4) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                         LocStr(@"银行卡号")]];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:cardNumber];
                cardNumber.text = [[UserInfo sharedInstance] BankNumber];
            }
        }
        return cell;
    }else if (_trans == NO) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                     LocStr(@"充值金额")]];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:rechargeMoney];
        }
        return cell;
    }
    return nil;
}

//TODO:转入按钮
- (void)createRegistButton
{
    if (_trans == NO) {
        regbutton = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.origin.x,textLabel.bottom+5,_tableView.width,ButtonHeight)];
    }else {
        if (_aliPay == YES) {  //转支付宝
            regbutton = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.origin.x,_tableView.bottom+15,_tableView.width,ButtonHeight)];
        }else {  //转银行卡
            
            if (iPhone4) {
                 regbutton = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.origin.x,cardTextLabel.bottom-10,_tableView.width,32)];
            }else {
                 regbutton = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.origin.x,cardTextLabel.bottom,_tableView.width,ButtonHeight)];
            }
        }
    }

    
    if (_aliPay == YES && _trans == YES) {
        [regbutton setTitle:LocStr(@"转支付宝账号") forState:UIControlStateNormal];
        [regbutton addTarget:self action:@selector(transAliAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }else if (_aliPay == NO && _trans == YES){
        [regbutton setTitle:LocStr(@"转入银行卡") forState:UIControlStateNormal];
        [regbutton addTarget:self action:@selector(transCardAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }else if (_trans == NO) {
        [regbutton setTitle:LocStr(@"提交") forState:UIControlStateNormal];
        [regbutton addTarget:self action:@selector(commitAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    
    [regbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regbutton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    regbutton.backgroundColor = REDFONTCOLOR;
    [_scrollView addSubview:regbutton];
    
}


//创建文本提示
- (void)createAlarmText {
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.origin.x,_tableView.bottom+2,_tableView.width,20*3)];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textColor = [UIColor grayColor];
    textLabel.text = @"温馨提示:\n1.请至少充值10元，免手续费\n2.支付前请确认开通支付宝账号";
    [_scrollView addSubview:textLabel];
    
}

- (void)createCardText {
    
    cardTextLabel = [[WXLabel alloc] initWithFrame:CGRectMake(_tableView.origin.x+10,_tableView.bottom+10,_tableView.width-15,0)];
    cardTextLabel.numberOfLines = 0;
    cardTextLabel.wxLabelDelegate = self;
    cardTextLabel.font = [UIFont systemFontOfSize:13];
    cardTextLabel.textColor = [UIColor grayColor];
    cardTextLabel.text = @"温馨提示:\n1.建议您完善身份认证信息：真实姓名.身份证信息，将以此作为兑奖的凭证！真实姓名和身份证号一经保存，不可修改。如填写有误，请致电客服热线:400-166-6018!\n2.本公司不收任何手续费，如产生任何费用均为 银行按照转账标准收取";
    cardTextLabel.height = [self calcFormatedTextHeight];
    [_scrollView addSubview:cardTextLabel];
    [WXLabel addLine:cardTextLabel text:cardTextLabel.text];
}


- (void)setupTextField
{
    CGRect textFrame = CGRectMake(100.0,iOS7? 2.0: 12.0,mScreenWidth-80,40.0);
    //账号余额 奖金金额
    prizeMoney = [[UILabel alloc] initWithFrame:textFrame];
    prizeMoney.font = [UIFont systemFontOfSize:13];
    prizeMoney.textColor = NAVITITLECOLOR;
    [XHDHelper addToolBarOnInputFiled:prizeMoney Action:@selector(cancleFirst:) Target:self];

    //转账金额 转账金额
    transMoney = [[UITextField alloc] initWithFrame:textFrame];
    transMoney.keyboardType = UIKeyboardTypeNumberPad;
    transMoney.font = [UIFont systemFontOfSize:13];
    if (_trans == YES && _aliPay == YES) {
        transMoney.placeholder = LocStr(@"请输入转账金额");
    }else if (_trans == YES && _aliPay == NO) {
       transMoney.placeholder = LocStr(@"请输入转账金额");
    }
    transMoney.textColor = NAVITITLECOLOR;
    transMoney.delegate = self;
    transMoney.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    transMoney.keyboardType = UIKeyboardTypeDecimalPad;
    [XHDHelper addToolBarOnInputFiled:transMoney Action:@selector(cancleFirst:) Target:self];
    
    //开户名称  支付宝账号
    aliAccount = [[UITextField alloc] initWithFrame:textFrame];
    aliAccount.font = [UIFont systemFontOfSize:13];
    aliAccount.delegate = self;
    if (_aliPay == YES) {
       [aliAccount setPlaceholder:@"邮箱或手机号"];
    }else {
         [aliAccount setPlaceholder:@""];
    }
    aliAccount.textColor = NAVITITLECOLOR;
    [XHDHelper addToolBarOnInputFiled:aliAccount Action:@selector(cancleFirst:) Target:self];
    
    //收款人姓名
    name = [[UITextField alloc] initWithFrame:textFrame];
    name.font = [UIFont systemFontOfSize:13];
    name.returnKeyType = UIReturnKeyDone;
    name.textColor = NAVITITLECOLOR;
    name.delegate = self;
    [XHDHelper addToolBarOnInputFiled:name Action:@selector(cancleFirst:) Target:self];
    
    if (_aliPay == NO) {
        //银行卡号
        cardNumber = [[UITextField alloc] initWithFrame:textFrame];
        cardNumber.keyboardType = UIKeyboardTypeNumberPad;
        cardNumber.font = [UIFont systemFontOfSize:13];
        cardNumber.returnKeyType = UIReturnKeyDone;
        [cardNumber setPlaceholder:@""];
        cardNumber.textColor = NAVITITLECOLOR;
        cardNumber.delegate = self;
        [XHDHelper addToolBarOnInputFiled:cardNumber Action:@selector(cancleFirst:) Target:self];
    }
    
    //支付宝充值金额
    rechargeMoney = [[UITextField alloc] initWithFrame:textFrame];
    rechargeMoney.font = [UIFont systemFontOfSize:13];
    rechargeMoney.returnKeyType = UIReturnKeyDone;
    rechargeMoney.keyboardType = UIKeyboardTypeNumberPad;
    [rechargeMoney setPlaceholder:@"请输入整数金额"];
    rechargeMoney.textColor = NAVITITLECOLOR;
    rechargeMoney.delegate = self;
    [XHDHelper addToolBarOnInputFiled:rechargeMoney Action:@selector(cancleFirst:) Target:self];
}



- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeNameNotification" object:nil];
}

#pragma mark -- 改变银行名称的消息通中心
-(void)ChangeNameNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    bankName = [nameDictionary objectForKey:@"name"];
    
    if ([bankName isEqual:@"未定义"])
    {
        bankName = @"其他";
    }else {
        bankName = [nameDictionary objectForKey:@"name"];
    }

    _bankID = [nameDictionary objectForKey:@"bankID"];
}

//TODO:添加单击手势隐藏键盘
-(void)cancleFirst:(UITapGestureRecognizer *)singleTap{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }];
    
}


#pragma mark - 按钮点击事件
//转入支付宝账号
- (void)transAliAction:(UIButton *)button {
    
    NSString *message;
    NSString *accountText = [XHDHelper delSpaceWith:aliAccount.text];
    NSString *accountName = [XHDHelper delSpaceWith:name.text];
    if ([transMoney.text intValue] < 10 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入转账金额,并且转账金额需要大于10元"];
        return;
    }
    if (accountText.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入支付宝账号"];
        return;
    }
    BOOL isValidateTele = [XHDHelper isphoneStyle:aliAccount.text];
    BOOL isValidateEmail = [XHDHelper isValidateEmail:aliAccount.text];
    if (!isValidateTele && !isValidateEmail) {
        [SVProgressHUD showErrorWithStatus:@"支付宝账号格式不对"];
        return;
    }
    if (accountName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入收款人姓名"];
        return;
    }
    message = [NSString stringWithFormat:@"1.您的中奖奖金%@元将在3个工作日内(节假日以及周末时间顺延)转账到您的支付宝账户；2.提现金额大于200元(包含200元)，免收手续费，提现金额小于200元，首次免收手续费，第二次开始加收手续费：2元/次，询：4001666018",transMoney.text];
    [self showOkayCancelAlert:message];
    
}

//转入银行卡
- (void)transCardAction:(UIButton *)button {
     NSString *message;
    NSString *accountText = [XHDHelper delSpaceWith:aliAccount.text];
    if ([transMoney.text floatValue] < 10 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入转账金额,并且转账金额需要大于10元"];
        return;
    }
    if (accountText.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入转开户名称"];
        [aliAccount becomeFirstResponder];
        return;
    }
    if (cardNumber.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        [cardNumber becomeFirstResponder];
        return;
    }
    [transMoney resignFirstResponder];
    [aliAccount resignFirstResponder];
    [cardNumber resignFirstResponder];
    
    NSString *cNumber = [cardNumber.text substringFromIndex:cardNumber.text.length-4];
    message = [NSString stringWithFormat:@"1.您的中奖奖金%@元将在3个工作日内(节假日以及周末时间顺延)转账到您%@的银行尾号%@的账号；2.本公司不收任何手续费，如产生任何费用均为银行按照转账标准收取。询：4001666018",transMoney.text,bankButton.text,cNumber];
    [self showOkayCancelAlert:message];
}

#pragma mark - 支付宝充值提交
//支付宝充值提交
- (void)commitAction:(UIButton *)button {
    
    if ([rechargeMoney.text intValue] < 10 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入充值金额,并且充值金额需要大于10元"];
        return;
    }
    
    /*生成订单*/
    WEAKSELF
    self.requestSignature = ^{
        [weakSelf getSignature];
    };
    
    /*去充值*/
    self.requestMobilepay = ^(id datas){
        weakSelf.requestMobilepay = nil;
        [weakSelf gotoMobilepay:datas];
    };
    
    _requestSignature();
    self.requestSignature = nil;
}

#pragma mark - 生成订单
- (void)getSignature
{
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"total_fee"] = [NSString stringWithFormat:@"%@00",rechargeMoney.text];
    [params setPublicDomain:kAPI_MobileAlipay_Signature];  //支付宝订单签名
    
    _connection = [RequestModel POST:URL(kAPI_MobileAlipay_Signature) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {

                       _requestMobilepay(data);
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
                       [SVProgressHUD showInfoWithStatus:msg];
                   }];

}


#pragma 调支付宝
- (void)gotoMobilepay:(id)datas
{
  
    Order *order  =[[Order alloc]init];
    //卖家的PID，账号
    order.partner = datas[@"partner"];
    order.seller = datas[@"seller"];
    
    order.tradeNO = datas[@"out_trade_no"]; //订单ID（由商家自行制定）
    order.productName = datas[@"subject"]; //商品标题
    order.productDescription = datas[@"body"]; //商品描述
    order.amount = datas[@"total_fee"];//[NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL = datas[@"notify_url"]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdklottery";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    
    id<DataSigner> signer = CreateRSADataSigner(@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBANz1S3sKzecmXgqwb7T0GmnWZoy5pSA4CQ4icDA8c9mrAVC7H26fpSGH4DfqlCbnKyvCglIuCJVX174Zw1NQvNAzVcvZEmqaV48IXqqb1Usm3ONC+/9HZUvqYjKUxw2S+HPrOd5waeAr85Y3UhcenhRDIM1jlzYZBgo/ohIKIWKJAgMBAAECgYACC+eSESyNCobudGnkdCpWdpzmisWjwcEbt2fwmm68QmA1vjXxUVs3L0n9WpfasGNu+VM5raF4uKKP6S8s8198TcSM6UtcORZvdJq3Gz9yWKtzDW6mp1YSp8bz/6AnMTe9b5BeAdfOHL5TkhJAitDWQvAmTtQahnmK4Sm352MfPQJBAPgda2iq7Hp78QXLRbN+Xsao5RqE+0J6BPYvVdAwu9wjFpiHia9yK1ftfF6vmQRY+sUKtm55+Jvcemmjd1FLwAsCQQDj+u/l9Psxtx40RRJCyB9bpmc5Cb9Hq5jV/4EBQTQJGkFcDt/XZjkGcsdwHc40rhTyvJNhwE6JXUmHTC1x+GA7AkAJvbXy1QsVv/n1fUaORn7YE9dy1Be9Q2cgdzlKRC+L9AC2GlQohDX5bMR+PyylxAyMYeBJtBYzoFNaBGXx1iSDAkALhI8AMCtMrLKy81Zj11Z2O+b1I7/tMActsJXk6VVmrFPnAb1fVYPGBqB60parZKwcQ1iy1JNjLzpawod9PY4nAkByOcq7XmHbW4ELjRPINakT6EUTcFvpw5FTj0pjKgXnXQN+Iko/MBQQeEIq1ZMufDg65WktVO5OxCb3qLSs4MuL");
     NSString *signedString = [signer signString:orderSpec];
    
    // 商户信息签名
   // NSString *signedString =  datas[@"sign"];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        NSLog(@"%@",orderString);
        //发送订单
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
            NSLog(@"reslut = %@",resultDic);
            NSInteger resultStadus = [resultDic[@"resultStatus"] integerValue];
            
            if (resultStadus == 9000)
            {  //订单支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHomeView"
                                                                    object:nil];
                
                 [self.navigationController popToRootViewControllerAnimated:YES];
                /*成功*/return;
            }
            /*失败*/
             [SVProgressHUD showErrorWithStatus:@"充值失败，请重新操作"];
        }];
        
    }
}

#pragma mark   ==============产生随机订单号==============
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((int)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}



#pragma mark -- 选择银行
- (void)selectBank:(UITapGestureRecognizer*)tap
{
    NSLog(@"选择银行");
    [transMoney resignFirstResponder];
    [aliAccount resignFirstResponder];
    [cardNumber resignFirstResponder];
    maskView =  [[UIView alloc] initWithFrame:CGRectMake(0, -64, mScreenWidth, mScreenHeight+64)];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [_scrollView insertSubview:maskView aboveSubview:_tableView];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    _scrollView.scrollEnabled = NO;
    if (iPhone4) {
         cityTableView = [[CityTableView alloc] initWithFrame:CGRectMake(10, 80, mScreenWidth-20, mScreenHeight-220) style:UITableViewStylePlain];
         cityTableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    }else {
         cityTableView = [[CityTableView alloc] initWithFrame:CGRectMake(10, 130, mScreenWidth-20, mScreenHeight-300) style:UITableViewStylePlain];
         cityTableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    }
    cityTableView.fromBankName = bankButton.text;
    [self createViews];
    cardTextLabel.hidden = YES;
    regbutton.hidden = YES;
    [_scrollView insertSubview:cityTableView atIndex:2];
}


- (void)createViews {
    
    
    if (iPhone4) {
        gView = [[Graphic alloc] initWithFrame:CGRectMake(10, 80, mScreenWidth-20, 50)];
        gView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:gView];
        
        view = [[BottomView alloc] initWithFrame:CGRectMake(10, mScreenHeight-120, mScreenWidth-20, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }else {
        gView = [[Graphic alloc] initWithFrame:CGRectMake(10, 120, mScreenWidth-20, 50)];
        gView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:gView];
        
        view = [[BottomView alloc] initWithFrame:CGRectMake(10, mScreenHeight-150, mScreenWidth-20, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    
    //设置成圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:gView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = gView.bounds;
    maskLayer.path = maskPath.CGPath;
    gView.layer.mask = maskLayer;
    
    headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, gView.width-20, 48)];
    headLabel.backgroundColor = [UIColor whiteColor];
    headLabel.text = @"银行";
    headLabel.font = [UIFont systemFontOfSize:16];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [gView insertSubview:headLabel aboveSubview:cityTableView];
    
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = gView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    view.layer.mask = maskLayer1;
    
    if (iPhone4) {
        lineView = [[LineView alloc] initWithFrame:CGRectMake((mScreenWidth-20)/2+5, mScreenHeight-149+30, 1, 50)];
        lineView.backgroundColor = RGBA(174, 174, 174, 1);
        lineView.alpha = 0.7;
        [self.view addSubview:lineView];
    }else {
        lineView = [[LineView alloc] initWithFrame:CGRectMake((mScreenWidth-20)/2+5, mScreenHeight-149, 1, 50)];
        lineView.backgroundColor = RGBA(174, 174, 174, 1);
        lineView.alpha = 0.7;
        [self.view addSubview:lineView];
    }

    footCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, view.width/2, 48)];
    footCancelButton.backgroundColor = [UIColor whiteColor];
    [footCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    footCancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [footCancelButton addTarget:self action:@selector(okAndCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    footCancelButton.tag = 1000;
    [footCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view insertSubview:footCancelButton aboveSubview:cityTableView];
    
    footOkButton = [[UIButton alloc] initWithFrame:CGRectMake(view.width/2+5, 2, view.width/2, 48)];
    footOkButton.backgroundColor = [UIColor whiteColor];
    [footOkButton setTitle:@"确定" forState:UIControlStateNormal];
    footOkButton.tag = 2000;
    footOkButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [footOkButton addTarget:self action:@selector(okAndCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [footOkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view insertSubview:footOkButton aboveSubview:cityTableView];
  
    
}


//取消
- (void)okAndCancelAction:(UIButton *)button {
    if (button.tag == 1000) {
        [cityTableView removeFromSuperview];
        [self hidden];
    }else if(button.tag == 2000){
        bankButton.text = bankName;
        [self hidden];
    }
}


- (void)hidden {
    _scrollView.scrollEnabled = YES;
    maskView.hidden = YES;
    cityTableView.hidden = YES;
    cardTextLabel.hidden = NO;
    regbutton.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    gView.hidden = YES;
    view.hidden = YES;
    lineView.hidden = YES;
}

//第一次提示确认框
- (void)showOkayCancelAlert:(NSString *)message {
    NSString *title = NSLocalizedString(@"提示", nil);
    NSString *mes = NSLocalizedString(message, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:mes preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (_aliPay == YES) {
            //第一次确认
            [self requestAlipay];
        }else {
            [self requestBankCard];
        }
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//第二次确认提示框
- (void)showTwoConfirmAlert:(NSString *)need_confirm message:(NSString *)msg{
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *mes = NSLocalizedString(msg, nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:mes preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (_aliPay == YES) {
                //第二次确认
                [self transToAlipay:@"true"];
            }else {
                [self transToCard:@"true"];
            }
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 转账到银行卡
//注意：转账金额没有精确到分  并且服务器要求的金额是大于10
- (void)requestBankCard {
    
    //isConfirm:false为第一次确认
    [self transToCard:@"false"];
}


- (void)transToCard:(NSString *)isConfirm
{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_TransferToBank];
    params[@"money"] = transMoney.text;
    params[@"customer_name"] =  aliAccount.text;
    params[@"is_confirm"] = isConfirm;
    
    if ([bankButton.text isEqualToString:@"其他"]){
      params[@"bank_code"] = @"0";
    }else{
      params[@"bank_code"] = _bankID;
    }
    params[@"bank_card"] = cardNumber.text;
    NSLog(@"%@",params);
    
    _connection = [RequestModel POST:URL(kAPI_TransferToBank) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       
                       NSString *need_confirm = data[@"need_confirm"];
                       NSString *msg = data[@"note"];
                       if ([need_confirm isEqual:@"true"]) {   //需要二次确认
                           [SVProgressHUD dismiss];
                           [self showTwoConfirmAlert:need_confirm message:msg];
                       }else {
                           [SVProgressHUD showSuccessWithStatus:@"提现成功"];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHomeView"
                                                                               object:nil];
                           [self.navigationController popToRootViewControllerAnimated:YES];
                       }
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       if ([state integerValue] == Status_Code_User_Not_Login)
                       {
                           [super gotoLoging];
                           [SVProgressHUD dismiss];
                           return;
                       }
                       [SVProgressHUD showSuccessWithStatus:@"提现失败"];
                       
                   }];
}


#pragma mark - 转账到支付宝
//服务器要求的金额是大于等于10  精确到分
- (void)requestAlipay {
    //isConfirm:false为第一次确认
    [self transToAlipay:@"false"];
}

- (void)transToAlipay:(NSString *)isConfirm {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_MobileAlipay_Trans];
    params[@"draw_money"] = [self transMoney];
    params[@"alipay_account"] = aliAccount.text;
    params[@"alipay_name"] = name.text;
    
    //第一次确认
    params[@"is_confirm"] = isConfirm;
    NSLog(@"%@",params);
    _connection = [RequestModel POST:URL(kAPI_MobileAlipay_Trans) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       NSString *need_confirm = data[@"need_confirm"];
                       NSString *msg = data[@"note"];
                       if ([need_confirm isEqual:@"true"]) {   //需要二次确认
                          
                           [SVProgressHUD dismiss];
                           [self showTwoConfirmAlert:need_confirm message:msg];
                           
                       } else {
                           
                           [SVProgressHUD showSuccessWithStatus:@"提现成功"];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHomeView"
                                                                               object:nil];
                           [self.navigationController popToRootViewControllerAnimated:YES];
                           
                       }
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
                       
                   }];
}

- (void)refreshWithViews
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

//转换输入的金额
- (NSString *)transMoney {
    
    NSRange range = [transMoney.text rangeOfString:@"."];
    if (range.length != 0) {   //存在小数点
        NSString *money = transMoney.text;
        NSLog(@"%f",[money floatValue]*100);
        NSString *m = [NSString stringWithFormat:@"%f",[money floatValue]*100];
        NSRange m1 = [m rangeOfString:@"."];
        NSString *str = [m substringToIndex:m1.location];
        return str;
    }else {       //不存在小数点
        NSString *m = [NSString stringWithFormat:@"%f",[transMoney.text floatValue]*100];
        NSRange m1 = [m rangeOfString:@"."];
        NSString *str = [m substringToIndex:m1.location];
        return str;
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   if(iPhone4)
   {
      if(textField == transMoney)
      {
          [UIView animateWithDuration:0.3 animations:^{
              _scrollView.contentOffset = CGPointMake(0, 90);
          }];
      }
       if(textField == aliAccount)
       {
           [UIView animateWithDuration:0.3 animations:^{
               _scrollView.contentOffset = CGPointMake(0, 130);
           }];
       }
       if(textField == name)
       {
           [UIView animateWithDuration:0.3 animations:^{
               _scrollView.contentOffset = CGPointMake(0, 135);
           }];
       }
       if(textField == cardNumber)
       {
           [UIView animateWithDuration:0.3 animations:^{
               _scrollView.contentOffset = CGPointMake(0, 140);
           }];
       }
   }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == transMoney||textField == rechargeMoney) {
        NSScanner  *scanner = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange    pointRange = [textField.text rangeOfString:@"."];
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) ){
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }else{
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] ){
            return NO;
        }
        short remain = 2; //默认保留2位小数
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
              return NO;
                }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                    
                }
                
            }
            
        }
        NSString *buffer;
        
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) ){
            return NO;
        }
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }];
}


#pragma mark - WXLabel 协议方法
//1.返回需要添加超链接的正则表达式
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    NSString *str = @"400-166-6018";
    return str;
}

//设置超链接的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    return [UIColor redColor];
    
}


//超链接的点击事件
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
    
    NSLog(@"%@",context);
    [self callService];
    
}

#pragma mark - 客服电话
-(void)callService
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"拨打 %@ 客服电话",kefuNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10086;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
    if (alertView.tag==10087&&buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kkAPPDownloadURLAddress]];
        
    }else if(alertView.tag==10086&&buttonIndex!=alertView.cancelButtonIndex){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",kefuNumber]]];
    }
}


#pragma mark - 动态高度
- (float)calcFormatedTextHeight {
    int hh = [NSObject getSizeWithText:cardTextLabel.text font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mScreenWidth-60, 800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+30, 45);
}






@end
