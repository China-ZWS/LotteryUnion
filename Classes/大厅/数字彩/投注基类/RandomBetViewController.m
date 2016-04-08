//
//  RandomBetViewController.m
//  YaBoCaiPiao
//  机选多期投注
//
//  Created by liuchan on 12-8-30.
//  Copyright (c) 2012年 DoMobile. All rights reserved.
//

#import "RandomBetViewController.h"
#import "AwardVC.h"
#import "LoginVC.h"
#import "PopUpOptionView.h"
#import "UtilMethod.h"
#import "XHDHelper.h"

#define CellIdentifier @"CellIdentifier"
#define TAG_ZHUIJIA_SWITCHER 100

@implementation RandomBetViewController
{
    NSString *jiXuanShu;  //机选数
    NSString *beiShu;  //倍数
    NSString *qiShu;  //期数
    
    //机选一注
    UILabel *randomNumberLab;
    //15倍
    UILabel *beiShuLab;
    //期数
    UILabel *qiShuLab;

}

-(id)initWithLotteryPK:(int)lot_pk
{
    if(self = [super init])
    {
        _lottery_pk = lot_pk;
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(openAwardList:) image:@"jczq_no"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
        
    }
    return self;
}
//TODO:返回
- (void)back
{
   // [self dismissViewController];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    [mNotificationCenter removeObserver:self];
}
//TODO:入口
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setNewTitle:getLotNames(GET_STRING_OF_INT((long)_lottery_pk))];
    _random_amout = _period_num = _multiple = 1;
    
    [self chooseInfoDiaplayLab];
    
    _titleArray = [NSArray arrayWithObjects:@"彩种",@"注数",@"倍数",@"期数",@"追加：",nil];
    
    //创建表
    [self createTableView];
    
    [self _initSubView];
    
    // 添加一个手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleEdit)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!IsEmpty([[UserInfo sharedInstance] Balance]))
    {
       [self changeMoneyAndMultiple];
    }
    
}
#pragma mark -- 创建表
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth-20, (_lottery_pk == lDLT_lottery)?200:160)
                                              style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    //去掉上方空白
    if (iOS7)
    {
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 0.01)];
    }
    [_tableView setBackgroundView:nil];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBounces:NO];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];

}
#pragma mark -- 显示信息的Lab
- (void)chooseInfoDiaplayLab
{
    
   //机选一注
    randomNumberLab = [XHDHelper createLabelWithFrame:mRectMake(70, 0, 100, 40) andText:[NSString stringWithFormat:@"机选%@注",jiXuanShu.length?jiXuanShu:@"1"] andFont:UIFONT(16) AndBackGround:[UIColor clearColor] AndTextColor:NAVITITLECOLOR];
    //15倍
      beiShuLab = [XHDHelper createLabelWithFrame:mRectMake(70, 0, 100, 40) andText:[NSString stringWithFormat:@"%@倍",beiShu.length?beiShu:@"1"] andFont:UIFONT(16) AndBackGround:[UIColor clearColor] AndTextColor:NAVITITLECOLOR];
    //期数
    qiShuLab = [XHDHelper createLabelWithFrame:mRectMake(70, 0, 100, 40) andText:[NSString stringWithFormat:@"%@期",qiShu.length?qiShu:@"1"] andFont:UIFONT(16) AndBackGround:[UIColor clearColor] AndTextColor:NAVITITLECOLOR];

}


