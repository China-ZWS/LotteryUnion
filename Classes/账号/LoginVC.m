//
//  ViewController.m
//  test2
//
//  Created by rt007 on 15/10/19.
//  Copyright (c) 2015年 rt007f. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"  //注册
#import "ResetPasswordFirstVC.h"  //忘记密码

#import "UserInfo.h"  //用户模型
#import "PhoneTextField.h"//手机输入框
#import "UtilMethod.h"
#import "XHDHelper.h"

#define kkHeight 20
#define kkWidth 10
#define kkRowHeight 40
#define kkFontColor ([UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1])

@interface LoginVC () <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIView *backView1;                          //背景视图1
    UIImageView *phoneImageView;                //手机视图
    UIImageView *passImageView;                 //密码视图
    UITextField *phoneTextField;                //手机号输入框
    UITextField *passTextField;                 //密码输入框
    UILabel *phoneLabel;                        //手机号lable
    UILabel *passLable;                         //密码lable
    UIButton *sendMsgBtn;                       //获取验证码按钮
    UIButton *loginBtn;                         //登录按钮
    UIButton *registerBtn;                      //注册按钮
    NSMutableAttributedString *titleString;     //标题
    int currentNumber;
    NSTimer *messageTimer;                      //计时器
    UIButton *forgetBtn;       //忘记密码
    UIButton *rememberBtn;     //记住密码按钮
    BOOL flag;    //是否记住密码
}
@end

@implementation LoginVC
{
    BOOL isVCodeLogin;   //是否是验证码登陆
}

- (id)initWithLoginSuccess:(SuccessLoginBlock)success;
{
    if ((self = [super initWithLoginSuccess:success]))
    {
        [self.navigationItem setNewTitle:@"登陆"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
    }
    return self;
}


- (id) init
{
    if (self = [super init])
    {
        [self.navigationItem setNewTitle:@"登陆"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
        currentNumber = 60;
        isVCodeLogin = NO;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self.navigationItem setNewTitle:@"登陆"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
    }
    return self;
}

//TODO:返回按钮动作
- (void)back
{
    _successLogin(self,NO);
}

#pragma mark - 入口
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatLoginUI];
    self.view.backgroundColor = kAppBgColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
      [self.navigationItem setNewTitle:@"登陆"];
}

//TODO:控制器即将展示
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([NS_USERDEFAULT objectForKey:@"name"])
    {
        phoneTextField.text = [NS_USERDEFAULT objectForKey:@"name"];
        sendMsgBtn.enabled = YES;
    }
    if([NS_USERDEFAULT objectForKey:@"pwd"])
    {
        passTextField.text = [NS_USERDEFAULT objectForKey:@"pwd"];
    }
}
//结束输入
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [messageTimer invalidate];
    if ([phoneTextField isFirstResponder]) {
        [phoneTextField resignFirstResponder];
    }
    if ([passTextField isFirstResponder])
    {
        [passTextField resignFirstResponder];
    }
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

