//
//  CityTableView.h
//  LotteryUnion
//
//  Created by happyzt on 15/11/19.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CityTableView : UITableView<UITableViewDataSource,UITableViewDelegate> {
    NSDictionary *cityDic;
    UIImageView *imgView;
    UIImageView *imgView1;
    UIButton *selectedButton;
}

@property(nonatomic,strong)NSMutableArray *bankIDArray;
@property(nonatomic,strong)NSMutableArray *bankNameArray;

@property(nonatomic,strong)NSString*fromBankName; //传进来的银行名字
@property(nonatomic,strong)NSString*bankID; //传进来的选中的
@property(nonatomic,strong)NSIndexPath *lastPath;

@end
