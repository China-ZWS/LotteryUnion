//
//  HHGGTwoCell.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "HHGGTwoCell.h"
#import "FootBallModel.h"
#import "PJCollectionViewCell.h"
#define backColorHighgeight(size) [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]]

@interface HHGGScoreOptionCell : PJCollectionViewCell

@end

@implementation HHGGScoreOptionCell


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

@interface HHGGTwoCell ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) UILabel *SLB;
@property (nonatomic) UILabel *PLB;
@property (nonatomic) UILabel *FLB;
@property (nonatomic) NSArray *optionDatas;
//@property (nonatomic) NSMutableArray *cacheDatas;
@end

@implementation HHGGTwoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor clearColor];
//        _cacheDatas = [NSMutableArray array];
        [self addSubview:self.title];
        [self addSubview:self.collectionView];
        [self addSubview:self.SLB];
        [self addSubview:self.PLB];
        [self addSubview:self.FLB];
    }
    return self;
}


- (UILabel *)SLB
{
    _SLB = [UILabel new];
    [_SLB getCornerRadius:0 borderColor:[UIColor whiteColor] borderWidth:LineWidth masksToBounds:YES];
    _SLB.backgroundColor = CustomRed;
    _SLB.text = @"主 胜";
    _SLB.textColor = [UIColor whiteColor];
    _SLB.textAlignment = NSTextAlignmentCenter;
    _SLB.numberOfLines = 2;
    _SLB.font = Font(13);
    return _SLB;
}

- (UILabel *)PLB
{
    
    _PLB = [UILabel new];
    [_PLB getCornerRadius:0 borderColor:[UIColor whiteColor] borderWidth:LineWidth masksToBounds:YES];
    _PLB.backgroundColor = RGBA(35, 161, 160, 1);
    _PLB.text = @"平";
    _PLB.textColor = [UIColor whiteColor];
    _PLB.textAlignment = NSTextAlignmentCenter;
    _PLB.numberOfLines = 2;
    _PLB.font = Font(13);
    return _PLB;
}

- (UILabel *)FLB
{
    _FLB = [UILabel new];
    [_FLB getCornerRadius:0 borderColor:[UIColor whiteColor] borderWidth:LineWidth masksToBounds:YES];
    _FLB.backgroundColor = RGBA(236, 161, 11, 1);
    _FLB.text = @"主 负";
    _FLB.textColor = [UIColor whiteColor];
    _FLB.textAlignment = NSTextAlignmentCenter;
    _FLB.numberOfLines = 2;
    _FLB.font = Font(13);
    return _FLB;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger row_S = ceil([_optionDatas[0] count] / 5.0);
    NSInteger row_P = ceil([_optionDatas[1] count] / 5.0);
    NSInteger row_F = ceil([_optionDatas[2] count] / 5.0);

    _collectionView.frame = CGRectMake(ScaleX(20), ScaleH(5), CGRectGetWidth(self.frame) - ScaleW(25), ScaleH(265));
    _SLB.frame = CGRectMake(ScaleW(5), CGRectGetMinY(_collectionView.frame), ScaleW(15), ScaleH(35) * row_S);
    _PLB.frame = CGRectMake(ScaleW(5), CGRectGetMaxY(_SLB.frame) + ScaleH(5), ScaleW(15), ScaleH(35) * row_P);
    _FLB.frame = CGRectMake(ScaleW(5), CGRectGetMaxY(_PLB.frame) + ScaleH(5), ScaleW(15), ScaleH(35) * row_F);
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
    [_collectionView registerClass:[HHGGScoreOptionCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = NO;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    return _collectionView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = (CGRectGetWidth(self.frame) - ScaleW(25)) / 5 ;
    
    if (indexPath.row == [_optionDatas[indexPath.section] count] - 1)
    {
        NSInteger num = [_optionDatas[indexPath.section] count] % 5 - 1;
        if (num < 0) {
            num = 4;
        }
        width = (CGRectGetWidth(self.frame) - ScaleW(25)) / 5 * (5 - num);
    }
    return CGSizeMake(width,ScaleH(35));
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _optionDatas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0); // header
    }
    return CGSizeMake(0, ScaleH(5)); // header
}


