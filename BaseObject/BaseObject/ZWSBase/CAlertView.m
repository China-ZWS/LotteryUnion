//
//  CAlertView.m
//  BananaCampus
//
//  Created by xu bin on 14-6-11.
//  Copyright (c) 2014年 xu bin. All rights reserved.
//
#import "CAlertView.h"


#define BE_IPAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

static CGFloat kTransitionDuration = 0.3f;
static NSMutableArray*  gAlertViewStack = nil;
static UIWindow* gPreviouseKeyWindow = nil;
static UIWindow* gMaskWindow = nil;

@interface CAlertView(priveteMethods)

-(BOOL)_shouldRotateToOrientation:(UIDeviceOrientation)orientation;
-(void)_registerObservers;
-(void)_removeObservers;
-(void)_orientationDidChange:(NSNotification*)notify;
-(void)_sizeToFitOrientation:(BOOL)transform;
-(CGAffineTransform)_transformForOrientation;

+(CAlertView*)_getStackTopAlertView;
+(void)_pushAlertViewInStack:(CAlertView*)alertView;
+ (void)_popAlertViewFromStack;

+(void)_presentMaskWindow;
+(void)_dismissMaskWindow;

+(void)_addAlertViewOnMaskWindow:(CAlertView *)alertView;
+(void)_removeAlertViewFormMaskWindow:(CAlertView*)alertView;

-(void)_bounce0Animation;
-(void)_bounce1AnimationDidStop;
-(void)_bounce2AnimationDidStop;
-(void)_bounceDidStop;

-(void)_dismissAlertView;
@end



@implementation CAlertView



@synthesize contentView = _contentView;
@synthesize backGroundView = _backGroundView;
@synthesize delegate = _delegate;
@dynamic visible;

- (BOOL)visible{
    return self.superview && !self.hidden;
}

-(UIView*)backGroundView{
    return _backGroundView;
}

-(void)setBackGroundView:(UIView *)backGroundView{
    if (nil != _backGroundView) {
        [_backGroundView removeFromSuperview];
        [_backGroundView release];
    }
    _backGroundView = [backGroundView retain];
}

-(UIView*)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [_contentView setBackgroundColor:[UIColor blueColor]];
    }
    return _contentView;
    
}

-(void)loadContentView{
    [[NSBundle mainBundle] loadNibNamed:@"TestDialogContentView"
                                  owner:self
                                options:nil];
}



-(id)initWithView:(UIView *)view {
    if (self = [super initWithFrame:CGRectZero]){
        _contentView = [view retain];
        self.contentView.autoresizesSubviews = YES;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        int w=self.contentView.frame.size.width;
        self.contentView.tag = 99;
        
        UIButton *disBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [disBtn setBackgroundImage:[UIImage imageNamed:@"alert_dis"] forState:UIControlStateNormal];
        [disBtn setFrame:CGRectMake(w - [UIImage imageNamed:@"alert_dis"].size.width, 0, [UIImage imageNamed:@"alert_dis"].size.width, [UIImage imageNamed:@"alert_dis"].size.height)];
        [disBtn addTarget:self action:@selector(disAlert) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:disBtn];
        
        [self addSubview:self.contentView];
    }
    return self;
}

-(void)disAlert
{
    [self dismissAlertViewWithAnimated:YES];
}


-(void)show{
    if (_beShow) {
        return;
    }
    _beShow = YES;
    
    [self retain];
    [self _registerObservers];//添加消息，在设备发生旋转时会有相应的处理
    [self _sizeToFitOrientation:NO];
    
    
    //如果栈中没有alertview,就表示maskWindow没有弹出，所以弹出maskWindow
    if (![CAlertView _getStackTopAlertView]) {
        [CAlertView _presentMaskWindow];
//        [gMaskWindow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disAlert:)]];

    }
    
    
    if (nil != self.backGroundView && ![[gMaskWindow subviews] containsObject:self.backGroundView]) {
        [gMaskWindow addSubview:self.backGroundView];
    }
    //将alertView显示在window上
    [CAlertView _addAlertViewOnMaskWindow:self];
    
    //alertView弹出动画
    [self _bounce0Animation];
}

//要让alertView消失时调用此方法
-(void)dismissAlertViewWithAnimated:(BOOL)animated{
    if (!_beShow) {
        return;
    }
    _beShow = NO;
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(_dismissAlertView)];
        self.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self _dismissAlertView];
    }
    
    if (nil != self.backGroundView && [[gMaskWindow subviews] containsObject:self.backGroundView]) {
        [self.backGroundView removeFromSuperview];
    }
}


-(CGSize)sizeThatFits:(CGSize)size{
    return self.contentView.frame.size;
}

@end




@implementation CAlertView(priveteMethods)

