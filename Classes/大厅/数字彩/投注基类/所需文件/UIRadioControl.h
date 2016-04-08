//
//  BMTabBarController.h
//  ydtctz
//
//  Created by 小宝 on 1/7/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRadioControl : UIControl
{
    NSUInteger _selectedIndex; // 选择的button的是第几个
    UISwipeGestureRecognizer *_swipeGesture;// 轻扫手势
    NSArray *_itemss;  //数组元素
}
@property (nonatomic, assign) NSUInteger selectedIndex;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
//设置字体
- (void)setFont:(UIFont *)font;
//根据转态设置字体颜色
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
//获取选择的标题
- (NSString *)titleForSelectedIndex:(NSUInteger )index;
//改变宽度
- (void)changeRadioWidth:(float)newWidth;
//设置元素
-(void)setItems:(NSArray*)items;

@end
