//
//  FootBallQueryViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/27.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "FootBallQueryViewController.h"
#import "DataConfigManager.h"
#import "DropdownMenu.h"
#import "FootBallModel.h"
#import "PJTableViewCell.h"
#import "FootballLotteryManagers.h"

@interface FootBallQueryCell : PJTableViewCell
{
    FBPlayType _playType;
}
@property (nonatomic, strong) UILabel *leagueLb;
@property (nonatomic, strong) UILabel *positionLb;
@property (nonatomic, strong) UILabel *endTimeLb;
@property (nonatomic, strong) UILabel *hostLb;
@property (nonatomic, strong) UILabel *guestLb;;
@end

@implementation FootBallQueryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _leagueLb = [UILabel new];
        _leagueLb.textAlignment = NSTextAlignmentCenter;
        _leagueLb.backgroundColor = RGBA(143, 194, 194, 1);
        _leagueLb.textColor = [UIColor whiteColor];
        _leagueLb.font = Font(12);
        _leagueLb.numberOfLines = 0;
        [self.contentView addSubview:_leagueLb];
       
        _positionLb = [UILabel new];
        _positionLb.textAlignment = NSTextAlignmentLeft;
        _positionLb.font = Font(11);
        _positionLb.textColor = CustomBlack;
        [self.contentView addSubview:_positionLb];

        _endTimeLb = [UILabel new];
        _endTimeLb.font = Font(11);
        _endTimeLb.textAlignment = NSTextAlignmentRight;
        _endTimeLb.textColor = CustomBlack;
        [self.contentView addSubview:_endTimeLb];

   
        _hostLb = [UILabel new];
        _hostLb.font = Font(14);
        _hostLb.textAlignment = NSTextAlignmentCenter;
        _hostLb.textColor = [UIColor blackColor];
        _hostLb.numberOfLines = 0;
        [self.contentView addSubview:_hostLb];
        
        _guestLb = [UILabel new];
        _guestLb.font = Font(14);
        _guestLb.textAlignment = NSTextAlignmentCenter;
        _guestLb.textColor = [UIColor blackColor];
        _guestLb.numberOfLines = 0;
        [self.contentView addSubview:_guestLb];
    }
    return self;
}

- (void)setSPF_OR_RQSPF:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    NSString *title = @"未知";
    UIColor *backColor = CustomSkyblue;
    NSString *playType= nil;
    NSInteger scoreWidth = ScaleH(12) + _positionLb.font.lineHeight + ScaleH(15);
    if (_playType == kSFP)
    {
        playType = @"spf";
    }
    else if (_playType == kRSFP)
    {
        playType = @"rq_spf";
    }
    
    if ([_datas[playType] integerValue] == 3 && [_datas[playType] length])
    {
        title = @"胜";
        backColor = CustomRed;
    }
    else if ([_datas[playType] integerValue] == 1 && [_datas[playType] length])
    {
        title = @"平";
        backColor = RGBA(236, 161, 11, 1);
    }
    else if ([_datas[playType] integerValue] == 0 && [_datas[playType] length])
    {
        title = @"负";
        backColor = RGBA(35, 151, 160, 1);
    }
    
    CGContextSetFillColorWithColor(context, backColor.CGColor);
    CGContextFillRect(context, CGRectMake(_hostLb.right, 0, scoreWidth, CGRectGetHeight(rect)));
    
    CGSize titleSize = [NSObject getSizeWithText:title font:_leagueLb.font maxSize:CGSizeMake(scoreWidth, _leagueLb.font.lineHeight)];
    [self drawTextWithText:title rect:CGRectMake(_hostLb.right + (scoreWidth - titleSize.width) / 2, _leagueLb.top + (_leagueLb.height - titleSize.height) / 2, titleSize.width, titleSize.height) color:[UIColor whiteColor] font:_leagueLb.font];
    
    NSString *bf = _datas[@"bf"];
    NSString *score = @"未知";
    if (bf.length) {
        score = [NSString stringWithFormat:@"%@:%@",[bf substringToIndex:1],[bf substringFromIndex:1]];
    }
    CGSize scoreSize = [NSObject getSizeWithText:score font:_positionLb.font maxSize:CGSizeMake(scoreWidth, _positionLb.font.lineHeight)];
    
    [self drawTextWithText:score rect:CGRectMake(_hostLb.right + (scoreWidth - scoreSize.width) / 2, _leagueLb.top + (_leagueLb.height - titleSize.height) / 2 + titleSize.height + ScaleH(2), scoreSize.width, scoreSize.height) color:[UIColor whiteColor] font:_positionLb.font];
    CGContextStrokePath(context);

}

