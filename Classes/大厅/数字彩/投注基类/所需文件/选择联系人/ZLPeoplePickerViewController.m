//
//  ZLPeoplePickerViewController.m
//  ZLPeoplePickerViewControllerDemo
//
//  Created by Zhixuan Lai on 11/4/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "ZLPeoplePickerViewController.h"
#import "ZLResultsTableViewController.h" //结果控制器

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ZLAddressBook.h"
#import "APContact+Sorting.h"

@interface ZLPeoplePickerViewController () <
    ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate,
    ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate,
    UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UIRefreshControl *refreshControl; //刷新控制器

@property (nonatomic, strong) UISearchController *searchController; //搜索控制器

@property (strong, nonatomic)
    ZLResultsTableViewController *resultsTableViewController; //结果列表控制器

// 控制装态恢复的变量
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation ZLPeoplePickerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  设置默认值
 */
- (void)setup
{
    _numberOfSelectedPeople = ZLNumSelectionNone;
    self.filedMask = ZLContactFieldDefault;
    self.allowAddPeople = YES;
}

#pragma mark -- 初始化通讯录单例
+ (void)initializeAddressBook
{
    [[ZLAddressBook sharedInstance] loadContacts:nil];
}
#pragma mark -- 导航控制器的设置
-(void)navigationBarConfig
{
    /*导航栏标题设置*/
    self.navigationItem.title = self.title.length > 0 ? self.title : NSLocalizedString(@"联系人", nil);
    
    // 自定义返回按钮
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(0, 0, 40, 40);
    [backbutton setImage:[UIImage imageNamed:kkBackImage] forState:UIControlStateNormal];
    [backbutton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    
    self.navigationItem.leftBarButtonItem = backBarbuttonItem;
    [backbutton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];

    /*是否允许添加联系人*/
    if (self.allowAddPeople)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(showNewPersonViewController)];
    }
    

}
-(void)backButtonAction
{
    [self.navigationController removeFromParentViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 视图循环
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationBarConfig];
    
    self.tableView.sectionIndexColor = REDFONTCOLOR;
    
    _resultsTableViewController = [[ZLResultsTableViewController alloc] init];
    _searchController = [[UISearchController alloc]
        initWithSearchResultsController:self.resultsTableViewController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;

    // 我们想要delegate去过滤表，所以得要didSelectRowAtIndexPath 会回调两个tableView
    self.resultsTableViewController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; //默认为 YES
    
    self.searchController.searchBar.delegate =
        self; //添加搜索控制器的代理，我们就能监控它的文本框的以及其他内容的变化

    // Search is now just presenting a view controller. As such, normal view
    // controller
    // presentation semantics apply. Namely that presentation will walk up the
    // view controller
    // hierarchy until it finds the root view controller or one that defines a
    // presentation context.
    //
    self.definesPresentationContext = YES; //你的搜索控制器将展示在哪里？

    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlAction:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self refreshControlAction:self.refreshControl];
    
    // self.clearsSelectionOnViewWillAppear = NO;

   
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(addressBookDidChangeNotification:)
               name:ZLAddressBookDidChangeNotification
             object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    /*重新存储搜索控制器的激活状态*/
    if (self.searchControllerWasActive)
    {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;

        if (self.searchControllerSearchFieldWasFirstResponder)
        {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController])
    {
        [self invokeReturnDelegate];
    }
}

/*注销*/
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:ZLAddressBookDidChangeNotification
                object:nil];
}

#pragma mark - Action
+ (instancetype)presentPeoplePickerViewControllerForParentViewController:
                    (UIViewController *)parentViewController
{
    UINavigationController *navController =
        [[UINavigationController alloc] init];
    ZLPeoplePickerViewController *peoplePicker =
        [[ZLPeoplePickerViewController alloc] init];
    [navController pushViewController:peoplePicker animated:NO];
    peoplePicker.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                             target:peoplePicker
                             action:@selector(doneButtonAction:)];
    peoplePicker.delegate = parentViewController;
    [parentViewController presentViewController:navController
                                       animated:YES
                                     completion:nil];
    return peoplePicker;
}

- (void)doneButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self invokeReturnDelegate];
}

/*刷新，搜索表的UI更新*/
- (void)refreshControlAction:(UIRefreshControl *)aRefreshControl
{
    [aRefreshControl beginRefreshing];
    [self reloadData:^(BOOL succeeded, NSError *error)
    {
        [aRefreshControl endRefreshing];
    }];
}

- (void)addressBookDidChangeNotification:(NSNotification *)note
{
    [self performSelector:@selector(reloadData) withObject:nil];
}

- (void)reloadData
{
    [self reloadData:nil];
}

- (void)reloadData:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    __weak __typeof(self) weakSelf = self;
    if ([ZLAddressBook sharedInstance].contacts.count > 0)
    {
        [weakSelf
            setPartitionedContactsWithContacts:[ZLAddressBook sharedInstance]
                                                   .contacts];
        [weakSelf.tableView reloadData];
    }
    [[ZLAddressBook sharedInstance]
        loadContacts:^(BOOL succeeded, NSError *error)
    {
            if (!error)
            {
                [weakSelf setPartitionedContactsWithContacts:
                              [ZLAddressBook sharedInstance].contacts];
                [weakSelf.tableView reloadData];
                if (completionBlock)
                {
                    completionBlock(YES, nil);
                }
            } else
            {
                if (completionBlock)
                {
                    completionBlock(NO, nil);
                }
            }
        }];
}

