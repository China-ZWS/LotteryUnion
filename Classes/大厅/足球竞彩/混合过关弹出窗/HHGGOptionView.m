//
//  HHGGOptionView.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "HHGGOptionView.h"
#import "HHGGOpitonListView.h"

@interface HHGGOptionView ()
@property (nonatomic, copy) void(^finished)(FBDatasModel *model);
@property (nonatomic) HHGGOpitonListView *listView;
@property (assign) BOOL removeFromSuperViewOnHide;
@property (nonatomic, copy) FBDatasModel *cacheModel;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIButton *cancel;
@property (nonatomic) UIButton *sure;
@property (nonatomic) id datas;

@end
@implementation HHGGOptionView

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - ScaleH(35)) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - ScaleH(35)) lineColor:CustomBlack lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) - ScaleH(30)) end:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) - ScaleH(5)) lineColor:CustomBlack lineWidth:LineWidth];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake((DeviceW - ScaleW(290)) / 2, (DeviceH - ScaleH(430)) / 2, ScaleW(290), ScaleH(430))])) {
        self.alpha = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self getCornerRadius:5 borderColor:[UIColor clearColor] borderWidth:0 masksToBounds:YES];
    }
    return self;
    
}


+ (id)showCoverView:(UIWindow *)window
{
    HHGGOptionView *hhgg = [HHGGOptionView new];
    [window addSubview:hhgg.coverView];
    [window addSubview:hhgg];
    return hhgg;
}


+ (id)showWithDatas:(id)datas cacheModel:(FBDatasModel *)cacheModel finished:(void(^)(FBDatasModel *model))finished;
{
    HHGGOptionView *hhgg = [HHGGOptionView showCoverView:[UIApplication sharedApplication].keyWindow];
    hhgg.datas = datas;
    hhgg.finished = finished;
    hhgg.cacheModel = cacheModel  ;
    hhgg.cacheModel.scroes = [cacheModel.scroes mutableCopy];  ;
    hhgg.cacheModel.BQCDatas = [cacheModel.BQCDatas mutableCopy];  ;

    return hhgg;
}

- (void)setDatas:(id)datas
{
    _datas = datas;
}

- (void)layoutSubviews
{    
    [super layoutSubviews];
    if (!_listView) {
        [self addSubview:self.listView];
    }
    if (!_title) {
        [self addSubview:self.title];
    }
    if (!_cancel) {
        [self addSubview:self.cancel];
    }
    if (!_sure) {
        [self addSubview:self.sure];
    }
    
    _coverView.alpha = 0.5;
    self.alpha = 1.0;

    [UIView shakeToShow:self duration:.3f];
}

- (HHGGOpitonListView *)listView
{
    _listView = [[HHGGOpitonListView alloc] initWithFrame:CGRectMake(0, ScaleH(35), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - ScaleH(70)) datas:_datas];
    return _listView;
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
    FBDatasModel *dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];
   
    NSLog(@"_c1111acheModel %@",_cacheModel.scroes);

    if ([FBTool.selectDatas containsObject:dataModel])
    {
        [[FBTool mutableArrayValueForKey:@"selectDatas"] removeObject:dataModel];
    }
    NSLog(@"_c1111acheModel %@",_cacheModel.scroes);
    
    if (_cacheModel.win || _cacheModel.pin || _cacheModel.lose || _cacheModel.rWin || _cacheModel.rPin || _cacheModel.rLose || _cacheModel.scroes.count || _cacheModel.BQCDatas.count || _cacheModel.JQS_select_one || _cacheModel.JQS_select_two || _cacheModel.JQS_select_three || _cacheModel.JQS_select_four || _cacheModel.JQS_select_five || _cacheModel.JQS_select_six || _cacheModel.JQS_select_seven || _cacheModel.JQS_select_eight)  {
        [[FBTool mutableArrayValueForKey:@"selectDatas"] addObject:_cacheModel];
    }
    
    _removeFromSuperViewOnHide = YES;
    [self hide];
}

#pragma mark - 确定
- (void)eventWithSure
{
    
    FBDatasModel *dataModel = [FootBallModel filtrateWithBettingDatas:_datas play:kHHGG_two];
    _removeFromSuperViewOnHide = YES;
    [self hide];

    
    _finished(dataModel);

    
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
