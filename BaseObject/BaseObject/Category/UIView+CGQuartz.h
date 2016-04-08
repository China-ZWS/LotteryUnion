//
//  UIView+CGQuartz.h
//  BabyStory
//
//  Created by 周文松 on 14-11-10.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OvalStyle) {
    //以下是枚举成员
    kParallelOval = 0,
    kOval = 1
};


/**
 *  @brief  cell背景类型枚举
 */
typedef NS_ENUM(NSInteger, CellStyle){
    /**
     *  @brief  上部分背景
     */
    kUpCell = 0,
    /**
     *  @brief  中间背景
     */
    kCenterCell,
    /**
     *  @brief  下部背景
     */
    kDownCell,
    /**
     *  @brief  独体cell背景
     */
    kRoundCell
};


@interface UIView (CGQuartz)
/**
*  @brief  画线条
*
*  @param rect               线条范围
*  @param start             开始点
*  @param end               结束点
*  @param lineColor         线颜色
*  @param lineWidth         线宽
*/
- (void)drawRectWithLine:(CGRect)rect start:(CGPoint)start end:(CGPoint)end lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;

/**
 *  @brief  画一个泡泡框
 *
 *  @param rect      范围
 *  @param lineColor 线条颜色
 *  @param radius    半径
 */
-(void)drawRectRoundMark:(CGRect)rect lineColor:(UIColor *)lineColor withRadius:(float)radius;

/**
 *  @brief  绘制文本
 *
 *  @param text  文字
 *  @param frame 范围
 *  @param color 字体颜色
 *  @param font  字体font
 */
- (void)drawTextWithText:(NSString *)text rect:(CGRect)frame color:(UIColor *)color font:(UIFont *)font;

/**
 *  @brief  绘制进度条
 *
 *  @param rect              范围
 *  @param progress          进度
 *  @param progressTintColor
 *  @param trackTintColor
 *  @param lineWidth         宽度
 *  @param lineColor         颜色
 *  @param radius            半径
 */
- (void)drawRectRoundProgress:(CGRect)rect progress:(CGFloat)progress progressTintColor:(UIColor *)progressTintColor trackTintColor:(UIColor *)trackTintColor lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor withRadius:(CGFloat)radius ;

/**
 *  @brief  话圆形
 *
 *  @param center 圆心
 *  @param radius 半径
 */
-(void)drawCircleWithCenter:(CGPoint)center radius:(float)radius width:(CGFloat)width widthColor:(UIColor *)widthColor fillColor:(UIColor *)fillColor shadowSize:(CGSize)shadowSize;


/**
 *  @brief  画4个倒角的矩形
 *
 *  @param rect            矩形范围
 *  @param radius          半径
 *  @param lineWidth       线宽
 *  @param lineColor       线色
 *  @param backgroundColor 背景颜色
 */
- (void)drawWithChamferOfRectangle:(CGRect)rect inset:(UIEdgeInsets)inset radius:(float)radius lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor;

/**
 *  @brief  绘制圆角cell背景
 *
 *  @param rect            rect
 *  @param cellStyle       背景类型
 *  @param inset           inset
 *  @param radius          角度
 *  @param lineWidth       线宽
 *  @param lineColor       线条颜色
 *  @param backgroundColor cell背景颜色
 */
- (void)drawCellWithRound:(CGRect)rect cellStyle:(CellStyle)cellStyle inset:(UIEdgeInsets)inset radius:(float)radius lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor;

@end
