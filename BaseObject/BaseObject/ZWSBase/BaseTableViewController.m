//
//  BaseTableViewController.m
//  BabyStory
//
//  Created by 周文松 on 14-11-6.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Device.h"
#import "BaseTableViewController.h"
#import "Header.h"

@interface BaseTableViewController ()
{
    UITableViewStyle _style;
}

@end

@implementation BaseTableViewController

- (id)initWithTableViewStyle:(UITableViewStyle)style parameters:(id)parameters;
{
    if ((self = [super init])) {
        _style = style;
        _parameters = parameters;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.table = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, CGRectGetHeight(self.view.frame)) style:_style];
    [self.view addSubview:_table];
    _table.touchDelegate = self;
    _table.delegate = self;
    _table.dataSource  = self;
    self.table.tableFooterView = [UIView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}




- (void)setTableWithFrame:(CGRect)rect
{
    self.table.frame = rect;
}

- (void)reloadTabData
{
   
    [self.table reloadData];
}

#pragma mark -
#pragma mark  touchDelegate 
#pragma mark -

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
//{
//
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
//{
//
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
//{
//
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
//{
//
//}


#pragma mark -
#pragma mark  delegate
#pragma mark -


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

#pragma mark -
#pragma mark dataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
   static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}




- (void)didReceiveMemoryWarning
{
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
