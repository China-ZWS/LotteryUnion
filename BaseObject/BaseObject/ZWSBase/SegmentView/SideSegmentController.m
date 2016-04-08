//
//  SideSegmentController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-30.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "SideSegmentController.h"
#import "SegmentBarItem.h"
#import "SegmentBar.h"
#define INDICATOR_HEIGHT 3
#define SEGMENT_BAR_HEIGHT 44

@interface SideSegmentController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) SegmentBar *segmentBar;
@property (nonatomic, strong) UIScrollView *slideView;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *indicatorBgView;

@property (nonatomic, strong) UICollectionViewFlowLayout *segmentBarLayout;

@end

@implementation SideSegmentController

- (id)initWithViewControllers:(NSArray *)viewControllers;
{
    if ((self = [super init]))
    {
        _viewControllers = viewControllers;
        _selectedIndex = NSNotFound;
        _titleColor = [UIColor whiteColor];
        _selectedTitleColor = [UIColor whiteColor];
        _lineColor = [UIColor blackColor];
    }
    return self;
}



#pragma mark - 初始化segmentBarLayout
- (UICollectionViewFlowLayout *)segmentBarLayout
{
    if (!_segmentBarLayout) {
        _segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
        _segmentBarLayout.itemSize = CGSizeMake(self.view.frame.size.width / _viewControllers.count, SEGMENT_BAR_HEIGHT);
        _segmentBarLayout.sectionInset = UIEdgeInsetsZero;
        _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentBarLayout.minimumLineSpacing = 0;
        _segmentBarLayout.minimumInteritemSpacing = 0;
    }
    return _segmentBarLayout;
}



#pragma mark - 初始化segmentBar
- (UICollectionView *)segmentBar
{
    if (!_segmentBar) {
        _segmentBar = [[SegmentBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SEGMENT_BAR_HEIGHT) collectionViewLayout:self.segmentBarLayout];
        _segmentBar.backgroundColor = [UIColor whiteColor];
        _segmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentBar.delegate = self;
        _segmentBar.dataSource = self;
    }
    return _segmentBar;
}

- (void)setSegmentBarFrame:(CGRect)segmentBarFrame
{
    _segmentBar.frame = segmentBarFrame;
    [_segmentBar setNeedsDisplay];
    _slideView.frame = CGRectMake(0, CGRectGetMaxY(segmentBarFrame) + 1, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(segmentBarFrame) + 1);
}

- (void)setBackgroudColor:(UIColor *)backgroudColor
{
    _segmentBar.backgroundColor = backgroudColor;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _indicatorBgView.backgroundColor = lineColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
}


- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    
}


#pragma mark - 初始化线条
- (UIView *)indicatorBgView
{
    if (!_indicatorBgView)
    {
        CGRect frame = CGRectMake(0, self.segmentBar.frame.size.height - INDICATOR_HEIGHT - 1,
                                  CGRectGetWidth(self.view.frame) / self.viewControllers.count, INDICATOR_HEIGHT);
        _indicatorBgView = [[UIView alloc] initWithFrame:frame];
        _indicatorBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _indicatorBgView.backgroundColor = [UIColor grayColor];
        [_indicatorBgView addSubview:self.indicator];
    }
    return _indicatorBgView;
}


#pragma mark - 初始化slideView
- (UIScrollView *)slideView
{
    if (!_slideView) {
        
        _slideView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_segmentBar.frame) + 1)];
        [_slideView setShowsHorizontalScrollIndicator:NO];
        _slideView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_slideView setShowsVerticalScrollIndicator:NO];
        [_slideView setPagingEnabled:YES];
//        _slideView setContentOffset:CGPointMake(-1, 0);
//        [_slideView setBounces:YES];
        [_slideView setDelegate:self];
    }
    return _slideView;
}


#pragma mark - 初始化组件
- (void)setupSubviews
{
    [self.view addSubview:self.segmentBar];
    [self.view addSubview:self.slideView];
    [_segmentBar registerClass:[SegmentBarItem class] forCellWithReuseIdentifier:@"title"];
    [_segmentBar addSubview:self.indicatorBgView];

}

