//
//  HelpContentViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/7/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

//注册帮助&提现帮助&流量费用&常见问题  html文件格式都有问题，竞彩足球没有html文件

#import "HelpContentViewController.h"
#import "UtilMethod.h"

@implementation HelpContentViewController
- (id)initWithContent:(NSString *)content {
    if ((self = [super init])) {
        _content = content;
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
    }
    return self;
}

- (id)initWithHTMLCode:(NSString *)code
{
    if ((self = [super init])) {
        _code = code;
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
    }
    return self;
}
//TODO:返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//TODO:  加载帮助数据
- (void)reloadContent
{
    NSString *fileName = [NSString stringWithFormat:@"help/%@.html",_code];
    NSString *htmlPath = getPathInDocument(fileName);
    if (![[NSFileManager defaultManager] fileExistsAtPath:htmlPath]) {
        
        htmlPath = [[NSBundle mainBundle] pathForResource:_code ofType:@"html"];
    }
    
    [_contentView loadRequest:[NSURLRequest requestWithURL:
                               [NSURL fileURLWithPath:htmlPath]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setNewTitle:_navTitle];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    _contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    [_contentView setDataDetectorTypes:UIDataDetectorTypeNone];
    [_contentView setBackgroundColor:[UIColor clearColor]];
    [_contentView setDelegate:self];
    [_contentView setScalesPageToFit:YES];
    [self.view addSubview:_contentView];
    // 加载帮助的内容
    [self reloadContent];
    
    NSUInteger helpversion = [NS_USERDEFAULT integerForKey:@"help_version"];
    NSUInteger newHelpversion = [NS_USERDEFAULT integerForKey:@"new_help_version"];
    if (newHelpversion > helpversion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"帮助更新") message:LocStr(@"有新的帮助内容,是否立即更新?") delegate:self cancelButtonTitle:LocStr(@"取消") otherButtonTitles:LocStr(@"确定"), nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self performSelector:@selector(updateHelpContent)];
    }
}

//TODO:更新帮助内容
- (void)updateHelpContent {
    
    [SVProgressHUD showWithStatus:LocStr(@"正在更新中,请稍候...")];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"help_version"] = [NS_USERDEFAULT objectForKey:@"help_version"];
    [params setPublicDomain:kAPI_Help];
    
    _connection = [RequestModel POST:URL(kAPI_Help) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [NS_USERDEFAULT setObject:[NS_USERDEFAULT objectForKey:@"new_help_version"] forKey:@"help_version"];
                       [NS_USERDEFAULT synchronize];
                       
                       NSArray *items = [data objectForKey:@"item"];
                       for (NSDictionary *cDict in items) {
                           NSString *helpID = [cDict objectForKey:@"help_id"];
                           NSString *htmlString = [cDict objectForKey:@"html"];
                           NSString *fileName = [NSString stringWithFormat:@"help/%@.html",helpID];
                           NSString *htmlPath = getPathInDocument(fileName);
                           
                           makeDirs([htmlPath stringByDeletingLastPathComponent]);
                           
                           [htmlString writeToFile:htmlPath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
                       }
                       
                       [self performSelector:@selector(updateInformation:) withObject:nil afterDelay:0.5];
                       [self performSelectorOnMainThread:@selector(reloadContent) withObject:nil waitUntilDone:NO];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                       [SVProgressHUD dismiss];
                   }];
    

    
}

- (void)updateInformation:(id)sender
{
    [SVProgressHUD showWithStatus:LocStr(@"成功更新")];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
    return (orient == UIInterfaceOrientationPortrait);
}

//TODO:网页加载完
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if(isValidateStr(_htmlTag)) {
        webView.scalesPageToFit = YES;
        NSString *js = [NSString stringWithFormat:
                        @"window.location.hash='%@';",_htmlTag];
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
}

@end
