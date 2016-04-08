//
//  SegmentBar.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-10.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "SegmentBar.h"

@implementation SegmentBar

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(CGRectGetWidth(rect), 0) lineColor:CustomBlack lineWidth:.3];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - .3) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - .3) lineColor:CustomBlack lineWidth:.3];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
