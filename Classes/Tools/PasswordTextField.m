//
//  PasswordTextField.m
//  DoSports
//
//  Created by SuSong on 14-10-19.
//  Copyright (c) 2014年 ShouldWin. All rights reserved.
//

#import "PasswordTextField.h"

@implementation PasswordTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        // Initialization code
    }
    return self;
}


//控制placeHolder的位置，左右缩20
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    if (!iOS7) {
        return CGRectInset(bounds, 10, 2);
    }
    return CGRectInset(bounds, 10, 4);
}

//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    if (!iOS7) {
        return CGRectInset(bounds, 10, 0);
    }
    return CGRectInset(bounds, 10, 0);
}

//控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (!iOS7) {
        return CGRectInset(bounds, 10, 0);
    }
    return CGRectInset(bounds, 10, 0);
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect {
    [toPCcolor(@"d8d8da") setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:14.4]];
    [[self text] drawInRect:rect withFont:[UIFont systemFontOfSize:14.4]];
}

// 删除按钮的位置
- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.size.width-50, 4, 33, 33);
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
