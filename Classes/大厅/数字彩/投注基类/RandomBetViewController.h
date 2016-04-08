//
//  RandomBetViewController.h
//  YaBoCaiPiao
//
//  Created by liuchan on 12-8-30.
//  Copyright (c) 2012年 DoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"
#import "AttributeColorLabel.h"
#import "UserInfo.h"

@interface RandomBetViewController : TopViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    UITableView *_tableView;
    UILabel *_amoutLabel;
    UIButton *confirmButton;
    AttributeColorLabel *_moneyLabel;
    UIActionSheet *actionSheet;
    UIPickerView *pickerView;
    
    NSArray *_titleArray;
    NSInteger _lottery_pk;
    NSInteger _random_amout;
    NSInteger _period_num;
    NSInteger _multiple;
    BOOL _is_follow;
    NSString *_chargeType;  // 支付方式的选择
    UITextField *_qishuFeild;
    UITextField *_zhushuFeild;
    UITextField *_beishuFeild;
}

-(id)initWithLotteryPK:(int)lot_pk;

@end
