//
//  RegisterViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/6/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "RegisterViewController.h"
#import "XHDHelper.h"
#import "NSString+Extension.h"
#import "UtilMethod.h"
#import "MineVC.h"
#import "UserInfo.h"


#define kkTitleColor
static double countdown_time = 0;

@implementation RegisterViewController

//TODO:初始化
- (id) init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"注 册"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
       
    }
    return self;
}
//TODO:返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*-----------------------------*/
#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO:表的设置
    [self createTableView];
  
    // 增加一个点击手势，一点击取消TextFile的第一响应
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleFirst:)];
    [self.view addGestureRecognizer:singleTap];
    
   //设置输入框
    [self setupTextField];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cancleFirst:nil];
    countdown_time = 0;
    [vcButton setEnabled:YES];
    [vcButton setTitle:LocStr(@"获取验证码")
              forState:UIControlStateNormal];
}
// 添加单击手势隐藏键盘
-(void)cancleFirst:(UITapGestureRecognizer *)singleTap
{
    if ([textName isFirstResponder])
    {
        [textName resignFirstResponder];
        return;
    }
    if ([textVC isFirstResponder])
    {
        [textVC resignFirstResponder];
        return;
    }
    if ([textPass isFirstResponder])
    {
        [textPass resignFirstResponder];
        return;
    }
    if ([textConfirm isFirstResponder])
    {
        [textConfirm resignFirstResponder];
        return;        
    }
}


/*-----------------------------*/
//TODO:创建表
- (void)createTableView
{
    //去掉上方空白
    self.tableView = [[UITableView alloc]initWithFrame:mRectMake(10, 10, mScreenWidth-20,44*4) style:UITableViewStylePlain];
    if (iOS7)
    {
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0.001)];
       // self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [self.view setBackgroundColor:kAppBgColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.layer.borderColor = DIVLINECOLOR.CGColor;
    _tableView.layer.borderWidth = 0.35;
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.scrollEnabled  = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self createRegistButton];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int section = (int)indexPath.section;
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:14.4];
    //添加分隔线
    UIView  *divline = [[UIView alloc]initWithFrame:mRectMake(0, cell.height-0.35,cell.width, 0.35)];
    divline.backgroundColor = DIVLINECOLOR;
    [cell addSubview:divline];
    
    if (section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                     LocStr(@"手机号码")]];
            [cell.contentView addSubview:textName];
            if(!mobile) [cell.contentView addSubview:vcButton];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                     LocStr(@"验证码")]];
            [cell.contentView addSubview:textVC];
            
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                     LocStr(@"登录密码")]];
            [cell.contentView addSubview:textPass];
        } else if (indexPath.row == 3) {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                     LocStr(@"确认密码")]];
            [cell.contentView addSubview:textConfirm];
        }
    }
    
    return cell;
}

//TODO:创建注册按钮
- (void)createRegistButton
{
    //TODO:注册按钮
    UIButton *regbutton = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.origin.x,_tableView.bottom+10,_tableView.width,40)];
    [regbutton setTitle:LocStr(@"注册") forState:UIControlStateNormal];
    [regbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regbutton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [regbutton addTarget:self action:@selector(registerAction:)
        forControlEvents:UIControlEventTouchUpInside];
    regbutton.backgroundColor = REDFONTCOLOR;
    [self.view addSubview:regbutton];
    
    // 去掉两个按钮，同意注册协议
    //        optionalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [optionalButton setImage:[UIImage imageNamed:@"domo_checkbox.png"]
    //                        forState:UIControlStateNormal];
    //        [optionalButton setImage:[UIImage imageNamed:@"domo_checkbox_press.png"]
    //                        forState:UIControlStateSelected];
    //        [optionalButton addTarget:self action:@selector(xieyiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [optionalButton setSelected:YES];
    //        [optionalButton setFrame:CGRectMake(10.0f,60.0f,23.0f,23.0f)];
    //        [view addSubview:optionalButton];
    //
    //        UIButton *textXY = [[UIButton alloc] initWithFrame:CGRectMake(33,62,120,23)];
    //        [textXY setTitle:LocStr(@"我同意注册协议") forState:UIControlStateNormal];
    //        [textXY setTitleColor:parseColor(BLUE_LINK) forState:UIControlStateNormal];
    //        [textXY.titleLabel setFont:[UIFont systemFontOfSize:14]];
    //        [textXY addTarget:self action:@selector(openXieYi) forControlEvents:UIControlEventTouchUpInside];
    //        [view addSubview:textXY];

}
//TODO:注册按钮响应动作
- (void)registerAction:(id)sender
{
    if(![self checkPhoneNumber])
    {
       return;
    }
    
    //    if(!optionalButton.selected)
    //    {
    //        alert_fail(LocStr(@"同意注册协议方可注册"));
    //        return;
    //    }
    
    if(!isValidateStr(textVC.text) || textVC.text.length>6)
    {
        [SVProgressHUD showErrorWithStatus:(LocStr(@"验证码不正确"))];
        [textVC becomeFirstResponder];
        return;
    }
    
    if ([textPass.text length] < 6||[textPass.text length] > 16)
    {
        [SVProgressHUD showErrorWithStatus:(LocStr(@"密码长度在6到16位之间"))];
        [textPass becomeFirstResponder];
        return;
    }
    
    if (![textPass.text isEqualToString:textConfirm.text])
    {
        [SVProgressHUD showErrorWithStatus:(LocStr(@"密码和确认密码要相同"))];
        [textConfirm becomeFirstResponder];
        return;
    }
    
    [textVC resignFirstResponder];
    [textName resignFirstResponder];
    [textPass resignFirstResponder];
    [textConfirm resignFirstResponder];
    mobile = textName.text;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = textName.text;
    params[@"pwd"] =  md5(textConfirm.text);
    params[@"valid_code"] = textVC.text;
    [params setPublicDomain:kAPI_BasicInfoRegister];
    
    _connection = [RequestModel POST:URL(kAPI_BasicInfoRegister) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                           [SVProgressHUD showSuccessWithStatus:([data objectForKey:@"note"])];
                           [NS_USERDEFAULT removeObjectForKey:@"pwd"];
                           [NS_USERDEFAULT removeObjectForKey:@"name"];     // 移除前一个登录的手机号
                           //保存注册好的手机号到本地用来预输入
                           [NS_USERDEFAULT setValue:mobile forKey:@"name"];
                           
                           id jsessionId = [data valueForKey:@"jesessionid"];
                           id serverStatus = [data valueForKey:@"server_status"];
                           [NS_USERDEFAULT setValue:jsessionId forKey:@"jesessionid"];
                           [NS_USERDEFAULT setValue:serverStatus forKey:@"server_status"];
                           [NS_USERDEFAULT synchronize];
                           
                           // 新注册的
                           [[UserInfo sharedInstance]clearUserInfo:YES];
                       
                           // 是新注册的设置为1
                            [MineVC setNew:1];
                           
                           //TODO 获取用户信息内容
                           [[UserInfo sharedInstance] setIsLogined:YES];
                           [mNotificationCenter postNotificationName:NotifyLoginStatusChange object:nil];
                       
                           [self.navigationController popToRootViewControllerAnimated:YES];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                       
                   }];
    
}

