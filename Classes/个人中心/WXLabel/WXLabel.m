//
//  WXLabel.m
//  CoreTextClicke
//
//  Created by zsm on 13-12-17.
//  Copyright (c) 2013年 zsm. All rights reserved.
//

#import "WXLabel.h"
#import <CoreText/CoreText.h>
//#import "RegexKitLite.h"

#define WXLABEL_IMAGE_NAME @"imageName"
@interface WXLabel ()

@property(nonatomic,assign)NSRange movieStringRange;//当前选中的字符索引
@property(nonatomic,strong)NSMutableArray *ranges;//所有链接文本的位置数组
@property(nonatomic,assign)NSInteger lastLineWidth;//最后一行文本的宽度
@property(nonatomic,strong)NSMutableAttributedString *attrString;//文本属性字符串
@property(nonatomic,strong)NSArray *row;//所有行的数组
@property(nonatomic,strong)UIColor *linkColor;   //超链接文本颜色
@property(nonatomic,strong)UIColor *passColor;   //鼠标经过链接文本颜色
@property(nonatomic,strong)NSArray *regexStrArray;  //正则表达式 数组
@property(nonatomic,strong)NSMutableDictionary *dicHeights;
@property(nonatomic,assign)CTFramesetterRef framesetter;
@end

@implementation WXLabel

- (void)dealloc
{
    if (_framesetter != nil) {
        CFRelease(_framesetter);
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initViews];        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews {
    // Initialization code
    //开启当前点击的手势
    self.userInteractionEnabled = YES;
    //缓存略字典
    self.dicHeights = [NSMutableDictionary dictionary];
    self.linespace = 10;
    
    //当前文本超链接文字的颜色默认为purpleColor
    self.linkColor = [UIColor purpleColor];
    //当前文本超链接文字手指经过的颜色默认为greenColor
    self.passColor = [UIColor redColor];
    
    _framesetter = nil;

}

- (CGFloat)textHeight {
    if (_framesetter == nil) {
        [self _createAttributeText];
    }
    
    if (_framesetter != nil) {
        //计算高度
        CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGRectGetWidth(self.bounds), 1000), NULL);
        suggestedSize = CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
        
        return suggestedSize.height;
    }
    return 0;
}


- (void)_createAttributeText {
    
    //自定义当前超链接文本颜色
    if ([self.wxLabelDelegate respondsToSelector:@selector(linkColorWithWXLabel:)]) {
        self.linkColor = [self.wxLabelDelegate linkColorWithWXLabel:self];
    }
    
    //自定义当前超链接文本颜色
    if ([self.wxLabelDelegate respondsToSelector:@selector(passColorWithWXLabel:)]) {
        self.passColor = [self.wxLabelDelegate passColorWithWXLabel:self];
    }
    if (self.text == nil) {
        return;
    }
    //生成属性字符串对象
    self.attrString = [[NSMutableAttributedString alloc]initWithString:self.text];
    //设置图片属性字符串
    [self replaceImageText];
    
    //------------------------设置字体属性--------------------------
    //    CTFontRef font = CTFontCreateWithName(CFSTR("Georgia"), 15, NULL);
    //设置当前字体
    [_attrString addAttribute:(id)kCTFontAttributeName value:self.font range:NSMakeRange(0, _attrString.length)];
    //设置当前文本的颜色
    [_attrString addAttribute:(id)kCTForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, _attrString.length)];
    
    
    //----------------------设置链接文本的颜色-------------------
    //判断当前链接文本表达式是否实现
    if ([self.wxLabelDelegate respondsToSelector:@selector(contentsOfRegexStringWithWXLabel:)] && [self.wxLabelDelegate contentsOfRegexStringWithWXLabel:self] != nil)
    {
        //获取所有的链接文本
        NSArray *contents = [self contentsOfRegexStrArray];
        
        //获取所有文本的的索引集合
        NSArray *ranges = [self rangesOfContents:contents];
        //NSLog(@"ranges %@",ranges);
        for (NSValue *value in ranges) {
            NSRange range = [value rangeValue];
            //设置字体的颜色
            [_attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)self.linkColor range:range];
            
        }
        
        //设置选中经过字体颜色
        [_attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)self.passColor range:self.movieStringRange];
        
    }
    
    
    //------------------------设置段落属性-----------------------------
    //指定为对齐属性
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierFirstLineHeadIndent;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    
    //行距
    self.linespace = 3.0f;
    CTParagraphStyleSetting lineSpaceSetting;
    lineSpaceSetting.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceSetting.value = &_linespace;
    lineSpaceSetting.valueSize = sizeof(_linespace);
    
    //多行高
    self.mutiHeight = 1.0f;
    CTParagraphStyleSetting Muti;
    Muti.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    Muti.value = &_mutiHeight;
    Muti.valueSize = sizeof(float);
    
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    //组合设置
    CTParagraphStyleSetting settings[] = {
        lineSpaceSetting,Muti,alignmentStyle,lineBreakMode
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 4);
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    
    // set attributes to attributed string
    [_attrString addAttributes:attributes range:NSMakeRange(0, _attrString.length)];
    
    
    //生成CTFramesetterRef对象
    _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attrString);
}

