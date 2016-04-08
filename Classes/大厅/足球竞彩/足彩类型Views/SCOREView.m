//
//  SCOREView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "SCOREView.h"
#import "ScoreOptionView.h"
static FBBettingType _bettingType;

@interface SCOREViewCell : BaseTypeCell
@end

@implementation SCOREViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        [self.contentView addSubview:_title];
        
        _abstracts = [UILabel new];
        _abstracts.numberOfLines = 0;
        _abstracts.font = Font(14);
        _abstracts.textAlignment = NSTextAlignmentCenter;
        _abstracts.lineBreakMode = NSLineBreakByTruncatingMiddle;//其中lineBreakMode可选值为
        _abstracts.backgroundColor = RGBA(240, 244, 235, 1);
        [_abstracts getCornerRadius:0 borderColor:RGBA(223, 223, 223, 1) borderWidth:1 masksToBounds:YES];
        _abstracts.textColor = CustomBlack;
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat abstractsHeight = ScaleH(25);
    
    /*数据筛选*/
    FBDatasModel *model = nil;
    /*判断是单场投注还是过关投注*/
    if (_bettingType == kSingle)
    {
        model = [FootBallModel filtrateWithBettingDatas:_datas play:kScore_one];
    }
    else
    {
        model = [FootBallModel filtrateWithBettingDatas:_datas play:kScore_two];
    }
    
    NSString *text = [[FootBallModel setScroeTextWithDatas:model.scroes] string];
    CGSize textSize = [NSObject getSizeWithText:text font:_abstracts.font maxSize:CGSizeMake(ScaleW(200), MAXFLOAT)];
    
    if (textSize.height > ScaleH(25)) {
        abstractsHeight = textSize.height + ScaleH(5);
    }
    _title.frame = CGRectMake(ScaleW(90), (self.height - _title.font.lineHeight - abstractsHeight - ScaleH(5)) / 2, ScaleW(200), _title.font.lineHeight);
    
    _abstracts.frame = CGRectMake(ScaleW(90), CGRectGetMaxY(_title.frame) + ScaleH(5), CGRectGetWidth(_title.frame), abstractsHeight);
    
    
    
}

- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ vs %@",datas[@"host_team"],datas[@"guest_team"]]];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, [datas[@"host_team"] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(attrString.length - [datas[@"guest_team"] length], [datas[@"guest_team"] length])];
    _title.attributedText = attrString;
}
@end



@interface SCOREView ()


@end


@implementation SCOREView

- (void)setDatas:(id)datas bettingType:(FBBettingType)bettingType;
{
    _bettingType = bettingType;
    [super setDatas:datas bettingType:bettingType keyword:@"list_value3" predicateWithFormats:@[@"bf_single == '1'"]];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat cellHeight = ScaleH(85);
    NSDictionary *dic =  _datas[indexPath.section][@"datas"][indexPath.row];
    
    /*数据筛选*/
    FBDatasModel *model = nil;
    /*判断是单场投注还是过关投注*/
    if (_bettingType == kSingle)
    {
        model = [FootBallModel filtrateWithBettingDatas:dic play:kScore_one];
    }
    else
    {
        model = [FootBallModel filtrateWithBettingDatas:dic play:kScore_two];
    }
    
    
    
    NSString *text = [[FootBallModel setScroeTextWithDatas:model.scroes] string];
    CGSize textSize = [NSObject getSizeWithText:text font:Font(14) maxSize:CGSizeMake(ScaleW(200), MAXFLOAT)];
    if (textSize.height > ScaleH(25)) {
        CGFloat abstractsHeight = ScaleH(25);
        abstractsHeight = textSize.height + ScaleH(5);
        cellHeight += (abstractsHeight - ScaleH(25));
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    SCOREViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SCOREViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dic =  _datas[indexPath.section][@"datas"][indexPath.row];
    cell.datas = dic;
    
    /*数据筛选*/
    FBDatasModel *model = nil;
    /*判断是单场投注还是过关投注*/
    if (_bettingType == kSingle)
    {
        model = [FootBallModel filtrateWithBettingDatas:dic play:kScore_one];
    }
    else
    {
        model = [FootBallModel filtrateWithBettingDatas:dic play:kScore_two];
    }
    /*修改AbstractsText*/
    cell.abstracts.attributedText = [FootBallModel setScroeTextWithDatas:model.scroes];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBBettingPlay bettingPlay = NSNotFound;
    NSDictionary *dic = _datas[indexPath.section][@"datas"][indexPath.row];
  
    /*数据筛选*/
    FBDatasModel *model = nil;
    /*判断是单场投注还是过关投注*/
    if (_bettingType == kSingle)
    {
        model = [FootBallModel filtrateWithBettingDatas:dic play:kScore_one];
        bettingPlay = kScore_one;
    }
    else
    {
        model = [FootBallModel filtrateWithBettingDatas:dic play:kScore_two];
        bettingPlay = kScore_two;
    }
    
    NSArray *currentDatas = [FootBallModel filtrateWithCurrentBettingPlay:bettingPlay];
    if ([currentDatas count] >= 4 && ![FBTool.selectDatas containsObject:model]) {
        [SVProgressHUD showInfoWithStatus:@"有比分的最多选择4场比赛"];
        return;
    }

    
    [ScoreOptionView showWithDatas:_datas[indexPath.section][@"datas"][indexPath.row] cacheDatas:model.scroes finished:^(id datas)
     {
         model.scroes = datas;
         if ([datas count] && datas)
         {
             if ([FBTool.selectDatas containsObject:model]) {
                 [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                 return ;
             }
             else
             {
                 model.play = bettingPlay;
                 model.datas = dic;
                 model.position = dic[@"position"];
                 model.endTime = dic[@"end_time"];
               
                 
                 [[FBTool mutableArrayValueForKey:@"selectDatas"] addObject:model];
                 
             }
         }
         else
         {
             /*表示之前已投注，后面放弃投注，所以要清空dataModel这场比赛*/
             if ([FBTool.selectDatas containsObject:model])
             {
                 [[FBTool mutableArrayValueForKey:@"selectDatas"] removeObject:model];
             }
         }
         [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

     }];
}


@end