#pragma mark - 绘制登陆界面
-(void)creatLoginUI
{
    //背景视图1
    backView1 = [[UIView alloc]initWithFrame:CGRectMake(kkWidth, kkHeight, mScreenWidth-kkWidth*2,kkRowHeight*2)];
    [backView1 setBackgroundColor:[UIColor whiteColor]];
    backView1.layer.borderWidth = 0.4;
    backView1.layer.borderColor = DIVLINECOLOR.CGColor;
    [self.view addSubview:backView1];
    
    //TODO:手机视图
    phoneImageView = [XHDHelper createImageViewWithFrame:CGRectMake(15,7.5,17,25) AndImageName:@"dl_nmb" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:nil AndAction:nil];
    [backView1 addSubview:phoneImageView];
    
    
    //TODO:手机号输入框
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.right+15,0,backView1.width-phoneImageView.width-18,kkRowHeight)];
    phoneTextField.delegate = self;
    phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    phoneTextField.font = [UIFont systemFontOfSize:14];
    phoneTextField.tintColor = kkFontColor;
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.borderStyle = UITextBorderStyleNone;
    [backView1 addSubview:phoneTextField];
    [XHDHelper addToolBarOnInputFiled:phoneTextField Action:@selector(hideKeyboard) Target:self];
    
    
    //分割线
    UILabel *divLine_1 = [XHDHelper createLabelWithFrame:CGRectMake(0,kkRowHeight, backView1.frame.size.width, 0.4) andText:nil andFont:nil AndBackGround:DIVLINECOLOR AndTextColor:nil];
    [backView1 addSubview:divLine_1];
    
    //TODO:创建密码视图
    passImageView = [XHDHelper createImageViewWithFrame:CGRectMake(15,divLine_1.bottom+7.5,17, 25) AndImageName:@"dl_Lock" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:nil AndAction:nil];
    [backView1 addSubview:passImageView];
    
    //TODO:创建密码输入框
    passTextField = [[UITextField alloc] initWithFrame:CGRectMake(passImageView.right+15,phoneTextField.bottom+1,backView1.width-passImageView.width-120,kkRowHeight)];
    passTextField.delegate = self;
    passTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    passTextField.font = [UIFont systemFontOfSize:15];
    passTextField.tintColor = kkFontColor;
    [passTextField setSecureTextEntry:YES];
    passTextField.textColor = kkFontColor;
    passTextField.keyboardType = UIKeyboardTypeDefault;
    passTextField.borderStyle = UITextBorderStyleNone;
    [backView1 addSubview:passTextField];
    [XHDHelper addToolBarOnInputFiled:passTextField Action:@selector(hideKeyboard) Target:self];
    
    
    //TODO:创建获取验证码按钮
    sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMsgBtn.frame = CGRectMake(backView1.right-95, divLine_1.bottom+7,80,kkRowHeight-14);
    sendMsgBtn.layer.cornerRadius = 5;
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMsgBtn addTarget:self action:@selector(beginGetMsg:) forControlEvents:UIControlEventTouchUpInside];
    sendMsgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    sendMsgBtn.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.55 alpha:1];
    [sendMsgBtn setTitle:@"验证码登陆" forState:UIControlStateNormal];
    [backView1 addSubview:sendMsgBtn];
   
    
    //TODO:创建记住密码按钮
    rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberBtn.frame = CGRectMake(backView1.frame.origin.x, backView1.bottom+7, 90, 30);
    [rememberBtn setTitle:@"  记住密码" forState:UIControlStateNormal];
    [rememberBtn setTitleColor:NAVITITLECOLOR forState:UIControlStateNormal];
    [rememberBtn setImage:mImageByName(@"dl_kuang.png") forState:UIControlStateNormal];
    [rememberBtn setImage:mImageByName(@"dl_kuang1.png") forState:UIControlStateSelected];
    [rememberBtn addTarget:self action:@selector(beginRemember:) forControlEvents:UIControlEventTouchUpInside];
    rememberBtn.selected = ((NSString*)[mUserDefaults valueForKey:@"pwd"]).length?YES:NO;
    rememberBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:rememberBtn];
   
    
    //TODO:创建登陆按钮
    loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(backView1.origin.x, backView1.bottom+80, backView1.frame.size.width, kkRowHeight);
    [loginBtn setBackgroundColor:[UIColor colorWithRed:180/255.0 green:45/255.0  blue:25/255.0 alpha:1]];
    loginBtn.layer.cornerRadius = 0;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:loginBtn];
    
    //TODO:创建注册按钮
    registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(loginBtn.origin.x, loginBtn.bottom+10, loginBtn.frame.size.width, loginBtn.frame.size.height);
    [registerBtn setBackgroundColor:[UIColor whiteColor]];
    registerBtn.layer.borderColor = DIVLINECOLOR.CGColor;
    registerBtn.layer.borderWidth = 0.3;
    registerBtn.layer.cornerRadius = 0;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:NAVITITLECOLOR forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(beginRegister:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:registerBtn];
    
    //TODO:创建忘记密码按钮
    forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    forgetBtn.frame = CGRectMake(registerBtn.origin.x, registerBtn.bottom+10, registerBtn.frame.size.width, 30);
    forgetBtn.layer.cornerRadius = 0;
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:NAVITITLECOLOR forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(resetPwdAction) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:forgetBtn];
}

/*--------------------*/
//TODO:记住密码
- (void)beginRemember:(UIButton*)sender
{
    sender.selected = !sender.isSelected;
    flag = sender.isSelected;
    if (sender.isSelected==NO)
    {
        [NS_USERDEFAULT setObject:@"" forKey:@"pwd"];
    }
    //保存到沙盒
    [NS_USERDEFAULT setBool:flag forKey:@"KeepPwd"]; // 设置是否记住密码
    [NS_USERDEFAULT synchronize];
}

//TODO:忘记密码
-(void)resetPwdAction
{
    // 忘记密码
    ResetPasswordFirstVC *registerView =[[ResetPasswordFirstVC alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];

}

//TODO:开始注册
- (void)beginRegister:(id)sender
{
    RegisterViewController *registerView = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerView animated:YES];
}

