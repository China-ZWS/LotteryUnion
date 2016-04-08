//
//  SelectTelTableViewController.h
//  YaBoCaiPiaoFJ
//
//  Created by jamalping on 14-3-31.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TelField.h"

@interface SelectTelTableViewController : UITableViewController

@property (nonatomic, strong) NSString *tel;         // 电话号码
@property (nonatomic, strong) NSArray *listContacts; // 装载联系人数据集合
@property (nonatomic, assign) id <passTextOfTextField> delegate; //代理

- (void)filterContentForSearchText:(NSString*)searchText; // 查询方法


@end
