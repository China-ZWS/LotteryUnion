//
//  BaseNavigationInteractiveTransition.h
//  BaseObject
//
//  Created by 周文松 on 15/9/28.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class UIViewController, UIPercentDrivenInteractiveTransition;

@interface BaseNavigationInteractiveTransition : NSObject
<UINavigationControllerDelegate>
- (instancetype)initWithViewController:(UIViewController *)vc;
- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;
- (UIPercentDrivenInteractiveTransition *)interactivePopTransition;
@end
