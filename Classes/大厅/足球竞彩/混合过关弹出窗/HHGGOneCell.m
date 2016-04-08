//
//  HHGGOneCell.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "HHGGOneCell.h"
#import "PJCollectionViewCell.h"
#import "FootBallModel.h"

#define backColorHighgeight(size) [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]]


@interface HHGGOneCollectCell : PJCollectionViewCell

@end

@implementation HHGGOneCollectCell


- (void)showIndex:(NSInteger)index model:(FBDatasModel *)dataModel hasSelect:(BOOL)hasSelect
{
    
    UIColor *teamColor = [UIColor blackColor];
    UIColor *displayColor = CustomBlack;
    self.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dic = nil;
    if (index < [_datas[@"list_value1"] count]) {
        dic = _datas[@"list_value1"][index];
    }
    else
    {
        dic = _datas[@"list_value2"][index - [_datas[@"list_value1"] count]];
        
    }
    
    
    if ( [_datas[@"list_value1"] count] && [_datas[@"list_value2"] count])
    {
        
        switch (index)
        {
            case 0: /*主场*/
            {
                
                /*取相反属性，一下Bool属性为YES均为选中状态依据，不解释*/
                if (hasSelect) {
                    dataModel.win = !dataModel.win;
                }
                if (dataModel.win) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
            }
                break;
            case 1: /*平局*/
            {
                if (hasSelect) {
                    dataModel.pin = !dataModel.pin;
                }
                if (dataModel.pin) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
                
            }
                break;
            case 2: /*客场*/
            {
                if (hasSelect) {
                    dataModel.lose = !dataModel.lose;
                }
                if (dataModel.lose) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
            }
                break;
            case 3: /*主场*/
            {
                /*取相反属性，一下Bool属性为YES均为选中状态依据，不解释*/
                if (hasSelect) {
                    dataModel.rWin = !dataModel.rWin;
                }
                if (dataModel.rWin) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
            }
                break;
            case 4: /*平局*/
            {
                if (hasSelect) {
                    dataModel.rPin = !dataModel.rPin;
                }
                if (dataModel.rPin) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
                
            }
                break;
            case 5: /*客场*/
            {
                if (hasSelect) {
                    dataModel.rLose = !dataModel.rLose;
                }
                if (dataModel.rLose) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
            }
                break;
                
            default:
                break;
        }
        
        
    }
    else if ([_datas[@"list_value1"] count] )
    {
        switch (index)
        {
            case 0: /*主场*/
            {
                /*取相反属性，一下Bool属性为YES均为选中状态依据，不解释*/
                if (hasSelect) {
                    dataModel.win = !dataModel.win;
                }
                if (dataModel.win) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
            }
                break;
            case 1: /*平局*/
            {
                if (hasSelect) {
                    dataModel.pin = !dataModel.pin;
                }
                if (dataModel.pin) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
                
            }
                break;
            case 2: /*客场*/
            {
                if (hasSelect) {
                    dataModel.lose = !dataModel.lose;
                }
                if (dataModel.lose) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
            }
                break;
                
            default:
                break;
        }
        
    }
    else if ([_datas[@"list_value2"] count])
    {
        switch (index)
        {
            case 0: /*主场*/
            {
                /*取相反属性，一下Bool属性为YES均为选中状态依据，不解释*/
                if (hasSelect) {
                    dataModel.rWin = !dataModel.rWin;
                }
                if (dataModel.rWin) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
            }
                break;
            case 1: /*平局*/
            {
                if (hasSelect) {
                    dataModel.rPin = !dataModel.rPin;
                }
                if (dataModel.rPin) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
                
            }
                break;
            case 2: /*客场*/
            {
                if (hasSelect) {
                    dataModel.rLose = !dataModel.rLose;
                }
                if (dataModel.rLose) {
                    teamColor = displayColor = [UIColor whiteColor];
                    self.backgroundColor = backColorHighgeight(self.size);
                }
            }
                break;
                
            default:
                break;
        }
        
    }
    
    NSString *title = nil;
    switch (index % 3) {
        case 0:
            title = [@"主" stringByAppendingString:dic[@"value_display"]];
            break;
        case 1:
            title = dic[@"value_display"];
            break;
        case 2:
            title = @"客胜";
            break;
        default:
            break;
    }
    
    _title.textColor = teamColor;
    _abstracts.textColor = displayColor;
    _title.text = title;
    _abstracts.text = dic[@"odds"];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _title = [UILabel new];
        _title.font = Font(13);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        
        _abstracts = [UILabel new];
        _abstracts.font = Font(11);
        _abstracts.textAlignment = NSTextAlignmentCenter;
        _abstracts.textColor = CustomBlack;
        
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)setDatas:(id)datas index:(NSInteger)index
{
    [super setDatas:datas];
    FBDatasModel *dataModel = nil;
    dataModel = [FootBallModel filtrateWithBettingDatas:datas play:kHHGG_two];
    [self showIndex:index model:dataModel hasSelect:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 - _title.font.lineHeight, CGRectGetWidth(self.frame), _title.font.lineHeight);
    _abstracts.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame), _title.font.lineHeight);
}

