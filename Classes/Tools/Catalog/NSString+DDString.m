//
//  NSString+DDString.m
//  DoSports
//
//  Created by SuSong on 14-10-21.
//  Copyright (c) 2014年 ShouldWin. All rights reserved.
//

#import "NSString+DDString.h"

@implementation NSString (DDString)


// 给string添加获取size的方法
- (CGSize)calculateWithString:(NSString *)string WithFont:(CGFloat)font
{
    CGSize size = CGSizeMake(mScreenWidth, mScreenHeight);
    size = [string sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return size;
}

- (CGSize)calculateWithString:(NSString *)string WithFont:(CGFloat)font WithSize:(CGSize)size
{
    CGSize newsize = [string sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return newsize;
}


@end
