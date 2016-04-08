//
//  BannerView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-19.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BannerView.h"
@interface QBluePageControl : UIPageControl
{
    UIImage *_activeImage;//（蓝色圆点图片）
    UIImage *_inactiveImage;//（白色圆点图片）
}

@end

@implementation QBluePageControl

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _activeImage = [UIImage imageNamed:@"icon_hover_pressed.png"];
        _inactiveImage = [UIImage imageNamed:@"icon_hover.png"];
    }
    return self;
}

- (void)updateDots
{
    for (int i = 0; i< [self.subviews count]; i++)
    {
        UIView* dot = [self.subviews objectAtIndex:i];
        CGSize size;
        size.height = _activeImage.size.height;     //自定义圆点的大小
        size.width = _activeImage.size.width;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        if (i == self.currentPage){
            dot.backgroundColor = [UIColor colorWithPatternImage:_activeImage];
        }
        else
            dot.backgroundColor = [UIColor colorWithPatternImage:_inactiveImage];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}
@end

@interface BannerView ()
<UIScrollViewDelegate>
{
    QBluePageControl *_pageControl;
    NSTimer *_bannerTimer;
}
@end

@implementation BannerView

- (void)dealloc
{
    [_bannerTimer invalidate];
    _bannerTimer = nil;
}


- (id)initWithSelect:(void(^)(id data))select;
{

    if ((self = [super initWithFrame:CGRectMake(0, -DeviceW / 3, DeviceW, DeviceW / 3)])) {
        self.delegate = self;
        
        _select = select;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = YES;
        self.contentSize = CGSizeMake(DeviceW, CGRectGetHeight(self.frame));
        
    }
    return self;
}


- (NSArray *)getData:(NSArray *)data
{
    if (data.count > 1)
    {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:data[data.count - 1]];
        for (NSDictionary *dic in data)
        {
            [arr addObject:dic];
        }
        [arr addObject:data[0]];
        return arr;
    }
    return data;
}

- (void)setData:(NSArray *)data
{
    
    _data = [self getData:data];
    
    for (int i = 0;i < _data.count; i ++)
    {
        NSDictionary *dic = _data[i];
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i * DeviceW, 0, DeviceW, CGRectGetHeight(self.frame))];
        view.tag = i;
        [view sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",serverUrl,dic[@"img_url"]] ] placeholderImage:[UIImage imageNamed:@"bk_5_2.png"]];
        NSLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",serverUrl,dic[@"img_url"]]]);
//        view.image = mImageByName(dic[@"image"]);
        view.userInteractionEnabled = YES;
        [self addSubview:view];
        self.contentSize = CGSizeMake(DeviceW * (i + 1), CGRectGetHeight(self.frame));
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)]];
    }
    
    if (_data.count == 1)
    {
        return;
    }
    _pageControl=[[QBluePageControl alloc]initWithFrame:CGRectMake(0, - 20, DeviceW , 20)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = _data.count - (_data.count > 1?2:0);
  
    [self.superview addSubview:_pageControl];
    
    self.contentOffset = CGPointMake(_data.count > 1?DeviceW:0, 0);

    if (_data.count >1) {
        _bannerTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollScrollView) userInfo:nil repeats:YES];
    }
}

- (void)scrollScrollView
{
    if (!self.window)return;
    [self setContentOffset:CGPointMake(self.contentOffset.x + DeviceW, 0) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    int currentPage = scrollView.contentOffset.x / DeviceW;
    [self changeCurrentPage:currentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    int currentPage = scrollView.contentOffset.x / DeviceW;

    [self changeCurrentPage:currentPage];
}

- (void)changeCurrentPage:(NSInteger )currentPage
{
    _pageControl.currentPage = currentPage - 1;
    
    
    if (currentPage == 0)
    {
        self.contentOffset = CGPointMake((_data.count - 2) * DeviceW , 0);
        _pageControl.currentPage = _data.count;
    }
     else if (currentPage == _data.count - 1)
    {
        self.contentOffset = CGPointMake( DeviceW , 0);
        _pageControl.currentPage= 0;
    }
}

- (void)setIsStop:(BOOL)isStop
{
    [_bannerTimer invalidate];
    _bannerTimer = nil;
    
    NSEnumerator *subviewsEnum = [self.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum)
    {
        [subview removeFromSuperview];
    }
    [_pageControl removeFromSuperview];
    _pageControl = nil;
}


- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    UIView *view = [gestureRecognizer view];
    _select(_data[view.tag]);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