@end


@interface HHGGOneCell()
<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) UILabel *notRangLb;
@property (nonatomic) UILabel *rangLb;

@end

@implementation HHGGOneCell

- (void)drawRect:(CGRect)rect
{
    CGFloat minX = ScaleX(5) + ScaleW(15) ;
    CGFloat minY = (CGRectGetHeight(rect) - ScaleH(70)) / 2;
    CGFloat maxX = CGRectGetMaxX(rect) - ScaleW(5);
    CGFloat maxY = minY + ScaleH(70);
    
    /*横上面第一条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(maxX, minY) lineColor:CustomBlack lineWidth:LineWidth];
    /*横中间条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX, (maxY - minY) / 2 + minY) end:CGPointMake(maxX , (maxY - minY) / 2 + minY) lineColor:CustomBlack lineWidth:LineWidth];
    /*横最后一条条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX, maxY) end:CGPointMake(maxX, maxY) lineColor:CustomBlack lineWidth:LineWidth];
    
    /*竖左边第一条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(minX, maxY) lineColor:CustomBlack lineWidth:LineWidth];

    /*竖第右边第一条线*/
    [self drawRectWithLine:rect start:CGPointMake(maxX, minY) end:CGPointMake(maxX, maxY) lineColor:CustomBlack lineWidth:LineWidth];
    
    NSString *mark = @"未开售";
    CGSize markSize = [NSObject getSizeWithText:mark font:Font(14) maxSize:CGSizeMake(CGRectGetWidth(rect), Font(14).lineHeight)];
    if ( [_datas[@"list_value1"] count] && [_datas[@"list_value2"] count])
    {

        /*竖第左边边第二条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + (maxX - minX) / 3, minY) end:CGPointMake(minX + (maxX - minX) / 3, maxY) lineColor:CustomBlack lineWidth:LineWidth];
        [self drawRectWithLine:rect start:CGPointMake(minX + (maxX - minX) / 3 * 2, minY) end:CGPointMake(minX + (maxX - minX) / 3 * 2, maxY) lineColor:CustomBlack lineWidth:LineWidth];
        
    }
    else if ([_datas[@"list_value1"] count] )
    {
        
        [self drawTextWithText:mark rect:CGRectMake(minX + (maxX - minX - markSize.width) / 2,  minY + (ScaleH(70) / 2 - markSize.height) / 2 + ScaleH(70) / 2, markSize.width, markSize.height) color:CustomBlack font:Font(14)];
        /*竖第左边边第二条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + (maxX - minX) / 3, minY) end:CGPointMake(minX + (maxX - minX) / 3, minY + (maxY - minY) / 2) lineColor:CustomBlack lineWidth:LineWidth];
        [self drawRectWithLine:rect start:CGPointMake(minX + (maxX - minX) / 3 * 2, minY) end:CGPointMake(minX + (maxX - minX) / 3 * 2, minY + (maxY - minY) / 2) lineColor:CustomBlack lineWidth:LineWidth];
        
    }
    else if ([_datas[@"list_value2"] count])
    {
        
        
        [self drawTextWithText:mark rect:CGRectMake(minX + (maxX - minX - markSize.width) / 2,  minY + (ScaleH(70) / 2 - markSize.height) / 2, markSize.width, markSize.height) color:CustomBlack font:Font(14)];

        /*竖第左边边第二条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + (maxX - minX) / 3,  minY + (maxY - minY) / 2) end:CGPointMake(minX + (maxX - minX) / 3, maxY) lineColor:CustomBlack lineWidth:LineWidth];
        [self drawRectWithLine:rect start:CGPointMake(minX + (maxX - minX) / 3 * 2,  minY + (maxY - minY) / 2) end:CGPointMake(minX + (maxX - minX) / 3 * 2, maxY) lineColor:CustomBlack lineWidth:LineWidth];
    }
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        _notRangLb = [UILabel new];
        _notRangLb.backgroundColor = CustomRed;
        _notRangLb.textColor = [UIColor whiteColor];
        _notRangLb.font = Font(13);
        _notRangLb.numberOfLines = 0;
        _notRangLb.textAlignment = NSTextAlignmentCenter;
        _rangLb = [UILabel new];
        _rangLb.backgroundColor = CustomSkyblue;
        _rangLb.textColor = [UIColor whiteColor];
        _rangLb.font = Font(13);
        _rangLb.numberOfLines = 0;
        _rangLb.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_notRangLb];
        [self.contentView addSubview:_rangLb];
    }
    return self;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake((CGRectGetWidth(self.frame) - ScaleW(25)) / 3,ScaleH(70) / 2);
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self segmentBarLayout]];
        _collectionView.scrollEnabled = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[HHGGOneCollectCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_collectionView];
    }
    CGFloat height = 0;
    CGFloat minY = 0;
    if ( [_datas[@"list_value1"] count] && [_datas[@"list_value2"] count]) {
        height = ScaleH(70) ;
        minY = (self.height - ScaleW(70)) / 2;
    }
    else if ([_datas[@"list_value1"] count] )
    {
        height = ScaleH(70) / 2;
        minY = (self.height - ScaleW(70)) / 2;
    }
    else if ([_datas[@"list_value2"] count])
    {
        height = ScaleH(70) / 2;
        minY = (self.height - ScaleW(70)) / 2 + height;
    }
    
    _notRangLb.frame = CGRectMake(ScaleX(5), (self.height - ScaleW(70)) / 2 , ScaleW(15), ScaleH(70) / 2);
    _rangLb.frame = CGRectMake(_notRangLb.left, _notRangLb.bottom, _notRangLb.width, _notRangLb.height);
    _collectionView.frame = CGRectMake(CGRectGetMaxX(_notRangLb.frame), minY, CGRectGetWidth(self.frame) - ScaleW(25), height);
    
}

#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[@"list_value1"] count] + [_datas[@"list_value2"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHGGOneCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDatas:_datas index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HHGGOneCollectCell *cell = (HHGGOneCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    FBDatasModel *dataModel = nil;
    dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];
    
    
    if ( [_datas[@"list_value1"] count] && [_datas[@"list_value2"] count])
    {
        if (indexPath.row < [_datas[@"list_value1"] count])
        {
            if ( dataModel.rWin || dataModel.rPin || dataModel.rLose || dataModel.scroes.count || dataModel.BQCDatas.count || dataModel.JQS_select_one || dataModel.JQS_select_two || dataModel.JQS_select_three || dataModel.JQS_select_four || dataModel.JQS_select_five || dataModel.JQS_select_six || dataModel.JQS_select_seven || dataModel.JQS_select_eight)
            {
                [SVProgressHUD showInfoWithStatus:@"一场比赛中，只允许选择一个玩法进行过关!"];
                return;
            }
        }
        else
        {
            if ( dataModel.win || dataModel.pin || dataModel.lose || dataModel.scroes.count || dataModel.BQCDatas.count || dataModel.JQS_select_one || dataModel.JQS_select_two || dataModel.JQS_select_three || dataModel.JQS_select_four || dataModel.JQS_select_five || dataModel.JQS_select_six || dataModel.JQS_select_seven || dataModel.JQS_select_eight)
            {
                [SVProgressHUD showInfoWithStatus:@"一场比赛中，只允许选择一个玩法进行过关!"];
                return;
            }
            
        }
        
    }
    else if ([_datas[@"list_value1"] count] )
    {
        if ( dataModel.rWin || dataModel.rPin || dataModel.rLose || dataModel.scroes.count || dataModel.BQCDatas.count || dataModel.JQS_select_one || dataModel.JQS_select_two || dataModel.JQS_select_three || dataModel.JQS_select_four || dataModel.JQS_select_five || dataModel.JQS_select_six || dataModel.JQS_select_seven || dataModel.JQS_select_eight)
        {
            [SVProgressHUD showInfoWithStatus:@"一场比赛中，只允许选择一个玩法进行过关!"];
            return;
        }
        
    }
    else if ([_datas[@"list_value2"] count])
    {
        if ( dataModel.win || dataModel.pin || dataModel.lose || dataModel.scroes.count || dataModel.BQCDatas.count || dataModel.JQS_select_one || dataModel.JQS_select_two || dataModel.JQS_select_three || dataModel.JQS_select_four || dataModel.JQS_select_five || dataModel.JQS_select_six || dataModel.JQS_select_seven || dataModel.JQS_select_eight)
        {
            [SVProgressHUD showInfoWithStatus:@"一场比赛中，只允许选择一个玩法进行过关!"];
            return;
        }
        
    }
    
    
    
    [cell showIndex:indexPath.row model:dataModel hasSelect:YES];
    
    /*dataModel表示一场比赛，如果没有一个BOOL属性为YES，即表示该场比赛未投注*/
    if (dataModel.win || dataModel.pin ||dataModel.lose || dataModel.rWin || dataModel.rPin || dataModel.rLose || dataModel.scroes.count || dataModel.BQCDatas.count || dataModel.JQS_select_one || dataModel.JQS_select_two || dataModel.JQS_select_three || dataModel.JQS_select_four || dataModel.JQS_select_five || dataModel.JQS_select_six || dataModel.JQS_select_seven || dataModel.JQS_select_eight)
    {
        NSLog(@"11: %d",FBTool.selectDatas.count);
        /*如果其中一方有投注切之前‘FBTool.selectDatas’就存在这个model，就return,原因：之前已经添加过，这次只是修改属性*/
        if ([FBTool.selectDatas containsObject:dataModel])
        {
            return;
        }
        else
        {
            dataModel.play = kHHGG_two;
            dataModel.datas = _datas;
            dataModel.endTime = _datas[@"end_time"];
            dataModel.position = _datas[@"position"];
            [[FBTool mutableArrayValueForKey:@"selectDatas"] addObject:dataModel];
        }
    }
    else
    {
        /*表示之前已投注，后面放弃投注，所以要清空dataModel这场比赛*/
        if ([FBTool.selectDatas containsObject:dataModel])
        {
            [[FBTool mutableArrayValueForKey:@"selectDatas"] removeObject:dataModel];
        }
    }
}



- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    _notRangLb.text = @"0";
    _rangLb.text = datas[@"let_count"];
    [_collectionView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
