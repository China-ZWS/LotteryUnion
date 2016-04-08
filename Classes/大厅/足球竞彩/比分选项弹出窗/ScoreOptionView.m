//
//  ScoreOptionView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/1.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "ScoreOptionView.h"
#import "PJCollectionViewCell.h"
@interface ScoreOptionCell : PJCollectionViewCell

@end

@implementation ScoreOptionCell

- (void)drawRect:(CGRect)rect
{
    [self drawWithChamferOfRectangle:rect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomBlack backgroundColor:[UIColor clearColor]];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        _title = [UILabel new];
        _title.font = Font(12);
        _title.highlightedTextColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        
        _abstracts = [UILabel new];
        _abstracts.highlightedTextColor = [UIColor whiteColor];
        _abstracts.font = Font(10);
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
    _title.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 - _title.font.lineHeight - ScaleH(1), CGRectGetWidth(self.frame), _title.font.lineHeight);
    _abstracts.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 + ScaleH(1), CGRectGetWidth(self.frame), _title.font.lineHeight);
}

- (void)setDatas:(id)datas
{
    _title.text = datas[@"value_display"];
    _abstracts.text = datas[@"odds"];
}
@end

@interface ScoreOptionView ()
<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *_optionDatas;
}

@property (nonatomic, copy) void(^finished)(id datas);
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *title;
@property (nonatomic) id datas;
@property (nonatomic) UIButton *cancel;
@property (nonatomic) UIButton *sure;
@property (assign) BOOL removeFromSuperViewOnHide;
@property (nonatomic) NSMutableArray *cacheDatas;
@property (nonatomic) UILabel *SLB;
@property (nonatomic) UILabel *PLB;
@property (nonatomic) UILabel *FLB;

@end

@implementation ScoreOptionView

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - ScaleH(35)) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - ScaleH(35)) lineColor:CustomBlack lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) - ScaleH(30)) end:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) - ScaleH(5)) lineColor:CustomBlack lineWidth:LineWidth];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake((DeviceW - ScaleW(290)) / 2, (DeviceH - ScaleH(265) - ScaleH(70)) / 2, ScaleW(290), ScaleH(265) + ScaleH(70))])) {
        self.backgroundColor = [UIColor whiteColor];
        [self getCornerRadius:5 borderColor:[UIColor clearColor] borderWidth:0 masksToBounds:YES];
    }
    return self;
    
}

+ (id)showCoverView:(UIWindow *)window
{
    ScoreOptionView *score = [ScoreOptionView new];
    [window addSubview:score.coverView];
    [window addSubview:score];
    return score;
}

+ (id)showWithDatas:(id)datas cacheDatas:(NSArray *)cacheDatas finished:(void(^)(id datas))finished;
{
    
    ScoreOptionView *score = [ScoreOptionView showCoverView:[UIApplication sharedApplication].keyWindow];
    score.datas = datas;
    score.finished = finished;
    score.cacheDatas = [NSMutableArray array];
    if (cacheDatas.count && cacheDatas)
    {
        [score.cacheDatas addObjectsFromArray:cacheDatas];
    }
    return score;
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    _optionDatas = [self filtrate:datas[@"list_value3"]];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.title];
    [self addSubview:self.collectionView];
    [self addSubview:self.cancel];
    [self addSubview:self.sure];
    [self addSubview:self.SLB];
    [self addSubview:self.PLB];
    [self addSubview:self.FLB];
    
    _coverView.alpha = 0.5;
    self.alpha = 1.0;
    
    [UIView animateWithDuration:0.3f animations:^{
     
        [UIView shakeToShow:self duration:.3f];
    }];

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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(ScaleX(20), ScaleY(35), CGRectGetWidth(self.frame) - ScaleW(25), ScaleH(265)) collectionViewLayout:[self segmentBarLayout]];
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[ScoreOptionCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = NO;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    dispatch_async(dispatch_get_main_queue(), ^{

    for (NSDictionary *dic in _cacheDatas)
    {
        [_collectionView selectItemAtIndexPath:dic[@"indexPath"] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    });
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
    ScoreOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datas = _optionDatas[indexPath.section][indexPath.row];
    NSDictionary *dic = _optionDatas[indexPath.section][indexPath.row];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"value_storage == %@",dic[@"value_storage"]];
    NSArray *same = [_cacheDatas filteredArrayUsingPredicate:predicate];

    if (same.count) {
        cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:YES]];
        cell.title.highlighted = cell.abstracts.highlighted = YES;

    }
    else
    {
        cell.title.highlighted = cell.abstracts.highlighted = NO;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    ScoreOptionCell *cell = (ScoreOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.title.highlighted = cell.abstracts.highlighted = YES;
    cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:YES]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_optionDatas[indexPath.section][indexPath.row]];
    dic[@"indexPath"] = indexPath;
    [_cacheDatas addObject:dic];

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreOptionCell *cell = (ScoreOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.title.highlighted = cell.abstracts.highlighted = NO;
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = _optionDatas[indexPath.section][indexPath.row];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"value_storage == %@",dic[@"value_storage"]];
    NSArray *same = [_cacheDatas filteredArrayUsingPredicate:predicate];

    if (same && same.count)
    {
        [_cacheDatas removeObject:same[0]];
    }
}


