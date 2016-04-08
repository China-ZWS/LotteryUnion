//
//  FTFooter.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//


@interface FTFooterItem : UIButton

@end

@implementation FTFooterItem

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsTouchWhenHighlighted = YES;
        self.titleLabel.font = NFont(13);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat allHeight = NFont(13).lineHeight + self.currentImage.height + 2;
    CGFloat imageY = (CGRectGetHeight(contentRect) - allHeight) / 2;
    CGFloat imageX = (contentRect.size.width - self.currentImage.size.width) / 2;
    return  CGRectMake(imageX, imageY, self.currentImage.size.width, self.currentImage.size.height);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect

{
    return CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 2, CGRectGetWidth(contentRect), NFont(13).lineHeight);
}

@end

#import "FTFooter.h"
#import "FootBallModel.h"
@interface FTFooter ()
{
    FBBettingPlay _play;
}

@property (nonatomic) NSArray *datas;

@property (nonatomic) FBPlayType *playType;
@property (nonatomic) FBBettingType *bettingType;

@property (nonatomic, strong) FTFooterItem *clearBtn;
@property (nonatomic, strong) FTFooterItem *scBtn;
@property (nonatomic, strong) FTFooterItem *finishBtn;

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *selectedLb;
@property (nonatomic, copy) void(^select)(id datas);
@property (nonatomic, copy) void(^clear)();
@property (nonatomic, copy) void(^SCEvent)(id datas);

@end

@implementation FTFooter

- (void)dealloc
{
    [FBTool removeObserver:self forKeyPath:@"selectDatas" context:NULL];
}

+ (FTFooter *)select:(void(^)(id datas))select SCEvent:(void(^)(id datas))SCEvent clear:(void(^)())clear;
{
    FTFooter *footer = [FTFooter new];
    footer.select = select;
    footer.clear = clear;
    footer.SCEvent = SCEvent;
    return footer;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, DeviceH - ScaleH(50), DeviceW, ScaleH(50))])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = RGBA(1, 1, 1, .9);
    }
    return self;
}


#pragma mark - 清空按钮
- (FTFooterItem *)clearBtn
{
    if (!_clearBtn) {
        _clearBtn = [FTFooterItem buttonWithType:UIButtonTypeCustom];
        _clearBtn.frame = CGRectMake(self.width - kDefaultInset.left - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        [_clearBtn setImage:[UIImage imageNamed:@"jczq_sc.png"] forState:UIControlStateNormal];
        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(eventWithClear) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clearBtn];
    }
    return _clearBtn;
}


#pragma mark - 设置选好了的按钮
- (FTFooterItem *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [FTFooterItem buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake(DeviceW / 2 - CGRectGetHeight(self.frame) / 2, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        [_finishBtn setImage:[UIImage imageNamed:@"ctzq_bet.png"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"投注" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(eventWithFinish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (FTFooterItem *)scBtn
{
    if (!_scBtn) {
        _scBtn = [FTFooterItem buttonWithType:UIButtonTypeCustom];
        _scBtn.frame = CGRectMake(_finishBtn.right + (_clearBtn.left - _finishBtn.right - CGRectGetHeight(self.frame)) / 2, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        [_scBtn setImage:[UIImage imageNamed:@"ctzq_send.png"] forState:UIControlStateNormal];
        [_scBtn setTitle:@"送彩票" forState:UIControlStateNormal];
        [_scBtn addTarget:self action:@selector(eventWithSCP) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scBtn;
}



#pragma mark - 设置提示文字
- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) / 2 + 3 , DeviceW / 2 - CGRectGetHeight(self.frame) / 2, Font(13).lineHeight)];
        _titleLb.font = Font(13);
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor whiteColor];
    }
    return _titleLb;
}

#pragma mark - 设置 选择后的计数提示
- (UILabel *)selectedLb
{
    if (!_selectedLb) {
        _selectedLb = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.frame) / 2 - 3 - Font(15).lineHeight, DeviceW / 2 -  CGRectGetHeight(self.frame) / 2, Font(15).lineHeight)];
        _selectedLb.font = Font(15);
        _selectedLb.textColor = [UIColor whiteColor];
        _selectedLb.textAlignment = NSTextAlignmentCenter;
    }
    return _selectedLb;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.clearBtn]; // 设置清空按钮
    [self addSubview:self.finishBtn]; // 设置选好了的按钮
    [self addSubview:self.scBtn];

    
    [self addSubview:self.titleLb]; // 设置提示文字
    [self addSubview:self.selectedLb]; // 设置 选择后的计数提示
    [self setTitle:0];
    /*数组KVO*/
    [FBTool addObserver:self forKeyPath:@"selectDatas" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}


