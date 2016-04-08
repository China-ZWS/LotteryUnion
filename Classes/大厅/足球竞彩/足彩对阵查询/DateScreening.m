//
//  DateScreening.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "DateScreening.h"
#import "PJCollectionViewCell.h"
#import "FootBallModel.h"

@interface DateScreeningCell : PJCollectionViewCell

@end

@implementation DateScreeningCell

- (void)drawRect:(CGRect)rect
{
    [self drawWithChamferOfRectangle:rect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomBlack backgroundColor:[UIColor whiteColor]];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _title = [[UILabel alloc] initWithFrame:self.bounds];;
        _title.font = Font(13);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = CustomBlack;
        _title.highlightedTextColor = CustomRed;
        [self.contentView addSubview:_title];
    }
    return self;
}


- (void)setDatas:(id)datas
{
    _title.text = datas;
}

@end

@interface DateScreening ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) BOOL removeFromSuperViewOnHide;
@property (nonatomic) UIView *coverView;
@property (nonatomic) NSMutableArray *datas;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic, copy) void(^result)(NSString *dateString);


@end

@implementation DateScreening

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, (DeviceH - ScaleH(35) * 5) / 2, DeviceW, ScaleH(35) * 5)])) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (id)showCoverView:(UIWindow *)window
{
    DateScreening *view = [DateScreening new];
    [window addSubview:view.coverView];
    [window addSubview:view];
    return view;
}


+ (id)showWithResult:(void(^)(NSString *dateString))result
{
    DateScreening *view = [DateScreening showCoverView:[UIApplication sharedApplication].keyWindow];
    view.result = result;
    return view;
}

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

- (void)singleTap
{
    [DateScreening hideHUDForView];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.collectionView];
    
    self.datas = [self getDatas:[NSMutableArray array] index:0];


}

- (void)setDatas:(NSMutableArray *)datas
{
    _datas = datas;
    [UIView animateWithDuration:0.3f animations:^{
        _coverView.alpha = 0.5;
        self.alpha = 1.0;
    }];

    [_collectionView reloadData];
}

- (NSMutableArray *)getDatas:(NSMutableArray *)array index:(NSInteger)index
{
    [FBTool.formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[NSDate date];
    
    NSDateComponents *comp = [FBTool.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                         fromDate:date];
    NSInteger day = [comp day];
    [comp setDay:day  - index];
    NSDate *currentDate= [FBTool.calendar dateFromComponents:comp];
    NSString *dateString = [FBTool.formatter stringFromDate:currentDate];
    [array addObject:dateString];
    
    if (index == 19) {
        return  array;
    }
    
    return [self getDatas:array index:index + 1];
}


- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(DeviceW / 4,ScaleH(35));
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (UICollectionView *)collectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self segmentBarLayout]];
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[DateScreeningCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = NO;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    return _collectionView;
}


#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datas.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DateScreeningCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datas = _datas[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    _result(_datas[indexPath.row]);
    [DateScreening hideHUDForView];
}


+ (BOOL)hideHUDForView
{
    DateScreening *view = [self menuForView:[UIApplication sharedApplication].keyWindow];
    if (view != nil)
    {
        view.removeFromSuperViewOnHide = YES;
        [view hide];
        return YES;
    }
    return NO;
}


+ (DateScreening *)menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum)
    {
        if ([subview isKindOfClass:self])
        {
            return (DateScreening *)subview;
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
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
