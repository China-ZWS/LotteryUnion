//
//  BallGroupContianView.m
//  ydtctz
//
//  Created by 小宝 on 1/11/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "BallGroupContianView.h"
#import "BallLineView.h"

@implementation BallGroupContianView
@synthesize format = _format;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10,0,mScreenWidth-20,mScreenHeight-200)];
        [self addSubview:_scrollView];
        
        //背景
        UIImage *ball_bg = [[UIImage imageNamed:@"ball_bg.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        UIImageView *bgview = [[UIImageView alloc] initWithImage:ball_bg];
        bgview.frame = CGRectMake(0,0,mScreenWidth-10,245.0);
        [self addSubview:bgview];
        
        self.backgroundColor = [UIColor clearColor];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)removeScrollView
{
    [_ballGroup removeAllObjects];
    [_scrollView removeFromSuperview];
}

- (NSArray *)getBallGroup
{
    return _ballGroup;
}

- (id)initWithFrame:(CGRect)frame ballGroup:(NSArray *)ballGroup
             format:(NSString *)format
{
    if ((self = [super initWithFrame:frame]))
    {
        self.format = format;
        _ballGroup = [ballGroup mutableCopy];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10,0,mScreenWidth-20,mScreenHeight-200)];
        [self addSubview:_scrollView];
        
        
        _scrollView.backgroundColor = [UIColor clearColor];
        [self drawBall:ballGroup format:_format];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame ballGroup:(NSArray *)ballGroup
{
    return [self initWithFrame:frame ballGroup:ballGroup format:@"02d"];
}

- (void)drawBall:(NSArray *)ballGroup format:(NSString *)format
{
    CGFloat varHeight = 0.0;
    
    [_scrollView removeAllSubviews];
    
    NSInteger count = [ballGroup count];
    for (int i = 0; i < count; i++)
    {
        NSArray *lineArray = [ballGroup objectAtIndex:i];
        NSMutableArray *redArray = [NSMutableArray array];
        NSMutableArray *blueArray = [NSMutableArray array];
        BOOL isBlueBall = NO;
        for (int j = 0; j < [lineArray count]; j++)
        {
            if ([[lineArray objectAtIndex:j] intValue] == -1)
            {
                isBlueBall = YES;
                continue;
            }
            
            if (isBlueBall)
            {
               [blueArray addObject:[lineArray objectAtIndex:j]];
            }
            
            else
            {
                 [redArray addObject:[lineArray objectAtIndex:j]];
            }
            
        }
        
        UIView *subView = [self getBallLine:redArray blueBall:blueArray format:format];
        subView.tag = 100 + i;
     
        //删除按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"dlt_delete"] forState:UIControlStateNormal];
        button.frame = CGRectMake(mScreenWidth-70,7.5,35.0,35.0);
        button.showsTouchWhenHighlighted = YES;
        button.tag = i;
        
        subView.frame = CGRectMake(-mScreenWidth,i*subView.height,mScreenWidth-10,50.0);
        
        [button addTarget:self action:@selector(removeSelectedLine:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:button];
        if (!disabledAnimation)
        {
           [self performSelector:@selector(setViewAnimation:) withObject:subView afterDelay:i * 0.2];
        }
        
        else
        {
           subView.frame = CGRectMake(0,i*subView.height,mScreenWidth-10,50.0);
        }

        varHeight += subView.height;
        [_scrollView addSubview:subView];
    }
    _scrollView.contentSize = CGSizeMake(0, varHeight+50);
}

- (void)setViewAnimation:(UIView *)subview
{
    CGRect newRect = subview.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    newRect.origin.x = 0;
    subview.frame = newRect;
    [UIView commitAnimations];
}

- (void)removeLine:(UIView *)subview
{
    CGRect newRect = subview.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    newRect.origin.x = mScreenWidth;
    subview.frame = newRect;
    [UIView commitAnimations];
}

#pragma mark -- 删除某一行
- (void)removeSelectedLine:(id)sender
{
    [_ballGroup removeObjectAtIndex:[sender tag]];
    if ([_target respondsToSelector:@selector(updateBatchView:)])
    {
       [_target performSelector:@selector(updateBatchView:) withObject:_ballGroup];
    }
    
    disabledAnimation = YES;
    for (UIView *subView in _scrollView.subviews) {
        if (subView.tag == [sender tag] + 100)
        {
           [self removeLine:subView];
        }
        
    }
    [self performSelector:@selector(redrawBall:) withObject:nil afterDelay:0.2];
}

- (void)redrawBall:(id)sender
{
    [self drawBall:_ballGroup format:_format];
}

- (UIView *)getBallLine:(NSArray *)redBall blueBall:(NSArray *)blueBall format:(NSString *)format
{
#pragma mark --  修改机选时的球高
    return [[BallLineView alloc] initWithFrame:CGRectMake(0.0,0.0,mScreenWidth-20.0,50.0) redBall:redBall blueBlue:blueBall format:format];
}

@end
