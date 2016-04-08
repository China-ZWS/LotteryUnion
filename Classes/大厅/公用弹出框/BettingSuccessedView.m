//
//  BettingSuccessedView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BettingSuccessedView.h"

@interface BettingSuccessedView ()
@property (nonatomic) BOOL removeFromSuperViewOnHide;
@property (nonatomic) UIImageView *backView;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UIImageView *headerImageView;
@property (nonatomic) UIButton *returnBtn;
@property (nonatomic) UIButton *shareBtn;
@property (nonatomic) NSString *content;
@property (nonatomic) UILabel *contentLb;
@property (nonatomic) UILabel *status;
@property (nonatomic) UIImageView *statusImgU;
@property (nonatomic, copy) void(^returnEvent)();
@property (nonatomic, copy) void(^shareEvent)();

@end

@implementation BettingSuccessedView

- (id)initWithFrame:(CGRect)frame
{
    UIImage *image = [UIImage imageNamed:@"tishi_bg.png"];
    if ((self = [super initWithFrame:CGRectMake((DeviceW - ScaleW(image.size.width)) / 2, (DeviceH - ScaleH(image.size.height)) / 2, ScaleW(image.width), ScaleH(image.height))])) {
    }
    return self;
}

+ (id)showCoverView:(UIWindow *)window
{
    BettingSuccessedView *successView = [BettingSuccessedView new];
    [window addSubview:successView.coverView];
    [window addSubview:successView];
    return successView;
}


+ (id)showWithContent:(NSString *)content returnEvent:(void(^)())returnEvent shareEvent:()shareEvent;
{
    BettingSuccessedView *successView = [BettingSuccessedView showCoverView:[UIApplication sharedApplication].keyWindow];
    successView.content = content;
    successView.returnEvent = returnEvent;
    successView.shareEvent = shareEvent;
    return successView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.backView];
    [self addSubview:self.headerImageView];
    [_backView addSubview:self.returnBtn];
    [_backView addSubview:self.shareBtn];
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

- (UIButton *)returnBtn
{
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnBtn.frame = CGRectMake(0, self.height - ScaleH(35), self.width / 2, ScaleH(35));
        _returnBtn.titleLabel.font = Font(15);
        [_returnBtn setBackgroundImage:[self drawrWithQuadrateLine:_returnBtn.size lineWidth:1.5 lineColor:CustomRed backgroundColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_returnBtn setTitle:@"返 回" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:CustomBlack forState:UIControlStateNormal];
        [_returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _returnBtn.backgroundColor = [UIColor whiteColor];
        [_returnBtn addTarget:self action:@selector(eventWithReturn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;

}

- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(self.width / 2, self.height - ScaleH(35), self.width / 2, ScaleH(35));
        [_shareBtn setBackgroundImage:[self drawrWithQuadrateLine:_returnBtn.size lineWidth:1.5 lineColor:CustomRed backgroundColor:CustomRed] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = Font(15);
        [_shareBtn setTitle:@"分 享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _shareBtn.backgroundColor = CustomRed;
        [_shareBtn addTarget:self action:@selector(eventWithShare) forControlEvents:UIControlEventTouchUpInside];

    }
    return _shareBtn;
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        CGSize size = [NSObject getSizeWithText:_content font:Font(14) maxSize:CGSizeMake(self.width - ScaleW(10), self.height)];
        _contentLb = [[UILabel alloc] initWithFrame:CGRectMake((self.width - size.width) / 2, _returnBtn.top - size.height - ScaleH(10), size.width, size.height)];
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
        _status.text = @"投注成功";
        _status.textAlignment = NSTextAlignmentCenter;
    }
    return _status;
}

- (UIImageView *)statusImgU
{
    if (!_statusImgU) {
        UIImage *image = [UIImage imageNamed:@"touzhu_suc.png"];
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
    BettingSuccessedView *successView = [self menuForView:[UIApplication sharedApplication].keyWindow];
    if (successView != nil)
    {
        successView.removeFromSuperViewOnHide = YES;
        [successView hide];
        return YES;
    }
    return NO;
}


+ (BettingSuccessedView *)menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum)
    {
        if ([subview isKindOfClass:self])
        {
            return (BettingSuccessedView *)subview;
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


- (void)eventWithReturn
{
    [BettingSuccessedView hideHUDForView];
    _returnEvent();
}

- (void)eventWithShare
{
    [BettingSuccessedView hideHUDForView];
    _shareEvent();
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
