//
//  ColorLabel.h
//  ydtctz
//
//  Created by 小宝 on 1/9/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorLabel : UILabel
- (id)initWithPosition:(CGPoint)point text:(NSString *)text color:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame number:(int)text aligment:(NSTextAlignment)alignment;


@end