//TODO:初始化子视图
- (void)_initSubView
{
    confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(15,0,mScreenWidth-30,(iPhone6||iPhone6Plus)?40:35)];
    [confirmButton setTitle:@"确定投注" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(betConfirmClick)
            forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setGeneralBgWithSize:confirmButton.size];
    //(IOS7? 8:50)
    [confirmButton setTop:mScreenHeight-65-50];
    
    //机选Label
    _amoutLabel = [[UILabel alloc] initWithFrame:mRectMake(_tableView.origin.x,_tableView.bottom+5 , mScreenWidth/2.0+50, 20)];
    [_amoutLabel setTextAlignment:NSTextAlignmentLeft];
    [_amoutLabel setBackgroundColor:[UIColor clearColor]];
    [_amoutLabel setFont:[UIFont systemFontOfSize:14]];
    [_amoutLabel setTextColor:NAVITITLECOLOR];
    
    //金额Label
    CGRect bFrame = CGRectMake(_amoutLabel.width+50,_amoutLabel.origin.y,mScreenWidth/2.0-65,25);
    _moneyLabel = [[AttributeColorLabel alloc] initWithFrame:bFrame];
    [_moneyLabel setFont:[UIFont systemFontOfSize:14]];
    [_moneyLabel setBackgroundColor:[UIColor clearColor]];
    [_moneyLabel setRight:_tableView.right];
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [_moneyLabel setTextColor:REDFONTCOLOR];
    
    [self.view addSubview:confirmButton];
    [self.view addSubview:_moneyLabel];
    [self.view addSubview:_amoutLabel];
    [self changeMoneyAndMultiple];
    
    //注数输入
    _zhushuFeild = [[UITextField alloc] initWithFrame:CGRectMake(_tableView.width-65, 7.5, 35, 25)];
    _zhushuFeild.text = [NSString stringWithFormat:@"%ld",(long)_random_amout];
    _zhushuFeild.keyboardType = UIKeyboardTypeNumberPad;
    _zhushuFeild.textAlignment = NSTextAlignmentCenter;
    _zhushuFeild.layer.borderColor = REDFONTCOLOR.CGColor;
    _zhushuFeild.layer.borderWidth = 0.4;
    _zhushuFeild.textColor = REDFONTCOLOR;
    _zhushuFeild.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _zhushuFeild.delegate = self;
    [XHDHelper addToolBarOnInputFiled:_zhushuFeild Action:@selector(cancleFristResponder) Target:self];
    
    //倍数输入
    _beishuFeild = [[UITextField alloc] initWithFrame:CGRectMake(_tableView.width-65, 7.5, 35, 25)];
    _beishuFeild.text = [NSString stringWithFormat:@"%ld",(long)_multiple];
    _beishuFeild.keyboardType = UIKeyboardTypeNumberPad;
    _beishuFeild.textAlignment = NSTextAlignmentCenter;
    _beishuFeild.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _beishuFeild.layer.borderColor = REDFONTCOLOR.CGColor;
    _beishuFeild.layer.borderWidth = 0.4;
    _beishuFeild.textColor = REDFONTCOLOR;
    _beishuFeild.delegate = self;
    [XHDHelper addToolBarOnInputFiled:_beishuFeild Action:@selector(cancleFristResponder) Target:self];
    
    //期数输入
    _qishuFeild = [[UITextField alloc] initWithFrame:CGRectMake(_tableView.width-65, 7.5, 35, 25)];
    _qishuFeild.text = _period_num?GET_INT((long)_period_num):@"无限";
    _qishuFeild.keyboardType = UIKeyboardTypeNumberPad;
    _qishuFeild.textAlignment = NSTextAlignmentCenter;
    _qishuFeild.textColor = REDFONTCOLOR;
    _qishuFeild.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _qishuFeild.layer.borderColor = REDFONTCOLOR.CGColor;
    _qishuFeild.layer.borderWidth = 0.4;
    _qishuFeild.delegate = self;
    [XHDHelper addToolBarOnInputFiled:_qishuFeild Action:@selector(cancleFristResponder) Target:self];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feildTextChange:) name:UITextFieldTextDidChangeNotification object:_zhushuFeild];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feildTextChange:) name:UITextFieldTextDidChangeNotification object:_beishuFeild];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feildTextChange:) name:UITextFieldTextDidChangeNotification object:_qishuFeild];
}

//TODO: 单击手势的响应方法
-(void)cancleEdit
{
    [self cancleFristResponder];
}

//取消第一响应
-(void)cancleFristResponder
{
    if ([_qishuFeild isFirstResponder]) {
        [_qishuFeild resignFirstResponder];
    }
    if ([_zhushuFeild isFirstResponder]) {
        [_zhushuFeild resignFirstResponder];
    }
    if ([_beishuFeild isFirstResponder]) {
        [_beishuFeild resignFirstResponder];
    }
}

