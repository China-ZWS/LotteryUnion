//
//  UIColor+RandomColor.h
//  TopTabControl
//
//  Created by vousaimer on 14-12-11.
//  Copyright (c) 2014年 va. All rights reserved.
//

#if __has_feature(objc_arc)
//compiling with ARC
#else
#error "this file need compile with arc"
#endif


#import <UIKit/UIKit.h>

@interface UIColor (RandomColor)

/**
 *  返回一个随机颜色
 *
 *  @return 颜色值
 */
+ (UIColor *)randomColor;

@end
