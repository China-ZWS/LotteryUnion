//
//  BQCOptionView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/1.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BQCOptionView.h"
#import "PJCollectionViewCell.h"
@interface BQCOptionCell : PJCollectionViewCell

@end

@implementation BQCOptionCell


- (void)drawRect:(CGRect)rect
{
    
    [self drawWithChamferOfRectangle:rect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomBlack backgroundColor:[UIColor clearColor]];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];

        _title = [UILabel new];
        _title.font = Font(12);
        _title.highlightedTextColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        
        _abstracts = [UILabel new];
        _abstracts.highlightedTextColor = [UIColor whiteColor];
        _abstracts.font = Font(10);
        _abstracts.textAlignment = NSTextAlignmentCenter;
        _abstracts.textColor = CustomBlack;
        
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 - _title.font.lineHeight - ScaleH(1), CGRectGetWidth(self.frame), _title.font.lineHeight);
    _abstracts.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2 + ScaleH(1), CGRectGetWidth(self.frame), _title.font.lineHeight);
    
}

- (void)setDatas:(id)datas
{
    _title.text = datas[@"value_display"];
    _abstracts.text = datas[@"odds"];
}


@end

@interface BQCOptionView()
<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *_optionDatas;
}

@property (nonatomic, copy) void(^finished)(id datas);
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *title;
@property (nonatomic) id datas;
@property (nonatomic) UIButton *cancel;
@property (nonatomic) UIButton *sure;
@property (assign) BOOL removeFromSuperViewOnHide;
@property (nonatomic) NSMutableArray *cacheDatas;
@property (nonatomic) UILabel *titleLb;

@end

@implementation BQCOptionView


- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - ScaleH(35)) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - ScaleH(35)) lineColor:CustomBlack lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) - ScaleH(30)) end:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) - ScaleH(5)) lineColor:CustomBlack lineWidth:LineWidth];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake((DeviceW - ScaleW(290)) / 2, (DeviceH - ScaleH(115) - ScaleH(70)) / 2, ScaleW(290), ScaleH(115) + ScaleH(70))])) {
        self.backgroundColor = [UIColor whiteColor];
        [self getCornerRadius:5 borderColor:[UIColor clearColor] borderWidth:0 masksToBounds:YES];
    }
    return self;
    
}

+ (id)showCoverView:(UIWindow *)window
{
    BQCOptionView *bqc = [BQCOptionView new];
    [window addSubview:bqc.coverView];
    [window addSubview:bqc];
    return bqc;
}


+ (id)showWithDatas:(id)datas cacheDatas:(NSArray *)cacheDatas finished:(void(^)(id datas))finished;
{
    BQCOptionView *bqc = [BQCOptionView showCoverView:[UIApplication sharedApplication].keyWindow];
    bqc.datas = datas;
    bqc.finished = finished;
    bqc.cacheDatas = [NSMutableArray array];
    if (cacheDatas.count && cacheDatas)
    {
        [bqc.cacheDatas addObjectsFromArray:cacheDatas];
    }
    return bqc;
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    _optionDatas = [self filtrate:datas[@"list_value4"]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.title];
    [self addSubview:self.collectionView];
    [self addSubview:self.cancel];
    [self addSubview:self.sure];
    [self addSubview:self.titleLb];
    
    self.alpha = 1.0;
    _coverView.alpha = 0.5;

    [UIView animateWithDuration:0.3f animations:^{
        [UIView shakeToShow:self duration:.3f];
    }];

}


- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (UICollectionView *)collectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(ScaleX(20), ScaleY(35), CGRectGetWidth(self.frame) - ScaleW(25), ScaleH(115)) collectionViewLayout:[self segmentBarLayout]];
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[BQCOptionCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = NO;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (NSDictionary *dic in _cacheDatas)
        {
            [_collectionView selectItemAtIndexPath:dic[@"indexPath"] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
    return _collectionView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = (CGRectGetWidth(self.frame) - ScaleW(25)) / 3 ;
    
    if (indexPath.row == _optionDatas.count - 1)
    {
        NSInteger num = _optionDatas.count % 3 - 1;
        if (num < 0) {
            num = 2;
        }
        width = (CGRectGetWidth(self.frame) - ScaleW(25)) / 3 * (3 - num);
    }
    return CGSizeMake(width,ScaleH(35));
}


#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _optionDatas.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BQCOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datas = _optionDatas[indexPath.row];
    NSDictionary *dic = _optionDatas[indexPath.row];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"value_storage == %@",dic[@"value_storage"]];
    NSArray *same = [_cacheDatas filteredArrayUsingPredicate:predicate];
    
    if (same.count) {
        cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:YES]];
        cell.title.highlighted = cell.abstracts.highlighted = YES;
        
    }
    else
    {
        cell.title.highlighted = cell.abstracts.highlighted = NO;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    BQCOptionCell *cell = (BQCOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.title.highlighted = cell.abstracts.highlighted = YES;
    cell.backgroundColor = [UIColor  colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:YES]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_optionDatas[indexPath.row]];
    dic[@"indexPath"] = indexPath;
    [_cacheDatas addObject:dic];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BQCOptionCell *cell = (BQCOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.title.highlighted = cell.abstracts.highlighted = NO;
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = _optionDatas[indexPath.row];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"value_storage == %@",dic[@"value_storage"]];
    NSArray *same = [_cacheDatas filteredArrayUsingPredicate:predicate];
    
    if (same && same.count)
    {
        [_cacheDatas removeObject:same[0]];
    }
}


