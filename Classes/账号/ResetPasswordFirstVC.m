//
//  ViewController.m
//  test2
//
//  Created by rt007 on 15/10/19.
//  Copyright (c) 2015年 rt007f. All rights reserved.
//

#import "ResetPasswordFirstVC.h"
#import "AppDelegate.h"
#import "ResetPasswordSecondVC.h"  //下一步

#import "PhoneTextField.h"//手机输入框
#import "UtilMethod.h"
#import "XHDHelper.h"

#define kkHeight 20
#define kkWidth 10
#define kkRowHeight 40
#define kkFontColor ([UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1])

@interface ResetPasswordFirstVC () <UITextFieldDelegate, UIScrollViewDelegate>
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
    UIButton *rememViewberBtn;  //记住密码视图
    UIButton *forgetBtn;       //忘记密码
    UIButton *rememberBtn;     //记住密码按钮
    BOOL flag;    //是否记住密码
}
@end

@implementation ResetPasswordFirstVC
- (id) init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"忘记密码"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
        currentNumber = 60;
    }
    return self;
}

//TODO:返回按钮动作
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 入口
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatLoginUI];
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
}

//TODO:判断是否已经登陆
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
//TODO:控制器即将消失，判断是否要记住密码
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (((NSString*)[NS_USERDEFAULT objectForKey:@"name"]).length)
    {
        phoneTextField.text = [NS_USERDEFAULT objectForKey:@"name"];
        sendMsgBtn.enabled = YES;
    }
}
//TODO:结束输入
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([phoneTextField isFirstResponder]) {
        [phoneTextField resignFirstResponder];
    }
    if ([passTextField isFirstResponder]) {
        [passTextField resignFirstResponder];
    }
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
    
    //TODO:创建验证码视图
    passImageView = [XHDHelper createImageViewWithFrame:CGRectMake(15,divLine_1.bottom+7.5,17, 25) AndImageName:@"dl_Lock" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:nil AndAction:nil];
    [backView1 addSubview:passImageView];
    
    //TODO:创建密码输入框
    passTextField = [[UITextField alloc] initWithFrame:CGRectMake(passImageView.right+15,phoneTextField.bottom+1,backView1.width-passImageView.width-120,kkRowHeight)];
    passTextField.delegate = self;
    passTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    passTextField.font = [UIFont systemFontOfSize:15];
    passTextField.tintColor = kkFontColor;
    [passTextField setSecureTextEntry:NO];
    passTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    [sendMsgBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [backView1 addSubview:sendMsgBtn];
    sendMsgBtn.enabled = NO;
    
    
    //TODO:创建下一步按钮
    loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(backView1.origin.x, backView1.bottom+15, backView1.frame.size.width, kkRowHeight);
    [loginBtn setBackgroundColor:[UIColor colorWithRed:180/255.0 green:45/255.0  blue:25/255.0 alpha:1]];
    loginBtn.layer.cornerRadius = 0;
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:loginBtn];
    
}

/*--------------------*/


/*----------------------------------*/
#pragma mark - textfield delegate
//TODO:开始输入
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == phoneTextField) {
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
        
        if (detailString.length == 11) {
            
            [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self changeMesBtnWithString:titleString WithEnable:YES];
            sendMsgBtn.enabled = YES;
        }
        
        if (detailString.length > 11) {
            return NO;
        }
        
    }
        //TODO:限制验证码长度
        if (textField == passTextField) {
            if (detailString.length>6) {
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

/*---------验证码获取&登陆相关--------*/
//TODO:改变验证码获取按钮的状态
- (void)changeMesBtnWithString:(NSMutableAttributedString *)string WithEnable:(BOOL)enable
{
    NSRange selectedRange = {0, [string length]};
    [string beginEditing];
    //设置字体大小
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:selectedRange];
    [string endEditing];
    [sendMsgBtn setAttributedTitle:string forState:UIControlStateNormal];
    [sendMsgBtn.titleLabel setAttributedText:string]; //解决4s秒数不动的问题
    //倒计时期间不能点击第二次
    if (enable)
    {
        sendMsgBtn.enabled = YES;
    }else{
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
        detailString =  [[NSMutableAttributedString alloc]initWithString:@"重获验证码"];
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
    if (phoneTextField.text.length < 11 || ![XHDHelper isphoneStyle:phoneTextField.text])
    {
        [SVProgressHUD showWithStatus:@"手机号码格式不正确"];
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = phoneTextField.text;
    params[@"sms_type"] = @"4";
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
                      
                       NSMutableAttributedString *detailString =  [[NSMutableAttributedString alloc]initWithString:@"重获验证码"];
                       //改变获取验证码的按钮
                       [self changeMesBtnWithString:detailString WithEnable:YES];
                       [messageTimer invalidate];  //结束计时器
                       
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"提示") message:msg delegate:self cancelButtonTitle:LocStr(@"确定") otherButtonTitles: nil];
                       [alert show];
                   }];
}

/*-------------下一步相关----------------*/
//TODO:下一步按钮的响应方法
- (void)nextButtonClick:(UIButton*)sender
{
    // 点击下一步，请求网络，请求成功的话，跳到下一步，代入手机号和验证码
    if(passTextField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }else
    {
        ResetPasswordSecondVC *next = [[ResetPasswordSecondVC alloc]init];
        next.mobile = phoneTextField.text;
        next.Vcode = passTextField.text;
        [self.navigationController pushViewController:next animated:YES];
    
    }
    
}

//TODO:结束输入
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end