#pragma mark - 绘制视图
- (void)drawRect:(CGRect)rect
{
    [self _createAttributeText];
    
    //然后创建一个CGPath对象，这个Path对象用于表示可绘制区域坐标值、长宽。
    CGRect bouds = CGRectInset(self.bounds, 0.0f, 0.0f);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, bouds);
    
    //使用上面生成的setter和path生成一个CTFrameRef对象，这个对象包含了这两个对象的信息（字体信息、坐标信息）
    CTFrameRef frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context != NULL) {
        CGContextSetTextMatrix(context , CGAffineTransformIdentity);
        //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
        //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
        CGContextSaveGState(context);
        //x，y轴方向移动
        CGContextTranslateCTM(context , 0 ,self.height );
        //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
        CGContextScaleCTM(context, 1.0 ,-1.0);
        //可以使用CTFrameDraw方法绘制了。
        CTFrameDraw(frame,context);
    }
    
    //获取当前行的集合
    self.row = (NSArray *)CTFrameGetLines(frame);
    
    if (self.row.count > 0) {
        CGRect lineBounds = CTLineGetImageBounds((CTLineRef)[self.row lastObject], context);
        _lastLineWidth = lineBounds.size.width;        
    }
    
    //---------------------------绘制图片---------------------------
    CFArrayRef lines = CTFrameGetLines(frame);
    if (lines == nil) {
        return;
    }
    
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    //NSLog(@"line count = %ld",CFArrayGetCount(lines));
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        //NSLog(@"ascent = %f,descent = %f,leading = %f",lineAscent,lineDescent,lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        //NSLog(@"run count = %ld",CFArrayGetCount(runs));
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            //NSLog(@"width = %f",runRect.size.width);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:WXLABEL_IMAGE_NAME];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    //#warning 设置图片的大小
                    imageDrawRect.size = CGSizeMake(self.font.pointSize * 1.2, self.font.pointSize * 1.2);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y - self.font.pointSize * .2;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                    //                    imageDrawRect.size = CGSizeMake(image.size.height, image.size.height);
                    //                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    //                    imageDrawRect.origin.y = lineOrigin.y - 8;
                    //                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                    
                }
            }
        }
    }
    
    
    //－－－－－－－－－－－－－－－获取当前文本的高度－－－－－－－－－－－－－－－－－－
    //获取当前的行高
    
//    float lineHeight = self.font.pointSize + self.linespace + 2;
//    self.textHeight = CFArrayGetCount(lines) * lineHeight ;
//    self.textHeight = suggestedSize.height;
//    CGRect myframe = self.frame;
//    myframe.size.height = self.textHeight;
//    self.frame = myframe;
    
    //释放对象
    CGPathRelease(path);
//    CFRelease(framesetter);
    CFRelease(frame);
    
}
#pragma mark - 检索当前图片
//获取所有图片的字符串
- (NSArray *)imagesOfRegexStrArray
{
    //需要添加图片正则表达，默认为@"<image url = '[a-zA-Z0-9_\\.@%&\\S]*'>"
    NSString *regex = @"<image url = '[a-zA-Z0-9_\\.@%&\\S]*'>";
    if ([self.wxLabelDelegate respondsToSelector:@selector(imagesOfRegexStringWithWXLabel:)]) {
        regex = [self.wxLabelDelegate imagesOfRegexStringWithWXLabel:self];
    }
    
    NSArray *matchArray = [self matchRegex:regex text:self.text];

    
    //<image url = 'wxhl.png'>
    return matchArray;
}

