//
//  HHGGFourCell.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "HHGGFourCell.h"
#import "FootBallModel.h"
#import "PJCollectionViewCell.h"
#define backColorHighgeight(size) [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]]


@interface HHGGJQSOptionCell : PJCollectionViewCell

@end

@implementation HHGGJQSOptionCell
- (void)drawRect:(CGRect)rect
{
    
    [self drawWithChamferOfRectangle:rect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomBlack backgroundColor:[UIColor clearColor]];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 - _title.font.lineHeight, CGRectGetWidth(self.frame), _title.font.lineHeight);
    _abstracts.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame), _title.font.lineHeight);
}

- (void)setDatas:(id)datas
{
    _title.text = datas[@"value_display"];
    _abstracts.text = datas[@"odds"];
    
    
}


@end

@interface HHGGFourCell ()
<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) NSArray *optionDatas;
@end

@implementation HHGGFourCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _title.frame = CGRectMake(ScaleW(5), ScaleY(5), ScaleW(15), ScaleH(70));
    _collectionView.frame = CGRectMake(CGRectGetMaxX(_title.frame), CGRectGetMinY(_title.frame), CGRectGetWidth(self.frame) - ScaleW(25), ScaleH(70));
}

- (UILabel *)title
{
    _title = [UILabel new];
    [_title getCornerRadius:0 borderColor:[UIColor whiteColor] borderWidth:LineWidth masksToBounds:YES];
    _title.backgroundColor = CustomSkyblue;
    _title.text = @"进球数";
    _title.numberOfLines = 0;
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = Font(13);
    return _title;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (UICollectionView *)collectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self segmentBarLayout]];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[HHGGJQSOptionCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = NO;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    return _collectionView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = (CGRectGetWidth(self.frame) - ScaleW(25)) / 4 ;
    
    if (indexPath.row == _optionDatas.count - 1)
    {
        NSInteger num = _optionDatas.count % 4 - 1;
        if (num < 0) {
            num = 3;
        }
        width = (CGRectGetWidth(self.frame) - ScaleW(25)) / 4 * (4 - num);
    }
    return CGSizeMake(width,ScaleH(35));
}


#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _optionDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHGGJQSOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.title.textColor = [UIColor blackColor];
    cell.abstracts.textColor = CustomBlack;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.datas = _optionDatas[indexPath.row];
    
    FBDatasModel *dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];
    switch (indexPath.row) {
        case 0:
            if (dataModel.JQS_select_one)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }
            break;
        case 1:
            if (dataModel.JQS_select_two)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }

            break;
        case 2:
            if (dataModel.JQS_select_three)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }

            break;
        case 3:
            if (dataModel.JQS_select_four)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }

            break;
        case 4:
            if (dataModel.JQS_select_five)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }

            break;
        case 5:
            if (dataModel.JQS_select_six)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }

            break;
        case 6:
            if (dataModel.JQS_select_seven)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }

            break;
        case 7:
            if (dataModel.JQS_select_eight)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }

            break;
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    HHGGJQSOptionCell *cell = (HHGGJQSOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.title.textColor = [UIColor blackColor];
    cell.abstracts.textColor = CustomBlack;
    cell.backgroundColor = [UIColor clearColor];

    
    FBDatasModel *dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];
    if ( dataModel.win || dataModel.pin || dataModel.lose || dataModel.rWin || dataModel.rPin || dataModel.rLose || dataModel.scroes.count || dataModel.BQCDatas.count)
    {
        [SVProgressHUD showInfoWithStatus:@"一场比赛中，只允许选择一个玩法进行过关!"];
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
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }
        }
            break;
        case 1: /*进2个球*/
        {
            dataModel.JQS_select_two = !dataModel.JQS_select_two;
            if (dataModel.JQS_select_two)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);

            }
        }
            break;
        case 2: /*进3个球*/
        {
            dataModel.JQS_select_three = !dataModel.JQS_select_three;
            if (dataModel.JQS_select_three)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);

            }
        }
            break;
        case 3: /*进4个球*/
        {
            dataModel.JQS_select_four = !dataModel.JQS_select_four;
            if (dataModel.JQS_select_four)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);

            }
        }
            break;
        case 4: /*进5个球*/
        {
            dataModel.JQS_select_five = !dataModel.JQS_select_five;
            if (dataModel.JQS_select_five)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);

            }
        }
            break;
        case 5: /*进6个球*/
        {
            dataModel.JQS_select_six = !dataModel.JQS_select_six;
            if (dataModel.JQS_select_six)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }
        }
            break;
        case 6: /*进6个球*/
        {
            dataModel.JQS_select_seven = !dataModel.JQS_select_seven;
            if (dataModel.JQS_select_seven)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);

            }
        }
            break;
        case 7: /*进6个球*/
        {
            dataModel.JQS_select_eight = !dataModel.JQS_select_eight;
            if (dataModel.JQS_select_eight)
            {
                cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
                cell.backgroundColor = backColorHighgeight(self.size);
            }
        }
            break;
            
        default:
            break;
    }
    
    /*dataModel表示一场比赛，如果没有一个BOOL属性为YES，即表示该场比赛未投注*/
    if (dataModel.win || dataModel.pin ||dataModel.lose || dataModel.rWin || dataModel.rPin || dataModel.rLose || dataModel.scroes.count || dataModel.BQCDatas.count || dataModel.JQS_select_one || dataModel.JQS_select_two || dataModel.JQS_select_three || dataModel.JQS_select_four || dataModel.JQS_select_five || dataModel.JQS_select_six || dataModel.JQS_select_seven || dataModel.JQS_select_eight)
    {
        
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
    _optionDatas = datas[@"list_value5"];
    [_collectionView reloadData];
}



@end
