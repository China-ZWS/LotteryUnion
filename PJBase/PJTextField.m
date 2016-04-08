//
//  PJTextField.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/19.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJTextField.h"

@implementation PJTextField

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) / 4 + 10, CGRectGetHeight(rect) - .5) end:CGPointMake(CGRectGetWidth(rect) - 10, CGRectGetHeight(rect) - .5) lineColor:CustomBlack lineWidth:0.15];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