- (NSArray *)matchRegex:(NSString *)regex text:(NSString *)text {
    
    //2.创建正则表达式实现对象
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    //3. expression  查找符合正则表达式的字符串
    NSArray *items = [expression matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    
    //4.循环遍历查找出来的结果
    NSMutableArray *matchArray = @[].mutableCopy;
    for (NSTextCheckingResult *result in items) {
        
        //符合表达的字符串的范围
        NSRange range = [result range];
        
        NSString *matchString = [self.text substringWithRange:range];
        
        //        NSLog(@"%@",matchString);
        [matchArray addObject:matchString];
    }
    
    return matchArray;
}

//替换图片文本
- (void)replaceImageText
{
    //为图片设置CTRunDelegate,delegate决定留给图片的空间大小
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    
    //存放所有图片的索引位置
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSString *imageUrl in [self imagesOfRegexStrArray]) {
        NSArray *imageUrls = [imageUrl componentsSeparatedByString:@"'"];
        NSString *imgName = imageUrls[1];
        if (imgName.length == 0) {
            continue;
        }
        
        CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(imgName));
        NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"   "];//空格用于给图片留位置
        [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(1, 1)];
        CFRelease(runDelegate);
        //设置空格的属性
        [imageAttributedString addAttribute:WXLABEL_IMAGE_NAME value:imgName range:NSMakeRange(1, 1)];
        
        //获取上一次图片检索的位置
        NSValue *lastValue = [ranges lastObject];
        NSInteger location = [lastValue rangeValue].location + ([lastValue rangeValue].length == 0 ? 0 : 1);
        
        if (location > [self.attrString string].length) {
            continue;
        }
        
        //获取当前字符串在文本中的位置
        NSRange range = [[self.attrString string] rangeOfString:imageUrl  options:NSCaseInsensitiveSearch range:NSMakeRange(location, self.attrString.length - location)];
        //NSLog(@"lenght:%d",self.attrString.length);
        //把图片的字符串替换为（空格的属性字符串）
        [self.attrString replaceCharactersInRange:range withAttributedString:imageAttributedString];
        //NSLog(@"lenght:%d",self.attrString.length);
        NSValue *value = [NSValue valueWithRange:range];
        //添加到数组中
        [ranges addObject:value];
    }
}

#pragma mark - CTRunDelegate delegate
void RunDelegateDeallocCallback(void *refCon) {
    
}
//设置空白区域的高度
CGFloat RunDelegateGetAscentCallback(void *refCon) {
    //NSString *imageName = (__bridge NSString *)refCon;
    return 0;//[UIImage imageNamed:imageName].size.height / 4;
}

CGFloat RunDelegateGetDescentCallback(void *refCon) {
    return 0;
}
//设置空白区域的宽度
CGFloat RunDelegateGetWidthCallback(void *refCon){
    //    NSString *imageName = (__bridge NSString *)refCon;
    //    return [UIImage imageNamed:imageName].size.width;
    return 23;
}
#pragma mark - 检索当前链接文本
//返回所有的链接字符串数组
- (NSArray *)contentsOfRegexStrArray
{
    //需要添加链接字符串正则表达：@用户、http://、#话题#
    NSString *regex = [self.wxLabelDelegate contentsOfRegexStringWithWXLabel:self];
    
    //通过正则表达式查找出匹配的字符串
//    NSArray *matchArray = [[self.attrString string] componentsMatchedByRegex:regex];
    
    NSArray *matchArray = [self matchRegex:regex text:[self.attrString string]];
    
    
    //@用户 ---> <a href='user://用户'>@用户</a>
    //http:// ---> <a href='http://wwww.iphonetrain.com'>http://wwww.iphonetrain.com</a>
    //#话题# -----> <a href='topic://话题'>#话题#</a>
    return matchArray;
}

//获取所有链接文字的位置
- (NSArray *)rangesOfContents:(NSArray *)contents
{
    if (_ranges == nil) {
        _ranges = [[NSMutableArray alloc]init];
    }
    [_ranges removeAllObjects];
    
    for (NSString *content in contents) {
        NSValue *lastValue = [_ranges lastObject];
        NSInteger location = [lastValue rangeValue].location + [lastValue rangeValue].length;
        
        if (location > [self.attrString string].length) {
            continue;
        }
        
        //获取当前字符串在文本中的位置
        NSRange range = [[self.attrString string] rangeOfString:content options:NSCaseInsensitiveSearch range:NSMakeRange(location, self.attrString.length - location)];
        NSValue *value = [NSValue valueWithRange:range];
        //添加到数组中
        [_ranges addObject:value];
    }
    
    return _ranges;
}


