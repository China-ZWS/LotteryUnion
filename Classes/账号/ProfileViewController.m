//
//  ProfileViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/6/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "ProfileViewController.h"
#import "XHDHelper.h"
#import "NSString+NumberSplit.h"
#import "UserInfo.h"
#import "UtilMethod.h"

@implementation ProfileViewController
- (id) init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:LocStr(@"基本信息修改")];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(backButtonAction) image:kkBackImage];
        
        from_flag = 2;
        
        self.hidesBottomBarWhenPushed = YES;// 隐藏tabar
        
        if(IsPad) [self.navigationItem setHidesBackButton:YES];
      
    }
    return self;
}

-(void)setFromFlag:(int)flag
{
    from_flag = flag;
}

//TODO:返回按钮动作
-(void)backButtonAction
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


/*----------------------------*/
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTable];
    
    //点击空白处结束输入
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleFirst:)];
    [self.view addGestureRecognizer:singleTap];
    [self setupTextField];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    // 基本信息查询
    [self queryList];
    //TODO:获取用户信息
    if(!isValidateStr([[UserInfo sharedInstance]RealName]))
    {
        textID.enabled = YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
/*-------------------------*/
//TODO:创建表
- (void)createTable
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, mScreenWidth-20, 44*3) style:UITableViewStyleGrouped];
    [self.tableView setBackgroundView:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.scrollEnabled  = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.borderColor = DIVLINECOLOR.CGColor;
    self.tableView.layer.borderWidth = 0.35;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    ;
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    [self.view addSubview:self.tableView];
    //去掉上方空白
    if (iOS7)
    {
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0.01)];
    }
    [self createCommitButton];
}

//TODO:提交按钮
- (void)createCommitButton
{
        UIButton *betButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [betButton setTitle:LocStr(@"提交") forState:UIControlStateNormal];
        [betButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
        betButton.titleLabel.font = [UIFont systemFontOfSize:15];
        betButton.backgroundColor = REDFONTCOLOR;
        betButton.frame = CGRectMake(_tableView.origin.x,_tableView.bottom+10,_tableView.width,40);
        [betButton addTarget:self action:@selector(submitAction:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:betButton];
    
    [self createTipsLabelWith:betButton];
}

//TODO:提示Label
- (void)createTipsLabelWith:(UIView*)aboveView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFrame:CGRectMake(10,aboveView.bottom+10,self.view.width-20,80.0f)];
    [label setNumberOfLines:4];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = LocStr(@"温馨提示:建议您真实姓名、身份证信息，作为找回密码和兑奖的凭证！真实姓名和身份证号码一经保存，将不可修改。如填写有误，请致点客服热线400-166-1668！");
    [self.view addSubview:label];
}

//TODO:查询基本信息
- (void)queryList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain:kAPI_GetAccountInfo];
    
    _connection = [RequestModel POST:URL(kAPI_GetAccountInfo) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [[UserInfo sharedInstance] setRealName:[data valueForKey:@"customer_name"]];
                       [[UserInfo sharedInstance] setIDCard:[data valueForKey:@"idcard"]];
                       [[UserInfo sharedInstance] setUserEmail:[data valueForKey:@"email"]];
                       // 初始化
                      [self updateTextFiledUI];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       if ([state integerValue] == Status_Code_User_Not_Login)
                       {
                           [super gotoLoging];
                           return;
                       }
                   }];
    
}


- (void)refreshWithViews
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

/*-------------------------------*/
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section
{
    return 160;
}

- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *f = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.width,160)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,80)];
        [f addSubview:view];
        [view setCenterX:self.view.frame.size.width/2];
       
        
        return f;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    
    cell.textLabel.textColor = NAVITITLECOLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (section == 0) {
        [XHDHelper addDivLineWithFrame:mRectMake(0, cell.height-0.3, tv.width, 0.3) SuperView:cell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *textLbl = cell.textLabel;
        if (indexPath.row == 0) {
            textLbl.text = [NSString stringWithFormat:@"%@:",
                            LocStr(@"真实姓名")];
            [cell.contentView addSubview:textName];
        } else if (indexPath.row == 1) {
            textLbl.text = [NSString stringWithFormat:@"%@:",
                            LocStr(@"身份证")];
            [cell.contentView addSubview:textID];
        } else if (indexPath.row == 2) {
            textLbl.text = [NSString stringWithFormat:@"%@:",
                            LocStr(@"邮箱地址")];
            [cell.contentView addSubview:textEmail];
        }
    }
    
    return cell;
}

