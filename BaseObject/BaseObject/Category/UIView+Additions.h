//
//  UIView+Additions.h
//  ydtctz
//
//  Created by 小宝 on 1/9/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define TT_FIX_CATEGORY_BUG(UIVIEW)
//@interface TT_FIX_CATEGORY_BUG_UIVIEW : NSObject
//@end

#define TT_TRANSITION_DURATION 0.3

@interface UIView (Additions)
+ (void) shakeToShow:(UIView*)aView duration:(CGFloat)duration;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

- (void)fitInSize:(CGSize) aSize;

+(UIView*)viewWithFrame:(CGRect)frame;

- (void)resetOrientation;
- (void)removeAllSubviews;
- (void)removeFromSuperviewAnimted;

@end

@interface UIScrollView(Additions)

-(void)setContentHeight:(CGFloat)height;
-(void)setContentWidth:(CGFloat)width;

@end

@interface UINavigationController (Additions)

-(void)removeViewController:(UIViewController*)controller;

@end

@interface UIButton (Additions)

-(void)setGeneralBgWithSize:(CGSize)size;
-(void) setSpinnerStyle;
+(UIButton *)setupWithFrame:(CGRect)frame image:(NSString *)imageName btnText:(NSString *)title buttonTag:(int)tag textFont:(UIFont*)font textColor:(UIColor *)color aTarget:(id)target asel:(SEL)buttonSel;

@end

@interface UIImage (Additions)

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@property (nonatomic,readonly) CGFloat width;
@property (nonatomic,readonly) CGFloat height;

@end