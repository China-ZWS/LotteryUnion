//
//  JQSView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJCollectionViewCell.h"
#import "JQSView.h"

static FBBettingType _bettingType;

@interface JQSCollectionCell : PJCollectionViewCell
{
    UILabel *_text;
}
@end

@implementation JQSCollectionCell
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
    
    /*数据筛选*/
    FBDatasModel *dataModel = nil;
    /*判断是单场投注还是过关投注*/
    if (_bettingType == kSingle)
    {
        dataModel = [FootBallModel filtrateWithBettingDatas:datas play:kJQS_one];
    }
    else
    {
        dataModel = [FootBallModel filtrateWithBettingDatas:datas play:kJQS_two];
    }
    
 
    switch (index) {
        case 0:
        {
            if (dataModel.JQS_select_one)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }

        }
            break;
        case 1:
        {
            if (dataModel.JQS_select_two)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }

        }
            break;
        case 2:
        {
            if (dataModel.JQS_select_three)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }

        }
            break;
        case 3:
        {
            if (dataModel.JQS_select_four)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }

        }
            break;
        case 4:
        {
            if (dataModel.JQS_select_five)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }

        }
            break;
        case 5:
        {
            if (dataModel.JQS_select_six)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }

        }
            break;
        case 6:
        {
            if (dataModel.JQS_select_seven)
            {
                self.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
                selectedColor = selectColor = [UIColor whiteColor];
            }

        }
            break;
        case 7:
        {
            if (dataModel.JQS_select_eight)
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
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, [dic[@"value_display"] length])];

    [attrString addAttribute:NSFontAttributeName value:Font(11) range:NSMakeRange(attrString.length - [dic[@"odds"] length], [dic[@"odds"] length])];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:selectColor range:NSMakeRange(attrString.length - [dic[@"odds"] length], [dic[@"odds"] length])];

    _title.attributedText = attrString;
}

@end


@interface JQSViewCell : BaseTypeCell
<UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation JQSViewCell