#pragma mark - 初始化交互
- (void)reset
{
    _selectedIndex = NSNotFound;
    [self setSelectedIndex:0];
    [self scrollToViewWithIndex:0 animated:NO];
    UIViewController *toSelectController = [_viewControllers objectAtIndex:0];
    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:)]) {
        [_delegate slideSegment:_segmentBar didSelectedViewController:toSelectController];
    }

}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self reset];
    
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInslideSegment:)]) {
        return [_dataSource numberOfSectionsInslideSegment:collectionView];
    }
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:numberOfItemsInSection:)]) {
        return [_dataSource slideSegment:collectionView numberOfItemsInSection:section];
    }
    
    return _viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_dataSource respondsToSelector:@selector(slideSegment:cellForItemAtIndexPath:)]) {
        return [_dataSource slideSegment:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    
    SegmentBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"title" forIndexPath:indexPath];
    segmentBarItem.titleLabel.highlightedTextColor = _selectedTitleColor;
    segmentBarItem.titleLabel.textColor = _titleColor;
    if (_selectedIndex == indexPath.row) {
        segmentBarItem.titleLabel.highlighted = YES;
    }
    
    UIViewController *vc = _viewControllers[indexPath.row];
    segmentBarItem.titleLabel.text = vc.title;
    return segmentBarItem;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < 0 || indexPath.row >= _viewControllers.count) {
        return NO;
    }
    
    BOOL flag = YES;
    UIViewController *vc = _viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(slideSegment:shouldSelectViewController:)]) {
        flag = [_delegate slideSegment:collectionView shouldSelectViewController:vc];
    }
    return flag;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return;
    }
    
//    UIViewController *vc = self.viewControllers[indexPath.row];
//    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:)]) {
//        [_delegate slideSegment:collectionView didSelectedViewController:vc];
//    }
//    
    [self scrollToViewWithIndex:indexPath.row animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if (scrollView == self.slideView) {
        // set indicator frame
        CGRect frame = self.indicatorBgView.frame;
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        frame.origin.x = scrollView.frame.size.width * percent;
        _indicatorBgView.frame = frame;
        
//        NSInteger index = ceilf(percent * self.viewControllers.count);
        NSInteger index = round(percent * self.viewControllers.count);
        if (index >= 0 && index < self.viewControllers.count)
        {
            [self setSelectedIndex:index];
        }
    }
}


- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    
 
    if (_selectedIndex == selectedIndex) {
        return;
    }

    SegmentBarItem *newItem = (SegmentBarItem *)[_segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    newItem.titleLabel.highlighted = YES;
    
    SegmentBarItem *oldItem = (SegmentBarItem *)[_segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    oldItem.titleLabel.highlighted = NO;

    
    NSParameterAssert(selectedIndex >= 0 && selectedIndex < _viewControllers.count);
    
    UIViewController *toSelectController = [_viewControllers objectAtIndex:selectedIndex];
    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:)]) {
        [_delegate slideSegment:_segmentBar didSelectedViewController:toSelectController];
    }

    
    //    toSelectController.title
    // Add selected view controller as child view controller
    if (!toSelectController.parentViewController) {
        [self addChildViewController:toSelectController];
        CGRect rect = _slideView.bounds;
        rect.origin.x = rect.size.width * selectedIndex;
        toSelectController.view.frame = rect;
        [_slideView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];
    }
    [self.view endEditing:YES];
    _selectedIndex = selectedIndex;
}


- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;
{
    CGRect rect = _slideView.bounds;
    rect.origin.x = rect.size.width * index;
    [_slideView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGSize conentSize = CGSizeMake(self.view.frame.size.width * _viewControllers.count, 0);
    [_slideView setContentSize:conentSize];
    
//    for (SegmentBarItem *item in _segmentBar.visibleCells)
//    {
//        item.titleLabel.highlightedTextColor = _selectedTitleColor;
//        item.titleLabel.textColor = _titleColor;
//    }
    
//    SegmentBarItem *newItem = (SegmentBarItem *)[_segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
//    newItem.titleLabel.highlighted = YES;
}


- (void)refreshWithViews
{

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