- (void)setScore:(CGRect)rect
{
    NSInteger scoreWidth = ScaleH(12) + _positionLb.font.lineHeight + ScaleH(15);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, RGBA(147, 128, 208, 1).CGColor);
    CGContextFillRect(context, CGRectMake(_hostLb.right, 0, scoreWidth, CGRectGetHeight(rect)));
  
    NSString *bf = _datas[@"bf"];
    NSString *score = @"未知";
    if (bf.length) {
        score = [NSString stringWithFormat:@"%@:%@",[bf substringToIndex:1],[bf substringFromIndex:1]];
    }
    CGSize scoreSize = [NSObject getSizeWithText:score font:_positionLb.font maxSize:CGSizeMake(scoreWidth, _positionLb.font.lineHeight)];
    
    [self drawTextWithText:score rect:CGRectMake(_hostLb.right + (scoreWidth - scoreSize.width) / 2, (CGRectGetHeight(rect) - scoreSize.height) / 2, scoreSize.width, scoreSize.height) color:[UIColor whiteColor] font:_positionLb.font];
    CGContextStrokePath(context);

}

- (void)setBQC:(CGRect)rect
{
    NSInteger scoreWidth = ScaleH(12) + _positionLb.font.lineHeight + ScaleH(15);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, RGBA(227, 115, 14, 1).CGColor);
    CGContextFillRect(context, CGRectMake(_hostLb.right, 0, scoreWidth, CGRectGetHeight(rect)));
    
    NSDictionary *dic = @{@"33":@"胜胜",@"31":@"胜平",@"30":@"胜负",@"13":@"平胜",@"11":@"平胜",@"10":@"平负",@"03":@"负胜",@"01":@"负平",@"00":@"负负"};
    NSString *title = dic[_datas[@"bqc"]];
    CGSize titleSize = [NSObject getSizeWithText:title font:_leagueLb.font maxSize:CGSizeMake(scoreWidth, _leagueLb.font.lineHeight)];
    [self drawTextWithText:title rect:CGRectMake(_hostLb.right + (scoreWidth - titleSize.width) / 2, _leagueLb.top + (_leagueLb.height - titleSize.height) / 2, titleSize.width, titleSize.height) color:[UIColor whiteColor] font:_leagueLb.font];

    NSString *bf = _datas[@"bf"];
    NSString *score = @"未知";
    if (bf.length) {
        score = [NSString stringWithFormat:@"%@:%@",[bf substringToIndex:1],[bf substringFromIndex:1]];
    }

    CGSize scoreSize = [NSObject getSizeWithText:score font:_positionLb.font maxSize:CGSizeMake(scoreWidth, _positionLb.font.lineHeight)];
    
    [self drawTextWithText:score rect:CGRectMake(_hostLb.right + (scoreWidth - scoreSize.width) / 2, _leagueLb.top + (_leagueLb.height - titleSize.height) / 2 + titleSize.height + ScaleH(2), scoreSize.width, scoreSize.height) color:[UIColor whiteColor] font:_positionLb.font];
    CGContextStrokePath(context);

}

- (void)setJQS:(CGRect)rect
{
    NSInteger scoreWidth = ScaleH(12) + _positionLb.font.lineHeight + ScaleH(15);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, RGBA(88, 179, 113, 1).CGColor);
    CGContextFillRect(context, CGRectMake(_hostLb.right, 0, scoreWidth, CGRectGetHeight(rect)));
    
    NSString *title = _datas[@"zjq"];
    CGSize titleSize = [NSObject getSizeWithText:title font:_leagueLb.font maxSize:CGSizeMake(scoreWidth, _leagueLb.font.lineHeight)];
    [self drawTextWithText:title rect:CGRectMake(_hostLb.right + (scoreWidth - titleSize.width) / 2, _leagueLb.top + (_leagueLb.height - titleSize.height) / 2, titleSize.width, titleSize.height) color:[UIColor whiteColor] font:_leagueLb.font];
    
    NSString *bf = _datas[@"bf"];
    NSString *score = @"未知";
    if (bf.length) {
        score = [NSString stringWithFormat:@"%@:%@",[bf substringToIndex:1],[bf substringFromIndex:1]];
    }
    CGSize scoreSize = [NSObject getSizeWithText:score font:_positionLb.font maxSize:CGSizeMake(scoreWidth, _positionLb.font.lineHeight)];
    
    [self drawTextWithText:score rect:CGRectMake(_hostLb.right + (scoreWidth - scoreSize.width) / 2, _leagueLb.top + (_leagueLb.height - titleSize.height) / 2 + titleSize.height + ScaleH(2), scoreSize.width, scoreSize.height) color:[UIColor whiteColor] font:_positionLb.font];
    CGContextStrokePath(context);

}

