//
//  FBBettingToolView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/9.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "FBBettingToolView.h"
#import "BaseBettingNumField.h"
#import "FBPassToChooseView.h"
#import "FootBallModel.h"
#define DefaultFrame CGRectMake(0, DeviceH - 88, DeviceW, 44)


@interface  FBBLeftBtn: UIButton
@property (nonatomic) BOOL hasShowArrow;
@end

@implementation FBBLeftBtn

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"收 起"];
        [self setAttributedTitle:attrString forState:UIControlStateSelected];;
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = FontBold(15);
        [self setTitleColor:CustomBlack forState:UIControlStateNormal];
    }
    return self;
}

- (void)setHasShowArrow:(BOOL)hasShowArrow
{
    if (hasShowArrow) {
        [self setImage:[UIImage imageNamed:@"jczq_arrow_red_down.png"] forState:UIControlStateNormal];
//        self.userInteractionEnabled = YES;
    }
    else
    {
//        self.userInteractionEnabled = NO;
    }
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect

{
    CGFloat imageY = (contentRect.size.height - self.titleLabel.font.lineHeight) / 2 + self.titleLabel.font.lineHeight - self.currentImage.size.height - 2;
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageX = contentRect.size.width - imageW - 5;

    CGFloat imageH = self.currentImage.size.height;
    return  CGRectMake(imageX, imageY, imageW, imageH);
    
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect

{
    CGFloat titleW = contentRect.size.width - self.currentImage.size.width - 5;
     return CGRectMake(0, 0, titleW, CGRectGetHeight(contentRect));
    
}

@end

static UIView *toView;
@interface FBBettingToolView (Category)
/**
 *  @brief  在view上查找FBBettingToolView对象
 *
 *  @param view
 *
 *  @return 返回找到的对象
 */
+ (FBBettingToolView *)_menuForView:(UIView *)view;

/**
 *  @brief  创建通知
 */
- (void)_addNotificationCenter;
@end


#import "FBPassToChooseView.h"
@interface FBBettingToolView ()
<UITextFieldDelegate>
{
    NSTimeInterval _animationDuration;
    UIViewAnimationCurve _animationCurve;
    CGRect _keyboardEndFrame;
}
@property (nonatomic) FBBLeftBtn *leftView;
@property (nonatomic) BaseBettingNumField *field;
@property (nonatomic) FBBettingType bettingType;


@end

@implementation FBBettingToolView


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
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetMidX(rect), 0) end:CGPointMake(CGRectGetMidX(rect), CGRectGetHeight(rect)) lineColor:CustomBlack lineWidth:LineWidth];
}


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:DefaultFrame])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self _addNotificationCenter];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.leftView];
    [self addSubview:self.field];
}


- (FBBLeftBtn *)leftView
{
    if (!_leftView) {
        _leftView = [FBBLeftBtn buttonWithType:UIButtonTypeCustom];
        _leftView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame));
        [_leftView addTarget:self action:@selector(eventWithLeftTouches:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftView;
}

- (UITextField *)field
{
    if (!_field) {
        _field = [[BaseBettingNumField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)  + (CGRectGetMidX(self.frame) - 80) / 2, (CGRectGetHeight(self.frame) - 30) / 2, 80, 30) toView:self];
        [_field getCornerRadius:5 borderColor:CustomRed borderWidth:1 masksToBounds:YES];        
        UILabel *one = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_field.frame) - 22, _field.top, 22, _field.height)];
        UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_field.frame), _field.top, 22, _field.height)];
        _field.delegate = self;
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
    FBTool.multiple = [_field.text integerValue];
    if ([_delegate respondsToSelector:@selector(toolView:changeWithMultiple:)] && [_delegate conformsToProtocol:@protocol(FBBettingToolViewDelegate)])
    {
        [_delegate toolView:self changeWithMultiple:[_field.text intValue]];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_leftView.selected) {
        [_leftView sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)eventWithLeftTouches:(UIButton *)btn
{
    if (_bettingType == kSingle) {
        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [_field resignFirstResponder];
    }
    if ([_delegate respondsToSelector:@selector(toolView:didSelectView:)] && [_delegate conformsToProtocol:@protocol(FBBettingToolViewDelegate)])
    {
        [_delegate toolView:self didSelectView:btn.selected];
    }
}

- (void)setHasSelected:(BOOL)hasSelected
{
    _leftView.selected = hasSelected;
}


#pragma mark - （+）类方法
#pragma mark - 实例化 FBBettingToolView
+ (FBBettingToolView*)sharedView
{
    FBBettingToolView *sharedView = [FBBettingToolView new];
    return sharedView;
}

+ (void)showViewToView:(UIView *)view delegate:(id<FBBettingToolViewDelegate>)delegate;
{
    toView = view;
    FBBettingToolView *sharedView = [self _menuForView:view];
    
    if (sharedView) {
        [sharedView removeFromSuperview];
        sharedView = nil;
    }
    sharedView = [self sharedView];
    sharedView.delegate = delegate;
    [view addSubview:sharedView];
}

#pragma mark - 显示用户选择的串玩法
+ (void)setPlayTypeName:(NSMutableAttributedString *)text;
{
    FBBettingToolView *sharedView = [self _menuForView:toView];
    [sharedView.leftView setAttributedTitle:text forState:UIControlStateNormal];;
}

#pragma mark - 显示用户选择的倍数
+ (void)setMultiple:(NSInteger)multiple;
{
    FBTool.multiple = multiple;
    FBBettingToolView *sharedView = [self _menuForView:toView];
    sharedView.field.defaultText = [NSString stringWithFormat:@"%d",multiple];
}

+ (void)setBettingType:(FBBettingType)bettingType;
{
    FBBettingToolView *sharedView = [self _menuForView:toView];
    sharedView.bettingType = bettingType;
}


@end


#pragma mark -  类扩充 -
@implementation FBBettingToolView (Category)

+ (FBBettingToolView *)_menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    
    for (UIView *subview in subviewsEnum)
    {
        
        if ([subview isKindOfClass:self])
        {
            return (FBBettingToolView *)subview;
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
