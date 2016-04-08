//
//  NSString+DDString.h
//  DoSports
//
//  Created by SuSong on 14-10-21.
//  Copyright (c) 2014年 ShouldWin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DDString)

// 给string添加获取size的方法
- (CGSize)calculateWithString:(NSString *)string WithFont:(CGFloat)font;

- (CGSize)calculateWithString:(NSString *)string WithFont:(CGFloat)font WithSize:(CGSize)size;

@end
