//
//  PDKeyColorLabel.m
//
//  Created by liuchan on 12-8-22.
//
//

#import "AttributeColorLabel.h"
#import <CoreText/CoreText.h>

#define KEY_TEXT @"text"
#define KEY_COLOR @"color"
#define KEY_FONT @"font"

@implementation AttributeColorLabel
@synthesize textArray;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Drawing code
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSaveGState(context);
//    CGContextSetTextMatrix(context,CGAffineTransformIdentity);//重置
//    
//    //y轴高度
//    float top = [self.text sizeWithFont:self.font].height;
//    CGContextTranslateCTM(context,0, (self.height-top)/2+top-4);
//	CGContextScaleCTM(context, 1, -1);
//    
//    NSAttributedString *attStr = [AttributeColorLabel buildAttrString:textArray font:self.font color:self.textColor];
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
//
//    CGPathRef path = [[UIBezierPath bezierPathWithRect:rect] CGPath];
//    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
//    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
//    CGContextSetTextPosition(context,0,0);
//    for (NSObject *line in lines) {
//        CTLineRef cLine = (__bridge CTLineRef)line;
//        CTLineDraw(cLine, context);
//        CGContextSetTextPosition(context,0,20);
//    }
//	CGContextRestoreGState(context);
}

-(void)clearText
{
    [textArray removeAllObjects];
}

-(void)addText:(NSString *)text color:(UIColor *)color font:(UIFont *)font{
    if(!textArray)
    {
       textArray = [NSMutableArray array];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:text forKey:KEY_TEXT];
    [dict setValue:color forKey:KEY_COLOR];
    [dict setValue:font forKey:KEY_FONT];
    [textArray addObject:dict];
}

+(void)addText:(NSString *)text color:(UIColor *)color font:(UIFont *)font toArray:(NSMutableArray*)tArray {
    if(!tArray)
        tArray = [NSMutableArray array];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:text forKey:KEY_TEXT];
    [dict setValue:color forKey:KEY_COLOR];
    [dict setValue:font forKey:KEY_FONT];
    [tArray addObject:dict];
}

#pragma mark - Custom methods
//
-(NSString*)drawColorString
{
    NSAttributedString *attrStr = [AttributeColorLabel buildAttrString:textArray font:self.font color:self.textColor];
    
    [self setAttributedText:attrStr];
    [super setAutomaticallyAddLinksForType:0];
    return attrStr.string;
}

+(NSAttributedString*)buildAttrString:(NSArray*)textArray font:(UIFont*)defFont
                                color:(UIColor*)defColor{
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] init];
    
    for (NSDictionary *attrDict in textArray) {
        NSMutableAttributedString *attrStr;
        NSString *text = [attrDict objectForKey:KEY_TEXT];
        if(text){
            UIColor *color = [attrDict objectForKey:KEY_COLOR];
            color = color?color:defColor;
            UIFont *font = [attrDict objectForKey:KEY_FONT];
            font = font?font:defFont;
            // 设置文字
            attrStr = [[NSMutableAttributedString alloc] initWithString:text];
            // 设置颜色
            [attrStr addAttribute:(NSString *)kCTForegroundColorAttributeName
                            value:(id)[color CGColor] range:NSMakeRange(0, text.length)];
            // 设置字体
            id fontRef = (__bridge id)CTFontCreateWithName((__bridge CFStringRef)font.fontName,font.pointSize,NULL);
            [attrStr addAttribute:(NSString *)kCTFontAttributeName value:fontRef
                            range:NSMakeRange(0, text.length)];
            [resultString appendAttributedString:attrStr];
        }
    }
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping; //换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode); // 1
    
    CTParagraphStyleSetting LineSpacing;
    CGFloat spacing = 1.0;  // 行距
    LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    LineSpacing.valueSize = sizeof(spacing); // 4
    LineSpacing.value = &spacing;

    CTParagraphStyleSetting settings[] = {lineBreakMode,LineSpacing};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
    [resultString addAttribute:(NSString *)kCTParagraphStyleAttributeName
                         value:(__bridge id)paragraphStyle
                         range:NSMakeRange(0, resultString.length)];
    
    
    return resultString;
}

@end