/*----------------------------------*/
#pragma mark - textfield delegate
//TODO:开始输入
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == phoneTextField)
    {
        if(phoneTextField.text.length==0)
        {
           passTextField.text = @"";
        }
    }
    if (textField == passTextField) {
        
    }
}

//TODO:输入限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *detailString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 限制手机号长度
    if (textField == phoneTextField) {
        
        if([detailString isEqualToString:@""])
        {
            passTextField.text = @"";
        }
        
        if (detailString.length > 11)
        {
            return NO;
        }
        
        
    }
        // 限制验证码长度
        if (textField == passTextField)
        {
            if (detailString.length>16)
            {
                return NO;
            }
        }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark ---------验证码获取&登陆相关--------
//TODO:改变验证码获取按钮的状态
- (void)changeMesBtnWithString:(NSMutableAttributedString *)string WithEnable:(BOOL)enable
{
    NSRange selectedRange = {0, [string length]};
   [string beginEditing];
    //改变属性字符串颜色
    if (enable)
    {
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:selectedRange];
    }else
    {
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:selectedRange];
    }
    //设置字体大小
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:selectedRange];
    [string endEditing];
    [sendMsgBtn setAttributedTitle:string forState:UIControlStateNormal];
    [sendMsgBtn.titleLabel setAttributedText:string]; //解决4s秒数不动的问题
    //倒计时期间不能点击第二次
    if (enable)
    {
        sendMsgBtn.enabled = YES;
    }
    else
    {
        sendMsgBtn.enabled = NO;
    }
}

//TODO:计时器开始计时
- (void)beginTimerRun:(id)sender
{
    NSMutableAttributedString *detailString;
    if (currentNumber == 0)
    {
        
        [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ;
        //改变获取验证码的按钮
        [self changeMesBtnWithString:detailString WithEnable:YES];
        [messageTimer invalidate];  //结束计时器
        return;
    }
    //倒计时数值改变
    detailString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d秒", currentNumber]];
    [self changeMesBtnWithString:detailString WithEnable:NO];
    currentNumber--;
}

//TODO:点击获取验证码
- (void)beginGetMsg:(UIButton*)sender
{
    [phoneTextField resignFirstResponder];
    if (phoneTextField.text.length !=11 || ![XHDHelper isphoneStyle:phoneTextField.text])
    {
        [SVProgressHUD showInfoWithStatus:@"手机号码格式不正确"];
        return;
        
    }else{
        
        currentNumber = 60;
        messageTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(beginTimerRun:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:messageTimer forMode:NSRunLoopCommonModes];
       [self getVerificationAction];
    }
    
    
}

//TODO:获取验证码
-(void)getVerificationAction
{
    [self beginTimerRun:nil];
    passTextField.text = nil;
    isVCodeLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = phoneTextField.text;
    params[@"sms_type"] = @"3";
    [params setPublicDomain:kAPI_GetVCode];
    
    _connection = [RequestModel POST:URL(kAPI_GetVCode) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"提示") message:[data objectForKey:@"note"] delegate:self cancelButtonTitle:LocStr(@"确定") otherButtonTitles: nil];
                           alert.tag = 10;
                           [alert show];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                      //获取验证码失败后，取消定时器，改变验证码按钮标题
                       [messageTimer invalidate];
                       
                        [self changeMesBtnWithString:[[NSMutableAttributedString alloc] initWithString:@"重获验证码"] WithEnable:YES];
                       
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"提示") message:msg delegate:self cancelButtonTitle:LocStr(@"确定") otherButtonTitles: nil];
                       [alert show];
                       
                   }];
}

/*-------------登陆相关----------------*/
//TODO:登录的响应方法
- (void)loginButtonClick
{
    
    int pwdLen = (int)passTextField.text.length;
    if ([phoneTextField.text length]!=11 ||![phoneTextField.text hasPrefix:@"1"]) {
        [SVProgressHUD showErrorWithStatus:(LocStr(@"请输入正确的手机号码"))];
        return;
    } else if (pwdLen == 0) {
        [SVProgressHUD showErrorWithStatus:(LocStr(@"请输入登录密码或验证码"))];
        return;
    } else if(!isVCodeLogin&&pwdLen>16)
    {
        [SVProgressHUD showErrorWithStatus:(LocStr(@"请输入长度为6-16位的登录密码"))];
        return;
    }
    
    [self.view endEditing:YES];
    [phoneTextField resignFirstResponder];
    [passTextField resignFirstResponder];

//验证码登陆还有BUG，登陆不了,不管是不是验证码登陆都要加密请求一次
    [SVProgressHUD show];
    if(pwdLen<=4)
    {
      [self unencryptRequest]; //验证码登陆
    }
    else
    {
        [self encryptRequest]; //密码登陆
    }
    

}
//TODO:加密请求
- (void)encryptRequest
{
    
    //如果要验证码登陆则登陆类型为1，密码登陆为零
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = phoneTextField.text;
    params[@"pwd"] = md5(passTextField.text);
    params[@"login_type"] = @"0";
    
    [params setPublicDomain:kAPI_Login];
    
    _connection = [RequestModel POST:URL(kAPI_Login) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       // SessionManager 为单例
                       [[UserInfo sharedInstance] setIsLogined:YES];
                       [self loginRequestFinished:data];
                    
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                      
                   }];

}

