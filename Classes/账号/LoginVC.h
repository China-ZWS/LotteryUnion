//
//  ViewController.h
//  test2
//
//  Created by rt007 on 15/10/19.
//  Copyright (c) 2015年 rt007f. All rights reserved.
//


#import "TopViewController.h"

@interface LoginVC : TopViewController
{
    BOOL _isEncrpty;   //是否加密
    int _loginErrorTimes;
    NSTimeInterval _lastLoginErrorTime;
}

//调用本对象的上一个控制器
@property (nonatomic,strong) UIViewController *callingController;

//用来记录是否从个人中心进来的(0表示正常出现，1：从个人中心push过来，2从其他页面present)
@property (nonatomic,assign)NSInteger pushFromAccount;

@end


