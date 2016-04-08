//
//  RQSFPView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//
#import "PJCollectionViewCell.h"
#import "RQSFPView.h"
static FBBettingType _bettingType;

@interface RQSFPCollectionCell : PJCollectionViewCell
@property (nonatomic) UILabel *text;

@end

@implementation RQSFPCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        _title = [UILabel new];
        _title.font = Font(13);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 0;
        _text = [UILabel new];
        _text.font = Font(12);
        _text.numberOfLines = 0;
        _text.textColor = CustomBlack;
        _text.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_text];
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2);
    _text.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2);
}

- (void)setDatas:(id)datas index:(NSInteger)index
{
    self.backgroundColor = [UIColor clearColor];
    _title.textColor = [UIColor blackColor];
    _text.textColor = CustomBlack;

    
    FBDatasModel *dataModel = nil;
    /*判断是单场投注还是过关投注*/
    if (_bettingType == kSingle)
    {
        dataModel = [FootBallModel filtrateWithBettingDatas:datas play:kRSFP_one];
    }
    else
    {
        dataModel = [FootBallModel filtrateWithBettingDatas:datas play:kRSFP_two];
    }

    switch (index) {
        case 0:/*主场*/
            _title.text = datas[@"host_team"];
            if (dataModel.rWin)
            {
                self.title.textColor = self.text.textColor = [UIColor whiteColor];
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
            break;
        case 1:/*平局*/
        {
            _title.text = @"VS";
            if (dataModel.rPin)
            {
                self.title.textColor = self.text.textColor = [UIColor whiteColor];
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
            
        }
            break;
        case 2:/*客场*/
        {
            _title.text = datas[@"guest_team"];
            if (dataModel.rLose)
            {
                self.title.textColor = self.text.textColor = [UIColor whiteColor];
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
        }
            break;
        default:
            break;
    }

    
    NSArray *list_value2 = datas[@"list_value2"];
    if (index == 0) {
        _text.text = [@"主" stringByAppendingString:[list_value2[index][@"value_display"] stringByAppendingString:list_value2[index][@"odds"]]];
    }
    else if (index == 1)
    {
        _text.text = [list_value2[index][@"value_display"] stringByAppendingString:list_value2[index][@"odds"]];
    }
    else
    {
        _text.text = [@"客胜" stringByAppendingString:list_value2[index][@"odds"]];
    }
    [self setNeedsDisplay];
    
}



@end

@interface RQSFPViewCell : BaseTypeCell
<UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation RQSFPViewCell

- (void)drawRect:(CGRect)rect
{

    CGFloat minX = ScaleW(15) + ScaleW(50) + ScaleW(15) + ScaleW(20);
    CGFloat minY = (CGRectGetHeight(rect) - ScaleH(65)) / 2;
    CGFloat maxX = minX + ScaleW(210);
    CGFloat maxY = minY + ScaleH(65);
    
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(maxX, minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX, (maxY - minY) / 2 + minY) end:CGPointMake(maxX, (maxY - minY) / 2 + minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX, maxY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    
    
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(minX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(maxX, minY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 3, minY) end:CGPointMake(minX + ScaleW(210) / 3, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 3 * 2, minY) end:CGPointMake(minX + ScaleW(210) / 3 * 2, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    
    [self drawCircleWithCenter:CGPointMake(_leagueNameLb.right + ScaleW(10) + ScaleW(15) / 2, CGRectGetMidY(rect)) radius:ScaleW(15) / 2 width:1 widthColor:RGBA(77, 180, 34, LineWidth) fillColor:RGBA(77, 180, 34, 1) shadowSize:CGSizeZero];
    
    CGSize size = [NSObject getSizeWithText:_datas[@"let_count"] font:Font(10) maxSize:CGSizeMake(ScaleW(15), ScaleW(15))];
    [self drawTextWithText:_datas[@"let_count"] rect:CGRectMake(_leagueNameLb.right + ScaleW(10) + (ScaleW(15) - size.width) / 2,  CGRectGetMidY(rect) - size.height / 2, size.width, size.height) color:[UIColor whiteColor] font:Font(10)];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _leagueNameLb.backgroundColor = CustomYellow;
    }
    return self;
}


- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(ScaleW(210) / 3,ScaleH(65));
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_leagueNameLb.right + ScaleW(15) + ScaleW(20), (self.height - ScaleW(65)) / 2,ScaleH(210), ScaleH(65)) collectionViewLayout:[self segmentBarLayout]];
        _collectionView.scrollEnabled = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[RQSFPCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_collectionView];
    }
}

#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[@"list_value2"] count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RQSFPCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDatas:_datas index:indexPath.row];
    return cell;
}

