//
//  FBPassToChooseView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/10.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "FBPassToChooseView.h"

#import "PJCollectionViewCell.h"

@interface FBPassToChooseCell : PJCollectionViewCell
@end

@implementation FBPassToChooseCell



- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _title.font = Font(14);
        _title.backgroundColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)setDatas:(id)datas
{
     _title.text = datas[@"title"];
}


@end

#define moreHeight ScaleH(25)

@interface FBPassToChooseView ()
<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *_puckerArray;
}
@property (nonatomic) id datas;
@property (nonatomic, copy) void(^select)(id datas);
@property (nonatomic, copy) void(^otherEvent)();
@property (assign) BOOL removeFromSuperViewOnHide;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIView *coverView;
@property (nonatomic) NSMutableArray *cacheDatas;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UILabel *infoView;
@end

@implementation FBPassToChooseView

#pragma mark - 创建coverView
- (UIView *)coverView
{
    if (!_coverView)
    {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)];
        _coverView.backgroundColor = RGBA(20, 20, 20, 1);
        _coverView.alpha = 0;
        /*给_coverView添加一个手势监测*/
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)]];
    }
    return _coverView;
}

- (UILabel *)infoView
{
    if (!_infoView) {
        _infoView = [[UILabel alloc] initWithFrame:CGRectMake(ScaleW(80), ScaleH(15), DeviceW - ScaleW(85), Font(14).lineHeight)];
        _infoView.textAlignment = NSTextAlignmentRight;
        _infoView.textColor = CustomBlack;
        _infoView.font = Font(14);
    }
    return _infoView;
}

#pragma mark - cover单击事件
- (void)singleTap
{
    _otherEvent();
    _otherEvent = nil;
}



- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(CGRectGetWidth(rect), 0) lineColor:CustomBlack lineWidth:LineWidth];
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if ((self = [super initWithFrame:frame collectionViewLayout:layout])) {
        self.backgroundColor = NavColor;
        [self registerClass:[FBPassToChooseCell class] forCellWithReuseIdentifier:@"cell"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.infoView];
}

+ (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (DeviceW - ScaleW(50)) / 4 ;
    segmentBarLayout.itemSize = CGSizeMake(width,ScaleH(30));
    segmentBarLayout.sectionInset = UIEdgeInsetsMake(ScaleW(10), ScaleW(10), ScaleW(10), ScaleW(10));
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


+ (FBPassToChooseView *)showCoverView:(UIView *)toView
{
    FBPassToChooseView *chooseView = [[FBPassToChooseView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(toView.frame), toView.width, 0) collectionViewLayout:[self segmentBarLayout]];
    [toView addSubview:chooseView];
    [toView.superview insertSubview:chooseView.coverView belowSubview:toView];
    return chooseView;
}

+ (id)showMenu:(id)datas toView:(UIView *)toView chooseDatas:(NSMutableArray *)chooseDatas select:(void(^)(id datas))select otherEvent:(void(^)())otherEvent;
{
    FBPassToChooseView *chooseView = [self showCoverView:toView];
    chooseView.datas = datas;
    chooseView.select = select;
    chooseView.otherEvent = otherEvent;
    chooseView.cacheDatas = chooseDatas;
    return chooseView;
}

+ (BOOL)hideHUDForView:(UIView *)view
{
    FBPassToChooseView *abnormal = [self menuForView:view];
    if (abnormal != nil) {
        abnormal.removeFromSuperViewOnHide = YES;
        [abnormal hide];
        return YES;
    }
    return NO;
}



+ (FBPassToChooseView *)menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (FBPassToChooseView *)subview;
        }
    }
    return nil;
}





- (void)show
{
    NSInteger row = 0;
    CGFloat height = 0;
    row = ceil([_datas[@"bettings1"] count] / 4.0f);
    height = row * ScaleH(40) + ScaleH(10) + ([_datas[@"bettings2"] count]?(moreHeight+ ScaleH(20)):0);
    
    [UIView animateWithDuration:0.3f animations:^{
        self.superview.transform = CGAffineTransformMakeTranslation(0,-height);
        self.superview.height = height + 44;
        self.height = height;
        _coverView.alpha = 0.5;
    }];
}

- (void)showMore
{
    NSInteger row = 0;
    CGFloat height = 0;
    row = ceil([_datas[@"bettings1"] count] / 4.0f) + ceil([_datas[@"bettings2"] count] / 4.0f);
    height = row * ScaleH(40) + ScaleH(10) + ([_datas[@"bettings2"] count]?(moreHeight+ ScaleH(20)):0);
    if (height > (DeviceH - ScaleH(120))) {
        return;
    }
    self.superview.height = height + 44;
    self.height = height + 44;
    [UIView animateWithDuration:0.3f animations:^{
        self.superview.transform = CGAffineTransformMakeTranslation(0,-height);
    }];

}


