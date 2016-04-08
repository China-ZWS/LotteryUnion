//
//  BallLineView.h
//  ydtctz
//
//  Created by 小宝 on 1/11/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

/* 这个方法是用来画出机选一注球的效果 */

#import <UIKit/UIKit.h>

@interface BallLineView : UIView
{
    NSArray *_redBall;
    NSArray *_blueBall;
    NSString *_format;
}

@property (nonatomic, retain) NSArray *redBall;
@property (nonatomic, retain) NSArray *blueBall;
@property (nonatomic, retain) NSString *format;

- (id)initWithFrame:(CGRect)frame redBall:(NSArray *)redBall blueBlue:(NSArray *)blueBall format:(NSString *)format;

@end
