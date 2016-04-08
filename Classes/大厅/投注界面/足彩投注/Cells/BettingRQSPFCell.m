//
//  BettingRQSPFCell.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/2.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BettingRQSPFCell.h"
#import "PJCollectionViewCell.h"
@interface BettingRQSPFCollectCell :PJCollectionViewCell

@end

@implementation BettingRQSPFCollectCell
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _title = [UILabel new];
        _title.highlightedTextColor = [UIColor whiteColor];
        _title.font = Font(12);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 0;
        _title.textColor = [UIColor blackColor];
        
        
        _abstracts = [UILabel new];
        _abstracts.font = Font(11);
        _abstracts.numberOfLines = 0;
        _abstracts.textColor = CustomBlack;
        _abstracts.textAlignment = NSTextAlignmentCenter;
        _abstracts.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2);
    _abstracts.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2);
}

- (void)setDatas:(id)datas index:(NSInteger)index
{
    
    self.backgroundColor = [UIColor clearColor];
    _title.textColor = [UIColor blackColor];
    _abstracts.textColor = CustomBlack;
    
    FBDatasModel *model = [FootBallModel filtrateWithBettingDatas:datas];
    
    switch (index) {
        case 0:/*主场*/
        {
            if (model.rWin) {
                _title.highlighted = _abstracts.highlighted = YES;
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
            _title.text = datas[@"host_team"];
        }
            break;
        case 1:/*平局*/
        {
            if (model.rPin) {
                _title.highlighted = _abstracts.highlighted = YES;
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
            _title.text = @"VS";
        }
            break;
        case 2:/*客场*/
        {
            if (model.rLose) {
                _title.highlighted = _abstracts.highlighted = YES;
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
            _title.text = datas[@"guest_team"];
        }
            break;
        default:
            break;
    }
    
    
    NSArray *list_value2 = datas[@"list_value2"];
    if (index == 0) {
        _abstracts.text = [@"主" stringByAppendingString:[list_value2[index][@"value_display"] stringByAppendingString:list_value2[index][@"odds"]]];
    }
    else if (index == 1)
    {
        _abstracts.text = [list_value2[index][@"value_display"] stringByAppendingString:list_value2[index][@"odds"]];
    }
    else
    {
        _abstracts.text = [@"客胜" stringByAppendingString:list_value2[index][@"odds"]];
    }
    
}

@end

@interface BettingRQSPFCell ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation BettingRQSPFCell
#pragma mark - tableViewcell 绘制
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat minX = _leagueNameLb.right + ScaleW(25);
    CGFloat minY = (CGRectGetHeight(rect) - ScaleH(55)) / 2;
    CGFloat maxX = minX + ScaleW(170);
    CGFloat maxY = minY + ScaleH(55);
    
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(maxX, minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX, (maxY - minY) / 2 + minY) end:CGPointMake(maxX, (maxY - minY) / 2 + minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX, maxY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    
    
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(minX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(maxX, minY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(170) / 3, minY) end:CGPointMake(minX + ScaleW(170) / 3, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(170) / 3 * 2, minY) end:CGPointMake(minX + ScaleW(170) / 3 * 2, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    
    
    [self drawCircleWithCenter:CGPointMake(_leagueNameLb.right + ScaleW(5) + ScaleW(15) / 2, CGRectGetMidY(rect)) radius:ScaleW(15) / 2 width:1 widthColor:RGBA(77, 180, 34, LineWidth) fillColor:RGBA(77, 180, 34, 1) shadowSize:CGSizeZero];
    CGSize size = [NSObject getSizeWithText:_datas[@"let_count"] font:Font(10) maxSize:CGSizeMake(ScaleW(15), ScaleW(15))];
    [self drawTextWithText:_datas[@"let_count"] rect:CGRectMake(_leagueNameLb.right + ScaleW(5) + (ScaleW(15) - size.width) / 2,  CGRectGetMidY(rect) - size.height / 2, size.width, size.height) color:[UIColor whiteColor] font:Font(10)];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _leagueNameLb.backgroundColor = CustomYellow;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _leagueNameLb.left = ScaleW(7.5);
    _positionLb.left = ScaleW(7.5);
    _endTimeLb.left = ScaleW(7.5);

    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_leagueNameLb.right + ScaleW(25), (self.height - ScaleH(55)) / 2, ScaleH(170), ScaleH(55)) collectionViewLayout:[self segmentBarLayout]];
        _collectionView.scrollEnabled = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[BettingRQSPFCollectCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.userInteractionEnabled = NO;
        
        FBDatasModel *model = [FootBallModel filtrateWithBettingDatas:_datas];
        if (model.rWin) {
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        if (model.rPin) {
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        if (model.rLose) {
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        [self.contentView addSubview:_collectionView];
    }
}

- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    [self setNeedsDisplay];
    [_collectionView reloadData];

}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(ScaleW(170) / 3.0,ScaleH(55));
    segmentBarLayout.minimumLineSpacing = 0.0;
    segmentBarLayout.minimumInteritemSpacing = 0.0;
    return segmentBarLayout;
}

#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[@"list_value2"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BettingRQSPFCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDatas:_datas index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    CollectCell *cell = (CollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.title.highlighted = cell.abstracts.highlighted = YES;
    //    cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    CollectCell *cell = (CollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.title.highlighted = cell.abstracts.highlighted = NO;
    //    cell.backgroundColor = [UIColor clearColor];
}



@end
