//
//  HHGGView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJCollectionViewCell.h"
#import "HHGGView.h"
#define backColorHighgeight(size) [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]]

//static FBBettingType _bettingType;

@interface HHGGCollectCell : PJCollectionViewCell

@end

@implementation HHGGCollectCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 0;
        _title.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:_title];
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
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",title,dic[@"odds"]]];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange(0, [title length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:teamColor range:NSMakeRange(0, [title length])];
    
    [attrString addAttribute:NSFontAttributeName value:Font(10) range:NSMakeRange(attrString.length - [dic[@"odds"] length], [dic[@"odds"] length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:displayColor range:NSMakeRange(attrString.length - [dic[@"odds"] length], [dic[@"odds"] length])];
    
    self.title.attributedText = attrString;
    
}



@end


@interface HHGGViewCell : BaseTypeCell
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation HHGGViewCell

- (void)drawRect:(CGRect)rect
{
    
    CGFloat minX = ScaleW(15) + ScaleW(50) + ScaleW(15) + ScaleW(20) ;
    CGFloat minY = (CGRectGetHeight(rect) - ScaleH(25) - ScaleH(65)) / 2 + ScaleH(25);
    CGFloat maxX = minX + ScaleW(210);
    CGFloat maxY = minY + ScaleH(65);
    
    /*横上面第一条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(maxX, minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    /*横中间条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX, (maxY - minY) / 2 + minY) end:CGPointMake(maxX - ScaleW(210) / 4, (maxY - minY) / 2 + minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    /*横最后一条条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX, maxY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    
    /*竖左边第一条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(minX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    /*竖第右边第二条线*/
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 4 * 3, minY) end:CGPointMake(minX + ScaleW(210) / 4 * 3, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    /*竖第右边第一条线*/
    [self drawRectWithLine:rect start:CGPointMake(maxX, minY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    
    NSString *mark = @"未开售";
    CGSize markSize = [NSObject getSizeWithText:mark font:Font(14) maxSize:CGSizeMake(CGRectGetWidth(rect), Font(14).lineHeight)];
    if ( [_datas[@"list_value1"] count] && [_datas[@"list_value2"] count])
    {
        /*竖第左边第二条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 4, minY) end:CGPointMake(minX + ScaleW(210) / 4, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
        /*竖第左边边第三条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 2, minY) end:CGPointMake(minX + ScaleW(210) / 2, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];

    }
    else if ([_datas[@"list_value1"] count] )
    {
        
        [self drawTextWithText:mark rect:CGRectMake(minX + (ScaleW(210) * 3 / 4 - markSize.width) / 2,  minY + (ScaleH(65) / 2 - markSize.height) / 2 + ScaleH(65) / 2, markSize.width, markSize.height) color:CustomBlack font:Font(14)];
        /*竖上第左边边第二条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 4, minY) end:CGPointMake(minX + ScaleW(210) / 4, maxY - ScaleH(65) / 2) lineColor:CustomSkyblue lineWidth:1];
        /*竖上第左边边第三条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 2, minY) end:CGPointMake(minX + ScaleW(210) / 2, maxY - ScaleH(65) / 2) lineColor:CustomSkyblue lineWidth:LineWidth];
    }
    else if ([_datas[@"list_value2"] count])
    {
        [self drawTextWithText:mark rect:CGRectMake(minX + (ScaleW(210) * 3 / 4 - markSize.width) / 2,  minY + (ScaleH(65) / 2 - markSize.height) / 2, markSize.width, markSize.height) color:CustomBlack font:Font(14)];
        /*竖上左边第二条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 4, minY + ScaleH(65) / 2) end:CGPointMake(minX + ScaleW(210) / 4, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
        /*竖上左边第三条线*/
        [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 2, minY + ScaleH(65) / 2) end:CGPointMake(minX + ScaleW(210) / 2, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    }
    
    
    /*非让球*/
    CGSize zeroSize = [NSObject getSizeWithText:@"0" font:Font(10) maxSize:CGSizeMake(ScaleW(15), ScaleW(15))];
    [self drawCircleWithCenter:CGPointMake(_leagueNameLb.right + ScaleW(10) + ScaleW(15) / 2, CGRectGetMidY(rect) - ScaleH(65) / 4 + ScaleH(12.5)) radius:ScaleW(15) / 2 width:0 widthColor:RGBA(37, 89, 71, 1) fillColor:RGBA(37, 89, 71, 1) shadowSize:CGSizeZero];
    [self drawTextWithText:@"0" rect:CGRectMake(_leagueNameLb.right + ScaleW(10) + (ScaleW(15) - zeroSize.width) / 2,  CGRectGetMidY(rect) - ScaleH(65) / 4 - zeroSize.height / 2 + ScaleH(12.5), zeroSize.width, zeroSize.height) color:[UIColor whiteColor] font:Font(10)];
    

    /*让球*/
    CGSize titleSize = [NSObject getSizeWithText:_datas[@"let_count"] font:Font(10) maxSize:CGSizeMake(ScaleW(15), ScaleW(15))];

    [self drawCircleWithCenter:CGPointMake(_leagueNameLb.right + ScaleW(10) + ScaleW(15) / 2, CGRectGetMidY(rect) + ScaleH(65) / 4 + ScaleH(12.5)) radius:ScaleW(15) / 2 width:0 widthColor:RGBA(77, 180, 34, 1) fillColor:RGBA(77, 180, 34, 1) shadowSize:CGSizeZero];
    [self drawTextWithText:_datas[@"let_count"] rect:CGRectMake(_leagueNameLb.right + ScaleW(10) + (ScaleW(15) - titleSize.width) / 2,  CGRectGetMidY(rect) + ScaleH(65) / 4 - titleSize.height / 2 + ScaleH(12.5), titleSize.width, titleSize.height) color:[UIColor whiteColor] font:Font(10)];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
       
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        [self.contentView addSubview:_title];

        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"更多选项" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = Font(12);
        [_moreBtn setTitleColor:CustomBlack forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _moreBtn.titleLabel.numberOfLines = 0;
        [_moreBtn setBackgroundImage:[UIImage drawrWithQuadrateLine:CGSizeMake(210 / 4, ScaleH(65)) lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO] forState:UIControlStateSelected];
        [self.contentView addSubview:_moreBtn];
    }
    return self;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(ScaleW(210) / 4,ScaleH(65) / 2);
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _leagueNameLb.left = ScaleW(15);
    _positionLb.left = _leagueNameLb.left;
    _endTimeLb.left = _leagueNameLb.left;
    
    
    
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self segmentBarLayout]];
        _collectionView.scrollEnabled = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[HHGGCollectCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_collectionView];
    }
    CGFloat height = 0;
    CGFloat minY = 0;
    if ( [_datas[@"list_value1"] count] && [_datas[@"list_value2"] count]) {
        height = ScaleH(65) ;
        minY = (ScaleH(85) - ScaleW(65)) / 2;
    }
    else if ([_datas[@"list_value1"] count] )
    {
        height = ScaleH(65) / 2;
        minY = (ScaleH(85) - ScaleW(65)) / 2;
    }
    else if ([_datas[@"list_value2"] count])
    {
        height = ScaleH(65) / 2;
        minY = (ScaleH(85) - ScaleW(65)) / 2 + height;
    }
   
    _title.frame = CGRectMake(_leagueNameLb.right + ScaleW(15) + ScaleW(20), (ScaleH(25) - _title.font.lineHeight + (ScaleH(85) - ScaleH(65)) / 2) / 2 , ScaleH(210), _title.font.lineHeight);
    _collectionView.frame = CGRectMake(CGRectGetMinX(_title.frame), minY + ScaleH(25), ScaleH(210) / 4 * 3, height);
    _moreBtn.frame = CGRectMake(CGRectGetMaxX(_collectionView.frame), (self.height - ScaleH(25) - ScaleW(65)) / 2 + ScaleH(25) , ScaleW(210) / 4, ScaleH(65));

}


#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[@"list_value1"] count] + [_datas[@"list_value2"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHGGCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     [cell setDatas:_datas index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    HHGGCollectCell *cell = (HHGGCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
   FBDatasModel *dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];
    NSArray *currentDatas = [FootBallModel filtrateWithCurrentBettingPlay:kHHGG_two];
    if ([currentDatas count] >= 8 && ![FBTool.selectDatas containsObject:dataModel]) {
        [SVProgressHUD showInfoWithStatus:@"混合过关最多选择8场比赛"];
        return;
    }
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

        /*如果其中一方有投注切之前‘FBTool.selectDatas’就存在这个model，就return,原因：之前已经添加过，这次只是修改属性*/
        if ([FBTool.selectDatas containsObject:dataModel])
        {
            [self setMoreTitle];
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
    
    [self setMoreTitle];

}



- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    
    [_collectionView reloadData];
    [self setNeedsDisplay];
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ vs %@",datas[@"host_team"],datas[@"guest_team"]]];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, [datas[@"host_team"] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(attrString.length - [datas[@"guest_team"] length], [datas[@"guest_team"] length])];
    _title.attributedText = attrString;

    [self setMoreTitle];
}

- (void)setMoreTitle
{
    FBDatasModel *model = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];

    NSInteger selectedOptionNum = 0;
    if (model.win) selectedOptionNum ++;
    if (model.pin) selectedOptionNum ++;
    if (model.lose) selectedOptionNum ++;
    if (model.rWin) selectedOptionNum ++;
    if (model.rPin) selectedOptionNum ++;
    if (model.rLose) selectedOptionNum ++;
    if (model.JQS_select_one) selectedOptionNum ++;
    if (model.JQS_select_two) selectedOptionNum ++;
    if (model.JQS_select_three) selectedOptionNum ++;
    if (model.JQS_select_four) selectedOptionNum ++;
    if (model.JQS_select_five) selectedOptionNum ++;
    if (model.JQS_select_six) selectedOptionNum ++;
    if (model.JQS_select_seven) selectedOptionNum ++;
    if (model.JQS_select_eight) selectedOptionNum ++;
    if (model.scroes.count) selectedOptionNum += model.scroes.count;
    if (model.BQCDatas.count) selectedOptionNum += model.BQCDatas.count;
    
    if (selectedOptionNum)
    {
        [_moreBtn setTitle:[NSString stringWithFormat:@"已选%d项",selectedOptionNum] forState:UIControlStateSelected];
         _moreBtn.selected = YES;
    }
    else
    {
        _moreBtn.selected = NO;
        [_moreBtn setTitle:@"更多选项" forState:UIControlStateNormal];
    }
}

