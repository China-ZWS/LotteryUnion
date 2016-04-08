//
//  HHGGOpitonListView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "HHGGOpitonListView.h"
#import "HHGGOneCell.h"
#import "HHGGTwoCell.h"
#import "HHGGThirdCell.h"
#import "HHGGFourCell.h"

@interface HHGGOpitonListView ()
<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_puckerArray;
}
@end

@implementation HHGGOpitonListView

- (id)initWithFrame:(CGRect)frame datas:(id)datas
{
    if ((self = [super initWithFrame:frame style:UITableViewStyleGrouped])) {
        _datas = datas;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[HHGGOneCell class] forCellReuseIdentifier:@"OneCell"];
        [self registerClass:[HHGGTwoCell class] forCellReuseIdentifier:@"TwoCell"];
        [self registerClass:[HHGGThirdCell class] forCellReuseIdentifier:@"ThirdCell"];
        [self registerClass:[HHGGFourCell class] forCellReuseIdentifier:@"FourCell"];

    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(25);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *header = [UIButton buttonWithType:UIButtonTypeCustom];
    header.backgroundColor = RGBA(129, 152, 204, .8);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultInset.left, 0, CGRectGetWidth(tableView.frame) - ScaleW(50), ScaleH(25))];
    title.textColor = [UIColor whiteColor];
    title.font = Font(13);
    NSString *text = nil;
    if (section == 0) {
        text = @"胜平负/让球胜平负";
    }
    else if (section == 1)
    {
        text = @"比分";
    }
    else if (section == 2)
    {
        text = @"半全场";
    }
    else if (section == 3)
    {
        text = @"进球数";
    }

    title.text = text;
    [header addSubview:title];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    NSNumber *number = [_puckerArray objectAtIndex:section];
//    if (![number boolValue]) {
//        return 0;
//    }
    
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScaleH(80);
    }
    else if (indexPath.section == 1)
    {
        return ScaleH(265);
    }
    else if (indexPath.section == 2)
    {
        return ScaleH(115);
    }
    else if (indexPath.section == 3)
    {
        return ScaleH(80);
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HHGGOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneCell" forIndexPath:indexPath];
        cell.datas = _datas;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        HHGGTwoCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"TwoCell" forIndexPath:indexPath];
        cell.datas = _datas;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        HHGGThirdCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ThirdCell" forIndexPath:indexPath];
        cell.datas = _datas;
        return cell;
    }
    else if (indexPath.section == 3)
    {
        HHGGFourCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"FourCell" forIndexPath:indexPath];
        cell.datas = _datas;
        return cell;
    }
    return nil;
}




//- (void)puckerTouches:(UIButton *)button
//{
//    NSNumber *number = [_puckerArray objectAtIndex:button.tag];
//    
//    [_puckerArray replaceObjectAtIndex:button.tag withObject:[NSNumber  numberWithBool:![number boolValue]]];
//    
//    [self reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationFade];
//}
//
//#pragma mark - 折点数组初始化
//-(void)makePuckerArray
//{
//    if (!_puckerArray)
//    {
//        _puckerArray = [NSMutableArray array];
//    }
//    else if (_puckerArray.count)
//    {
//        return;
//    }
//    for (int i = 0;i < 4;i++) {
//        NSNumber *number = [NSNumber numberWithBool:YES];
//        [_puckerArray addObject:number];
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
