//
//  UIView+CGTool.m
//  BabyStory
//
//  Created by 周文松 on 14-11-14.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import "UIView+CGTool.h"
#import "Device.h"

@implementation UIView (CGTool)

- (void)getShadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity cornerRadius:(CGFloat)cornerRadius masksToBounds:(BOOL)masksToBounds;
{
    [self.layer getShadowOffset:shadowOffset shadowRadius:shadowRadius shadowColor:shadowColor shadowOpacity:shadowOpacity cornerRadius:cornerRadius masksToBounds:masksToBounds];
}

- (void)getCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth masksToBounds:(BOOL)masksToBounds;
{
    [self.layer getCornerRadius:IS_IPHONE?cornerRadius:cornerRadius*2 borderColor:borderColor borderWidth:borderWidth masksToBounds:masksToBounds];
}


+ (id )getView:(UIView *)view toClass:(NSString *)toClass;
{
   
    for (UIView* next = view; next; next =
         next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        NSLog(@"%@",nextResponder);
        
        if ([nextResponder isKindOfClass:NSClassFromString(toClass)])
        {
            return nextResponder;
        }
    }
    return nil;
}



- (UIViewController*)setViewController;
{
    for (UIView* next = [self superview]; next; next =
         next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
