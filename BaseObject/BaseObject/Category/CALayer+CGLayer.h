//
//  CALayer+CGLayer.h
//  BabyStory
//
//  Created by 周文松 on 14-11-10.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (CGLayer)

/**
 *  @brief  设置
 *
 *  @param shadowOffset  layer偏移量
 *  @param shadowRadius  阴影到焦半径
 *  @param shadowColor   阴影颜色
 *  @param shadowOpacity 阴影透明度
 *  @param masksToBounds 是否有阴影
 */

- (void)getShadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity cornerRadius:(CGFloat)cornerRadius masksToBounds:(BOOL)masksToBounds;

/**
 *  @brief  倒角方法
 *
 *  @param cornerRadius  半径
 *  @param borderColor   颜色
 *  @param borderWidth   宽度
 *  @param masksToBounds
 */
- (void)getCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth masksToBounds:(BOOL)masksToBounds;

@end
