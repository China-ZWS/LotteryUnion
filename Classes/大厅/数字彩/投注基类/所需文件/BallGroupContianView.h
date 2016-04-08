//
//  BallGroupContianView.h
//  ydtctz
//
//  Created by 小宝 on 1/11/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallGroupContianView : UIView {
    UIScrollView *_scrollView;
    NSMutableArray *_ballGroup;
    NSString *_format;
    
    BOOL disabledAnimation;
}

@property (nonatomic, retain) NSString *format;
@property (nonatomic, weak) id target;

- (id)initWithFrame:(CGRect)frame ballGroup:(NSArray *)ballGroup;
- (id)initWithFrame:(CGRect)frame ballGroup:(NSArray *)ballGroup format:(NSString *)format;

- (UIView *)getBallLine:(NSArray *)redBall blueBall:(NSArray *)blueBall format:(NSString *)format;
- (void)drawBall:(NSArray *)ballGroup format:(NSString *)format;

- (NSArray *)getBallGroup;
-(void)removeScrollView;

@end
