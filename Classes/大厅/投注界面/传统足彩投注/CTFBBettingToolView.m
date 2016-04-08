//
//  CTFBBettingToolView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/16.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFBBettingToolView.h"
#import "BaseBettingNumField.h"
#import "CTFBModel.h"
#define DefaultFrame CGRectMake(0, DeviceH - 88, DeviceW, 44)

@interface CTFBBettingToolView (Category)
/**
 *  @brief  在view上查找FBBettingToolView对象
 *
 *  @param view
 *
 *  @return 返回找到的对象
 */
+ (CTFBBettingToolView *)_menuForView:(UIView *)view;

/**
 *  @brief  创建通知
 */
- (void)_addNotificationCenter;

@end


@interface CTFBBettingToolView()
<UITextFieldDelegate>
{
    NSTimeInterval _animationDuration;
    UIViewAnimationCurve _animationCurve;
    CGRect _keyboardEndFrame;
}

@property (nonatomic) BaseBettingNumField *field;

@end
@implementation CTFBBettingToolView


#pragma mark - （-）实列方法 -

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(CGRectGetWidth(rect), 0) lineColor:CustomBlack lineWidth:LineWidth];
}


- (id)initWithFrame:(CGRect)frame
{
    if ((self= [super initWithFrame:DefaultFrame])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        CTFBTool.multiple  = 1;
        [self _addNotificationCenter];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.field];
    CTFBTool.multiple  = [_field.text integerValue];
}



- (UITextField *)field
{
    if (!_field) {
        _field = [[BaseBettingNumField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)  + (CGRectGetMidX(self.frame) - 80) / 2, (CGRectGetHeight(self.frame) - 30) / 2, 80, 30) toView:self];
        [_field getCornerRadius:5 borderColor:CustomRed borderWidth:1 masksToBounds:YES];
        UILabel *one = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_field.frame) - 22, _field.top, 22, _field.height)];
        UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_field.frame), _field.top, 22, _field.height)];
        _field.delegate = self;
        _field.textColor = CustomRed;
        one.text = @"投";
        two.text = @"倍";
        one.font = two.font = Font(14);
        one.textColor = two.textColor = CustomBlack;
        one.textAlignment = two.textAlignment = NSTextAlignmentCenter;
        one.backgroundColor = two.backgroundColor = [UIColor clearColor];
        [self addSubview:one];
        [self addSubview:two];
    }
    return _field;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CTFBTool.multiple  = [_field.text integerValue];
    if ([_delegate respondsToSelector:@selector(toolView:changeWithMultiple:)] && [_delegate conformsToProtocol:@protocol(CTFBBettingToolViewDelegate)])
    {
        [_delegate toolView:self changeWithMultiple:[_field.text intValue]];
    }
}


#pragma mark - （+）类方法
#pragma mark - 实例化 FBBettingToolView
+ (CTFBBettingToolView *)sharedView
{
    CTFBBettingToolView *sharedView = [CTFBBettingToolView new];
    return sharedView;
}

+ (void)showViewToView:(UIView *)view delegate:(id<CTFBBettingToolViewDelegate>)delegate;
{
    CTFBBettingToolView *sharedView = [self _menuForView:view];
    
    if (sharedView) {
        [sharedView removeFromSuperview];
        sharedView = nil;
    }
    sharedView = [self sharedView];
    sharedView.delegate = delegate;
    [view addSubview:sharedView];
}



@end

@implementation CTFBBettingToolView (Category)



+ (CTFBBettingToolView *)_menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    
    for (UIView *subview in subviewsEnum)
    {
        
        if ([subview isKindOfClass:self])
        {
            return (CTFBBettingToolView *)subview;
        }
    }
    return nil;
}

#pragma mark - 初始化通知
-(void)_addNotificationCenter
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
    if (self.window)
    {
        [self moveTextViewForKeyboard:notification up:YES];
    }
}

#pragma mark - 键盘消失调用的事件
-(void)keyboardWasHidden:(NSNotification *)notification
{
    if (self.window)
    {
        [self moveTextViewForKeyboard:notification up:NO];
    }
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up
{
    NSDictionary* userInfo = [aNotification userInfo];
    // Get animation info from userInfo
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardEndFrame];
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:_animationDuration];
    [UIView setAnimationCurve:_animationCurve];
    
    if (up) {
        self.transform = CGAffineTransformMakeTranslation(0, -_keyboardEndFrame.size.height + 44);
    }
    else
    {
        self.transform = CGAffineTransformIdentity;
    }
    [UIView commitAnimations];
    
}


@end