/*-------------------------------*/
#pragma mark -- 提交动作相关
//TODO:提交按钮响应
- (void)submitAction:(id)sender
{

    NSLog(@"textName.text == %@ ------",textName.text);
    if (textName.text.length <1)
    {
        [SVProgressHUD showErrorWithStatus:LocStr(@"请填写真实姓名")];
        [textName becomeFirstResponder];
        return;
    }
    
    if(!isChinese(textName.text))
    {
        [textName becomeFirstResponder];
        [SVProgressHUD showErrorWithStatus:LocStr(@"请您输入中文姓名")];
        return;
    }

    if ([textID.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:LocStr(@"请填写身份证号码")];
        [textID becomeFirstResponder];
        return;
    }

    // 身份证号码验证
    if(textID.enabled){
        BOOL valid = [XHDHelper isIdentityCard:textID.text];
        if (!valid) {
           [SVProgressHUD showErrorWithStatus:LocStr(@"身份证号码有误")];
            [textID becomeFirstResponder];
            return;
        }
    }
    // 邮箱地址验证
    if (textEmail.text.length > 0
        && ![XHDHelper isValidateEmail:textEmail.text])
    {
        [SVProgressHUD showErrorWithStatus:LocStr(@"邮件地址有误")];
        [textEmail becomeFirstResponder];
        return;
    }
    
    NSString *optionStr = @"";
    if(isValidateStr(textEmail.text))
        optionStr=[NSString stringWithFormat:@"%@\n 邮箱地址：%@",
                   optionStr,textEmail.text];

    NSString *message = [NSString stringWithFormat:@" 真实姓名：%@\n 身份证：%@%@",
                         textName.text,isValidateStr([[UserInfo sharedInstance] IDCard])?[[UserInfo sharedInstance]IDCard]:textID.text,optionStr];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认信息" message:message delegate:self cancelButtonTitle:LocStr(@"取消") otherButtonTitles:LocStr(@"确认"), nil];
    [alertView show];

}

//TODO:请求网络
- (void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    params[@"customer_name"] = textName.text;
    params[@"idcard"] = isValidateStr([[UserInfo sharedInstance]IDCard])?[[UserInfo sharedInstance]IDCard]:textID.text;
    params[@"email"] = textEmail.text;
    [params setPublicDomain:kAPI_BasicInfoModify];
    
    _connection = [RequestModel POST:URL(kAPI_BasicInfoModify) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [SVProgressHUD showSuccessWithStatus:@"基本信息修改成功"];
                       //保存到沙盒，保存到本地
                       [[NSUserDefaults standardUserDefaults] setValue:[NS_USERDEFAULT stringForKey:IDcard]?[NS_USERDEFAULT stringForKey:IDcard]:textID.text forKey:IDcard];
                        [[NSUserDefaults standardUserDefaults] setValue:textEmail.text forKey:Email];
                       
                       [[NSUserDefaults standardUserDefaults] synchronize];
                       [[UserInfo sharedInstance]setIDCard:textID.text];
                       [[UserInfo sharedInstance]setRealName:textName.text];
                       [[UserInfo sharedInstance]setUserEmail:textEmail.text];
                       [self.navigationController popViewControllerAnimated:YES];
                       
//                      if(from_flag<2)
//                      {
//                          // 直接修改基本信息时 from_flag 为2
//                        [self performSelectorOnMainThread:@selector(gotoEditBank) withObject:nil waitUntilDone:NO];
//                      }
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                     
                   }];
    

}

