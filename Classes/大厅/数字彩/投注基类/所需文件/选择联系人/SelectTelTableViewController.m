//
//  SelectTelTableViewController.m
//  YaBoCaiPiaoFJ
//
//  Created by jamalping on 14-3-31.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import "SelectTelTableViewController.h"

@interface SelectTelTableViewController ()

@end

@implementation SelectTelTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // 自定义返回按钮
        UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        backbutton.frame = CGRectMake(0, 0, 30, 30);
        [backbutton setImage:[UIImage imageNamed:kkBackImage] forState:UIControlStateNormal];
        UIBarButtonItem *backBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
        
        self.navigationItem.leftBarButtonItem = backBarbuttonItem;
        [backbutton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        //自定义标题
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
        titleLab.textColor = NAVITITLECOLOR;
        titleLab.font = [UIFont systemFontOfSize:18.5];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"联系人";
        self.navigationItem.titleView  = titleLab;

        
    }
    return self;
}

// 自定义navigationBar标题方法
-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = titleLabel;
    }
    titleLabel.text = title;
    [titleLabel sizeToFit];
}

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFErrorRef error = NULL;
    // 创建addressBook对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    // 这个函数用于向用户请求访问通讯录数据库，如果是第一次访问，则会弹出一个用户授权对话框
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            //查询所有
            [self filterContentForSearchText:@""];
        }
    });
}



- (void)filterContentForSearchText:(NSString*)searchText
{
    //如果没有授权则退出
    //    函数返回应用的授权状态
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return ;
    }
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if([searchText length]==0)
    {
        //查询所有
        self.listContacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
        
    } else {
        //条件查询
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        self.listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
    }
    NSLog(@".......%@",self.listContacts);
    if (self.listContacts) {
        [self.tableView reloadData];
    }

}

//ABRecordRef参数是记录对象，ABPropertyID是属性ID，就是上面的常量kABPersonFirstNameProperty等。返回值类型是CFTypeRef，它是Core Foundation类型的“泛型”，可以代表任何的Core Foundation类型。
CFTypeRef ABRecordCopyValue (ABRecordRef record,ABPropertyID property);

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%ld",[self.listContacts count]);
    return [self.listContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //从NSArray*集合中取出一个元素，并且转化为Core Foundation类型的ABRecordRef类型。
    ABRecordRef thisPerson = CFBridgingRetain(self.listContacts[indexPath.row]);
    // 语句是将名字属性取出来，转化为NSString*类型
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
    firstName = firstName != nil?firstName:@"";
    NSString *lastName =  CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
    lastName = lastName != nil?lastName:@"";
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    
    //获取的联系人单一属性:Nickname
    NSString *tmpNickname =  CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonNicknameProperty));
    NSLog(@"Nickname:%@", tmpNickname);
    
    //获取的联系人单一属性:生日
    NSString *birth =  CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonBirthdayProperty));
    NSLog(@"birth:%@", birth);
    
    // 最后CFRelease(thisPerson)是释放ABRecordRef对象
    //    CFRelease(thisPerson);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从NSArray*集合中取出一个元素，并且转化为Core Foundation类型的ABRecordRef类型。
    ABRecordRef thisPerson = CFBridgingRetain([self.listContacts objectAtIndex:[indexPath row]]);
    ABMultiValueRef phone = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
    //获取电话Label
    for (int k = 0; k<ABMultiValueGetCount(phone); k++)
    {
        //获取电话Label
        NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
        //获取該Label下的电话值
        _tel = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
        NSLog(@"%@......%@",personPhoneLabel,_tel);
    }
    if ([_delegate respondsToSelector:@selector(setTextField:)]) {
        [_delegate setTextField:_tel];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
