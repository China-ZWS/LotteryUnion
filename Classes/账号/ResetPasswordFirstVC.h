//
//  ViewController.h
//  test2
//
//  Created by rt007 on 15/10/19.
//  Copyright (c) 2015年 rt007f. All rights reserved.
//


#import "PJViewController.h"

@interface ResetPasswordFirstVC : PJViewController{
    
    BOOL _isEncrpty;   //是否加密
    int _loginErrorTimes;  
    NSTimeInterval _lastLoginErrorTime;
}


@end


