//
//  BallLineView.m
//  ydtctz
//
//  Created by 小宝 on 1/11/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "BallLineView.h"

@implementation BallLineView
@synthesize redBall = _redBall;
@synthesize blueBall = _blueBall;
@synthesize format = _format;

- (id)initWithFrame:(CGRect)frame redBall:(NSArray *)redBall blueBlue:(NSArray *)blueBall format:(NSString *)format
{
    if ((self = [super initWithFrame:frame]))
    {
        self.redBall = redBall;
        self.blueBall = blueBall;
        self.format = format;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark --- 画球的方法
- (void)drawRect:(CGRect)rect
{
    CGFloat lasty = 0.0;
    //画红球
    for (int i = 0; i < [_redBall count]; i++) {
        UIImage *ball_red = [UIImage imageNamed:@"Redball"];
        CGFloat ball_radius = ball_radius = ball_red.size.width * 0.88;
      
        
        [ball_red drawInRect:CGRectMake(i * ball_radius + 5.0, 10.0, ball_radius, ball_radius)];
        
        NSString *_f = [NSString stringWithFormat:@"%%%@",_format];
        NSString *number = [NSString stringWithFormat: _f,[[_redBall objectAtIndex:i] intValue]];
        
        
        if ([_format isEqualToString:@"02d"])
        {
            [[UIColor whiteColor] set];
            [number drawAtPoint:ccp(i * ball_radius + 11.2,16) withAttributes:@{NSFontAttributeName:BallFont,NSForegroundColorAttributeName:[UIColor whiteColor]}];
        }
        else if ([_format isEqualToString:@"d"])
        {
          
            [[UIColor whiteColor] set];
            [number drawAtPoint:ccp(i * ball_radius + 15.8,16) withAttributes:@{NSFontAttributeName:BallFont,NSForegroundColorAttributeName:[UIColor whiteColor]}];
        }
        lasty = i * ball_radius + ball_radius;
    }
    
    //TODO:画篮球
    for (int i = 0; i < [_blueBall count]; i++)
    {
        UIImage *ball_blue = [UIImage imageNamed:@"Blueball"];
        CGFloat ball_radius = ball_blue.size.width * 0.91;
        
        [ball_blue drawInRect:CGRectMake(lasty + i * ball_radius + 5.0, 10.0, ball_radius, ball_radius)];
        NSString *number = [NSString stringWithFormat:@"%02d",[[_blueBall objectAtIndex:i] intValue]];
        //高亮效果
        [[UIColor whiteColor] set];
        [number drawAtPoint:ccp(lasty + i * ball_radius + 11.8,16.5) withAttributes:@{NSFontAttributeName:BallFont,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    }
    
    // 画一条分割线
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,1.2f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,rect.origin.x+8.0, rect.size.height);
    CGContextAddLineToPoint(context,rect.size.width-25.0, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
    
}


@end
