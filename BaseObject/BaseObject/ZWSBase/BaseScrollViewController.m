//
//  BaseScrollViewController.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseScrollViewController.h"
#define kMinHeight CGRectGetHeight(self.view.frame) + .1
@interface BaseScrollViewController ()
{
    
}
@end

@implementation BaseScrollViewController

- (void)loadView
{
    [super loadView];
    
    
}

- (UIScrollView *)scrollView
{
    
    if (!_scrollView) {
        _scrollView = [[BaseScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), kMinHeight - 63);
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];


    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
