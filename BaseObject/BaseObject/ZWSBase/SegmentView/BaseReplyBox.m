//
//  BaseReplyBox.m
//  BaseObject
//
//  Created by 周文松 on 15/10/4.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseReplyBox.h"
#import "Header.h"
#import "Device.h"
#import "UIView+CGTool.h"
#import "BaseInputView.h"

@interface RePeplyInputView : UIView
<UITextViewDelegate>
{
    BOOL _isShow;
    NSTimeInterval _animationDuration;
    UIViewAnimationCurve _animationCurve;
    CGRect _keyboardEndFrame;
    UIView *_currentField;
    void (^_success)(NSString *string);
    CGFloat _hight;

}
@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, strong) UIButton *send;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation RePeplyInputView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)eventWithCancel
{
    [self endEditing:YES];
    [self.superview removeFromSuperview];
}

- (void)eventWithSend
{
    [self endEditing:YES];
    _success(_textView.text);
    [self.superview removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame success:(void (^)(NSString *string))success
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = RGBA(230, 230, 230, 1);
        _success = success;
        _hight = CGRectGetMaxY(self.frame);
        [self layoutViews];
        [self notificationCenter];
    }
    return self;
}

- (void)layoutViews
{
    [self addSubview:self.textView];
    [self addSubview:self.cancel];
    [self addSubview:self.send];
}

- (UITextView *)textView
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(kDefaultInset.left, kDefaultInset.top, DeviceW - kDefaultInset.left * 2, CGRectGetHeight(self.frame) - kDefaultInset.top * 3 - ScaleH(35))];
    _textView.font = NFont(17);
    _textView.backgroundColor = [UIColor whiteColor];
    [_textView becomeFirstResponder];
    [_textView getCornerRadius:3 borderColor:CustomGray borderWidth:.5 masksToBounds:YES];
    _textView.delegate =self;
    return _textView;
}

- (UIButton *)cancel
{
    _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel.frame = CGRectMake(kDefaultInset.left * 3 , CGRectGetHeight(self.frame) - kDefaultInset.bottom  - ScaleH(35), ScaleW(65), ScaleH(35));
    _cancel.backgroundColor = CustomGray;
    [_cancel setTitle:@"取 消" forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(eventWithCancel) forControlEvents:UIControlEventTouchUpInside];
    return _cancel;
}

- (UIButton *)send
{
    _send = [UIButton buttonWithType:UIButtonTypeCustom];
    _send.frame = CGRectMake(DeviceW - ScaleW(65) - kDefaultInset.left * 3 , CGRectGetHeight(self.frame) - kDefaultInset.bottom  - ScaleH(35), ScaleW(65), ScaleH(35));
    _send.backgroundColor = CustomBlue;
    [_send setTitle:@"发 送" forState:UIControlStateNormal];
    [_send addTarget:self action:@selector(eventWithSend) forControlEvents:UIControlEventTouchUpInside];
    return _send;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
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
    
    [UIView animateWithDuration:_animationDuration animations:^{
    if (up)
    {
        [self calculateInsetHeight];
        
    }
    else
    {
        self.transform = CGAffineTransformIdentity;
        
    }
    }];
}

- (void)calculateInsetHeight
{
    if (!_isShow) {
        return;
    }
    CGRect rect = [self.window convertRect:_keyboardEndFrame toView:self.superview];
    CGFloat insetHeight = _hight - CGRectGetMinY(rect);
    if (insetHeight > 0)
    {
        self.transform=CGAffineTransformMakeTranslation(0, -insetHeight);
    }
    
}



@end

@interface BaseReplyBox ()
@property (assign) BOOL removeFromSuperViewOnHide;
@property (nonatomic, strong) void(^success)(NSString *string);
@end

@implementation BaseReplyBox


- (void)dealloc
{
    NSLog(@"%@",self);
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)])) {
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    BaseReplyBox __weak*safeSelf = self;
    RePeplyInputView *inputView = [[RePeplyInputView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), DeviceW, ScaleH(190)) success:^(NSString *string){
        [safeSelf successToString:string];
    }];
    [self addSubview:inputView];
}

- (void)successToString:(NSString *)string
{
    _success(string);
}


+ (id)showCoverView:(UIView *)view
{
    BaseReplyBox *reply = [self new];
    reply.backgroundColor = RGBA(20, 20, 20, .6);
    [view addSubview:reply];
    return reply;
}


+ (BaseReplyBox *)showToSuccess:(void(^)(NSString *string))success;
{
    BaseReplyBox *reply = [BaseReplyBox showCoverView:[UIApplication sharedApplication].keyWindow];
    reply.success = success;
    return reply;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