#pragma mark - 选中和取消写在一起，是没有办法的办法allowsMultipleSelection 配合 didDeselectItemAtIndexPath与reloadData冲突，只能写在一起。
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RQSFPCollectionCell *cell = (RQSFPCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];

    FBBettingPlay bettingPlay = NSNotFound;
    FBDatasModel *dataModel = nil;
    /*判断是单场投注还是过关投注*/
    if (_bettingType == kSingle)
    {
        dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kRSFP_one];
        bettingPlay = kRSFP_one;
    }
    else
    {
        dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kRSFP_two];
        bettingPlay = kRSFP_two;
    }
    NSArray *currentDatas = [FootBallModel filtrateWithCurrentBettingPlay:bettingPlay];
    if ([currentDatas count] >= 8 && ![FBTool.selectDatas containsObject:dataModel]) {
        [SVProgressHUD showInfoWithStatus:@"让球胜平负最多选择8场比赛"];
        return;
    }

    
    
    switch (indexPath.row)
    {
        case 0: /*主场*/
        {
            /*取相反属性，一下Bool属性为YES均为选中状态依据，不解释*/
            dataModel.rWin = !dataModel.rWin;
            if (dataModel.rWin)
            {
                cell.title.textColor = cell.text.textColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
            else
            {
                cell.title.textColor = [UIColor blackColor];
                cell.text.textColor = CustomBlack;
                cell.backgroundColor = [UIColor clearColor];
            }
        }
            break;
        case 1: /*平局*/
        {
            dataModel.rPin = !dataModel.rPin;
            if (dataModel.rPin)
            {
                cell.title.textColor = cell.text.textColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
            else
            {
                cell.title.textColor = [UIColor blackColor];
                cell.text.textColor = CustomBlack;
                cell.backgroundColor = [UIColor clearColor];
            }
        }
            break;
        case 2: /*客场*/
        {
            dataModel.rLose = !dataModel.rLose;
            if (dataModel.rLose)
            {
                cell.title.textColor = cell.text.textColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:YES]];
            }
            else
            {
                cell.title.textColor = [UIColor blackColor];
                cell.text.textColor = CustomBlack;
                cell.backgroundColor = [UIColor clearColor];
            }
        }
            break;
            
        default:
            break;
    }
    
    /*dataModel表示一场比赛，如果没有一个BOOL属性为YES，即表示该场比赛未投注*/
    if (dataModel.rWin || dataModel.rPin || dataModel.rLose)
    {
        /*如果其中一方有投注切之前‘FBTool.selectDatas’就存在这个model，就return,原因：之前已经添加过，这次只是修改属性*/
        if ([FBTool.selectDatas containsObject:dataModel])
        {
            
            return;
        }
        else
        {
//
            
            dataModel.play = bettingPlay;
            dataModel.endTime = _datas[@"end_time"];
            dataModel.datas = _datas;
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
    [_collectionView reloadData];
    [self setNeedsDisplay];

}
@end


@interface RQSFPView ()


@end


@implementation RQSFPView


- (void)setDatas:(id)datas bettingType:(FBBettingType)bettingType;
{
    
    _bettingType = bettingType;
   
    
    [super setDatas:datas bettingType:bettingType keyword:@"list_value2" predicateWithFormats:@[@"spfrq_single == '1'"]];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    RQSFPViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RQSFPViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.datas = _datas[indexPath.section][@"datas"][indexPath.row];
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
