//
//  BaseTypeTableView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BaseTypeTableView.h"


@interface BaseTypeCell ()
{
}
@end

@implementation BaseTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _positionLb = [UILabel new];
        _positionLb.textColor = CustomBlack;
        _positionLb.textAlignment = NSTextAlignmentCenter;
        _positionLb.font = Font(12);

        _leagueNameLb = [UILabel new];
        _leagueNameLb.textColor = [UIColor whiteColor];
        _leagueNameLb.backgroundColor = CustomRed;
        _leagueNameLb.font = Font(12);
        _leagueNameLb.numberOfLines = 0;

        _endTimeLb = [UILabel new];
        _endTimeLb.textColor = CustomBlack;
        _endTimeLb.textAlignment = NSTextAlignmentCenter;
        _endTimeLb.font = Font(10);
        [self.contentView addSubview:_positionLb];
        [self.contentView addSubview:_leagueNameLb];
        [self.contentView addSubview:_endTimeLb];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [NSObject getSizeWithText:_leagueNameLb.text font:_leagueNameLb.font maxSize:CGSizeMake(ScaleW(50), MAXFLOAT)];
   
    CGFloat height = 0;
    if (size.height <= ScaleH(15))
    {
        height = ScaleH(15);
        _leagueNameLb.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        height = size.height + 3;
        _leagueNameLb.textAlignment = NSTextAlignmentLeft;
    }
    _leagueNameLb.frame = CGRectMake(ScaleW(25), CGRectGetHeight(self.frame) / 2 - height / 2, ScaleW(50), height);
    
    _positionLb.frame = CGRectMake(CGRectGetMinX(_leagueNameLb.frame), CGRectGetMinY(_leagueNameLb.frame) - ScaleH(2) - ScaleH(15), CGRectGetWidth(_leagueNameLb.frame), ScaleH(15));
    _endTimeLb.frame = CGRectMake(CGRectGetMinX(_leagueNameLb.frame), CGRectGetMaxY(_leagueNameLb.frame) +  ScaleH(3), CGRectGetWidth(_leagueNameLb.frame), ScaleH(15));
    
//    [self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
}

- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    _positionLb.text = [datas[@"position"] substringFromIndex:8];
    _leagueNameLb.text = datas[@"league_name"];
    _endTimeLb.text = [[[datas[@"end_time"] componentsSeparatedByString:@" "][1] substringToIndex:5] stringByAppendingString:@"截止"];
}

@end

@interface BaseTypeTableView ()
{
    NSMutableArray *_puckerArray;
  }
@end

@implementation BaseTypeTableView


- (id)init
{
    if ((self = [super initWithFrame:CGRectMake(0, ScaleH(35), DeviceW, DeviceH - ScaleH(85)) style:UITableViewStylePlain]))
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *header = [UIButton buttonWithType:UIButtonTypeCustom];
    header.backgroundColor = RGBA(129, 152, 204, .8);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultInset.left, 0, DeviceW - ScaleW(50), ScaleH(30))];
    title.textColor = [UIColor whiteColor];
    title.font = Font(13);
    title.text = _datas[section][@"info"];
    [header addTarget:self action:@selector(puckerTouches:) forControlEvents:UIControlEventTouchUpInside];
    header.tag = section;
    [header addSubview:title];
    
    UIImage *img = [UIImage imageNamed:@"jczq_arrow_down.png"];
    UIButton *acc = [UIButton buttonWithType:UIButtonTypeCustom];
    acc.frame = CGRectMake(title.right + (ScaleW(50) - img.size.width) / 2, (ScaleH(30) - img.size.height) / 2, img.size.width, img.size.height);
    [acc setImage:img forState:UIControlStateNormal];
    NSNumber *number = [_puckerArray objectAtIndex:section];
    if ([number boolValue])
    {
        acc.transform = CGAffineTransformIdentity;
    }
    else
    {
        acc.transform = CGAffineTransformMakeRotation(-M_PI);
    }
    
    [header addSubview:acc];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *number = [_puckerArray objectAtIndex:section];
    if (![number boolValue]) {
        return 0;
    }

    return  [_datas[section][@"datas"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(85);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}


- (void)puckerTouches:(UIButton *)button
{
    NSNumber *number = [_puckerArray objectAtIndex:button.tag];
    [_puckerArray replaceObjectAtIndex:button.tag withObject:[NSNumber  numberWithBool:![number boolValue]]];
    [self reloadData];
//    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 折点数组初始化
-(void)makePuckerArray
{
    if (!_puckerArray)
    {
        _puckerArray = [NSMutableArray array];
    }
    else if (_puckerArray.count)
    {
        return;
    }
    for (int i = 0;i < [_datas count];i++) {
        NSNumber *number = [NSNumber numberWithBool:YES];
        [_puckerArray addObject:number];
    }
}

- (void)setDatas:(id)datas bettingType:(FBBettingType)bettingType keyword:(NSString *)keyword predicateWithFormats:(NSArray *)predicateWithFormats;
{
    
    if (bettingType == kSkipmatch)
    {
        
        /*
         判断过关投注数据有没有已经获取
         */
        if (!_skipmatchDatas && datas)
        {
            //如果没有
           
            /*
             得到当前时间戳
             */
            [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *timestamp=[FBTool.formatter dateFromString:datas[@"system_time"] ];
            /*
             数据重组过关投注
             */
            _skipmatchDatas = [FootBallModel getDatasClassifyForLotteryPlayInformation:datas[@"item"] timestamp:timestamp keyword:keyword];
        }
        [super setDatas:_skipmatchDatas];
    }
    else
    {
        if (!_singleDatas)
        {
            _singleDatas = [FootBallModel getSingleDatasToItemDatas:datas predicateWithFormats:predicateWithFormats keyword:keyword];
        }

        [super setDatas:_singleDatas];
    }
    
    [self makePuckerArray];
}

- (void)setDatas:(id)datas bettingType:(FBBettingType)bettingType;
{
    
    if (!_skipmatchDatas && datas)
    {//如果没有
        /*
         得到当前时间戳
         */
        [FBTool.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *timestamp=[FBTool.formatter dateFromString:datas[@"system_time"] ];
        /*
         数据重组过关投注
         */
        _skipmatchDatas = [FootBallModel getDatasClassifyForLotteryPlayInformation:datas[@"item"] timestamp:timestamp keyword:nil];
    }
    [super setDatas:_skipmatchDatas];
    [self makePuckerArray];
}



/*
 //最后一行分隔线顶头显示
 //http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working
 static void setLastCellSeperatorToLeft(UITableViewCell* cell)
 {
 if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
 [cell setSeparatorInset:UIEdgeInsetsZero];
 }
 
 if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
 [cell setLayoutMargins:UIEdgeInsetsZero];
 }
 
 if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
 [cell setPreservesSuperviewLayoutMargins:NO];
 }
 }
 */



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