@end



#import "HHGGOptionView.h"
@interface HHGGView ()

@end


@implementation HHGGView


- (void)setDatas:(id)datas bettingType:(FBBettingType)bettingType;
{

    [super setDatas:datas bettingType:bettingType];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(85) + ScaleH(25);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    HHGGViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HHGGViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.moreBtn addTarget:self action:@selector(eventWithMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.datas = _datas[indexPath.section][@"datas"][indexPath.row];
    return cell;
}

- (void)eventWithMore:(UIButton *)btn
{
    HHGGViewCell *cell = [UIView getView:btn toClass:@"HHGGViewCell"];
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    FBDatasModel *dataModel = [FootBallModel filtrateWithBettingDatas:_datas[indexPath.section][@"datas"][indexPath.row] play:kHHGG_two];
    
    NSArray *currentDatas = [FootBallModel filtrateWithCurrentBettingPlay:kHHGG_two];
    if ([currentDatas count] >= 8 && ![FBTool.selectDatas containsObject:dataModel]) {
        [SVProgressHUD showInfoWithStatus:@"混合过关最多选择8场比赛"];
        return;
    }
    
    [HHGGOptionView showWithDatas:_datas[indexPath.section][@"datas"][indexPath.row] cacheModel:dataModel finished:^(FBDatasModel *model)
     {
         [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
