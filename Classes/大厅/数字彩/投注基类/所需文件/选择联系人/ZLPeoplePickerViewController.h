//
//  ZLPeoplePickerViewController.h
//  ZLPeoplePickerViewControllerDemo
//
//  Created by Zhixuan Lai on 11/4/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "ZLBaseTableViewController.h"
#import "TelField.h"

@class ZLPeoplePickerViewController;

@protocol ZLPeoplePickerViewControllerDelegate <NSObject>
@optional
/**
 * 告诉委托者选中了一个联系人
 *
 *  @param peoplePicker 联系人选着器提供的信息
 *  @param recordId     通讯录中选中联系人的电话号码
 */
- (void)peoplePickerViewController:( ZLPeoplePickerViewController*)peoplePicker
                   didSelectPhone:(NSString *)recordPhone;


/**
 * 告诉委托者选中了一个联系人
 *
 *  @param peoplePicker 联系人选着器提供的信息
 *  @param recordId     通讯录中选中联系人的id
 */
- (void)peoplePickerViewController:( ZLPeoplePickerViewController*)peoplePicker
                   didSelectPerson:( NSNumber *)recordId;

/**
 * 告诉委托者选中了一组联系人
 *
 *  @param peoplePicker 联系人选着器提供的信息
 *  @param recordId     通讯录中选中联系人的id数组
 */
- (void)peoplePickerViewController:(nullable ZLPeoplePickerViewController *)peoplePicker
       didReturnWithSelectedPeople:(nullable NSArray *)people;

/**
 *  通知代理方完成了一个新的联系人的添加
 *
 *  @param person     一个可用的联系人保存到了通讯录，否则是空
 */

-(void)newPersonViewControllerDidCompleteWithNewPerson:(nullable ABRecordRef)person;

@end

@interface ZLPeoplePickerViewController : ZLBaseTableViewController

@property (weak, nonatomic) id<ZLPeoplePickerViewControllerDelegate,passTextOfTextField> delegate;

@property (nonatomic) ZLNumSelection numberOfSelectedPeople; //能选择的联系人数

@property (nonatomic, assign) BOOL allowAddPeople; //是否允许添加联系人,默认为YES

+ (void)initializeAddressBook; //初始话通讯录

- (nonnull id)initWithStyle:(UITableViewStyle)style __attribute__((unavailable(
                        "-initWithStyle is not allowed, use -init instead")));

+ (nonnull instancetype)presentPeoplePickerViewControllerForParentViewController:
        (nullable UIViewController *)parentViewController;
@end
