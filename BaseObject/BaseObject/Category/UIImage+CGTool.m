//
//  UIImage+CGTool.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-24.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "UIImage+CGTool.h"

@implementation UIImage (CGTool)


#pragma mark - 绘制圆形图片
+ (UIImage *)drawrWithRoundImage:(CGSize)size lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor withParam:(CGFloat) inset;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height ), NO, 0);
    [backgroundColor setFill];
    [lineColor setStroke];
    
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context,lineWidth);
    CGContextAddEllipseInRect(context, CGRectMake(inset / 2, inset / 2, size.width - inset, size.height - inset));
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return im;
}


#pragma mark - 图片倒圆
+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
    
}

#pragma mark - 绘制矩形，底部带线
+ (UIImage *)drawrWithbottomLine:(CGSize)size lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height ), NO, 0);
    [backgroundColor setFill];
    [lineColor setStroke];
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,lineWidth);
    CGContextMoveToPoint(context,0,size.height);
    CGContextAddLineToPoint(context,size.width, size.height);
    
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return im;
}

#pragma mark - 绘制矩形， 中间可以带线
+ (UIImage *)drawrWithQuadrateLine:(CGSize)size lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor hasCenterLine:(BOOL)hasCenterLine;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height ), NO, 0);
    [backgroundColor setFill];
    [lineColor setStroke];
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,lineWidth);
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,size.width, 0);
    CGContextAddLineToPoint(context,size.width, size.height);
    CGContextAddLineToPoint(context,0, size.height);
    CGContextAddLineToPoint(context,0, 0);

    if (hasCenterLine) {
        CGContextClosePath(context);
        CGContextMoveToPoint(context,0,size.height / 2);
        CGContextAddLineToPoint(context,size.width, size.height / 2);
    }
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return im;
}

+ (UIImage *)drawrWithLeftRound:(CGSize)size  lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height ), NO, 0);
    [backgroundColor setFill];
    [lineColor setStroke];
    
    CGFloat radius = size.height / 2;
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,lineWidth);
    CGContextMoveToPoint(context,radius,0);
    CGContextAddLineToPoint(context,size.width, 0);
    CGContextAddLineToPoint(context,size.width, size.height);
    CGContextAddArcToPoint(context, 0,  size.height,  0,  radius, radius);
    CGContextAddArcToPoint(context, 0,  0,  radius,  0, radius);

    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return im;
}

@end
