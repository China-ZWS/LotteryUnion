//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "AttributedLabel.h"

@interface AttributedLabel(){

}
@property (nonatomic,retain)NSMutableAttributedString          *attString;
@end

@implementation AttributedLabel
@synthesize attString = _attString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = _attString;
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:textLayer];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)color.CGColor
                        range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                       font.pointSize,
                                                       NULL))
                        range:NSMakeRange(location, length)];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:style]
                        range:NSMakeRange(location, length)];
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