#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_optionDatas[section] count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    HHGGScoreOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.title.textColor = [UIColor blackColor];
    cell.abstracts.textColor = CustomBlack;
    cell.backgroundColor = [UIColor clearColor];

    cell.datas = _optionDatas[indexPath.section][indexPath.row];
   
    FBDatasModel *dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];

    NSDictionary *dic = _optionDatas[indexPath.section][indexPath.row];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"value_storage == %@",dic[@"value_storage"]];
    NSArray *same = [dataModel.scroes filteredArrayUsingPredicate:predicate];
  
    if (same.count) {
        cell.backgroundColor = backColorHighgeight(self.size);
        cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    HHGGScoreOptionCell *cell = (HHGGScoreOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];

    
    FBDatasModel *dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];
    if (!dataModel.scroes) {
        dataModel.scroes = [NSMutableArray array];
    }
    if ( dataModel.win || dataModel.pin || dataModel.lose || dataModel.rWin || dataModel.rPin || dataModel.rLose || dataModel.BQCDatas.count || dataModel.JQS_select_one || dataModel.JQS_select_two || dataModel.JQS_select_three || dataModel.JQS_select_four || dataModel.JQS_select_five || dataModel.JQS_select_six || dataModel.JQS_select_seven || dataModel.JQS_select_eight)
    {
        [SVProgressHUD showInfoWithStatus:@"一场比赛中，只允许选择一个玩法进行过关!"];
        return;
    }

    NSDictionary *dic = _optionDatas[indexPath.section][indexPath.row];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"value_storage == %@",dic[@"value_storage"]];
    NSArray *same = [dataModel.scroes filteredArrayUsingPredicate:predicate];
    
    
    if (same && same.count)
    {
        
        [dataModel.scroes removeObject:same[0]];
        cell.title.textColor = [UIColor blackColor];
        cell.abstracts.textColor = CustomBlack;
        cell.backgroundColor = [UIColor clearColor];
    }
    else
    {
        cell.backgroundColor = backColorHighgeight(self.size);
        cell.title.textColor = cell.abstracts.textColor = [UIColor whiteColor];
        [dataModel.scroes addObject:dic];
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
    _optionDatas = [self filtrate:datas[@"list_value3"]];
    [_collectionView reloadData];
}

- (NSArray *)filtrate:(NSArray *)datas
{
    
    NSMutableArray *Sdatas = [NSMutableArray array];
    NSMutableArray *Pdatas = [NSMutableArray array];
    NSMutableArray *Fdatas = [NSMutableArray array];
    
    NSDictionary *Sdic = [NSDictionary dictionary];
    NSDictionary *Pdic = [NSDictionary dictionary];
    NSDictionary *Fdic = [NSDictionary dictionary];
    
    for (NSDictionary *dic in datas)
    {
        
        NSInteger first = [[dic[@"value_storage"] substringToIndex:1] integerValue];
        NSInteger second = [[dic[@"value_storage"] substringFromIndex:1] integerValue];
        NSString *display = dic[@"value_display"];
        if (first > second && ![display isEqualToString:@"胜其他"]) {
            [Sdatas addObject:dic];
        }
        else if (first == second && ![display isEqualToString:@"平其他"])
        {
            [Pdatas addObject:dic];
        }
        else if (first < second && ![display isEqualToString:@"负其他"])
        {
            [Fdatas addObject:dic];
        }
        if ([display isEqualToString:@"胜其他"]) {
            Sdic = dic;
        }
        else if ([display isEqualToString:@"平其他"]) {
            Pdic = dic;
        }
        else if ([display isEqualToString:@"负其他"]) {
            Fdic = dic;
        }
        
    }
    
    Sdatas = [self getSortedArray:Sdatas result:NSOrderedDescending];
    Pdatas = [self getSortedArray:Pdatas result:NSOrderedDescending];
    Fdatas = [self getSortedArray:Fdatas result:NSOrderedDescending];
    [Sdatas addObject:Sdic];
    [Pdatas addObject:Pdic];
    [Fdatas addObject:Fdic];
    return @[Sdatas, Pdatas, Fdatas];
}

- (NSMutableArray *)getSortedArray:(NSArray *)items result:(NSComparisonResult)result
{
    return [NSMutableArray arrayWithArray:[items  sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                           {
                                               
                                               NSComparisonResult comparisonResult = [obj1[@"value_storage"] compare:obj2[@"value_storage"]];
                                               return comparisonResult == result;
                                           }]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