#pragma mark - 送彩票事件
- (void)eventWithSCP
{
    _SCEvent(_datas);
}

#pragma mark - 响应投注事件
- (void)eventWithFinish
{
    _select(_datas);
}

#pragma mark - 响应清空事件
- (void)eventWithClear
{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"play == %d",_play];
    /*通过谓语查询，目的是为了找到‘FBTool.selectDatas’里的‘FBDatasModel’数据对象*/
    NSArray *selectDatas = [FBTool.selectDatas filteredArrayUsingPredicate:predicate];
    [FBTool.selectDatas removeObjectsInArray:selectDatas];
    _clear();
}

#pragma mark - 用户选择的单关还是过关，及但来的选择场次的玩法的提示
- (void)setRuleForSingle:(BOOL)hasSingle;
{
    if (!hasSingle) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"请至少选择 2 场比赛"];
        [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([@"请至少选择 " length], 1)];
        [attrString addAttribute:NSFontAttributeName value:Font(17) range:NSMakeRange([@"请至少选择 " length], 1)];
        _titleLb.attributedText = attrString;
        ;
    }
    else
    {
        _titleLb.text = @"场数不受限制";
    }
}


#pragma mark - 设置已选择了多少场比赛的title
- (void)setTitle:(NSInteger )num
{
    NSString *numStr = [NSString stringWithFormat:@"%d",num];
    
    NSString *title = [NSString stringWithFormat:@"已经选择了 %@ 场",numStr];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([@"已经选择了 " length], numStr.length)];
    [attrString addAttribute:NSFontAttributeName value:Font(17) range:NSMakeRange([@"已经选择了 " length], numStr.length)];
    _selectedLb.attributedText = attrString;
    
}

#pragma mark - 设置用户当前玩法选择了多少场次
- (void)setCurrentBettingType:(FBBettingType)bettingType playType:(FBPlayType)playType;
{
    
    if (bettingType == kSingle) {
        switch (playType) {
            case kSFP:
                _play = kSFP_one;
                break;
            case kRSFP:
                _play = kRSFP_one;
                break;
            case kScore:
                _play = kScore_one;
                break;
            case kBQC:
                _play = kBQC_one;
                break;
            case kJQS:
                _play = kJQS_one;
                break;
            default:
                break;
        }
    }
    else if (bettingType == kSkipmatch)
    {
        switch (playType) {
            case kSFP:
                _play = kSFP_two;
                break;
            case kRSFP:
                _play = kRSFP_two ;
                break;
            case kScore:
                _play = kScore_two;
                break;
            case kBQC:
                _play = kBQC_two;
                break;
            case kJQS:
                _play = kJQS_two;
                break;
            case kHHGG:
                _play = kHHGG_two;
                break;

            default:
                break;
        }
    }
    
    /*
     根据用户选择的条件进行数据筛选
     */
    _datas = [self gotDatafiltering];
    [self setTitle:_datas.count];
    
}

#pragma mark - 数组KVO 监听，目的是知道用户在当前玩法及投注类型选择的场次
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectDatas"])
    {
        /*数据进行筛选*/
        _datas = [self gotDatafiltering];
        [self setTitle:_datas.count];
    }
}


#pragma mark  - 根据用户选择的条件数据筛选
- (NSArray *)gotDatafiltering
{
    
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"play == %d",_play];
    /*通过谓语查询，目的是为了找到‘FBTool.selectDatas’里的‘FBDatasModel’数据对象*/
    NSArray *selectDatas = [FBTool.selectDatas filteredArrayUsingPredicate:predicate];
   
    return selectDatas;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