/*-------------------------------*/
//TODO:提示框即将显示
-(void)willPresentAlertView:(UIAlertView *)alertView {
    for (UIView *view in alertView.subviews)
    {
        if([view.class isSubclassOfClass:[UILabel class]])
        {
            UILabel *txtLbl = (UILabel*)view;
            if(![txtLbl.text isEqualToString:alertView.title])
                [txtLbl setTextAlignment:NSTextAlignmentLeft];
        }
    }
}
//TODO:请求网络
-(void)alertView:(UIAlertView *)av clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==av.firstOtherButtonIndex)
    {
        [self performSelector:@selector(requestData)
                   withObject:nil afterDelay:0.5];
    }
    
}
/*-------------------------------*/
//TODO:设置文本输入框
- (void)setupTextField
{
    textID = [[UITextField alloc] initWithFrame:CGRectMake(100,iOS7?2.0:12.0,170,40)];
    textID.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textID.font = [UIFont systemFontOfSize:15];
    textID.returnKeyType = UIReturnKeyNext;
    textID.placeholder = LocStr(@"请输入身份证号码");
    textID.delegate = self;
    [XHDHelper addToolBarOnInputFiled:textID Action:@selector(cancleFirst:) Target:self];
    
    textName = [[UITextField alloc] initWithFrame:CGRectMake(100,iOS7?2.0:12.0,170,40)];
    textName.keyboardType = UIKeyboardTypeDefault;
    textName.font = [UIFont systemFontOfSize:15];
    textName.returnKeyType = UIReturnKeyNext;
    textName.placeholder = LocStr(@"请您输入中文姓名");
    textName.delegate = self;
    [XHDHelper addToolBarOnInputFiled:textName Action:@selector(cancleFirst:) Target:self];

    
    textEmail = [[UITextField alloc] initWithFrame:CGRectMake(100,iOS7?2.0:12.0,170,40)];
    textEmail.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textEmail.font = [UIFont systemFontOfSize:15];
    textEmail.returnKeyType = UIReturnKeyNext;
    textEmail.placeholder = LocStr(@"请输入邮箱地址");
    textEmail.delegate = self;
    [XHDHelper addToolBarOnInputFiled:textEmail Action:@selector(cancleFirst:) Target:self];

}
#pragma mark-- 文本输入框代理方法
//TODO:结束输入
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == textName)
    {
        [textID becomeFirstResponder];
    } else if (textField == textID)
    {
        [textEmail becomeFirstResponder];
    } else if (textField == textEmail)
    {
        [self submitAction:nil];
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int newLength = (int)(textField.text.length+string.length-range.length);
    
    if(textField == textID)
    {
        return (newLength > 18) ? NO : YES;
    }
    if(textField == textName)
    {
        return (newLength > 20) ? NO : YES;
    }
    
    if(textField==textEmail && ![string isAllInvalidEmailString])
    {
           return NO;
    }
    
    if(textField == textEmail) {
        return (newLength > 50) ? NO : YES;
    }
    
    return YES;
}

//TODO:添加单击手势隐藏键盘
-(void)cancleFirst:(UITapGestureRecognizer *)singleTap
{
    NSArray * tfArr = @[textName,textID,textEmail];
    for(UITextField *tf in tfArr)
    {
        [tf resignFirstResponder];
    }
}
/*-----------------------*/

#pragma mark --- 更新输入框里面的内容
- (void)updateTextFiledUI
{
    
    //TODO:身份证的5-13位替换成*
    if(IsEmpty([[UserInfo sharedInstance]IDCard]))
    {
        textID.enabled = YES;
    }
    else
    {
        NSString *str = [[UserInfo sharedInstance]IDCard];
        if(str.length>13)
        {
            NSRange range = NSMakeRange (5, 8);
            NSLog(@"%@",str);
            textID.text = [str stringByReplacingOccurrencesOfString:[str substringWithRange:range] withString:@"********"];
            [textID reloadInputViews];
            textID.enabled = NO;
        }
    }
    
    if(IsEmpty([[UserInfo sharedInstance]RealName]))
    {
        textName.enabled = YES;
    }
    else
    {
        textName.text = [[UserInfo sharedInstance]RealName];
        textName.enabled = NO;
    }
    
    
    if(IsEmpty([[UserInfo sharedInstance]UserEmail]))
    {
        
    }else
    {
        textEmail.text = [[UserInfo sharedInstance]UserEmail];
    }
}


//TODO:是否支持横屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient {
    if(IsPad) return UIInterfaceOrientationIsLandscape(orient);
    return (orient == UIInterfaceOrientationPortrait);
}

@end