- (void)hide
{
    if (_removeFromSuperViewOnHide)
        _removeFromSuperViewOnHide = NO;
    
    [UIView animateWithDuration:.3f animations:^
     {
         self.superview.transform = CGAffineTransformIdentity;
         _coverView.alpha = 0;
     }completion:^(BOOL finished){
         self.superview.height = 44;
         self.height = 0;
         [self removeFromSuperview];
         [_coverView removeFromSuperview];
     }];
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    [self show];
    [self makePuckerArray];
}

#pragma mark - 折点数组初始化
-(void)makePuckerArray
{
    if (!_puckerArray)
    {
        _puckerArray = [NSMutableArray array];
    }
    else if (_puckerArray.count)
    {
        return;
    }
    for (int i = 0;i < [_datas count];i++) {
        NSNumber *number = [NSNumber numberWithBool:NO];
        [_puckerArray addObject:number];
    }
}

- (void)puckerTouches:(UIButton *)button
{
    NSNumber *number = [_puckerArray objectAtIndex:button.tag];
    if ([number boolValue]) {
        [self show];
    }
    else
    {
        [self showMore];
    }

    [_puckerArray replaceObjectAtIndex:button.tag withObject:[NSNumber  numberWithBool:![number boolValue]]];
    [self reloadSections:[NSIndexSet indexSetWithIndex:button.tag]];
}

#pragma mark - collectionView delegate, dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
     return [_datas count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.backgroundColor = NavColor;
    UIButton *btn = (UIButton *)[headerView viewWithTag:indexPath.section];
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"jczq_arrow_red_down.png"];
        btn.frame = CGRectMake(0, 0, 100, ScaleH(25));
        [btn setTitle:@"更多玩法" forState:UIControlStateSelected];
        [btn setTitle:@"收起更多" forState:UIControlStateNormal];
        btn.titleLabel.font = FontBold(15);
        btn.tag = indexPath.section;
        [btn setTitleColor:CustomBlue forState:UIControlStateNormal];
        [btn setImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(puckerTouches:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
    }
    
    NSNumber *number = [_puckerArray objectAtIndex:indexPath.section];
   
    if ([number boolValue])
    {
        btn.imageView.transform = CGAffineTransformIdentity;
        btn.selected = NO;
    }
    else
    {
        btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        btn.selected = YES;
    }
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
   
    if (section == 0)
    {
        return CGSizeMake(0, 0);
    }
    else if (section == 1)
    {
//        判断串多有没有数据，有就返回25的高度
        if ([_datas[@"bettings2"] count]) {
            return CGSizeMake(0, moreHeight); // header
        }

    }
    return CGSizeMake(0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_datas[@"bettings1"] count];
    }
    else if (section == 1)
    {
        NSNumber *number = [_puckerArray objectAtIndex:section];
        if (![number boolValue]) {
            return 0;
        }
        return [_datas[@"bettings2"] count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FBPassToChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  
    NSDictionary *datas = nil;
    if (indexPath.section == 0) {
        
       datas = _datas[@"bettings1"][indexPath.row];
    }
    else
    {
        datas = _datas[@"bettings2"][indexPath.row];
    }
    
    cell.datas = datas;
    if ([_cacheDatas containsObject:datas]) {
        [cell getCornerRadius:5 borderColor:CustomRed borderWidth:1 masksToBounds:YES];
        cell.title.textColor = CustomRed;
    }
    else
    {
        [cell getCornerRadius:5 borderColor:CustomGray borderWidth:.5 masksToBounds:YES];
        cell.title.textColor = [UIColor blackColor];
    }


    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *datas = nil;
    if (indexPath.section == 0) {
        BOOL hasIntersection = [self arr1:_cacheDatas arr2:_datas[@"bettings1"]];
        if (!hasIntersection && _cacheDatas.count) {
            [_cacheDatas removeAllObjects];
        }
        datas = _datas[@"bettings1"][indexPath.row];
    }
    else
    {
        if (![_indexPath isEqual: indexPath]) {
            [_cacheDatas removeAllObjects];
        }
        datas = _datas[@"bettings2"][indexPath.row];
    }
    
    _indexPath = indexPath;
  
    if ([_cacheDatas containsObject:datas]) {
        return;
    }
    else
    {
        [_cacheDatas addObject:datas];
    }
    [self reloadData];
    
    _select(_cacheDatas);
}


- (BOOL)arr1:(NSArray *)arr1 arr2:(NSArray *)arr2
{
    BOOL hasIntersection = NO;
    for (NSDictionary *dic in arr1)
    {
        if ([arr2 containsObject:dic]) {
            hasIntersection = YES;
            break;
        }
    }
    return hasIntersection;
}

+ (void)setInfoText:(NSString *)text toView:(UIView *)toView;
{
    FBPassToChooseView *chooseView = [self menuForView:toView];
    chooseView.infoView.text = text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
