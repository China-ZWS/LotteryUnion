//
//  BaseViewController.m
//  MoodMovie
//
//  Created by 周文松 on 14-7-22.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationBar.h"
#import "BaseMsgPlaySound.h"
#import "Header.h"
#import "SVProgressHUD.h"

@interface BaseViewController()
{
    UIAlertView *_alert;
}
@end

@implementation BaseViewController

- (void)dealloc
{
    NSLog(@"dealloc=%@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithParameters:(id)parameters;
{
    if ((self = [super init])) {
        _parameters = parameters;
        
    }
    return self;
    
}


- (id)initWithLoginSuccess:(SuccessLoginBlock)success;
{
    if ((self = [super init])) {
        _successLogin = success;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}


- (void)setConnection:(NSURLConnection *)connection
{
    _connection = connection;
}

- (void)loadView
{
    [super loadView];
    NSNotificationAdd(self, refreshWithViews, RefreshWithViews, nil);
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)refreshWithViews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpViews];
    [self setUpDatas];
    
    // Do any additional setup after loading the view.
//    UIButton *a = [UIButton buttonWithType:UIButtonTypeCustom];
//    [a setBackgroundImage:[UIImage imageNamed:@"jianpan_action.png"] forState:UIControlStateNormal];
//    a.frame = CGRectMake(90, 10, 90, 90);
//    [self.view addSubview:a];
}


- (void)setUpViews
{
    
}

- (void)setUpDatas;
{

}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden;
{
    
    [self.navigationController setNavigationBarHidden:navigationBarHidden animated:YES];
}

-(void)pushViewController:(UIViewController *)viewcontroller;
{
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)pushAnimated:(UIViewController *)viewcontroller ;
{
    [self.navigationController pushViewController:viewcontroller animated:NO];
    UIApplication *app=[UIApplication sharedApplication];
    CATransition *trans=[CATransition animation];
    trans.type=@"rippleEffect";
    trans.subtype=kCATransitionFromRight;
    [app.delegate.window.layer addAnimation:trans forKey:nil];

}


- (void)popViewController;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popAnimated;
{
    [self.navigationController popViewControllerAnimated:NO];
    UIApplication *app=[UIApplication sharedApplication];
    CATransition *trans=[CATransition animation];
    trans.type=@"rippleEffect";
    trans.subtype=kCATransitionFromRight;
    [app.delegate.window.layer addAnimation:trans forKey:nil];

}

- (void)presentViewController:(UIViewController *)viewcontroller
{
    viewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewcontroller animated:YES completion:^()
     {
         
     }];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (void)addNavigationWithPushController:(UIViewController *)viewcontroller;
{
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[BaseNavigationBar class] toolbarClass:nil];
    nav.viewControllers = @[viewcontroller];
    
    [self pushViewController:nav];
    
}



- (void)addNavigationWithPresentViewController:(UIViewController *)viewcontroller;
{
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[BaseNavigationBar class] toolbarClass:nil];
    nav.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    nav.viewControllers = @[viewcontroller];
    nav.navigationBarHidden = YES;
    [self presentViewController:nav];
    
}

- (void)back
{
    [self dismissViewController];
}


- (void)alertTitle:(NSString *)alertTitle message:(NSString *)message;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)progressView:(NSString *)title
{
    if (_alert ) {
        [_alert dismissWithClickedButtonIndex:0 animated:NO];
        _alert = nil;
    }
    _alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alert show];
}


- (void)progressHide:(BOOL)isHide
{
    if (_alert && isHide)
    {
        [_alert dismissWithClickedButtonIndex:0 animated:NO];
    }
    
}

- (void)makeToast:(NSString *)message;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    [self performSelector:@selector(disappearAler:) withObject:alert afterDelay:1];
}

- (void)disappearAler:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoLogingWithSuccess:(void(^)(BOOL isSuccess))success  class:(NSString *)className;
{
    Class class = NSClassFromString(className);
    
    if(![self.navigationController.topViewController isKindOfClass:[class class]])
    {
        
        void  (^GotoLogingWithSuccess)(BOOL isSuccess)  = success ;
        
        id login = [[class alloc] initWithLoginSuccess:^(UIViewController *controller, BOOL isSuccess)
                    {
                        GotoLogingWithSuccess(isSuccess);

                        [controller dismissViewControllerAnimated:YES completion:^()
                         {
//                             GotoLogingWithSuccess(isSuccess);
                         }];
                    }];
        
        [self addNavigationWithPresentViewController:login];
       // [self presentViewController:login];

    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - 取消一切编辑事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


- (void)gotoLoging;
{
    [self gotoLogingWithSuccess:^(BOOL isSuccess)
     {
         if (isSuccess) {
             NSNotificationPost(RefreshWithViews, nil, nil);
         }
     }class:@"LoginVC"];
    
}


@end