- (NSArray *)filtrate:(NSArray *)datas
{
    return [self getSortedArray:datas result:NSOrderedAscending];

}

- (NSArray *)getSortedArray:(NSArray *)items result:(NSComparisonResult)result
{
    return [items  sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                
                NSComparisonResult comparisonResult = [obj1[@"value_storage"] compare:obj2[@"value_storage"]];
                return comparisonResult == result;
            }];
}


- (UILabel *)titleLb
{
    
    NSInteger row = ceil(_optionDatas.count / 3.0);
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(ScaleW(5), CGRectGetMinY(_collectionView.frame), ScaleW(15), ScaleH(35) * row)];
    [_titleLb getCornerRadius:0 borderColor:[UIColor whiteColor] borderWidth:LineWidth masksToBounds:YES];
    _titleLb.backgroundColor = RGBA(227, 115, 14, 1);
    _titleLb.text = @"半全场";
    _titleLb.numberOfLines = 0;
    _titleLb.textColor = [UIColor whiteColor];
    _titleLb.textAlignment = NSTextAlignmentCenter;
    _titleLb.font = Font(13);
    return _titleLb;
}


- (UIButton *)cancel
{
    _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel.frame = CGRectMake(0, CGRectGetHeight(self.frame) - ScaleH(35), CGRectGetWidth(self.frame) / 2, ScaleH(35));
    [_cancel setTitle:@"取 消" forState:UIControlStateNormal];
    [_cancel setTitleColor:CustomBlack forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(eventWithCancel) forControlEvents:UIControlEventTouchUpInside];
    _cancel.titleLabel.font = Font(14);
    return _cancel;
}

- (UIButton *)sure
{
    _sure = [UIButton buttonWithType:UIButtonTypeCustom];
    _sure.frame = CGRectMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - ScaleH(35), CGRectGetWidth(self.frame) / 2, ScaleH(35));
    [_sure setTitle:@"确 定" forState:UIControlStateNormal];
    [_sure setTitleColor:CustomBlack forState:UIControlStateNormal];
    [_sure addTarget:self action:@selector(eventWithSure) forControlEvents:UIControlEventTouchUpInside];
    _sure.titleLabel.font = Font(14);
    return _sure;
}

- (UILabel *)title
{
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), ScaleH(35))];
    _title.font = FontBold(15);
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = [UIColor blackColor];
    NSString *title = [NSString stringWithFormat:@"%@ VS %@",_datas[@"host_team"],_datas[@"guest_team"]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([_datas[@"host_team"] length] + 1, 2)];
    [attrString addAttribute:NSFontAttributeName value:Font(11) range:NSMakeRange([_datas[@"host_team"] length] + 1, 2)];
    _title.attributedText = attrString;
    return _title;
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


#pragma mark - 取消
- (void)eventWithCancel
{
    _removeFromSuperViewOnHide = YES;
    [self hide];
}

#pragma mark - 确定
- (void)eventWithSure
{
    _removeFromSuperViewOnHide = YES;
    [self hide];
    _finished(_cacheDatas);
}


+ (BOOL)hideHUDForView
{
    BQCOptionView *bqc = [self menuForView:[UIApplication sharedApplication].keyWindow];
    if (bqc != nil)
    {
        bqc.removeFromSuperViewOnHide = YES;
        [bqc hide];
        return YES;
    }
    return NO;
}


+ (BQCOptionView *)menuForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum)
    {
        if ([subview isKindOfClass:self])
        {
            return (BQCOptionView *)subview;
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

@end