- (UILabel *)SLB
{

    NSInteger row = ceil([_optionDatas[0] count] / 5.0);
    _SLB = [[UILabel alloc] initWithFrame:CGRectMake(ScaleW(5), CGRectGetMinY(_collectionView.frame), ScaleW(15), ScaleH(35) * row)];
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
    
    NSInteger row = ceil([_optionDatas[1] count] / 5.0);
    _PLB = [[UILabel alloc] initWithFrame:CGRectMake(ScaleW(5), CGRectGetMaxY(_SLB.frame) + ScaleH(5), ScaleW(15), ScaleH(35) * row)];
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
    NSInteger row = ceil([_optionDatas[2] count] / 5.0);
    _FLB = [[UILabel alloc] initWithFrame:CGRectMake(ScaleW(5), CGRectGetMaxY(_PLB.frame) + ScaleH(5), ScaleW(15), ScaleH(35) * row)];
    [_FLB getCornerRadius:0 borderColor:[UIColor whiteColor] borderWidth:LineWidth masksToBounds:YES];
    _FLB.backgroundColor = RGBA(236, 161, 11, 1);
    _FLB.text = @"主 负";
    _FLB.textColor = [UIColor whiteColor];
    _FLB.textAlignment = NSTextAlignmentCenter;
    _FLB.numberOfLines = 2;
    _FLB.font = Font(13);
    return _FLB;
}


- (UIButton *)cancel
{
    _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel.frame = CGRectMake(0, CGRectGetHeight(self.frame) - ScaleH(35), CGRectGetWidth(self.frame) / 2, ScaleH(35));
    [_cancel setTitle:@"取 消" forState:UIControlStateNormal];
    [_cancel setTitleColor:CustomBlack forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(eventWithCancel) forControlEvents:UIControlEventTouchUpInside];
    _cancel.titleLabel.font = Font(14);
    return _cancel;
}

- (UIButton *)sure
{
    _sure = [UIButton buttonWithType:UIButtonTypeCustom];
    _sure.frame = CGRectMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - ScaleH(35), CGRectGetWidth(self.frame) / 2, ScaleH(35));
    [_sure setTitle:@"确 定" forState:UIControlStateNormal];
    [_sure setTitleColor:CustomBlack forState:UIControlStateNormal];
    [_sure addTarget:self action:@selector(eventWithSure) forControlEvents:UIControlEventTouchUpInside];
    _sure.titleLabel.font = Font(14);
    return _sure;
}

- (UILabel *)title
{
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), ScaleH(35))];
    _title.font = FontBold(15);
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = [UIColor blackColor];
    NSString *title = [NSString stringWithFormat:@"%@ VS %@",_datas[@"host_team"],_datas[@"guest_team"]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([_datas[@"host_team"] length] + 1, 2)];
    [attrString addAttribute:NSFontAttributeName value:Font(11) range:NSMakeRange([_datas[@"host_team"] length] + 1, 2)];
    _title.attributedText = attrString;
    return _title;
}

- (UIView *)coverView
{
    if (!_coverView)
    {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)];
        _coverView.backgroundColor = RGBA(20, 20, 20, 1);
        _coverView.alpha = 0;
    }
    return _coverView;
}


#pragma mark - 取消
- (void)eventWithCancel
{
    _removeFromSuperViewOnHide = YES;
    [self hide];
}

#pragma mark - 确定
- (void)eventWithSure
{
    _removeFromSuperViewOnHide = YES;
    [self hide];
    _finished(_cacheDatas);
}


+ (BOOL)hideHUDForView
{
    ScoreOptionView *score = [self menuForView:[UIApplication sharedApplication].keyWindow];
    if (score != nil)
    {
        score.removeFromSuperViewOnHide = YES;
        [score hide];
        return YES;
    }
    return NO;
}


+ (ScoreOptionView *)menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum)
    {
        if ([subview isKindOfClass:self])
        {
            return (ScoreOptionView *)subview;
        }
    }
    return nil;
    
}


- (void)hide
{
    if (_removeFromSuperViewOnHide)
        _removeFromSuperViewOnHide = NO;
    
    [UIView animateWithDuration:.3f animations:^
     {
         _coverView.alpha = 0;
         self.alpha = 0;
     }completion:^(BOOL finished){
         [self removeFromSuperview];
         [_coverView removeFromSuperview];
         
     }];
    [self.superview bringSubviewToFront:self.coverView];
    [self.superview bringSubviewToFront:self];
}

@end
