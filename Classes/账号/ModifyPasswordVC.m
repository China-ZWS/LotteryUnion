//
//  RegisterViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/6/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "ModifyPasswordVC.h"
#import "XHDHelper.h"

//#import "HttpRequest.h"


@implementation ModifyPasswordVC
{
    UIButton *regbutton;//提交修改按钮
}
//TODO:初始化
- (id) init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"修改密码"];
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

// 添加单击手势隐藏键盘
-(void)cancleFirst:(UITapGestureRecognizer *)singleTap
{
    if ([textName isFirstResponder]) {
        [textName resignFirstResponder];
        return;
    }
    if ([textPass isFirstResponder]) {
        [textPass resignFirstResponder];
        return;
    }
    if ([textConfirm isFirstResponder]) {
        [textConfirm resignFirstResponder];
        return;        
    }
}


/*-----------------------------*/
//TODO:创建表
- (void)createTableView
{
    //去掉上方空白
    self.tableView = [[UITableView alloc]initWithFrame:mRectMake(10, 10, mScreenWidth-20,44*3) style:UITableViewStylePlain];
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
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:14.4];
    //添加分隔线
    UIView  *divline = [[UIView alloc]initWithFrame:mRectMake(0, cell.height-0.35,tv.width, 0.35)];
    divline.backgroundColor = DIVLINECOLOR;
    [cell addSubview:divline];
    
    if (section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                     LocStr(@"原始密码")]];
            [cell.contentView addSubview:textName];
            
        } else if (indexPath.row == 1) {
           
            [cell.textLabel setText:[NSString stringWithFormat:@"%@:",
                                     LocStr(@"新密码")]];
            [cell.contentView addSubview:textPass];
        } else if (indexPath.row == 2) {
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
    //TODO:密码修改按钮
    regbutton = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.origin.x,_tableView.bottom+10,_tableView.width,40)];
    [regbutton setTitle:LocStr(@"修改") forState:UIControlStateNormal];
    [regbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regbutton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [regbutton addTarget:self action:@selector(sureModifyAction:)
        forControlEvents:UIControlEventTouchUpInside];
    regbutton.backgroundColor = REDFONTCOLOR;
    [self.view addSubview:regbutton];
}

//TODO:修改密码按钮响应动作
- (void)sureModifyAction:(UIButton*)sender
{
//请求网络，成功后，回到根控制器
    regbutton.enabled = NO;
    if(textName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入原始密码~"];
        regbutton.enabled = YES;
        return;
    }
    if(textPass.text.length == 0)
    {
       [SVProgressHUD showErrorWithStatus:@"请输入新密码~"];
        regbutton.enabled = YES;
        return;
    }
    if(textPass.text.length < 6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能小于6位"];
        regbutton.enabled = YES;
        return;
    }
    if(textConfirm.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请确认新密码~"];
        regbutton.enabled = YES;
        return;
    }
    if(![textPass.text isEqualToString:textConfirm.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致，请重新输入"];
        regbutton.enabled = YES;
        return;
    }
    [self requestData];
    

}
//TODO:请求网络
- (void)requestData
{
    //如果要验证码登陆则登陆类型为1，密码登陆为零
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pwd_old"] = md5(textName.text);
    params[@"pwd_new"] = md5(textConfirm.text) ;
    [params setPublicDomain:kAPI_ModifyPwd];
    
    _connection = [RequestModel POST:URL(kAPI_ModifyPwd) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                       //如果沙盒里面保存了密码，则将密码保存到沙盒
                       if(((NSString*)[mUserDefaults valueForKey:@"pwd"]).length)
                       {
                          [mUserDefaults setObject:textConfirm.text forKey:@"pwd"];
                       }
                       regbutton.enabled = YES;
                       [self.navigationController popViewControllerAnimated:YES];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       regbutton.enabled = YES;
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

/*-----------------------------*/
//TODO:输入框设置
- (void)setupTextField
{
    //TODO:用户名输入框
    CGRect textFrame = CGRectMake(90.0,iOS7? 2.0: 12.0,170.0,40.0);
    textName = [[UITextField alloc] initWithFrame:textFrame];
    textName.keyboardType = UIKeyboardTypeASCIICapable;
    textName.placeholder = LocStr(@"请输入原始密码");
    textName.font = [UIFont systemFontOfSize:15];
    textName.returnKeyType = UIReturnKeyNext;
    textName.textColor = NAVITITLECOLOR;
    textName.delegate = self;
    [XHDHelper addToolBarOnInputFiled:textName Action:@selector(cancleFirst:) Target:self];
    
    
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
    
}

#pragma mark ----UITextField delegate
//TODO:输入限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = textField.text.length+string.length-range.length;
    
    if(textField == textName)
        return (newLength > 11) ? NO : YES;
   
    if(textField == textConfirm||textField == textPass)
        return (newLength > 16) ? NO : YES;
    return YES;
}

//TODO:即将结束输入
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == textName)
        [textPass becomeFirstResponder];
    else if (textField == textPass) {
        [textConfirm becomeFirstResponder];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else if (textField == textConfirm)
    {
        [textField resignFirstResponder];
#warning 点击最后一个输入框直接调用修改密码网络请求
        [self sureModifyAction:nil];
    }

    return YES;
}


//TODO:是否支持横屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
    if(IsPad) return UIInterfaceOrientationIsLandscape(orient);
    return (orient == UIInterfaceOrientationPortrait);
}

@end
