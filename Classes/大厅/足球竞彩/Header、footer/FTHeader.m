//
//  FTHeader.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "FTHeader.h"

@interface FTHeader ()
{
    UIButton *_currentBtn;
    BOOL _hasFirst;
}
@property (nonatomic, copy) void(^select)(FBBettingType type);
@property (nonatomic,  strong) UIButton *singleBtn;
@property (nonatomic, strong) UIButton *doubleBtn;
@property (nonatomic, strong) UILabel *allTitle;

@end

@implementation FTHeader

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - .3) end:CGPointMake(CGRectGetMaxX(rect), CGRectGetHeight(rect) - .3) lineColor:CustomGray lineWidth:.3];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(35))])) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (FTHeader *)selectBlock:(void(^)(FBBettingType type))select;
{
    FTHeader *header = [FTHeader new];
    header.select = select;
    return header;
}

- (UILabel *)allTitle
{
    _allTitle = [UILabel new];
    _allTitle.frame = CGRectMake(0, 0, DeviceW / 5 * 2, CGRectGetHeight(self.frame));
    _allTitle.font = Font(15);
    _allTitle.textAlignment = NSTextAlignmentCenter;
    _allTitle.textColor = [UIColor blackColor];
    return _allTitle;
}

- (UIButton *)singleBtn
{
    _singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _singleBtn.frame = CGRectMake(CGRectGetMaxX(_allTitle.frame), 0, DeviceW / 5 * 1.5, CGRectGetHeight(self.frame));
    [_singleBtn setBackgroundImage:[UIImage drawrWithbottomLine:CGSizeMake(CGRectGetWidth(_singleBtn.frame), CGRectGetHeight(_singleBtn.frame) - 2) lineWidth:2 lineColor:CustomRed backgroundColor:[UIColor clearColor]] forState:UIControlStateSelected];
    _singleBtn.titleLabel.font = Font(15);
    [_singleBtn setTitle:@"单场投注" forState:UIControlStateNormal];
    [_singleBtn setTitleColor:CustomBlack forState:UIControlStateNormal];
    [_singleBtn setTitleColor:CustomRed forState:UIControlStateSelected];
    [_singleBtn addTarget:self action:@selector(eventWithTouch:) forControlEvents:UIControlEventTouchUpInside];
    return _singleBtn;
}


- (UIButton *)doubleBtn
{
    _doubleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doubleBtn.frame = CGRectMake(CGRectGetMaxX(_singleBtn.frame), 0, DeviceW / 5 * 1.5, CGRectGetHeight(self.frame));
    [_doubleBtn setBackgroundImage:[UIImage drawrWithbottomLine:CGSizeMake(CGRectGetWidth(_doubleBtn.frame), CGRectGetHeight(_doubleBtn.frame) - 2) lineWidth:2 lineColor:CustomRed backgroundColor:[UIColor clearColor]] forState:UIControlStateSelected];
    _doubleBtn.titleLabel.font = Font(15);
    [_doubleBtn setTitle:@"过关投注" forState:UIControlStateNormal];
    [_doubleBtn setTitleColor:CustomBlack forState:UIControlStateNormal];
    [_doubleBtn setTitleColor:CustomRed forState:UIControlStateSelected];
    [_doubleBtn addTarget:self action:@selector(eventWithTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return _doubleBtn;
}


#pragma mark - 默认选中。
- (void)defaultTouchWithSkipmatch
{
    _doubleBtn.selected = YES; // default touched;
    _singleBtn.selected = NO;
    _currentBtn = _doubleBtn;
    _select(kSkipmatch);
}


#pragma mark - 手动选投注类型
- (void)eventWithTouch:(UIButton *)button
{
    button.selected = !button.selected;
    _currentBtn.selected = !_currentBtn.selected;
    _currentBtn = button;
    if ([_currentBtn isEqual:_singleBtn]) {
        _select(kSingle);
    }
    else
        _select(kSkipmatch);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_hasFirst) return;
    _hasFirst = YES;
    [self addSubview:self.allTitle];
    [self addSubview:self.singleBtn];
    [self addSubview:self.doubleBtn];
    [self defaultTouchWithSkipmatch]; // 默认过关选项
}

#pragma mark - 显示总赛事数量
- (void)setHeaderWithAllCompetition:(NSInteger)numOfAllCompetition;
{
    NSString *title = [NSString stringWithFormat:@"全部赛事 %d场",numOfAllCompetition];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([@"全部赛事 " length], title.length - [@"全部赛事 " length])];
    [attrString addAttribute:NSFontAttributeName value:Font(11) range:NSMakeRange([@"全部赛事 " length], title.length - [@"全部赛事 " length])];
    [attrString addAttribute:NSFontAttributeName value:Font(15) range:NSMakeRange(0,[@"全部赛事 " length])];

    _allTitle.attributedText = attrString;

}

#pragma mark - 影藏单注投注
- (void)hideSingleOption:(BOOL)hasHide;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hasHide)
        {
            _singleBtn.hidden = hasHide;
            _doubleBtn.left = CGRectGetMaxX(_allTitle.frame) + CGRectGetWidth(_doubleBtn.frame) / 2;
        }
        else
        {
            _singleBtn.hidden = hasHide;
            _doubleBtn.left = CGRectGetMaxX(_singleBtn.frame);
        }
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
