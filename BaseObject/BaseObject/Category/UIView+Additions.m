//
//  UIView+Additions.m
//  ydtctz
//
//  Created by liuchan on 1/9/12.
//  Copyright (c) 2012 DoMobile. All rights reserved.
//

#import "UIView+Additions.h"

//@implementation TT_FIX_CATEGORY_BUG_UIVIEW
//@end

@implementation UIView (Additions)

/**
 *  视图震动出现
 *
 *  @param aView    父视图
 *  @param duration 动画时间
 */
+ (void) shakeToShow:(UIView*)aView duration:(CGFloat)duration
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}


#pragma mark === 永久闪烁的动画 ======
+ (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////获取父视图的x
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////获取父视图的y
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 适应某个尺寸
- (void)fitInSize:(CGSize)aSize
{
	CGFloat scale;
	CGRect newframe = self.frame;
	
	if (newframe.size.height && (newframe.size.height > aSize.height))
	{
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	if (newframe.size.width && (newframe.size.width >= aSize.width))
	{
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	self.frame = newframe;
}

// 获取视图的frame
+(UIView*)viewWithFrame:(CGRect)frame {
    return [[UIView alloc] initWithFrame:frame];
}

// 设置旋转
-(void)resetOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformRotate(transform, -M_PI/2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformRotate(transform, M_PI/2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        default:
            break;
    }
    
    [self setTransform:transform];
}

// 移除所有子视图
- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

// 动画移除某个子视图
-(void)removeFromSuperviewAnimted
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setTransform:CGAffineTransformMakeScale(3, 3)];
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

@implementation UIScrollView(Additions)

// 设置滑动视图内容的高度和宽度
-(void)setContentHeight:(CGFloat)height
{
    CGSize size = self.contentSize;
    size.height = height;
    [self setContentSize:size];
}

-(void)setContentWidth:(CGFloat)width
{
    CGSize size = self.contentSize;
    size.width = width;
    [self setContentSize:size];
}

@end

@implementation UINavigationController (Additions)

// 导航控制器移除某个控制器
-(void)removeViewController:(UIViewController*)controller
{
    NSMutableArray *array = [self.viewControllers mutableCopy];
    [array removeObject:controller];
    [self setViewControllers:array];
}

@end

@implementation UIButton (Additions)
-(void)setBackBtnFrameImg
{
    self.frame = CGRectMake(0, 0, 48, 48);
    [self setImage:[UIImage imageNamed:@"back.ong"] forState:UIControlStateNormal];
}

+(UIButton *)setupWithFrame:(CGRect)frame image:(NSString *)imageName btnText:(NSString *)title buttonTag:(int)tag textFont:(UIFont*)font textColor:(UIColor *)color aTarget:(id)target asel:(SEL)buttonSel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame =frame;
    [button addTarget:target action:buttonSel forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 40, 40)];
    imgView2.image = [UIImage imageNamed:imageName];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:title forState:UIControlStateNormal];
    [button1.titleLabel setFont:font];
    button1.frame = CGRectMake(imgView2.frame.size.width, imgView2.frame.origin.y, frame.size.width-imgView2.frame.size.width, 40);
    [button1 setTitleColor:color forState:UIControlStateNormal];
    
    [button addSubview:imgView2];
    [button addSubview:button1];
    return button;
}

// 设置一般按钮背景颜色和圆角
-(void)setGeneralBgWithSize:(CGSize)size
{
    [self.titleLabel setShadowColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    if (size.width!=0) {
        self.layer.cornerRadius = 0;
    }
    self.backgroundColor = [UIColor colorWithRed:191/225.0 green:45/225.0 blue:36/225.0 alpha:1];
}

// 设置按钮带图片和title，向上或向下
-(void) setSpinnerStyle
{
    UIImage *button_norm = [[UIImage imageNamed:@"spinner"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 30)];
    UIImage *button_down = [[UIImage imageNamed:@"spinner_down"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 30)];
    [self setBackgroundImage:button_norm forState:UIControlStateNormal];
    [self setBackgroundImage:button_down forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    // 设置title偏移
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -28, 0, 0)];
}

@end

@implementation UIImage(Additions)
// 获取图片高度和宽度
-(CGFloat)height{
    return self.size.height;
}

-(CGFloat)width{
    return self.size.width;
}
/**
 *  根据颜色获取一个图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context,rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  img;
}



@end