//TODO:不加密请求
- (void)unencryptRequest
{
    //如果要验证码登陆则登陆类型为1，密码登陆为零
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = phoneTextField.text;
    params[@"pwd"] = passTextField.text;
    params[@"login_type"] = @"1";
    [params setPublicDomain:kAPI_Login];
    
    _connection = [RequestModel POST:URL(kAPI_Login) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       //设置为短信验证码登陆
                       [[UserInfo sharedInstance] setIsLoginedWithVirefi:YES];
                       [self loginRequestFinished:data];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                      // [self encryptRequest];
                       [SVProgressHUD showErrorWithStatus:@"密码或验证码输入不正确！"];
                   }];
}

//TODO:请求网络完成
- (void)loginRequestFinished:(id)dataSource
{
    [SVProgressHUD dismiss];
    NSDictionary *data = (NSDictionary*)dataSource;
    if (!data)
    {
        [SVProgressHUD showErrorWithStatus:LocStr(@"无网络连接")];
        return;
    }

    // 得到状态码
    int code = [[data objectForKey:@"code"] intValue];
    
    /*登陆成功*/
    if (code == Status_Code_Request_Success)
    {

//        // 保存登录错误的次数
//       [self saveLoginErrorTimes:-1];
//        
        //TODO:如果不是验证码登陆且保存,才保存密码
        if (!isVCodeLogin && flag==YES)
        {
             [NS_USERDEFAULT setValue:passTextField.text forKey:@"pwd"];
        }
        
        [NS_USERDEFAULT setValue:phoneTextField.text forKey:@"name"];
        [NS_USERDEFAULT synchronize];

        UserInfoTool.TelNumber = phoneTextField.text;
        if(data.count >3)
        {
            [UserInfo sharedInstance].ShareBonus = [data valueForKey:@"bonus_share_content"];
            [UserInfo sharedInstance].Bonus= [data valueForKey:@"bonus"];
            [UserInfo sharedInstance].Lot_PK = [data valueForKey:@"lottery_pk"];
        }
        // 操作文字提示
        [SVProgressHUD showSuccessWithStatus:([data valueForKey:@"note"])];
        // 通知登录成功 回到更控制器前，如果登陆了，就要请求一下用户基本信息的数据可提现余额之类的
        [[UserInfo sharedInstance]getBaseUserInfoSuccess:^{
            
        } failure:^{
            
        }];
        [[UserInfo sharedInstance]getUserBonusSuccess:^{
            
            _successLogin(self,YES);
            
        } failure:^{
            
            _successLogin(self,NO);
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:([data valueForKey:@"note"])];
        // 保存登录错误的次数
        _successLogin(self,NO);
//        [self saveLoginErrorTimes:1];
    }
    
}

//TODO:结束输入
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#if 0
//TODO:加载登录失败次数
- (int) loadLoginErrorTimes
{
    _loginErrorTimes=(int)[NS_USERDEFAULT integerForKey:pk_login_error_times];
    double lastTime=[NS_USERDEFAULT doubleForKey:pk_last_login_error_time];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if((nowTime-lastTime)>3600) _loginErrorTimes = 0;
    
    return _loginErrorTimes;
}

//TODO:保存登陆失败次数
- (void) saveLoginErrorTimes:(int)delta
{
    // 连续输错密码只记录2分钟内的
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if(nowTime-[NS_USERDEFAULT doubleForKey:pk_last_login_error_time]>120)
        _loginErrorTimes = 0;
    
    // 增加或减少一次错误登录次数
    _loginErrorTimes += ((delta<0)?-_loginErrorTimes:delta);
    nowTime = (delta<0)?0:nowTime;
    
    NSLog(@"error times:%d",_loginErrorTimes);
    [NS_USERDEFAULT setInteger:_loginErrorTimes forKey:pk_login_error_times];
    if(_loginErrorTimes == 1)
        [NS_USERDEFAULT setDouble:nowTime forKey:pk_last_login_error_time];
    [NS_USERDEFAULT synchronize];
}

#endif
@end