/*-----------------------------*/
//TODO:输入框设置
- (void)setupTextField
{
    //TODO:用户名输入框
    CGRect textFrame = CGRectMake(90.0,iOS7? 2.0: 12.0,130.0,40.0);
    textName = [[UITextField alloc] initWithFrame:textFrame];
    textName.keyboardType = UIKeyboardTypeNumberPad;
    textName.placeholder = LocStr(@"请输入手机号码");
    textName.font = [UIFont systemFontOfSize:15];
    textName.returnKeyType = UIReturnKeyNext;
    textName.textColor = NAVITITLECOLOR;
    textName.delegate = self;
    [XHDHelper addToolBarOnInputFiled:textName Action:@selector(cancleFirst:) Target:self];
    
    //TODO:校验码输入框
    textVC = [[UITextField alloc] initWithFrame:textFrame];
    textVC.keyboardType = UIKeyboardTypeNumberPad;
    textVC.font = [UIFont systemFontOfSize:15];
    textVC.placeholder = LocStr(@"请输入验证码");
    textVC.returnKeyType = UIReturnKeyNext;
    textVC.textColor = NAVITITLECOLOR;
    textVC.delegate = self;
    [XHDHelper addToolBarOnInputFiled:textVC Action:@selector(cancleFirst:) Target:self];
    
    //TODO:密码输入框
    textPass = [[UITextField alloc] initWithFrame:textFrame];
    textPass.keyboardType = UIKeyboardTypeASCIICapable;
    textPass.font = [UIFont systemFontOfSize:15];
    textPass.returnKeyType = UIReturnKeyNext;
    [textPass setPlaceholder:@"6-16位字符"];
    textPass.secureTextEntry = YES;
    textPass.textColor = NAVITITLECOLOR;
    textPass.delegate = self;
    [XHDHelper addToolBarOnInputFiled:textPass Action:@selector(cancleFirst:) Target:self];
    
    //TODO:密码确认输入框
    textConfirm = [[UITextField alloc] initWithFrame:textFrame];
    textConfirm.keyboardType = UIKeyboardTypeASCIICapable;
    textConfirm.font = [UIFont systemFontOfSize:15];
    textConfirm.returnKeyType = UIReturnKeyDone;
    [textConfirm setPlaceholder:@"6-16位字符"];
    textConfirm.secureTextEntry = YES;
    textConfirm.textColor = NAVITITLECOLOR;
    textConfirm.delegate = self;
    [XHDHelper addToolBarOnInputFiled:textConfirm Action:@selector(cancleFirst:) Target:self];
    
    //TODO:验证码按钮
    vcButton = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.width-88,8,78,30)];
    vcButton.layer.cornerRadius = 4;
    vcButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.55 alpha:1];
    [vcButton setTitle:LocStr(@"获取验证码") forState:UIControlStateNormal];
    [vcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vcButton.titleLabel setFont:[UIFont systemFontOfSize:13.5]];
    [vcButton addTarget:self action:@selector(vcAction)
       forControlEvents:UIControlEventTouchUpInside];
