//
//  UINavigationItem+BaseNavigationItem.m
//  MoodMovie
//
//  Created by 周文松 on 14-8-28.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import "UINavigationItem+BaseNavigationItem.h"
#import "BaseNavBarButtonItem.h"
#import "Header.h"
#import "Category.h"
#import "Device.h"
#import "ArrowView.h"

@implementation UINavigationItem (BaseNavigationItem)


- (void)setNewTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 22, 22);
    label.backgroundColor = [UIColor clearColor];
    label.font = FontBold(17);
    label.textColor =  RGBA(80, 80, 80, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    self.titleView = label;
}

- (UIButton *)setRightItemWithTarget:(id)target title:(NSString *)title action:(SEL)action image:(NSString *)image;
{
    BaseNavBarButtonItem *buttonItem = [BaseNavBarButtonItem itemWithTarget:target title:title action:action image:image];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
    return buttonItem.button;
}

- (void)setBackItemWithTarget:(id)target title:(NSString *)title  action:(SEL)action image:(NSString *)image;
{
    BaseNavBarButtonItem *buttonItem = [BaseNavBarButtonItem itemWithTarget:target title:nil action:action image:image];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
//    [self.leftBarButtonItem setBackgroundVerticalPositionAdjustment:-40.0 forBarMetrics:UIBarMetricsDefaultPrompt];
}

- (void)setBackItemWithTargets:(id)target titles:(NSArray *)titles actions:(NSArray *)actions images:(NSArray *)images;
{
    BaseNavBarButtonItem *buttonItem = [BaseNavBarButtonItem itemWithTarget:target titles:titles actions:actions images:images];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.view];
}

- (void)setRightItemView:(UIView *)view
{
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (UIButton *)setOptionView:(id)target title:(NSString *)title action:(SEL)action image:(NSString *)image;
{
    ArrowView *btn = [ArrowView buttonInstance:kRight];
    CGSize titleSize = [NSObject getSizeWithText:title font:Font(20) maxSize:CGSizeMake(200, 30)];
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, titleSize.height + [UIImage imageNamed:image].size.width + 5, 30);
    [btn setTitleColor:CustomBlack forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.titleView = btn;
    return btn;
}




@end
