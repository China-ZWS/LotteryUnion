//
//  RegisterViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/6/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "PJViewController.h"

@interface ResetPasswordSecondVC : PJViewController <UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *textName;   // 手机号码输入框
    UITextField *textPass;   // 密码输入框
    UITextField *textConfirm; // 密码确认输入框
}
@property(nonatomic,strong)NSString *mobile;         // 手机号码
@property(nonatomic,strong)NSString*Vcode;           //验证码
@property(nonatomic,strong)UITableView *tableView;


@end
