//
//  BMTabBarController.m
//  ydtctz
//
//  Created by 小宝 on 1/7/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "UIRadioControl.h"

@implementation UIRadioControl
@synthesize selectedIndex = _selectedIndex;

// 初始化方法 （设置了frame 以及玩法选择按钮）
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        _itemss = items;
        [self setItems:items];
        // 创建手势
        _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
        _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_swipeGesture];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipe];
    }
    return self;
}

// 玩法数组(自定义按钮
-(void)setItems:(NSArray*)items
{
    int count = (int)[items count];
    CGFloat button_width = self.width / count;
    CGFloat button_height = self.height;
    
    // 移除所有的子视图
    [self removeAllSubviews];
    for (int i = 0; i < count; i++) {
        UIImage *img_n = NULL;
        UIImage *img_p = NULL;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i == 0) {
            img_n = [[UIImage imageNamed:@"radio_left_off.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
            img_p = [[UIImage imageNamed:@"radio_left_off_hover"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        } else if (i == count - 1) {
            img_n = [[UIImage imageNamed:@"radio_right_off.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
            img_p = [[UIImage imageNamed:@"radio_right_off_hover"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        } else {
            img_n = [[UIImage imageNamed:@"radio_middle_off.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
            img_p = [[UIImage imageNamed:@"radio_middle_off_hover"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        }
        
//        [button setBackgroundImage:img_n forState:UIControlStateNormal];
//        [button setBackgroundImage:img_n forState:UIControlStateNormal|UIControlStateHighlighted];
//        [button setBackgroundImage:img_p forState:UIControlStateSelected];
//        [button setBackgroundImage:img_p forState:UIControlStateSelected|UIControlStateHighlighted];
//
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = i;
        button.frame = CGRectMake(i*button_width,0,button_width,button_height);
        [self addSubview:button];
    }
}

// 重写的设置方法
- (void)setFont:(UIFont *)font
{
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]])
            button.titleLabel.font = font;
    }
}

// 设置title颜色的方法
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]])
            [button setTitleColor:color forState:state];
    }
}

// 轻扫事件响应
-(void)swipeGestureAction:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"hua dong le ?");
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {// 右滑
        _selectedIndex = _selectedIndex+1;
        
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {// 左滑
        if (_selectedIndex >=1) {
            _selectedIndex = _selectedIndex-1;
        }
    }
    
    if (_selectedIndex <= 0) {
        _selectedIndex = 0;
    }else if (_selectedIndex == self.subviews.count) {
        _selectedIndex = 0;
    }
    [self tabBarClick:[self.subviews objectAtIndex:_selectedIndex]];
    [self setSelectedIndex:_selectedIndex];
}

// 判断选中的是那个按钮
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    for (UIButton *button in self.subviews) {
        if (button.tag == selectedIndex)
            button.selected = YES;
        else
            button.selected = NO;
    }
}

// 被选中的按钮的title重写
- (NSString *)titleForSelectedIndex:(NSUInteger )index
{
    NSString *title = NULL;
    for (UIButton *button in self.subviews) {
        if (button.tag == index) {
            title = [NSString stringWithFormat:@"%@",[button titleForState:UIControlStateNormal]];
            break;
        }
    }
    return title;
}

// 玩法选择按钮响应方法
- (void)tabBarClick:(UIButton *)button
{
    if (!button.isSelected){
        for (UIButton *button in self.subviews){
            if ([button isKindOfClass:[UIButton class]])
                button.selected = NO;
        }
        
        button.selected = YES;
        _selectedIndex = button.tag;
        // 该方法说明只要是controll的子类都可以调用（事件分发）
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

// 改变不同个数button有不同的布局
- (void)changeRadioWidth:(float)newWidth
{
    [self setWidth:newWidth];
    
    float childWidth = newWidth/self.subviews.count;
    float childLeft = 0;
    if (self.subviews.count > 5) {
        childWidth =newWidth/5;
    }
    for (UIView *childView in self.subviews) {
        [childView setWidth:childWidth];
        [childView setLeft:childLeft];
        childLeft += childWidth;
    }
}

-(void)drawRect:(CGRect)rect
{
    // 图形上下文，得到一个画笔，画布是view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,1.5f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height );
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    /*
     * @kCGPathFill, 设置填充
     * @kCGPathStroke, 设置线条
     * @kCGPathFillStroke, 两者兼有
     */
    
    CGContextSetLineWidth(context,0.8f);
    //绘制竖线
    for (int i = 1; i < _itemss.count; i++)
    {
        // 画笔的起始坐标
        CGContextMoveToPoint(context, mScreenWidth/_itemss.count*i, 8);
        CGContextAddLineToPoint(context, mScreenWidth/_itemss.count*i, 27);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

@end
