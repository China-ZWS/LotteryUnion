//
//  LineView.m
//  LotteryUnion
//
//  Created by happyzt on 15/12/4.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (void)drawRect:(CGRect)rect {
    
    //1.取得图形上下文（画笔）
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLine2:context];
    
}

- (void)drawLine2:(CGContextRef)context {
    
    CGPoint p1 = {25,0};
    CGPoint p2 = {25,50};
    CGPoint points[] = {p1,p2};
    
    int len = sizeof(points)/sizeof(CGPoint);
    CGContextAddLines(context, points, len);
    
    //设置线条两端顶点的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置线条连接点的样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    //设置颜色、线宽
    UIColor *color = RGBA(197, 42, 37, 1);
    [color setStroke];  //将颜色对象设置成线条的颜色
    [[UIColor greenColor] setFill];
    
    //线宽
    CGContextSetLineWidth(context, 2);
    
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

@end
