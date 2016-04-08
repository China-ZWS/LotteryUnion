//
//  BaseNavigationBar.m
//  MoodMovie
//
//  Created by 周文松 on 14-7-28.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import "BaseNavigationBar.h"
#ifndef IS_IOS7
#define IS_IOS7   [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#endif

#define Height 55.0
@implementation BaseNavigationBar




#pragma -mark Property Setters

-(void)setColourAdjustFactor:(UIColor *)colourAdjustFactor
{
    //set the property, then trigger a refresh to re-call drawRect with the new colour
    _colourAdjustFactor = colourAdjustFactor;
   
    if (IS_IOS7) {
        self.barTintColor = colourAdjustFactor;
    }
    else
    {
        self.tintColor = colourAdjustFactor;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
