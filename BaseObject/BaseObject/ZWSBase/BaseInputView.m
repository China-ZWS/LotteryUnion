//
//  CPInputView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseInputView.h"
#import "Header.h"
#import "Device.h"

@interface BaseInputView ()
{
    CGFloat _selfMinY;
}
@property (nonatomic) UIView *coverView;

@end

@implementation BaseInputView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"BaseInputView dealloc");
}

- (UILabel *)setLeftTitle:(NSString *)title;
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}


- (id)initWithFrame:(CGRect)frame success:(void(^)())success;
{
    if ((self = [super initWithFrame:frame]))
    {
        _success = success;
        _selfMinY = CGRectGetMinY(frame);
        [self layoutViews];
        [self notificationCenter];
    }
    return self;
}

- (void)layoutViews
{
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.superview insertSubview:self.coverView belowSubview:self];
}

- (void)setFieldDelegate:(BaseTextField *)fieldDelegate
{
    fieldDelegate.delegate = self;
}

- (void)setTextDelegate:(BaseTextView *)textDelegate
{
    textDelegate.delegate = self;
}


#pragma mark - 初始化通知
-(void)notificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}



#pragma mark - 键盘调用的事件
- (void)keyboardWasShow:(NSNotification *)notification
{
    
    [self moveTextViewForKeyboard:notification up:YES];
}

#pragma mark - 键盘消失调用的事件
-(void)keyboardWasHidden:(NSNotification *)notification
{
    [self moveTextViewForKeyboard:notification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up
{
    NSDictionary* userInfo = [aNotification userInfo];
    // Get animation info from userInfo
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardEndFrame];
    _isShow = up;
    
    if (up)
    {
        [UIView animateWithDuration:0.3f animations:^{
            [self calculateInsetHeight];
            _coverView.alpha = 0.5;
        }];

    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.transform = CGAffineTransformIdentity;
            _coverView.alpha = 0;
        }];
    }
}

- (void)calculateInsetHeight
{
    if (!_isShow) {
        return;
    }
    CGRect rect = [self.window convertRect:_keyboardEndFrame toView:self.superview];
    CGFloat insetHeight = CGRectGetMaxY(_currentField.frame) + _selfMinY - CGRectGetMinY(rect);
//    NSLog(@"%f === %f",CGRectGetMaxY(_currentField.frame), CGRectGetMinY(rect));
    if (insetHeight > 0)
    {
        self.transform=CGAffineTransformMakeTranslation(0, -insetHeight);
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)coverView
{
    if (!_coverView)
    {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)];
        _coverView.backgroundColor = RGBA(20, 20, 20, 1);
        _coverView.alpha = 0;
        
        /*给_coverView添加一个手势监测*/
        
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)]];
    }
    return _coverView;
}
- (void)singleTap
{
    [self endEditing:YES];
}

@end
