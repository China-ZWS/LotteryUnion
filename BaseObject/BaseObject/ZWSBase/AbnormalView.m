//
//  AbnormalView.m
//  BabyStory
//
//  Created by 周文松 on 14-12-18.
//  Copyright (c) 2014年 com.talkweb.www.HCTProject. All rights reserved.
//

#import "AbnormalView.h"
#import "Device.h"
#import "Category.h"
#import "Header.h"

static NSString *const notNetWorkImg = @"notDatas.png";
static NSString *const notDatasImg = @"notDatas.png";
static NSString *const kErrorImg = @"";
static NSString *const netTimeOutImg = @"notDatas.png";


@interface AbnormalView ()
@property (nonatomic) NSString *title;
@end

@implementation AbnormalView

- (void)drawRect:(CGRect)rect
{
    NSString *text = nil;
    NSString *reText = nil;
    UIImage *image = nil;
    
    switch (self.abnormalType) {
        case NotNetWork:
        {
            text = @"亲，网络开小差了~";
            reText = @"点击重新刷新";
            image = [UIImage imageNamed:notNetWorkImg];
        }
            break;
        case NotDatas:
        {
            if (!self.title) {
                text = @"亲，查询无数据~";
            }
            else
            {
                text = self.title;
            }
            reText = @"点击重新刷新";
            image = [UIImage imageNamed:notNetWorkImg];

        }
            break;
        case kError:
        {
            text = @"亲，服务器异常";
            reText = @"点击重新刷新";
            image = [UIImage imageNamed:kErrorImg];
        }
            break;

        default:
            break;
    }
    
    CGSize textSize = [NSObject getSizeWithText:text font:Font(22) maxSize:CGSizeMake(DeviceW, DeviceH)];
    CGSize reTextSize = [NSObject getSizeWithText:reText font:Font(15) maxSize:CGSizeMake(DeviceW, DeviceH)];
    CGSize imgSize = [NSObject adaptiveWithImage:image maxHeight:CGRectGetHeight(rect) * ScaleHor maxWidth:CGRectGetWidth(rect) * ScaleVer];
    CGFloat width = 0;
    if (textSize.width - reTextSize.width > 0) {
        if (textSize.width - imgSize.width > 0) {
            width = textSize.width;
        }
        else
        {
            width = imgSize.width;
        }
    }
    else
    {
        if (reTextSize.width - imgSize.width > 0) {
            width = reTextSize.width;
        }
        else
        {
            width = imgSize.width;
        }
    }
    
    
    CGRect nRect = CGRectMake((CGRectGetWidth(rect) - width) / 2, (CGRectGetHeight(rect) - image.size.height - textSize.height - reTextSize.width) / 2, imgSize.width, imgSize.height);
    [image drawInRect:nRect];
    
    [self drawTextWithText:text rect:CGRectMake((DeviceW - textSize.width) / 2, CGRectGetMaxY(nRect), textSize.width, textSize.height) color:CustomBlue font:Font(22)];
    [self drawTextWithText:reText rect:CGRectMake((DeviceW - reTextSize.width) / 2, CGRectGetMaxY(nRect) + textSize.height, reTextSize.width, reTextSize.height) color:CustomGray font:Font(15)];
    [self drawRectWithLine:rect start:CGPointMake((DeviceW - reTextSize.width) / 2, CGRectGetMaxY(nRect) + textSize.height + reTextSize.height + 2) end:CGPointMake((DeviceW + reTextSize.width) / 2, CGRectGetMaxY(nRect) + textSize.height + reTextSize.height + 2) lineColor:CustomGray lineWidth:.3];
}

+ (id)showAbnormalViewRect:(CGRect)rect view:(UIView *)view
{
    AbnormalView *abnormal = [[self alloc] initWithFrame:rect];
    [view addSubview:abnormal];
    return abnormal;
}

+ (AbnormalView *)setRect:(CGRect)rect toView:(UIView *)view abnormalType:(AbnormalType)AbnormalType;
{
    
    [self hideHUDForView:view];
    AbnormalView *abnormal = [AbnormalView showAbnormalViewRect:rect view:view];
    abnormal.backgroundColor = [UIColor clearColor];
    abnormal.abnormalType = AbnormalType;
    return abnormal;
}

+ (AbnormalView *)setRect:(CGRect)rect toView:(UIView *)view abnormalType:(AbnormalType)AbnormalType title:(NSString *)title;
{
    
    [self hideHUDForView:view];
    AbnormalView *abnormal = [AbnormalView showAbnormalViewRect:rect view:view];
    abnormal.backgroundColor = [UIColor clearColor];
    abnormal.abnormalType = AbnormalType;
    abnormal.title = title;
    return abnormal;
}


+ (BOOL)hideHUDForView:(UIView *)view
{
    AbnormalView *abnormal = [self abnormalForView:view];
    if (abnormal != nil) {
        abnormal.removeFromSuperViewOnHide = YES;
        [abnormal hide];
        return YES;
    }
    return NO;
}


+ (AbnormalView *)abnormalForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (AbnormalView *)subview;
        }
    }
    return nil;

}

- (void)hide
{
    if (_removeFromSuperViewOnHide)
        _removeFromSuperViewOnHide = NO;
        [self removeFromSuperview];
}


+ (void)setDelegate:(id)target toView:(UIView *)view;
{
    AbnormalView *abnormal = [self abnormalForView:view];
    if (abnormal.removeFromSuperViewOnHide) return;
    abnormal.delegate = target;
    [abnormal addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:abnormal action:@selector(clickCategory)]];
    
}

- (void)clickCategory
{
    if ([_delegate respondsToSelector:@selector(abnormalReloadDatas)] && [_delegate conformsToProtocol:@protocol(AbnormalViewDelegate)]) {
        [_delegate abnormalReloadDatas];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
