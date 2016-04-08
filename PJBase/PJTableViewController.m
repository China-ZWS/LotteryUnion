//
//  PJTableViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/27.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewController.h"
#import "PJNavigationBar.h"
@implementation PJTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = NavColor;
}

// 这是重载BaseViewController的方法
- (void)addNavigationWithPresentViewController:(UIViewController *)viewcontroller;
{
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
    nav.viewControllers = @[viewcontroller];
    [self presentViewController:nav];
}


@end
