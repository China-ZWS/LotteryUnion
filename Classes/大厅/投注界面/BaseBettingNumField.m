//
//  BaseBettingField.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/9.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BaseBettingNumField.h"

@interface NumView : UIView

@end

@implementation NumView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *lineColor = RGBA(122, 122, 122, 1);
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) / 3.0, 0) end:CGPointMake(CGRectGetWidth(rect) / 3.0, CGRectGetHeight(rect)) lineColor:lineColor lineWidth:.4];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) / 3.0 * 2, 0) end:CGPointMake(CGRectGetWidth(rect) / 3.0 * 2, CGRectGetHeight(rect)) lineColor:lineColor lineWidth:.4];
    
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(CGRectGetWidth(rect), 0) lineColor:lineColor lineWidth:.4];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 4) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 4) lineColor:lineColor lineWidth:.4];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 2) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 2) lineColor:lineColor lineWidth:.4];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 4 * 3) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 4 * 3) lineColor:lineColor lineWidth:.4];
    

}

@end

#define backColor(size) [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:size lineWidth:.2 lineColor:RGBA(122, 122, 122, 1) backgroundColor:RGBA(200, 203, 213, 1) hasCenterLine:NO]]

@interface BaseBettingNumCell : UICollectionViewCell
@property (nonatomic) UILabel *num;
@end

@implementation BaseBettingNumCell
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    _num.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
@end

@interface BaseBettingNumField ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) UICollectionView *collectView;
@property (nonatomic) NSMutableString *content;
@property (nonatomic) UIView *coverView;
@end

@implementation BaseBettingNumField

- (void)dealloc
{
    [self removeAllSubviews];
}

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

- (id)initWithFrame:(CGRect)frame toView:(UIView *)view;
{
    if ((self = [super initWithFrame:frame]))
    {
        self.text = @"1";
        self.textAlignment = NSTextAlignmentCenter;
        [self.content appendFormat:@"1"];
        self.inputView = [self contentView];
        [view.superview insertSubview:self.coverView belowSubview:view];
    }
    return self;
}




- (UIView *)contentView
{
    NumView *contentView = [[NumView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(184))];
    [contentView addSubview:self.collectView];
    return contentView;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (UICollectionView *)collectView
{
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(184)) collectionViewLayout:[self segmentBarLayout]];
    [_collectView registerClass:[BaseBettingNumCell class] forCellWithReuseIdentifier:@"cell"];
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
    BaseBettingNumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundView  = nil;
    if (indexPath.row < 9) {
        cell.num.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseBettingNumCell *cell = (BaseBettingNumCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath.row != 9 && indexPath.row != 11)
    {
        if (self.text.length == 0 && [cell.num.text isEqualToString:@"0"]) return;
        NSUInteger loc = _content.length;
        if (loc > 3)
        {
            [_content setString:@"9999"];
            self.text = _content;
            return;
        }
        [_content appendString:cell.num.text];
        self.text = _content;
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

- (NSMutableString *)content {
    if (!_content) {
        _content = [NSMutableString stringWithCapacity:2];
    }
    return _content;
}



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
        _coverView.alpha = 0.5;
    }];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self.text isEqualToString:@"0"] || [self.text isEqualToString:@""]) {
        [_content appendString:@"1"];
        self.text = _content;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _coverView.alpha = 0;
    }];
    return [super resignFirstResponder];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