#pragma -mark UITableView代理方法  ---------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //大乐透
    if(_lottery_pk==lDLT_lottery)
    {
        return _titleArray.count;
    }
    return _titleArray.count-1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //TODO:追号开关
        UIButton *mSwitch = [[UIButton alloc] initWithFrame:mRectMake(0, 0, 25, 25)];
        [mSwitch setCenterY:cell.height/2];
        [mSwitch setLeft:cell.width-mSwitch.width-40];
        [mSwitch setImage:mImageByName(@"dlt_zhuijia_circle") forState:UIControlStateNormal];
        [mSwitch setImage:mImageByName(@"dlt_zhuijia_circle1") forState:UIControlStateSelected];
      //  mSwitch.selected = NO;
        [mSwitch setTag:TAG_ZHUIJIA_SWITCHER];
        [mSwitch addTarget:self action:@selector(switcherValueChanged:)
          forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:mSwitch];
        [mSwitch setHidden:YES];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:NAVITITLECOLOR];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIButton *followSwitch = (UIButton*)[cell.contentView viewWithTag:TAG_ZHUIJIA_SWITCHER];
    
    switch (indexPath.row)
    {
        case 0:
            [cell.textLabel setText:[NSString stringWithFormat:@"%@：   %@", [_titleArray objectAtIndex:indexPath.row], getLotNames(GET_STRING_OF_INT((long)_lottery_pk))]];
            break;
        case 1:{
            
            [cell.textLabel setText:[NSString stringWithFormat:@"%@：",[_titleArray objectAtIndex:indexPath.row]]];
            cell.textLabel.userInteractionEnabled = YES;
            
            [cell addSubview:randomNumberLab];
            [cell.textLabel addSubview:_zhushuFeild];
        }break;
        case 2:
        {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@: ", [_titleArray objectAtIndex:indexPath.row]]];
            cell.textLabel.userInteractionEnabled = YES;
            
            [cell addSubview:beiShuLab];
            [cell.textLabel addSubview:_beishuFeild];
        }break;
        case 3:{
            
            [cell.textLabel setText:[NSString stringWithFormat:@"%@: ",[_titleArray objectAtIndex:indexPath.row]]];
             cell.textLabel.userInteractionEnabled = YES;
            
            [cell addSubview:qiShuLab];
            [cell.textLabel addSubview:_qishuFeild];
        }break;
            
        case 4:
            [cell.textLabel setText:[_titleArray objectAtIndex:indexPath.row]];
            break;
    }
    
    if(indexPath.row==0)
    {
        [followSwitch setHidden:YES];
        [cell setUserInteractionEnabled:NO];
        
    }else if(indexPath.row==4)
    {
        [followSwitch setHidden:NO];
        [cell.textLabel setWidth:150];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setUserInteractionEnabled:NO];
        [followSwitch setUserInteractionEnabled:YES];
        [cell setUserInteractionEnabled:YES];
        
    }else
    {
        [followSwitch setHidden:YES];
        [cell setUserInteractionEnabled:YES];
    }
    return cell;
}


#pragma mark -- 追加开关改变
-(void)switcherValueChanged:(UIButton*)sender
{
    sender.selected = !sender.isSelected;
    _is_follow = [sender isSelected];
    [self changeMoneyAndMultiple];
}

-(void)openAwardList:(id)sender
{
    // push到开奖控制器
    AwardVC *awrd = [[AwardVC alloc]initWithLottery_pk:GET_INT((long)_lottery_pk) playName:getLotNames(GET_STRING_OF_INT((long) _lottery_pk))];
    [self.navigationController pushViewController:awrd animated:YES];
    
}

#pragma  mark -- 改变金额和倍数
-(void)changeMoneyAndMultiple
{
    NSString *periodNum = _period_num?GET_INT((long)_period_num):@"无限";
    [_amoutLabel setText:[NSString stringWithFormat:@"机选投注%li注，%li倍，%@期",
                          (long)_random_amout,(long)_multiple,periodNum]];
    
    // 余额和金额
    NSInteger money = _random_amout*_multiple*_period_num*(_is_follow?3:2);
    NSString *moneyStr = money?[NSString stringWithFormat:@"总金额%li元",(long)money]:@"";
    [_moneyLabel clearText];
    [_moneyLabel addText:moneyStr color:nil font:nil];
    CGSize size = [[_moneyLabel drawColorString] sizeWithAttributes:@{NSFontAttributeName:_moneyLabel.font}];
    [_moneyLabel adjustsFontSizeToFitWidth];
    [_moneyLabel setWidth:size.width+25];
}

