//
//  BaseNavBarButtonItem.h
//  MoodMovie
//
//  Created by 周文松 on 14-8-28.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavBarButtonItem : NSObject
+ (id)itemWithTarget:(id)target title:(NSString *)title action:(SEL)action image:(NSString *)image;
+ (id)itemWithTarget:(id)target titles:(NSArray *)titles actions:(NSArray *)actions images:(NSArray *)images;

@property (nonatomic) UIButton *button;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *title;

@property (nonatomic) UIView *view;
@property (nonatomic) NSArray *images;
@property (nonatomic) NSArray *titles;

@end