- (void)drawRect:(CGRect)rect
{
    switch (_playType) {
        case kSFP:
            [self setSPF_OR_RQSPF:rect];
            break;
        case kRSFP:
            [self setSPF_OR_RQSPF:rect];
            break;
        case kScore:
            [self setScore:rect];

            break;
        case kBQC:
            [self setBQC:rect];
            break;
        case kJQS:
            [self setJQS:rect];
            break;
   
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize leagueLbSize = [NSObject getSizeWithText:_leagueLb.text font:_leagueLb.font maxSize:CGSizeMake(ScaleW(65), MAXFLOAT)];
    CGFloat height = ScaleH(15);
    if (leagueLbSize.height > _leagueLb.font.lineHeight)
    {
        height = leagueLbSize.height + 3;
    }
    CGFloat scoreWidth = ScaleH(12) + _positionLb.font.lineHeight + ScaleH(15);
    _leagueLb.frame = CGRectMake(ScaleX(15), ScaleH(5), ScaleW(65), height);
    _positionLb.frame = CGRectMake(_leagueLb.left, _leagueLb.bottom + ScaleH(2), _leagueLb.width, _positionLb.font.lineHeight);
    _endTimeLb.frame = CGRectMake(_leagueLb.left, _positionLb.top, _leagueLb.width, _endTimeLb.font.lineHeight);
    _hostLb.frame = CGRectMake(_leagueLb.right + ScaleX(15), 0, (deviceWidth - _leagueLb.right - ScaleW(30) - scoreWidth) / 2, CGRectGetHeight(self.frame));
    _guestLb.frame = CGRectMake(CGRectGetWidth(self.frame) - _hostLb.width - ScaleW(15), 0, _hostLb.width, _hostLb.height);
}

- (void)setDatas:(id)datas playType:(FBPlayType)playType
{
    [super setDatas:datas];
    _playType = playType;
    _leagueLb.text = _datas[@"league_name"];
    _positionLb.text = [_datas[@"position"] substringFromIndex:8];
    _endTimeLb.text = [[_datas[@"end_time"] componentsSeparatedByString:@" "][1] substringToIndex:5];
    _hostLb.text = datas[@"host_team"];
    _guestLb.text = datas[@"guest_team"];
    [self setNeedsDisplay];
}

@end


#import "DateScreening.h"

@interface FootBallQueryViewController ()
{
    FBPlayType _playType;
    NSMutableArray *_puckerArray;
    UIButton *_titleBtn;
}
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) NSString *match_no;
@end
@implementation FootBallQueryViewController

- (id)initWithPlayType:(FBPlayType)playType match_no:(NSString *)match_no;
{
    if ((self = [super init])) {
        _match_no = match_no;
        _playType = playType;
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(eventWithRight) image:@"kjhm_rq.png"];
       _titleBtn = [self.navigationItem setOptionView:self title:[DataConfigManager getLottery_JCZQ][playType][@"title"] action:@selector(showOptions:) image:@"jczq_arrow_red_down.png"]; // 初始化下拉菜单点击按钮
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)eventWithRight
{
    [DateScreening showWithResult:^(NSString *dateString)
    {
        [self requestDate:[dateString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    }];
}

#pragma mark - 点开下拉菜单、更换玩法
- (void)showOptions:(UIButton *)button
{
    @autoreleasepool {
        button.selected = !button.selected;
        if (button.selected)
        {
            /*
             弹出下来菜单
             */
            [DropdownMenu showMenu:[[DataConfigManager getLottery_JCZQ]subarrayWithRange:NSMakeRange(0, 5)] toView:self.view index:_playType select:^(id data)
             {
                 _playType = [data[@"type"] integerValue];
                 [self reloadTabData];
                 [_titleBtn setTitle:data[@"title"] forState:UIControlStateNormal];
                 [UIView animateWithDuration:0.3f animations:^{
                     button.imageView.transform = CGAffineTransformIdentity;
                 }];
                 button.selected = !button.selected;
             } otherEvent:^{
             
             }];
            
            [UIView animateWithDuration:0.3f animations:^{
                button.imageView.transform = CGAffineTransformRotate(button.imageView.transform, M_PI);
            }];
        }
        else
        {
            /*
             隐藏菜单
             */
            [DropdownMenu hideHUDForView:self.view];
            [UIView animateWithDuration:0.3f animations:^{
                button.imageView.transform = CGAffineTransformRotate(button.imageView.transform, -M_PI);
            }];
        }
    }
}

#pragma mark - 加载数据
- (void)setUpDatas
{
    [self requestDate:@""];
}

- (void)requestDate:(NSString *)date
{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain:kAPI_ZJZQ_award];
    params[@"date"] = date;
    params[@"match_no"] = _match_no;
    _connection = [RequestModel POST:URL(kAPI_ZJZQ_award) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       if (!data[@"item"] || ![data[@"item"] count]) {
                           [SVProgressHUD showInfoWithStatus:@"暂时没有数据"];
                           return ;
                       }
                       _datas = [FootBallModel getTheLotteryInformation:data[@"item"]];
                       [self makePuckerArray];
                       [self reloadTabData];
                       [SVProgressHUD dismiss];
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showInfoWithStatus:msg];
                   }];

}