#pragma mark -- 投注确定按钮
-(void)betConfirmClick
{
    if ([[UserInfo sharedInstance]isLogined]==NO&&[[UserInfo sharedInstance]isLoginedWithVirefi]==NO)
    {
        [SVProgressHUD showInfoWithStatus:@"您还未登陆，请先登陆~"];
        [keychainItemManager deleteSessionId];
        //判断是否登陆，没有登陆就直接跳到登陆界面去,登陆了就查询中奖信息
        [self gotoLogingWithSuccess:^(BOOL success)
         {
            [self betButtonAction];
             
         }class:@"LoginVC"];
        return;
    }else
    {
       [self betButtonAction];
    }
    
}



#pragma mark -- 投注响应方式 -----------
-(void)betButtonAction
{
    [self showBettingDialog]; //基控制器的提示等待方法
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lottery_pk"] = GET_INT((long)_lottery_pk);  //彩种
    params[@"amount"] = GET_INT((long)_random_amout);  //定制期数
    params[@"multiple"] = GET_INT((long)_multiple);  //倍数
    params[@"define_num"] = (_period_num==0?@"-1":GET_INT((long)_period_num));  //追号期
    params[@"follow_prize"] = @"0"; //中奖继续追号
    params[@"sup"] = GET_INT(_is_follow?(long)1:(long)0); //是否追加
    params[@"charge_type"] = GET_INT((long)4); //支付方式
    [params setPublicDomain:kAPI_RandomBetAction];
    
    _connection = [RequestModel POST:URL(kAPI_RandomBetAction) parameter:params   class:[RequestModel class] success:^(id data)
                   {
                       
                       /*调用父控制器处理投注结果的方法*/
                       [self betResponse:data lot_pk:lottery_pk buttonTag:11111111];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [self hideBettingDialog];
                       [SVProgressHUD showInfoWithStatus:LocStr(msg)];
                   }];
    
}

#pragma textField -delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _zhushuFeild)
    {
        [_beishuFeild becomeFirstResponder];
    }
    if (textField == _beishuFeild)
    {
        [_qishuFeild becomeFirstResponder];
    }
    if (textField == _qishuFeild)
    {
        [_qishuFeild resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = textField.text.length+string.length-range.length;
    if (textField == _zhushuFeild) {
        return  (newLength >= 3)? NO : YES;
    }
    if (textField == _beishuFeild) {
        return  (newLength >= 3)? NO : YES;
    }
    if (textField == _qishuFeild) {
        return  (newLength >= 5)? NO : YES;
    }else {
        return NO;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _zhushuFeild) {
        _random_amout = [textField.text intValue];
        if (_random_amout>20)
        {
             [SVProgressHUD showInfoWithStatus:@"请选择20注以内!"];
            return NO;
        }
        if (_random_amout < 1)
        {
             [SVProgressHUD showInfoWithStatus:@"请选择至少选择一注!"];
            return NO;
        }
    }
    if (textField == _beishuFeild)
    {
        _multiple = [textField.text intValue];
        if (_multiple < 1)
        {
             [SVProgressHUD showInfoWithStatus:@"请选择至少选择一倍!"];
            return NO;
        }
    }
    if (textField == _qishuFeild)
    {
        _period_num = [textField.text intValue];
    }
    [self changeMoneyAndMultiple];
    return YES;
}

#pragma mark -- 可以在这里改变lab的值
- (void)feildTextChange:(NSNotification*)noti
{
    jiXuanShu = _zhushuFeild.text;
    beiShu = _beishuFeild.text;
    qiShu = _qishuFeild.text;
    randomNumberLab.text = [NSString stringWithFormat:@"机选 %@ 注",jiXuanShu.length?jiXuanShu:@"1"];
    beiShuLab.text =[NSString stringWithFormat:@" %@ 倍",beiShu.length?beiShu:@"1"];
    qiShuLab.text = [NSString stringWithFormat:@" %@ 期",qiShu.length?qiShu:@"1"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
