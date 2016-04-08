//
//  BettingFailedView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BettingFailedView.h"

@interface BettingFailedView ()
@property (nonatomic) BOOL removeFromSuperViewOnHide;
@property (nonatomic) UIImageView *backView;
@property (nonatomic) UIImageView *headerImageView;
@property (nonatomic) UIButton *finishBtn;
@property (nonatomic) UIView *coverView;
@property (nonatomic) NSString *content;
@property (nonatomic) UILabel *contentLb;
@property (nonatomic) UILabel *status;
@property (nonatomic) UIImageView *statusImgU;
@property (nonatomic, copy) void (^finishedEvent)();
@end
@implementation BettingFailedView

- (id)initWithFrame:(CGRect)frame
{
    UIImage *image = [UIImage imageNamed:@"tishi_bg.png"];
    if ((self = [super initWithFrame:CGRectMake((DeviceW - ScaleW(image.size.width)) / 2, (DeviceH - ScaleH(image.size.height)) / 2, ScaleW(image.width), ScaleH(image.height))])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

+ (id)showCoverView:(UIWindow *)window
{
    BettingFailedView *failedView = [BettingFailedView new];
    [window addSubview:failedView.coverView];
    [window addSubview:failedView];
    return failedView;
}


+ (id)showWithContent:(NSString *)content finishedEvent:(void(^)())finishedEvent;
{
    BettingFailedView *failedView = [BettingFailedView showCoverView:[UIApplication sharedApplication].keyWindow];
    failedView.content = content;
    failedView.finishedEvent = finishedEvent;
    return failedView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.backView];
    [self addSubview:self.headerImageView];
    [_backView addSubview:self.finishBtn];
    [self addSubview:self.contentLb];
    [self addSubview:self.status];
    [self addSubview:self.statusImgU];
    [UIView animateWithDuration:0.3f animations:^{
        _coverView.alpha = 0.5;
        self.alpha = 1.0;
    }];
}

- (UIImageView *)backView
{
    if (!_backView) {
        UIImage *image = [UIImage imageNamed:@"tishi_bg.png"];
        _backView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backView.image = image;
        _backView.userInteractionEnabled = YES;
        [_backView getCornerRadius:5 borderColor:[UIColor clearColor] borderWidth:1 masksToBounds:YES];
    }
    return _backView;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        UIImage *image = [UIImage imageNamed:@"tishi.png"];
        _headerImageView = [[UIImageView alloc] initWithImage:image];
        _headerImageView.size = CGSizeMake(ScaleW(image.size.width), ScaleH(image.size.height));
        _headerImageView.center = CGPointMake(self.width / 2, ScaleH(25));
    }
    return _headerImageView;
}

- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake(0, self.height - ScaleH(35), self.width, ScaleH(35));
        _finishBtn.titleLabel.font = Font(15);
        [_finishBtn setTitle:@"确 定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishBtn.backgroundColor = CustomRed;
        [_finishBtn addTarget:self action:@selector(eventWithFinished) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
    
}


- (UILabel *)contentLb
{
    if (!_contentLb) {
        CGSize size = [NSObject getSizeWithText:_content font:Font(14) maxSize:CGSizeMake(self.width - ScaleW(10), self.height)];
        _contentLb = [[UILabel alloc] initWithFrame:CGRectMake((self.width - size.width) / 2, _finishBtn.top - size.height - ScaleH(10), size.width, size.height)];
        _contentLb.numberOfLines = 0;
        _contentLb.text = _content;
        _contentLb.textAlignment = NSTextAlignmentCenter;
        _contentLb.textColor = CustomBlack;
        _contentLb.font = Font(14);
    }
    return _contentLb;
}

- (UILabel *)status
{
    if (!_status) {
        _status = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentLb.top - Font(25).lineHeight - ScaleH(10), self.width, Font(25).lineHeight)];
        _status.textColor = CustomRed;
        _status.font = Font(25);
        _status.text = @"投注失败";
        _status.textAlignment = NSTextAlignmentCenter;
    }
    return _status;
}

- (UIImageView *)statusImgU
{
    if (!_statusImgU) {
        UIImage *image = [UIImage imageNamed:@"touzhu_los.png"];
        _statusImgU = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - image.size.width) / 2, (_status.top - _headerImageView.bottom - image.size.height) / 2 + _headerImageView.bottom, image.size.width, image.size.height)];
        _statusImgU.image = image;
    }
    return _statusImgU;
}

- (UIView *)coverView
{
    if (!_coverView)
    {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)];
        _coverView.backgroundColor = RGBA(20, 20, 20, 1);
        _coverView.alpha = 0;
    }
    return _coverView;
}


+ (BOOL)hideHUDForView
{
    BettingFailedView *failedView = [self menuForView:[UIApplication sharedApplication].keyWindow];
    if (failedView != nil)
    {
        failedView.removeFromSuperViewOnHide = YES;
        [failedView hide];
        return YES;
    }
    return NO;
}


+ (BettingFailedView *)menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum)
    {
        if ([subview isKindOfClass:self])
        {
            return (BettingFailedView *)subview;
        }
    }
    return nil;
    
}


- (void)hide
{
    if (_removeFromSuperViewOnHide)
        _removeFromSuperViewOnHide = NO;
    
    [UIView animateWithDuration:.3f animations:^
     {
         _coverView.alpha = 0;
         self.alpha = 0;
     }completion:^(BOOL finished){
         [self removeFromSuperview];
         [_coverView removeFromSuperview];
         
     }];
}



- (void)eventWithFinished
{
    [BettingFailedView hideHUDForView];
    _finishedEvent();
}


#pragma mark - 绘制矩形， 中间可以带线
- (UIImage *)drawrWithQuadrateLine:(CGSize)size lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor backgroundColor:(UIColor *)backgroundColor ;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height ), NO, 0);
    [backgroundColor setFill];
    [lineColor setStroke];
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,lineWidth);
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,size.width, 0);
    
    CGContextClosePath(context);
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,size.width, 0);
    
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return im;
}

@end
