//
//  ColorLabel.m
//  ydtctz
//
//  Created by 小宝 on 1/9/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "ColorLabel.h"

@implementation ColorLabel
//
- (id)initWithPosition:(CGPoint)point text:(NSString *)text
                 color:(UIColor *)color {
    if ((self = [super initWithFrame:CGRectZero])) {
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = color;
        self.text = text;
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:self.font}];
        self.frame = CGRectMake(point.x,point.y,size.width,size.height);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame number:(int)text
           aligment:(NSTextAlignment)alignment {
    if ((self = [super initWithFrame:frame])) {
        self.text = [NSString stringWithFormat:@"%d",text];
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:13];
        self.textAlignment = alignment;
        
        self.textColor = REDFONTCOLOR;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = color;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = color;
        self.text = text;
    }
    return self;
}

@end
