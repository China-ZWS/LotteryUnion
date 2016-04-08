//
//  RegisterViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/6/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "PJViewController.h"

//#import "XieYiViewController.h"
//#import "SessionControl.h"


@interface RegisterViewController : PJViewController <UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *textName;   // 手机号码输入框
    UITextField *textVC;     // 验证码输入框
    UITextField *textPass;   // 密码输入框
    UITextField *textConfirm; // 密码确认输入框
    UIButton *optionalButton; // 同意协议按钮
    UIButton *vcButton;       // 获取验证码按钮
    UILabel  *_timeLabel;    // 倒计时
    
    NSString *mobile;         // 手机号码
    
    UITableViewController *loginView;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic)BOOL pushFromAcc;

-(void)setupTextField;

@end