#pragma mark - UISearchBarDelegate 搜索条的代理方法

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [aSearchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar
{
    [aSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar
{
    [aSearchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    APContact *contact = [self contactForRowAtIndexPath:indexPath];

    if (![tableView isEqual:self.tableView])
    {
        contact = [(ZLResultsTableViewController *)
                       self.searchController.searchResultsController
            contactForRowAtIndexPath:indexPath];
    }

    if (![self shouldEnableCellforContact:contact])
    {
        return;
    }

    if (_delegate&&[_delegate respondsToSelector:@selector(setTextField:)])
    {
        if(contact.phones.count)
        {
             [_delegate setTextField:contact.phones[0]];
             [self.navigationController removeFromParentViewController];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
   

    if ([self.selectedPeople containsObject:contact.recordID])
    {
        [self.selectedPeople removeObject:contact.recordID];
        
    } else
    {
        if (self.selectedPeople.count < self.numberOfSelectedPeople)
        {
            [self.selectedPeople addObject:contact.recordID];
        }
    }
    [tableView reloadData];
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:
            (UISearchController *)searchController
{
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [[self.partitionedContacts
        valueForKeyPath:@"@unionOfArrays.self"] mutableCopy];

    // strip out all the leading and trailing spaces
    NSString *strippedStr =
        [searchText stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];

    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedStr.length > 0)
    {
        searchItems = [strippedStr componentsSeparatedByString:@" "];
    }
    // build all the "AND" expressions for each value in the searchString
    NSMutableArray *andMatchPredicates = [NSMutableArray array];

    for (NSString *searchString in searchItems) {
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];

        // TODO: match phone number matching

        // name field matching
        NSPredicate *finalPredicate = [NSPredicate
            predicateWithFormat:@"compositeName CONTAINS[c] %@", searchString];
        [searchItemsPredicate addObject:finalPredicate];

        NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"ANY SELF.emails CONTAINS[c] %@",
                                             searchString];
        [searchItemsPredicate addObject:predicate];

        predicate = [NSPredicate
            predicateWithFormat:@"ANY SELF.addresses.street CONTAINS[c] %@",
                                searchString];
        [searchItemsPredicate addObject:predicate];
        predicate = [NSPredicate
            predicateWithFormat:@"ANY SELF.addresses.city CONTAINS[c] %@",
                                searchString];
        [searchItemsPredicate addObject:predicate];
        predicate = [NSPredicate
            predicateWithFormat:@"ANY SELF.addresses.zip CONTAINS[c] %@",
                                searchString];
        [searchItemsPredicate addObject:predicate];
        predicate = [NSPredicate
            predicateWithFormat:@"ANY SELF.addresses.country CONTAINS[c] %@",
                                searchString];
        [searchItemsPredicate addObject:predicate];
        predicate = [NSPredicate
            predicateWithFormat:
                @"ANY SELF.addresses.countryCode CONTAINS[c] %@", searchString];
        [searchItemsPredicate addObject:predicate];

        //        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc]
        //        init];
        //        [numFormatter setNumberStyle:NSNumberFormatterNoStyle];
        //        NSNumber *targetNumber = [numFormatter
        //        numberFromString:searchString];
        //        if (targetNumber != nil) {   // searchString may not convert
        //        to a number
        //            predicate = [NSPredicate predicateWithFormat:@"ANY
        //            SELF.sanitizePhones CONTAINS[c] %@", searchString];
        //            [searchItemsPredicate addObject:predicate];
        //        }

        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates =
            (NSCompoundPredicate *)[NSCompoundPredicate
                orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }

    NSCompoundPredicate *finalCompoundPredicate = nil;

    // match up the fields of the Product object
    finalCompoundPredicate = (NSCompoundPredicate *)
        [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];

    searchResults = [[searchResults
        filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];

    // hand over the filtered results to our search results table
    ZLResultsTableViewController *tableController =
        (ZLResultsTableViewController *)
            self.searchController.searchResultsController;
    tableController.filedMask = self.filedMask;
    tableController.selectedPeople = self.selectedPeople;
    [tableController setPartitionedContactsWithContacts:searchResults];
    [tableController.tableView reloadData];
}

#pragma mark - ABAdressBookUI

#pragma mark -- 创建一个新的联系人
- (void)showNewPersonViewController
{
    ABNewPersonViewController *picker =
        [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;

    UINavigationController *navigation =
        [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:navigation animated:YES completion:nil];
}
#pragma mark -- ABNewPersonViewControllerDelegate  代理方法
- (void)newPersonViewController:
            (ABNewPersonViewController *)newPersonViewController
       didCompleteWithNewPerson:(ABRecordRef)person

{
    /*出栈*/
    [self dismissViewControllerAnimated:YES completion:NULL];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(newPersonViewControllerDidCompleteWithNewPerson:)])
    {
            [self.delegate newPersonViewControllerDidCompleteWithNewPerson:person];
    }
}

#pragma mark - ()
- (void)invokeReturnDelegate
{
    if (self.delegate &&[self.delegate
            respondsToSelector:@selector(peoplePickerViewController:
                                        didReturnWithSelectedPeople:)])
    {
        [self.delegate peoplePickerViewController:self
                      didReturnWithSelectedPeople:[self.selectedPeople copy]];
    }
}

@end
