//
//  BettingJQSCell.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BettingJQSCell.h"
#import "PJCollectionViewCell.h"

@interface BettingJQSCollectCell :PJCollectionViewCell

@end

@implementation BettingJQSCollectCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
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
    self.backgroundColor = [UIColor clearColor];
    UIColor *selectColor = CustomBlack;
    UIColor *selectedColor = [UIColor blackColor];
    FBDatasModel *model = [FootBallModel filtrateWithBettingDatas:datas];
    
    switch (index) {
        case 0:
        {
            if (model.JQS_select_one)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }
            
        }
            break;
        case 1:
        {
            if (model.JQS_select_two)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }
        }
            break;
        case 2:
        {
            if (model.JQS_select_three)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }
        }
            break;
        case 3:
        {
            if (model.JQS_select_four)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }
        }
            break;
        case 4:
        {
            if (model.JQS_select_five)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }
            
        }
            break;
        case 5:
        {
            if (model.JQS_select_six)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }
            
        }
            break;
        case 6:
        {
            if (model.JQS_select_seven)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }
            
        }
            break;
        case 7:
        {
            if (model.JQS_select_eight)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    NSArray *list_value5 = datas[@"list_value5"];
    NSDictionary *dic = list_value5[index];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",dic[@"value_display"],dic[@"odds"]]];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:selectedColor range:NSMakeRange(0, [dic[@"value_display"] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(13) range:NSMakeRange(0, [dic[@"value_display"] length])];
    
    [attrString addAttribute:NSFontAttributeName value:Font(10) range:NSMakeRange(attrString.length - [dic[@"odds"] length], [dic[@"odds"] length])];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:selectColor range:NSMakeRange(attrString.length - [dic[@"odds"] length], [dic[@"odds"] length])];
    
    _title.attributedText = attrString;

}


@end

@interface BettingJQSCell ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation BettingJQSCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat minX = ScaleW(55) + ScaleW(10);
    CGFloat minY = (CGRectGetHeight(rect) - ScaleH(25) - ScaleH(55)) / 2 + ScaleH(25);
    CGFloat maxX = minX + ScaleW(180);
    CGFloat maxY = minY + ScaleH(55);
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(maxX, minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX, (maxY - minY) / 2 + minY) end:CGPointMake(maxX, (maxY - minY) / 2 + minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX, maxY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(minX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(maxX, minY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(180) / 4, minY) end:CGPointMake(minX + ScaleW(180) / 4, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(180) / 2, minY) end:CGPointMake(minX + ScaleW(180) / 2, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(180) / 4 * 3, minY) end:CGPointMake(minX + ScaleW(180) / 4 * 3, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(ScaleW(180) / 4,ScaleH(55) / 2);
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
     self.textLabel.frame = CGRectMake(_leagueNameLb.right + ScaleW(10), (ScaleH(25) - self.textLabel.font.lineHeight + (self.height - ScaleH(25) - ScaleH(55)) / 2) / 2 , ScaleH(180), self.textLabel.font.lineHeight);

    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_leagueNameLb.right + ScaleW(10) , (self.height - ScaleH(25) - ScaleH(55)) / 2 + ScaleH(25), ScaleH(180), ScaleH(55)) collectionViewLayout:[self segmentBarLayout]];
        _collectionView.scrollEnabled = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[BettingJQSCollectCell   class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = YES;
        [self.contentView addSubview:_collectionView];
    }
}

#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[@"list_value5"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BettingJQSCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDatas:_datas index:indexPath.row];
    return cell;
}

#pragma mark - 选中和取消写在一起，是没有办法的办法allowsMultipleSelection 配合 didDeselectItemAtIndexPath与reloadData冲突，只能写在一起。
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    [self setNeedsDisplay];
    [_collectionView reloadData];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ vs %@",_datas[@"host_team"],_datas[@"guest_team"]]];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([_datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([_datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, [_datas[@"host_team"] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(attrString.length - [_datas[@"guest_team"] length], [_datas[@"guest_team"] length])];
     self.textLabel.attributedText = attrString;
}


@end
