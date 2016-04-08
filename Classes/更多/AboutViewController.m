//
//  AboutViewController.m
//  ydtctz
//
//  Created by 小宝 on 1/7/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "AboutViewController.h"

#define CommonFont  [UIFont systemFontOfSize:14]

@implementation AboutViewController
- (id) init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"关于我们"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:kkBackImage];
    }
    return self;
}
//TODO:返回动作
- (void)back
{
    [SVProgressHUD dismiss];
    [self popViewController];
}

#pragma mark - View lifecycle‘
- (void)viewDidLoad
{
    [super viewDidLoad];
    _aboutData = @[@"版本",@"官网",@"版权",@"客服电话"];
    
    // 新需求的界面
    [self _initNewSubViews];
    
    //
//    [self _initSubViews];
}

-(void)_initNewSubViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, mScreenWidth-10, 400) style:UITableViewStyleGrouped];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    //TODO:标题图像
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 120)];
//    UIImage *iconImage = [UIImage imageNamed:@"gd_logo.png"];
//    UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImage];
//    iconView.frame = CGRectMake(0, 0, mScreenWidth*0.42, 44);
//    iconView.center = headerView.center;
//    [headerView addSubview:iconView];
//    [_tableView setTableHeaderView:headerView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, mScreenWidth-10, 60)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth-10, 40)];
    label.text = @"技术支持：深圳市中加力实业发展有限公司";
    label.textAlignment = NSTextAlignmentCenter;
//    label.center = footView.center;
    label.textColor = toPCcolor(@"#a09c9c");
    label.font = CommonFont;
    
    [footView addSubview:label];
    [_tableView setTableFooterView:footView];
    
    // 初始化cell上的4个label
    _officialwebLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      NSString *appName = [NSString stringWithFormat:@"%@ %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    _officialwebLabel.text = appName;
    _officialwebLabel.textColor = toPCcolor(@"#555555");
    _officialwebLabel.font = CommonFont;
    _officialwebLabel.textAlignment = NSTextAlignmentRight;
    [_officialwebLabel sizeToFit];
    
    _versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _versionLabel.text = @"http://www.ccpower.com.cn";
    _versionLabel.textColor = toPCcolor(@"#555555");
    _versionLabel.font = CommonFont;
    _versionLabel.textAlignment = NSTextAlignmentRight;
    [_versionLabel sizeToFit];
    _versionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openHomeAddress)];
    [_versionLabel addGestureRecognizer:tap];
    
    _copyrightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _copyrightLabel.text = @"深圳市中加力实业发展有限公司";
    _copyrightLabel.textColor = toPCcolor(@"#555555");
    [_copyrightLabel adjustsFontSizeToFitWidth];
    _copyrightLabel.font = CommonFont;
    _copyrightLabel.textAlignment = NSTextAlignmentRight;
    [_copyrightLabel sizeToFit];
    
    _customerServiceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _customerServiceLabel.text = kefuNumber;
    _customerServiceLabel.textColor = REDFONTCOLOR;
    _customerServiceLabel.font = CommonFont;
    _customerServiceLabel.textAlignment = NSTextAlignmentRight;
    [_customerServiceLabel sizeToFit];
}

#if 0
// 初始化子视图
-(void)_initSubViews
{
    //TODO:log
    UIImage *iconImage = [UIImage imageNamed:@"Icon"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImage];
    iconView.backgroundColor = [UIColor lightTextColor];
    [iconView.layer setCornerRadius:10];
    [iconView.layer setMasksToBounds:YES];
    [iconView setSize:iconImage.size];
    iconView.center = CGPointMake(160, iconView.center.y);
    //IOS7?74:10
    [iconView setTop:10];
    [self.view addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFrame:CGRectMake(0, iconView.bottom, self.view.width, 20)];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor blackColor]];
    

    NSString *appName = [NSString stringWithFormat:@"%@ %@",[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Bundle version"]];
  
    [nameLabel setText:appName];
    [self.view addSubview:nameLabel];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,mScreenWidth,0)];
    [_webView setHeight:self.view.height-nameLabel.bottom-44];
    [_webView setTop:nameLabel.bottom];
    [_webView setDataDetectorTypes:UIDataDetectorTypeAll];
    //
    [_webView setBackgroundColor:[UIColor lightGrayColor]];
    [_webView setDelegate:self];
    [_webView.scrollView setBounces:NO];
    [_webView setOpaque:NO];
    [self.view addSubview:_webView];
    
    [_webView loadHTMLString:LocStr(@"ABOUT_INFO") baseURL:nil];
}
#endif

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  UITableView delegate && datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentif = @"cellIdentif";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentif];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentif];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _aboutData[indexPath.row];
    cell.textLabel.font = CommonFont;
    cell.textLabel.textColor = NAVITITLECOLOR;
    
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:_officialwebLabel];
            _officialwebLabel.right = tableView.right-25;
            _officialwebLabel.top = 15;
            break;
        case 1:
            [cell.contentView addSubview:_versionLabel];
            _versionLabel.right = tableView.right-25;
            _versionLabel.top = 15;
            break;
        case 2:
            [cell.contentView addSubview:_copyrightLabel];
            _copyrightLabel.right = tableView.right-25;
            _copyrightLabel.top = 15;
            break;
        case 3:
            [cell.contentView addSubview:_customerServiceLabel];
            _customerServiceLabel.right = tableView.right-35;
            _customerServiceLabel.top = 15;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"拨打 %@ 客服电话",kefuNumber] delegate:self cancelButtonTitle:LocStr(@"否") otherButtonTitles:LocStr(@"是"), nil];
        [alert show];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",kefuNumber]]];
    }
}


//- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
//    if (inType == UIWebViewNavigationTypeLinkClicked) {
//        [[UIApplication sharedApplication] openURL:[inRequest URL]];
//        return NO;
//    }
//    
//    return YES;
//}

//TODO:打开网页
- (void)openHomeAddress
{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ccpower.com.cn"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
