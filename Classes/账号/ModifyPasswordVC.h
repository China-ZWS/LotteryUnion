//
//  RegisterViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/6/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "PJViewController.h"

@interface ModifyPasswordVC : PJViewController <UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *textName;   // 原始密码
    UITextField *textPass;   // 密码输入框
    UITextField *textConfirm; // 密码确认输入框
    NSString *mobile;         // 手机号码
}
@property(nonatomic,strong)UITableView *tableView; //主表


@end