-(BOOL)_shouldRotateToOrientation:(UIDeviceOrientation)orientation{
    BOOL result = NO;
    if (_orientation != orientation) {
        result = (orientation == UIDeviceOrientationPortrait ||
                  orientation == UIDeviceOrientationPortraitUpsideDown ||
                  orientation == UIDeviceOrientationLandscapeLeft ||
                  orientation == UIDeviceOrientationLandscapeRight);
    }
    
    return result;
}

-(void)_registerObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)_removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)_orientationDidChange:(NSNotification*)notify
{
    
    UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    if ([self _shouldRotateToOrientation:orientation]) {
        if ([_delegate respondsToSelector:@selector(didRotationToInterfaceOrientation:view:alertView:)]) {
            [_delegate didRotationToInterfaceOrientation:UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) view:_contentView alertView:self];
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self _sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

- (void)_sizeToFitOrientation:(BOOL)transform{
    
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self sizeToFit];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setCenter:CGPointMake(screenSize.width/2, screenSize.height/2)];
    if (transform) {
        self.transform = [self _transformForOrientation];
    }
}

-(CGAffineTransform)_transformForOrientation{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5f);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2.0f);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}


+(void)_presentMaskWindow{
    
    if (!gMaskWindow) {
        gMaskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        gMaskWindow.windowLevel = UIWindowLevelStatusBar + 1;
        gMaskWindow.backgroundColor = [UIColor clearColor];
        gMaskWindow.hidden = YES;
        
        [gMaskWindow setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65f]];
        
        // FIXME: window at index 0 is not awalys previous key window.
        gPreviouseKeyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [gMaskWindow makeKeyAndVisible];
        
        // Fade in background
        gMaskWindow.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        gMaskWindow.alpha = 1;
        [UIView commitAnimations];
        
        

    }
}

+(void)_dismissMaskWindow{
    // make previouse window the key again
    if (gMaskWindow) {
        [gPreviouseKeyWindow makeKeyAndVisible];
        gPreviouseKeyWindow = nil;
        
        [gMaskWindow release];
        gMaskWindow = nil;
    }
}

+(CAlertView*)_getStackTopAlertView{
    CAlertView* topItem = nil;
    if (0 != [gAlertViewStack count]) {
        topItem = [gAlertViewStack lastObject];
    }
    
    return topItem;
}

+ (void)_addAlertViewOnMaskWindow:(CAlertView *)alertView{
    if (!gMaskWindow ||[gMaskWindow.subviews containsObject:alertView]) {
        return;
    }
    
    [gMaskWindow addSubview:alertView];
    alertView.hidden = NO;
    
    CAlertView* previousAlertView = [CAlertView _getStackTopAlertView];
    if (previousAlertView) {
        previousAlertView.hidden = YES;
    }
    [CAlertView _pushAlertViewInStack:alertView];
}

+(void)_removeAlertViewFormMaskWindow:(CAlertView*)alertView{
    if (!gMaskWindow || ![gMaskWindow.subviews containsObject:alertView]) {
        return;
    }
    
    [alertView removeFromSuperview];
    alertView.hidden = YES;
    
    [CAlertView _popAlertViewFromStack];
    CAlertView *previousAlertView = [CAlertView _getStackTopAlertView];
    if (previousAlertView) {
        previousAlertView.hidden = NO;
        [previousAlertView _bounce0Animation];
    }
}

+(void)_pushAlertViewInStack:(CAlertView*)alertView{
    if (!gAlertViewStack) {
        gAlertViewStack = [[NSMutableArray alloc] init];
    }
    [gAlertViewStack addObject:alertView];
}


+(void)_popAlertViewFromStack{
    if (![gAlertViewStack count]) {
        return;
    }
    [gAlertViewStack removeLastObject];
    
    if ([gAlertViewStack count] == 0) {
        [gAlertViewStack release];
        gAlertViewStack = nil;
    }
}

-(void)_bounce0Animation{
    self.transform = CGAffineTransformScale([self _transformForOrientation], 0.001f, 0.001f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(_bounce1AnimationDidStop)];
    self.transform = CGAffineTransformScale([self _transformForOrientation], 1.1f, 1.1f);
    [UIView commitAnimations];
}

-(void)_bounce1AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(_bounce2AnimationDidStop)];
    self.transform = CGAffineTransformScale([self _transformForOrientation], 0.9f, 0.9f);
    [UIView commitAnimations];
}
-(void)_bounce2AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(_bounceDidStop)];
    self.transform = [self _transformForOrientation];
    [UIView commitAnimations];
}

-(void)_bounceDidStop{
    if (!_bePresented) {
        _bePresented = YES;
    }
}

-(void)_dismissAlertView{
    [CAlertView _removeAlertViewFormMaskWindow:self];
    
    // If there are no dialogs visible, dissmiss mask window too.
    if (![CAlertView _getStackTopAlertView]) {
        [CAlertView _dismissMaskWindow];
    }
    
    [self _removeObservers];
    [self release];
}






@end