//
//  UINavigationItem+BaseNavigationItem.h
//  MoodMovie
//
//  Created by 周文松 on 14-8-28.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (BaseNavigationItem)
- (void)setNewTitle:(NSString *)title;

- (UIButton *)setRightItemWithTarget:(id)target title:(NSString *)title action:(SEL)action image:(NSString *)image;

- (void)setBackItemWithTarget:(id)target title:(NSString *)title action:(SEL)action image:(NSString *)image;

- (void)setBackItemWithTargets:(id)target titles:(NSArray *)titles actions:(NSArray *)actions images:(NSArray *)images;

- (void)setRightItemView:(UIView *)view;

- (UIButton *)setOptionView:(id)target title:(NSString *)title action:(SEL)action image:(NSString *)image;
@end
