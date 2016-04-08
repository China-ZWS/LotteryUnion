//
//  BaseScrollView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseScrollView.h"

@implementation BaseScrollView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)setScrollHeaderView:(UIView *)scrollHeaderView
{
    if (![scrollHeaderView isEqual: _scrollHeaderView]) {
        [_scrollHeaderView removeFromSuperview];
        _scrollHeaderView = nil;
        _scrollHeaderView = scrollHeaderView;
        [self addSubview:scrollHeaderView];
    }
}

- (void)setScrollFooterView:(UIView *)scrollFooterView
{
    if (scrollFooterView != _scrollFooterView) {
        [_scrollFooterView removeFromSuperview];
        _scrollFooterView = nil;
        [self addSubview:scrollFooterView];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
