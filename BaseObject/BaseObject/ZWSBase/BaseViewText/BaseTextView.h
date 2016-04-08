//
//  BaseTextView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-15.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTextView;

@protocol BaseTextViewDelegate <UITextViewDelegate>
@optional
- (void)textView:(BaseTextView *)textView heightWithContent:(CGFloat)textHeigh ;
- (void)calculateInsetHeight;
@end


@interface BaseTextView : UITextView
{
    NSTimeInterval _animationDuration;
    UIViewAnimationCurve _animationCurve;
    CGRect _keyboardEndFrame;
    BOOL _isShow;
}
- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<BaseTextViewDelegate>delegate;

@end
