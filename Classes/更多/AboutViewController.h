//
//  AboutViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/7/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "PJViewController.h"


@interface AboutViewController : PJViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIWebView *_webView; // 新需求里已经不用了
    
    UITableView *_tableView;
    NSArray *_aboutData;
    
    UILabel *_officialwebLabel;
    UILabel *_versionLabel;
    UILabel *_copyrightLabel;
    UILabel *_customerServiceLabel;
}
@end
