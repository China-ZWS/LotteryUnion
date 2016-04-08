//
//  DropdownMenu.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "DropdownMenu.h"

#import "PJCollectionViewCell.h"

@interface MenuCell : PJCollectionViewCell
@end

@implementation MenuCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        _title = [UILabel new];
        _title.font = NFontBold(16);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.highlightedTextColor = [UIColor whiteColor];
        _title.textColor = CustomBlack;
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(kDefaultInset.left, kDefaultInset.top, CGRectGetWidth(self.frame) - kDefaultInset.right * 2, CGRectGetHeight(self.frame) - kDefaultInset.top * 2);

}

- (void)setDatas:(id)datas
{
    _title.text = datas[@"title"];
}

@end


@interface DropdownMenu ()
<UICollectionViewDataSource, UICollectionViewDelegate>
{
}
@property (nonatomic) NSArray *datas;
@property (nonatomic, copy) void(^select)(id datas);
@property (nonatomic, copy) void(^otherEvent)();
@property (assign) BOOL removeFromSuperViewOnHide;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIView *coverView;
@property (nonatomic) NSInteger index;
@end


@implementation DropdownMenu

- (void)dealloc
{
    
}


- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetMidY(rect)) end:CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect)) lineColor:CustomBlack lineWidth:.1];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetMaxX(rect) / 3, 0) end:CGPointMake(CGRectGetMaxX(rect) / 3, CGRectGetMaxY(rect)) lineColor:CustomBlack lineWidth:.1];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetMaxX(rect) / 3 * 2, 0) end:CGPointMake(CGRectGetMaxX(rect) / 3 * 2, CGRectGetMaxY(rect)) lineColor:CustomBlack lineWidth:.1];

}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DeviceW, 0)])) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutView];
    }
    return self;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;

    NSInteger row = ceil(_datas.count / 3.0f);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0, 0, DeviceW, row * 50);
        _collectionView.frame = CGRectMake(0, 0, DeviceW, row * 50);
        _coverView.alpha = 0.5;

    }];
}


+ (id)showCoverView:(UIView *)view
{
    DropdownMenu *menu = [DropdownMenu new];

    [view addSubview:menu.coverView];
    [view addSubview:menu];

    return menu;
}

+ (id)showMenu:(NSArray *)datas toView:(UIView *)toView index:(NSInteger)index select:(void(^)(id datas))select otherEvent:(void(^)())otherEvent;
{
    DropdownMenu *menu = [DropdownMenu showCoverView:toView];
    menu.datas = datas;
    menu.select = select;
    menu.otherEvent = otherEvent;
    menu.index = index;
    return menu;
}

+ (BOOL)hideHUDForView:(UIView *)view
{
    DropdownMenu *abnormal = [self menuForView:view];
    if (abnormal != nil) {
        abnormal.removeFromSuperViewOnHide = YES;
        [abnormal hide];
        return YES;
    }
    return NO;
}


+ (DropdownMenu *)menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (DropdownMenu *)subview;
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
         self.frame = CGRectMake(0, 0, DeviceW, 0);
         _coverView.alpha = 0;
     }completion:^(BOOL finished){
         [self removeFromSuperview];
         [_coverView removeFromSuperview];
         
     }];
    [self.superview bringSubviewToFront:self.coverView];
    [self.superview bringSubviewToFront:self];

}




- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = DeviceW / 3 ;
    segmentBarLayout.itemSize = CGSizeMake(width,50);
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}



- (void)layoutView
{
    
    [self addSubview:self.collectionView];

}

#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datas.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datas = _datas[indexPath.row];
    if (indexPath.row == _index) {
        cell.title.highlighted = YES;
        cell.title.backgroundColor = CustomRed;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_index == indexPath.row ) {
        return;
    }
    MenuCell *cell = (MenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.title.backgroundColor = CustomRed; // 修改点击背景颜色
    _select(_datas[indexPath.row]);
    self.removeFromSuperViewOnHide = YES;
    [self hide];
  
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:[self segmentBarLayout]];
        _collectionView.userInteractionEnabled = YES;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[MenuCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical  = NO;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
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
    _otherEvent();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