- (UIButton *)btn
{
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.view.frame) / 5 * 3) / 2, 5, CGRectGetWidth(self.view.frame) / 5 * 3, 34);
    [_btn setTitle:@"投注竞彩足球" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(toBet:) forControlEvents:UIControlEventTouchUpInside];
    _btn.backgroundColor = CustomRed;
    [_btn getCornerRadius:5 borderColor:[UIColor clearColor] borderWidth:0 masksToBounds:YES];
    _btn.titleLabel.font = NFont(18);
    return _btn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_table setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *header = [UIButton buttonWithType:UIButtonTypeCustom];
    header.backgroundColor = RGBA(129, 152, 204, .8);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultInset.left, 0, DeviceW - ScaleW(50), ScaleH(30))];
    title.textColor = [UIColor whiteColor];
    title.font = Font(13);
    title.text = _datas[section][@"info"];
    [header addTarget:self action:@selector(puckerTouches:) forControlEvents:UIControlEventTouchUpInside];
    header.tag = section;
    [header addSubview:title];
    
    UIImage *img = [UIImage imageNamed:@"jczq_arrow_down.png"];
    UIButton *acc = [UIButton buttonWithType:UIButtonTypeCustom];
    acc.frame = CGRectMake(title.right + (ScaleW(50) - img.size.width) / 2, (ScaleH(30) - img.size.height) / 2, img.size.width, img.size.height);
    [acc setImage:img forState:UIControlStateNormal];
    NSNumber *number = [_puckerArray objectAtIndex:section];
    if ([number boolValue])
    {
        acc.transform = CGAffineTransformIdentity;
    }
    else
    {
        acc.transform = CGAffineTransformMakeRotation(-M_PI);
    }
    
    [header addSubview:acc];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *number = [_puckerArray objectAtIndex:section];
    if (![number boolValue]) {
        return 0;
    }
    return  [_datas[section][@"datas"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *league = _datas[indexPath.section][@"datas"][indexPath.row][@"league_name"];
    CGSize leagueLbSize = [NSObject getSizeWithText:league font:Font(12) maxSize:CGSizeMake(ScaleW(65), MAXFLOAT)];
    CGFloat height = ScaleH(15);
    if (leagueLbSize.height > Font(12).lineHeight)
    {
        height = leagueLbSize.height + 3;
    }
    return ScaleH(12) + height + Font(11).lineHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    FootBallQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[FootBallQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setDatas:_datas[indexPath.section][@"datas"][indexPath.row] playType:_playType];
    return cell;
}


- (void)puckerTouches:(UIButton *)button
{
    NSNumber *number = [_puckerArray objectAtIndex:button.tag];
    
    [_puckerArray replaceObjectAtIndex:button.tag withObject:[NSNumber  numberWithBool:![number boolValue]]];
    [self reloadTabData];
}

#pragma mark - 折点数组初始化
-(void)makePuckerArray
{
    if (!_puckerArray)
    {
        _puckerArray = [NSMutableArray array];
    }
    else if (_puckerArray.count)
    {
        [_puckerArray removeAllObjects];
    }
    for (int i = 0;i < [_datas count];i++) {
        NSNumber *number = [NSNumber numberWithBool:YES];
        [_puckerArray addObject:number];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self.navigationController.toolbar addSubview:self.btn];
    [self.navigationController  setToolbarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [_btn removeFromSuperview];
    [self.navigationController  setToolbarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}



- (void)toBet:(UIButton *)button {
  
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[FootballLotteryManagers class]])
        {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    
    FootballLotteryManagers *manager = [[FootballLotteryManagers alloc] initWithPlayType:_playType];
    manager.hidesBottomBarWhenPushed = YES;
    [self pushViewController:manager];
}


@end
