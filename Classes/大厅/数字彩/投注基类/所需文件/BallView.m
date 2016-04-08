//
//  ballView.m
//  YaBoCaiPiaoSDK
//
//  Created by jamalping on 14-6-5.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import "BallView.h"
#import "XHDHelper.h"

@implementation BallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMagnifier:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

+(BallView *)ballViewWithFrame:(CGRect)frame target:(id)aTarget action:(SEL)action tag:(int)aTag normalTitle:(NSString *)nTitle normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage selectImage:(UIImage *)selectImage selectArray:(NSArray *)selectArray magnifierImage:(UIImage *)bgImg isSmall:(BOOL)small
{
    BallView *view = [[BallView alloc] initWithFrame:frame];
    
    //背景
    view.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    view.imageView.image = normalImage;
    [view addSubview:view.imageView];
    view.selected = NO;
    view.small = small;
    view.number = nTitle;
    view.normalImage = normalImage;
    view.selectImage = selectImage;
    view.action = action;
    view.Target = aTarget;
    view.selectArray = selectArray;
    view.tag = aTag;
    
    for (int j = 0; j < [selectArray count]; j++)
    {
        if (aTag == [[selectArray objectAtIndex:j] intValue])
            view.selected = YES;
    }
    
    view.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    view.label.text = nTitle;
    view.label.textColor = REDFONTCOLOR;
    view.label.textAlignment = NSTextAlignmentCenter;
    view.label.font = [UIFont systemFontOfSize:14];
    [view addSubview:view.label];
    
    // 创建放大镜视图
    [view _initMagnifierWithBGimage:bgImg];
    
    return view;
}

// 初始化放大镜视图
- (void)_initMagnifierWithBGimage:(UIImage *)bgimg
{
//    NSLog(@"-----创建放大镜视图-----");
    // 一个和放大镜视图frame相同的视图，用来转换坐标
    bbb = [[UIView alloc] initWithFrame:CGRectMake(-(65-self.width)/2, 0, 65, 107)];
    bbb.bottom = self.height;
    [self addSubview:bbb];
    
    // 创建放大镜视图
    UIImageView *mfImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 107)];
    mfImgView.image = bgimg;
    
    _magnifierView = [[UIWindow alloc] initWithFrame:CGRectZero];
    _magnifierView.windowLevel = UIWindowLevelAlert;
    _magnifierView.backgroundColor = [UIColor clearColor];
    [_magnifierView addSubview:mfImgView];
    [_magnifierView makeKeyAndVisible];
    _magnifierView.hidden = YES;
    
    //放大镜上的球视图
    UIButton *faceItem = [UIButton buttonWithType:UIButtonTypeCustom];
    faceItem.frame = CGRectMake(35/2,20, 30, 20);
    [faceItem setTitle:self.number forState:UIControlStateNormal];
    [faceItem setImage:_highlightImage forState:UIControlStateNormal];
    faceItem.tag = 100;
    
    if (_small)
    {
        bbb.frame = CGRectMake(-(40-self.width), 0, 52, 86);
        bbb.bottom = self.height;
        mfImgView.size = bbb.size;
        faceItem.frame = CGRectMake(10, 15, 30, 20);
    }
    
    [mfImgView addSubview:faceItem];
}

// 显示放大镜
-(void)showMagnifier:(UITapGestureRecognizer *)tap
{
    [self reSetMagnifierViewPoint];
    _magnifierView.hidden = NO;
    
    [self performSelector:@selector(hiddenMagnifier) withObject:nil afterDelay:0.2];
}
// 隐藏放大镜
-(void)hiddenMagnifier
{
    _magnifierView.hidden = YES;
    if([self.Target respondsToSelector:self.action]==YES)
    {
        SEL action = self.action;
       [self.Target performSelector:action withObject:self];
    }
    
}

// 选中时候的UI改变
-(void)isSelectedWithChange
{
    if (_selected) {
        NSLog(@"选中了");
        self.imageView.image = self.selectImage;
        self.label.textColor = [UIColor whiteColor];
    }else if (_selected == NO)
    {
        NSLog(@"没选中");
        self.imageView.image = self.normalImage;
        self.label.textColor = _isRedBall?REDFONTCOLOR:BLUEBALLCOLOR;
    }
    
}
// 重新设置放大镜视图的位置
-(void)reSetMagnifierViewPoint
{
    UIWindow *window = [XHDHelper getKeyWindow];
    CGRect cgre = [self convertRect:bbb.frame toView:window];
    _magnifierView.frame = cgre;
}

#pragma mark - touch method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 重新设置放大镜视图的位置
    [self reSetMagnifierViewPoint];
    //显示放大镜
    _magnifierView.hidden = NO;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _magnifierView.hidden = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏放大镜
    _magnifierView.hidden = YES;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch事件");
    _magnifierView.hidden = YES;
}

@end