//    
//    // 倒计时用的button
//    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,30)];
//    _timeLabel.font = [UIFont systemFontOfSize:15];
//    _timeLabel.textColor = [UIColor whiteColor];
//    _timeLabel.textAlignment = NSTextAlignmentCenter;
//    _timeLabel.backgroundColor = [UIColor clearColor];
    
    //按钮不能点击
        if ([self getCountdownTime]!=0)
        {
            [self enableVCButton];
        }
}

#pragma mark ----UITextField delegate
//TODO:输入限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = textField.text.length+string.length-range.length;
    
    if(textField == textName)
        return (newLength > 11) ? NO : YES;
    
    if(textField == textVC)
        return (newLength > 6) ? NO : YES;
    
    if(textField == textConfirm||textField == textPass)
        return (newLength > 16) ? NO : YES;
    return YES;
}

//TODO:即将结束输入
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == textName)
        [textVC becomeFirstResponder];
    else if(textField == textVC)
        [textPass becomeFirstResponder];
    else if (textField == textPass) {
        [textConfirm becomeFirstResponder];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else if (textField == textConfirm)
    {
        [textField resignFirstResponder];
     // 点击最后一个输入框直接调用注册网络请求
       [self registerAction:nil];
    }

    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
    if(IsPad) return UIInterfaceOrientationIsLandscape(orient);
    return (orient == UIInterfaceOrientationPortrait);
}

#pragma mark - Action Method
- (void)xieyiButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
}

//打开协议内容
- (void)openXieYi
{
//    XieYiViewController *xieyiView = [[XieYiViewController alloc] init];
//    xieyiView.reg_view = self;
//    [self.navigationController pushViewController:xieyiView animated:YES];
}

//TODO:倒计时IOS6
-(void)enableVCButton
{
   int remainTime = [self getCountdownTime];
    if(remainTime <= 0)
    {
        [vcButton setEnabled:YES];
        [vcButton setTitle:LocStr(@"获取验证码")
                  forState:UIControlStateNormal];
        return;
    }
    
    [vcButton setEnabled:NO];
    [vcButton setTitle:nil forState:UIControlStateNormal];
    [vcButton setTitle:[NSString stringWithFormat:@"%i秒",remainTime]
              forState:UIControlStateNormal];
    [self performSelector:@selector(enableVCButton)
               withObject:nil afterDelay:1];
    
}


//TODO:手机号是否有效
-(BOOL)checkPhoneNumber
{
    if(![NSString validateMobile:textName.text]|| textName.text.length > 11) {
         [SVProgressHUD showErrorWithStatus:(LocStr(@"请输入正确的手机号码"))];
        [textName becomeFirstResponder];
        return NO;
    }
    return YES;
}


// 点击获取验证码之后的一些UI变化(iOS7)
-(void)changeAction
{
    vcButton.enabled = NO;
    [vcButton setTitle:nil forState:UIControlStateNormal];
    //开启定时器
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownAction:) userInfo:nil repeats:YES];
}

// 定时器调用方法
-(void)countdownAction:(NSTimer *)aTime
{
    static int _time = 60;
    if (_time-- <= 0)
    {
        // 关闭定时器
        [aTime invalidate];
        // 重新设置i，下次计时用
        _time = 60;
        vcButton.enabled = YES;
        [vcButton setTitle:@"重获验证码" forState:UIControlStateNormal];
    }
}


//TODO:获取验证码
- (void)vcAction
{
    // 判断手机号码是否有效
    if(![self checkPhoneNumber])
    {
       return;
    }
    // 验证码获取成功后，60秒内，不能再次获取验证码
    [self resetCountdownTime];
    [self changeAction];
    [self enableVCButton];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = textName.text;
    params[@"sms_type"] = @"1";
    [params setPublicDomain:kAPI_GetVCode];
    
    _connection = [RequestModel POST:URL(kAPI_GetVCode) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"提示") message:[data objectForKey:@"note"] delegate:self cancelButtonTitle:LocStr(@"确定") otherButtonTitles: nil];
                           alert.tag = 10;
                           [alert show];
                           
                           [textName setEnabled:NO];
                           [textVC becomeFirstResponder];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"提示") message:msg delegate:self cancelButtonTitle:LocStr(@"确定") otherButtonTitles: nil];
                       [alert show];
                       
                       //关闭定时器，充值按钮
                       countdown_time = 0;
                       [vcButton setEnabled:YES];
                       [vcButton setTitle:LocStr(@"重获验证码")
                                 forState:UIControlStateNormal];
                    
                   }];
}

// 同意按钮响应
- (void)tongyiAction:(BOOL) tongyi
{
   // [optionalButton setSelected:tongyi];
}


//TODO:退出提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde
{
    if(alertView.tag==1)
    {// 确定
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//TODO:倒计时相关
// 记录剩下的时间
-(int)getCountdownTime
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return 60-(now - countdown_time);
}

// 时间轴
-(void)resetCountdownTime
{
    countdown_time = [[NSDate date] timeIntervalSince1970];
    
}

@end