#pragma mark - touch Action

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.movieStringRange = NSMakeRange(0, 0);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //获取当前选中字符的范围
    NSRange range = [self touchInLabelText:point];
    if (range.length == 0) {
        [super touchesEnded:touches withEvent:event];
    }else{
        //判断当前代理方法是否实现
        if ([self.wxLabelDelegate respondsToSelector:@selector(toucheEndWXLabel:withContext:)]) {
            //获取当前点击字符串
            NSString *context = [[self.attrString string] substringWithRange:range];
            //调用点击开始代理方法
            [self.wxLabelDelegate toucheEndWXLabel:self withContext:context];
        }
    }
    
    //
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        });
    //    });
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.movieStringRange = NSMakeRange(0, 0);
}
//手指接触视图
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //获取当前选中字符的范围
    NSRange range = [self touchInLabelText:point];
    self.movieStringRange = range;
    if (range.length == 0) {
        [super touchesBegan:touches withEvent:event];
    }else
    {
        //判断当前代理方法是否实现
        if ([self.wxLabelDelegate respondsToSelector:@selector(toucheBenginWXLabel:withContext:)]) {
            //获取当前点击字符串
            NSString *context = [[self.attrString string] substringWithRange:range];
            //调用点击开始代理方法
            [self.wxLabelDelegate toucheBenginWXLabel:self withContext:context];
        }
    }
    
}


#pragma mark - 检索当前点击的是否是链接文本
//检查当前点击的是否是连接文本,如果是返回文本的位置
- (NSRange)touchInLabelText:(CGPoint)point
{
    //获取当前的行高
    float lineHeight = self.font.pointSize + self.linespace;
    
    int indexLine = point.y / lineHeight;
    //NSLog(@"indexLine:%d",indexLine);
    
    //如果当前行数大于最大行数
    if (indexLine >= _row.count) {
        return NSMakeRange(0, 0);
    }
    //如果当前行是最后一行and点击位置的横坐标大于当前行文本最大的位置
    if (indexLine == _row.count - 1 && point.x > _lastLineWidth) {
        return NSMakeRange(0, 0);
    }
    
    //如果点击在当前行文字的上方空白位置
    //    if (point.y <= indexLine *lineHeight + (asc+des+lead) * (_mutiHeight - 1.0f)) {
    //        return NSMakeRange(0, 0);
    //    }
    
    
    //获取当前行
    CTLineRef selectLine = CFArrayGetValueAtIndex((__bridge CFArrayRef)_row, indexLine);
    CFIndex selectCharIndex = CTLineGetStringIndexForPosition(selectLine, point);
    
    
    //获取当前行结束字符位置
    CFIndex endIndex = CTLineGetStringIndexForPosition(selectLine, CGPointMake(self.frame.size.width-1, 1));
    
    
    //获取整段文字中charIndex位置的字符相对line的原点的x值
    CGFloat beginset;
    do {
        //获取当前选中字符距离起点位置
        CTLineGetOffsetForStringIndex(selectLine,selectCharIndex
                                      ,&beginset);
        //判断当前字符的开始位置是否小于点击位置
        if (point.x >= beginset) {
            //判断当前字符是否为最后一个字符
            if (selectCharIndex == endIndex) {
                break;
            }
            //判断当前字符的结束位置是否大于点击位置
            CGFloat endset;
            CTLineGetOffsetForStringIndex(selectLine,selectCharIndex + 1,&endset);
            if (point.x <= endset) {
                break;
            }else
            {
                selectCharIndex++;
            }
        }else
        {
            selectCharIndex--;
        }
        
    } while (YES);
    
    //判断当前点击的位置是否在链接文本位置
    for (NSValue *value in _ranges) {
        NSRange range = [value rangeValue];
        if (range.location <= selectCharIndex && selectCharIndex + 1 <= range.location + range.length) {
            return range;
        }
    }
    
    
    return NSMakeRange(0, 0);
}

#pragma mark - 当前手指触摸文本
//复写当前选中的链接文本的索引
- (void)setMovieStringRange:(NSRange)movieStringRange
{
    if (_movieStringRange.location != movieStringRange.location || _movieStringRange.length != movieStringRange.length) {
        _movieStringRange = movieStringRange;
        [self setNeedsDisplay];
    }
}

#pragma mark - 计算文本高度
#define kHeightDic @"kHeightDic"
//计算文本内容的高度
+ (float)getTextHeight:(float)fontSize
                 width:(float)width
                  text:(NSString *)text
             linespace:(CGFloat)linespace
{
    
    if (linespace == 0) {
        linespace = 10;
    }
    
    WXLabel *wxLabel = [[WXLabel alloc] initWithFrame:CGRectMake(0, 0, width, 400)];
    wxLabel.linespace = linespace;
    wxLabel.font = [UIFont systemFontOfSize:fontSize];
    wxLabel.text = text;
//    [wxLabel drawRect:CGRectMake(0, 0, width , 400)];
    
    return wxLabel.textHeight;
}


#warning - 没有显示效果
//添加下划线
+ (void)addLine:(UILabel *)label text:(NSString *)text {
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    label.attributedText = content;
}



@end
