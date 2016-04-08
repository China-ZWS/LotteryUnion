//
//  BaseBettingField.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/9.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "numberSniperTextFild.h"

@interface NumberView : UIView

@end

@implementation NumberView

/*数字视图*/
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, RGBA(255, 255, 255, 1).CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
    
    UIColor *lineColor = RGBA(122, 122, 122, 1);
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(CGRectGetWidth(rect), 0) lineColor:lineColor lineWidth:.5];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 4) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 4) lineColor:lineColor lineWidth:.5];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 2) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 2) lineColor:lineColor lineWidth:.5];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 4 * 3) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 4 * 3) lineColor:lineColor lineWidth:.5];
    
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) / 3, 0) end:CGPointMake(CGRectGetWidth(rect) / 3, CGRectGetHeight(rect)) lineColor:lineColor lineWidth:.5];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) / 3 * 2, 0) end:CGPointMake(CGRectGetWidth(rect) / 3 * 2, CGRectGetHeight(rect)) lineColor:lineColor lineWidth:.5];
    
}

@end

#define backColor(size) [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:size lineWidth:.5 lineColor:RGBA(122, 122, 122, 1) backgroundColor:RGBA(200, 203, 213, 1) hasCenterLine:NO]]

@interface numberSniperCell : UICollectionViewCell
@property (nonatomic) UILabel *num;
@end

/*Cell*/
@implementation numberSniperCell
- (id)initWithFrame:(CGRect)frame
{
    
    if ((self = [super initWithFrame:frame])) {
        _num = [UILabel new];
        _num.font = Font(20);
        
        _num.textAlignment = NSTextAlignmentCenter;
        _num.textColor = [UIColor blackColor];
        [self.contentView addSubview:_num];
        
    }
    return self;
}

/*布局子控件*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    _num.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
@end



#pragma mark -- 输入框
@interface numberSniperTextFild ()
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectView;
@property (nonatomic) NSMutableString *content;
@property (nonatomic) UIView *coverView;
@end

@implementation numberSniperTextFild

- (void)dealloc
{
    [self removeAllSubviews];
}

/*背景覆盖视图*/
- (UIView *)coverView
{
    if (!_coverView)
    {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH)];
        _coverView.backgroundColor = RGBA(20, 20, 20, 1);
        _coverView.alpha = 0;
        
        /*给_coverView添加一个手势监测*/
        
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder)]];
    }
    return _coverView;

}

//初始化方法
- (id)initWithFrame:(CGRect)frame toView:(UIView *)view;
{
    if ((self = [super initWithFrame:frame]))
    {
        self.text = @"5";
        _fatherView = view;
        self.textAlignment = NSTextAlignmentCenter;
        [self.content appendFormat:@"5"];
        self.inputView = [self contentView];
        [_fatherView.superview insertSubview:self.coverView belowSubview:_fatherView];
    }
    return self;
}


//内容视图==（键盘）
- (UIView *)contentView
{
    NumberView *contentView = [[NumberView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(184))];
    [contentView addSubview:self.collectView];
    return contentView;
}

//布局
- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

//CollectionView
- (UICollectionView *)collectView
{
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(184)) collectionViewLayout:[self segmentBarLayout]];
    _collectView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectView registerClass:[numberSniperCell class] forCellWithReuseIdentifier:@"cell"];
    _collectView.delegate = self;
    _collectView.alwaysBounceVertical  = NO;
    _collectView.dataSource = self;
    _collectView.backgroundColor = [UIColor clearColor];
    return _collectView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGFloat)CGRectGetWidth(collectionView.frame) / 3.000000f, CGRectGetHeight(collectionView.frame) / 4.0000000f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    numberSniperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundView  = nil;
    if (indexPath.row < 9)
    {
        cell.num.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        cell.backgroundColor = [UIColor clearColor];
    }
    else if (indexPath.row == 9)
    {
        cell.num.text = @"确认";
        cell.backgroundColor = backColor(cell.size);
    }
    else if (indexPath.row == 10)
    {
        cell.num.text = @"0";
        cell.backgroundColor = [UIColor clearColor];
    }
    else
    {
        cell.backgroundColor = backColor(cell.size);
        cell.num.hidden = YES;
        UIButton *backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        backgroundView.frame = cell.bounds;
        [backgroundView setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
         cell.backgroundView = backgroundView;
    }
    return cell;
}

//Cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    numberSniperCell *cell = (numberSniperCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath.row != 9 && indexPath.row != 11)
    {
//        if (self.text.length == 0 && [cell.num.text isEqualToString:@"0"])
//        {
//           return;
//        }
        
        //设置最大值
        NSUInteger loc = _content.length;
        if (loc > 1)
        {
            [_content setString:@"20"];
            self.text = _content;
            return;
        }
        [_content appendString:cell.num.text];
        if(_content.integerValue>20)
        {
           [_content setString:@"20"];
        }
        if(_content.integerValue==0||[_content isEqualToString:@""])
        {
            [_content setString:@"0"];
        }
        self.text = _content;
        //在这里返回一个协议方法
       if(_NumberSniperDelegate)
       {
           [_NumberSniperDelegate numberHadChange:self];
       }
        
    }
    else if (indexPath.row == 11)
    {
        NSUInteger loc = _content.length;
        if (loc == 0) return;
        NSRange range = NSMakeRange(loc - 1, 1);
        [_content deleteCharactersInRange:range];
        self.text = _content;
    }
    else
    {
           [self resignFirstResponder];
    }
    
}

//内容
- (NSMutableString *)content
{
    if (!_content) {
        _content = [NSMutableString stringWithCapacity:2];
    }
    return _content;
}


//设置默认的文本
- (void)setDefaultText:(NSString *)defaultText
{
    NSUInteger loc = _content.length;
    NSRange range = NSMakeRange(0, loc);
    [_content deleteCharactersInRange:range];
    [_content appendString:defaultText];
    self.text = _content;
}

- (BOOL)becomeFirstResponder
{
    
    [UIView animateWithDuration:0.3f animations:^{
        _coverView.alpha = 0.05;
        [_fatherView.superview insertSubview:self.coverView belowSubview:_fatherView];
    }];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if (![self.text isEqualToString:@""]&&![self.text isEqualToString:@"0"])
    {
        [UIView animateWithDuration:0.3f animations:^{
            _coverView.alpha = 0;
        }];

    }
    return [super resignFirstResponder];
}


@end
