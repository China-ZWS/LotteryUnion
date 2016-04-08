//
//  BaseTextField.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-8.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTextField;
@protocol BaseTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textField:(BaseTextField *)textField insetWithHeight:(CGFloat)inset;
@end
@interface BaseTextField : UITextField
{ 
    NSTimeInterval _animationDuration;
    UIViewAnimationCurve _animationCurve;
    CGRect _keyboardEndFrame;
}
@property (nonatomic, assign) id<BaseTextFieldDelegate>dataSource;
@end
