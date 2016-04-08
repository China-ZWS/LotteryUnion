//
//  BaseTableViewController.h
//  BabyStory
//
//  Created by 周文松 on 14-11-6.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"

@interface BaseTableViewController : BaseViewController
<UITableViewDelegate, UITableViewDataSource, BaseTableViewDelegate>
{
    BaseTableView *_table;
}


- (id)initWithTableViewStyle:(UITableViewStyle)style parameters:(id)parameters;

/**
 *@brief 函数描述 刷新tableView;
 */
- (void)reloadTabData;
@property (nonatomic) BaseTableView *table;

@property (nonatomic, assign) CGRect tableWithFrame;
@end