- (void)drawRect:(CGRect)rect
{
    CGFloat minX = ScaleH(85);
    CGFloat minY = (CGRectGetHeight(rect) - ScaleH(25) - ScaleH(65)) / 2 + ScaleH(25);
    CGFloat maxX = minX + ScaleW(210);
    CGFloat maxY = minY + ScaleH(65);
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(maxX, minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX, (maxY - minY) / 2 + minY) end:CGPointMake(maxX, (maxY - minY) / 2 + minY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX, maxY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    
    [self drawRectWithLine:rect start:CGPointMake(minX, minY) end:CGPointMake(minX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(maxX, minY) end:CGPointMake(maxX, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 4, minY) end:CGPointMake(minX + ScaleW(210) / 4, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 2, minY) end:CGPointMake(minX + ScaleW(210) / 2, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(minX + ScaleW(210) / 4 * 3, minY) end:CGPointMake(minX + ScaleW(210) / 4 * 3, maxY) lineColor:CustomSkyblue lineWidth:LineWidth];

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        [self.contentView addSubview:_title];

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
    
    _title.frame = CGRectMake(_leagueNameLb.right + ScaleW(10), (ScaleH(25) - _title.font.lineHeight + (ScaleH(85) - ScaleH(65)) / 2) / 2 , ScaleH(210), _title.font.lineHeight);

    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(ScaleH(85) , (ScaleH(85) - ScaleH(65)) / 2 + ScaleH(25), ScaleH(210), ScaleH(65)) collectionViewLayout:[self segmentBarLayout]];
        _collectionView.scrollEnabled = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[JQSCollectionCell   class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
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
    JQSCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDatas:_datas index:indexPath.row];
    return cell;
}

#pragma mark - 选中和取消写在一起，是没有办法的办法allowsMultipleSelection 配合 didDeselectItemAtIndexPath与reloadData冲突，只能写在一起。
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JQSCollectionCell *cell = (JQSCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
   
    cell.backgroundColor = [UIColor clearColor];
    UIColor *selectColor = CustomBlack;
    UIColor *selectedColor = [UIColor blackColor];
    
    FBBettingPlay bettingPlay = NSNotFound;
    /*数据筛选*/
    FBDatasModel *dataModel = nil;
    /*判断是单场投注还是过关投注*/
    if (_bettingType == kSingle)
    {
        dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kJQS_one];
        bettingPlay = kJQS_one;
    }
    else
    {
        dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kJQS_two];
        bettingPlay = kJQS_two;
    }
    
    NSArray *currentDatas = [FootBallModel filtrateWithCurrentBettingPlay:bettingPlay];
    if ([currentDatas count] >= 6 && ![FBTool.selectDatas containsObject:dataModel]) {
        [SVProgressHUD showInfoWithStatus:@"投注进球数最多选择6场"];
        return;
    }

    
    
    switch (indexPath.row)
    {
        case 0: /*进一个球*/
        {
            /*取相反属性，一下Bool属性为YES均为选中状态依据，不解释*/
            dataModel.JQS_select_one = !dataModel.JQS_select_one;
            if (dataModel.JQS_select_one)
            {
                selectedColor = selectColor = [UIColor whiteColor];
                
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
            }
        }
            break;
        case 1: /*进2个球*/
        {
            dataModel.JQS_select_two = !dataModel.JQS_select_two;
            if (dataModel.JQS_select_two)
            {
                selectedColor = selectColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
            }
        }
            break;
        case 2: /*进3个球*/
        {
            dataModel.JQS_select_three = !dataModel.JQS_select_three;
            if (dataModel.JQS_select_three)
            {
                selectedColor = selectColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
            }
        }
            break;
        case 3: /*进4个球*/
        {
            dataModel.JQS_select_four = !dataModel.JQS_select_four;
            if (dataModel.JQS_select_four)
            {
                selectedColor = selectColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
            }
        }
            break;
        case 4: /*进5个球*/
        {
            dataModel.JQS_select_five = !dataModel.JQS_select_five;
            if (dataModel.JQS_select_five)
            {
                selectedColor = selectColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
            }
        }
            break;
        case 5: /*进6个球*/
        {
            dataModel.JQS_select_six = !dataModel.JQS_select_six;
            if (dataModel.JQS_select_six)
            {
                selectedColor = selectColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
            }
          }
            break;
        case 6: /*进6个球*/
        {
            dataModel.JQS_select_seven = !dataModel.JQS_select_seven;
            if (dataModel.JQS_select_seven)
            {
                selectedColor = selectColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
            }
         }
            break;
        case 7: /*进6个球*/
        {
            dataModel.JQS_select_eight = !dataModel.JQS_select_eight;
            if (dataModel.JQS_select_eight)
            {
                selectedColor = selectColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomSkyblue hasCenterLine:NO]];
            }
        }
            break;

        default:
            break;
    }
    
    NSArray *list_value5 = _datas[@"list_value5"];
   
    NSDictionary *dic = list_value5[indexPath.row];
  
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",dic[@"value_display"],dic[@"odds"]]];
   
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, [dic[@"value_display"] length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:selectedColor range:NSMakeRange(0, [dic[@"value_display"] length])];

    
    [attrString addAttribute:NSFontAttributeName value:Font(11) range:NSMakeRange(attrString.length - [dic[@"odds"] length], [dic[@"odds"] length])];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:selectColor range:NSMakeRange(attrString.length - [dic[@"odds"] length], [dic[@"odds"] length])];
    cell.title.attributedText = attrString;

    
    
    
    /*dataModel表示一场比赛，如果没有一个BOOL属性为YES，即表示该场比赛未投注*/
    if (dataModel.JQS_select_one || dataModel.JQS_select_two || dataModel.JQS_select_three || dataModel.JQS_select_four || dataModel.JQS_select_five || dataModel.JQS_select_six || dataModel.JQS_select_seven || dataModel.JQS_select_eight)
    {
        /*如果其中一方有投注切之前‘FBTool.selectDatas’就存在这个model，就return,原因：之前已经添加过，这次只是修改属性*/
        if ([FBTool.selectDatas containsObject:dataModel])
        {
            
            return;
        }
        else
        {
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
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ vs %@",datas[@"host_team"],datas[@"guest_team"]]];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, [datas[@"host_team"] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(attrString.length - [datas[@"guest_team"] length], [datas[@"guest_team"] length])];
    _title.attributedText = attrString;

}


@end

@interface JQSView ()
@end


@implementation JQSView

- (void)setDatas:(id)datas bettingType:(FBBettingType)bettingType;
{
    _bettingType = bettingType;
  [super setDatas:datas bettingType:bettingType keyword:@"list_value5" predicateWithFormats:@[@"zjq_single == '1'"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(85) + ScaleH(25);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    JQSViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[JQSViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
