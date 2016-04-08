//
//  ProfileViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/6/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "PJViewController.h"
//#import "Util.h"
//#import "JSON.h"
//#import "TKAlertCenter.h"

#define IDcard @"IDcard"
#define Email @"Email"

@interface ProfileViewController : PJViewController <UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    UITextField *textID;
    UITextField *textName;
    UITextField *textEmail;
    UITextField *textQQ;     // qq
    int from_flag;           // 判断是否两次push进来的
    UITapGestureRecognizer *singleTap;
}

@property (nonatomic)UITableView *tableView;

- (void)setupTextField;
-(void)setFromFlag:(int)flag;

@end
