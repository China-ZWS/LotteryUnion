//
//  TopViewController.m
//  YaBoCaiPiao
//
//  Created by liuchan on 12-9-5.
//  Copyright (c) 2012年 DoMobile. All rights reserved.
//

#import "TopViewController.h"
#import "LoginVC.h"
#import "ProfileViewController.h"
#import "ShareTools.h"
#import "UtilMethod.h"
#import "UserInfo.h"
#import "TransferSelViewController.h"
#import "BettingFailedView.h"
#import "BettingSuccessedView.h"
#import "WinRecordViewController.h"

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //根据采种设置标题名称
    
    // 设置返回按钮
    [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
    [self.navigationItem setNewTitle:getLotNames(GET_STRING_OF_INT(lottery_pk))];
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 打开登录控制器
-(void)openLoginController
{
    //判断是否登陆，没有登陆就直接跳到登陆界面去,登陆了就查询中奖信息
    [self gotoLogingWithSuccess:^(BOOL success)
         {
             
         }class:@"LoginVC"];
}

// 显示提示视图
-(void)showBettingDialog
{
    [SVProgressHUD showWithStatus:@"正在为您投注,等待也是一种快乐..."];
  
}
// 隐藏提示视图
-(void)hideBettingDialog
{
    [SVProgressHUD dismiss];
}

#pragma mark -- 投注成功之后的回调 (投注结果，彩种，按钮的Tag)-------
-(BOOL)betResponse:(id)response lot_pk:(int)lot_pk buttonTag:(NSInteger)btnTag
{
    [self hideBettingDialog]; //隐藏请求界面
    
    if(!response)
    {
        [SVProgressHUD showInfoWithStatus:(LocStr(@"无网络连接"),@"Alert")];
        return NO;
    }
    
    int code = [[response objectForKey:@"code"] intValue];
    betNote = [response objectForKey:@"note"]; //getCodeMessageWithCode([response objectForKey:@"code"]);
    if (code == Status_Code_Request_Success)
    { // 成功
        if([response objectForKey:@"balance"])
        {
            [[UserInfo sharedInstance] setBalance:[response objectForKey:@"balance"]];
        }
        if([response objectForKey:@"cash"])
        {
           [[UserInfo sharedInstance] setCash:[response objectForKey:@"cash"]];
        }
        
        //显示投注成功的alertView
        
        NSString*shareMsg;
        if(btnTag == SendCaiPiaoTag)
        {
            shareMsg  = ((NSString*)[response objectForKey:@"share_recommend"]).length?[response objectForKey:@"share_recommend"]:@"独有的彩票联盟APP，特别的送彩票服务。刚刚给小伙伴送了一个500万的梦想,眼馋了吧,速速下载彩票联盟APP,梦想即将照进现实。";
        }
        if(btnTag == TouzhuTag)
        {
            shareMsg =((NSString*)[response objectForKey:@"share_recommend"]).length?[response objectForKey:@"share_recommend"]:[NSString stringWithFormat:@"轻轻一点，500万梦想到手。刚刚在彩票联盟APP客户端上买了第{20150715001}期体彩{大乐透}，500万快点到我的口袋里来吧"];
        }
        
        [self showSuccessWithStatus:betNote andShareMsg:shareMsg];
    
    }
    else if (Status_Code_Need_Profile == code) // 完善资料
    {
        // 跳转到个人信息
        [SVProgressHUD showInfoWithStatus:betNote];
        ProfileViewController *controller1 = [[ProfileViewController alloc] init];
        [self.navigationController pushViewController:controller1 animated:YES];
    }
    else if (Status_Code_Money_Not_Enough == code) // 余额不足
    {
        [SVProgressHUD showInfoWithStatus:betNote];
        // 跳转到充值
        TransferSelViewController *con = [[TransferSelViewController alloc]initWithTran:NO];
        [self.navigationController pushViewController:con animated:YES];
        [SVProgressHUD showInfoWithStatus:@"余额不足"];
        
    }
    else if(Status_Code_User_Not_Login == code) // 没登录
    {
       [SVProgressHUD showInfoWithStatus:betNote];
    }
    else
    {
        // 失败提示
        [self showFailedWithStatus:betNote];
    }

    return  NO;
}

/*投注成功*/
- (void)showSuccessWithStatus:(NSString *)msg andShareMsg:(NSString*)shareMsg
{
    
    [BettingSuccessedView showWithContent:msg returnEvent:^{
        [self continueBet];
        
    } shareEvent:^{
        [ShareTools shareAllButtonClickHandler:@"彩票联盟客户端" andUser:shareMsg.length?shareMsg:@"轻轻一点，500万梦想到手。小伙伴们，快来和我一起加入彩票联盟吧！" andUrl:kkShareURLAddress andDes:@"快来加入彩票联盟吧~"];
        [self continueBet];
        
    }];
    
}

/*投注失败*/
- (void)showFailedWithStatus:(NSString *)msg
{
    [BettingFailedView showWithContent:msg finishedEvent:^{
        
    }];
}

#pragma mark -- 继续投注  ---- ok
-(void)continueBet
{
    [self.navigationController popViewControllerAnimated:YES];
}


 #pragma mark ---- 显示中奖的alertView -----------
-(void)showWinPrizeDialog:(NSString*)note
                 shareContent:(NSString*)shareNote
                 Lotter_pk:(int)lot_pk
{
      WEAKSELF
      customAlert = [[CustomIOS7AlertView alloc] init];
      customAlert.layer.borderColor = [UIColor clearColor].CGColor;
      [customAlert setContainerView:[self createWinPrizeContentSubView:note Lotter_pk:lot_pk ]];
      [customAlert setButtonTitles:[NSMutableArray arrayWithObjects:@"查看",@"分享", nil]];
 
      [customAlert setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
      {
        switch (buttonIndex)  //查看
          {
            //不管点击了哪个，都要清空中奖信息
                  
             case 0:  //跳到中奖记录界面
                   {
                       WinRecordViewController *winRecord = [[WinRecordViewController alloc]init];
                       winRecord.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:winRecord animated:YES];
                       
                       [UserInfo sharedInstance].Bonus = @"";
                       [UserInfo sharedInstance].ShareBonus = @"";
                       
                          [alertView close];
                       
                   }
                   break;
             case 1:   //分享
                  {
                      [ShareTools shareAllButtonClickHandler:@"彩票联盟客户端" andUser:shareNote.length?shareNote:@"中奖咯！小伙伴们，快来和我一起加入体彩投注吧~" andUrl:kkShareURLAddress andDes:@"快来加入彩票联盟吧~"];
                      [UserInfo sharedInstance].Bonus = @"";
                      [UserInfo sharedInstance].ShareBonus = @"";
                      [alertView close];
                      [weakSelf continueBet];
                  }
                  break;
             default:
                  break;
           }
 
      }];
         customAlert.useMotionEffects = true;
         [customAlert show];
}
 
 #pragma mark -- 中奖提示视图
 - (UIView*)createWinPrizeContentSubView:(NSString *)note
                               Lotter_pk:(NSInteger)lot_pk
 {
       //背景
       UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth-90, mScreenHeight*0.456f)];
        view.image = [UIImage imageNamed:@"tishi_bg"];
        view.layer.cornerRadius = 8;// 设置圆角
 
 
       //提示
           UIImageView *topLabelImg = [[UIImageView alloc] initWithFrame: CGRectMake(-32.5, 10, view.width+65, 38)];
              topLabelImg.image = [UIImage imageNamed:@"tishi"];
              [view addSubview:topLabelImg];
 
 
         //恭喜您中奖了字样
        UIImageView *bottomImg = [[UIImageView alloc] initWithFrame:CGRectMake(view.width/2.0-100, topLabelImg.bottom+12, 200, 30)];
            bottomImg.image = [UIImage imageNamed:@"touzhu_zhongjiang_word"];
       [view addSubview:bottomImg];
 
 
      //字体
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, bottomImg.bottom +5, view.width-40, 25)];
      label.numberOfLines = 2;
      label.textAlignment = NSTextAlignmentCenter;
      label.font = [UIFont systemFontOfSize:16.5];
      label.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
     label.text = [NSString stringWithFormat:@"%@中了%@元",getLotNames(GET_INT((long)lot_pk)),[UserInfo sharedInstance].Bonus];
 
    //宝箱
     UIImageView *seZi = [[UIImageView alloc]initWithFrame:mRectMake(55,label.bottom+13 ,view.width-110,(view.width-110)*0.8
     )];
     seZi.image = mImageByName(@"touzhu_zhongjiang");
     [view addSubview:seZi];
     [view addSubview:label];
     return view;
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}


@end
