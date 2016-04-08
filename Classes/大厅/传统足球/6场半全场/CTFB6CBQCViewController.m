//
//  CTFB6CBQCViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/15.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFB6CBQCViewController.h"
#import "PJCollectionViewCell.h"
@interface CTFB6CBQCollectCCell :PJCollectionViewCell

@end

@implementation CTFB6CBQCollectCCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _title = [UILabel new];
        _title.font = Font(13);
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(0, 0, self.width, self.height);
}



- (void)setLeftDatas:(CTFBDataModels *)model index:(NSInteger)index
{
    BOOL hasSelected = NO;
    switch (index) {
        case 0:
        {
            _title.text = @"主胜";
            if (model.win) hasSelected = YES;
        }
            break;
        case 1:
        {
            if (model.pin) hasSelected = YES;
            _title.text = @"平";
        }
            break;
        case 2:
        {
            if (model.lose) hasSelected = YES;
            _title.text = @"客胜";
        }
            break;
        default:
            break;
    }
    [self titleType:hasSelected];

}

- (void)setRightDatas:(CTFBDataModels *)model index:(NSInteger)index
{
    BOOL hasSelected = NO;
    switch (index) {
        case 0:
        {
            _title.text = @"主胜";
            if (model.bWin) hasSelected = YES;
        }
            break;
        case 1:
        {
            if (model.bPin) hasSelected = YES;
            _title.text = @"平";
        }
            break;
        case 2:
        {
            if (model.bLose) hasSelected = YES;
            _title.text = @"客胜";
        }
            break;
        default:
            break;
    }
    [self titleType:hasSelected];
}

- (void)titleType:(BOOL)hasSelected
{
    if (hasSelected) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
        self.title.textColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        self.title.textColor = CustomRed;
    }
}
@end


@interface CTFB6CBQCCell : PJTableViewCell
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) UICollectionView *leftcollection;
@property (nonatomic) UICollectionView *rightCollection;

@property (nonatomic) UILabel *leftView;
@property (nonatomic) UILabel *rightView;
@end

@implementation CTFB6CBQCCell

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, NavColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), ScaleH(10)));

    [self drawRectWithLine:rect start:CGPointMake(0, ScaleH(35)) end:CGPointMake(CGRectGetWidth(rect), ScaleH(35)) lineColor:CustomBlack lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetMidX(rect), ScaleH(35)) end:CGPointMake(CGRectGetMidX(rect), CGRectGetHeight(rect)) lineColor:CustomBlack lineWidth:LineWidth];

    
    CGRect leftContentRect = CGRectMake((self.width / 2 - ScaleW(120)) / 2, ScaleH(65), ScaleH(120), ScaleH(30));
    [self drawWithChamferOfRectangle:leftContentRect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomRed backgroundColor:[UIColor clearColor]];
    [self drawRectWithLine:leftContentRect start:CGPointMake(CGRectGetWidth(leftContentRect) / 3, 0) end:CGPointMake(CGRectGetWidth(leftContentRect) / 3, CGRectGetHeight(leftContentRect)) lineColor:CustomRed lineWidth:LineWidth];
    [self drawRectWithLine:leftContentRect start:CGPointMake(CGRectGetWidth(leftContentRect) / 3 * 2, 0) end:CGPointMake(CGRectGetWidth(leftContentRect) / 3 * 2, CGRectGetHeight(leftContentRect)) lineColor:CustomRed lineWidth:LineWidth];

    
    CGRect rightContentRect = CGRectMake((self.width / 2 - ScaleW(120)) / 2 + self.width / 2, ScaleH(65), ScaleH(120), ScaleH(30));
    [self drawWithChamferOfRectangle:rightContentRect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomRed backgroundColor:[UIColor clearColor]];
    [self drawRectWithLine:rightContentRect start:CGPointMake(CGRectGetWidth(rightContentRect) / 3, 0) end:CGPointMake(CGRectGetWidth(rightContentRect) / 3, CGRectGetHeight(rightContentRect)) lineColor:CustomRed lineWidth:LineWidth];
    [self drawRectWithLine:rightContentRect start:CGPointMake(CGRectGetWidth(rightContentRect) / 3 * 2, 0) end:CGPointMake(CGRectGetWidth(rightContentRect) / 3 * 2, CGRectGetHeight(rightContentRect)) lineColor:CustomRed lineWidth:LineWidth];
    
}


- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(ScaleW(120) / 3.000000f,ScaleH(30));
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = Font(14);

        
        _leftView = [UILabel new];
        _leftView.font = Font(14);
        _leftView.text = @"上半场";
        _leftView.textColor = [UIColor blackColor];
        _leftView.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_leftView];
        
        _rightView = [UILabel new];
        _rightView.text = @"全场";
        _rightView.font = Font(14);
        _rightView.textColor = [UIColor blackColor];
        _rightView.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_rightView];


        _leftcollection = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:[self segmentBarLayout]];
        _leftcollection.backgroundColor = [UIColor clearColor];
        _leftcollection.delegate = self;
        _leftcollection.dataSource = self;
        [_leftcollection registerClass:[CTFB6CBQCollectCCell class] forCellWithReuseIdentifier:@"cell"];
        _leftcollection.alwaysBounceVertical  = NO;
        [self.contentView addSubview:_leftcollection];
        
        _rightCollection = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:[self segmentBarLayout]];
        _rightCollection.backgroundColor = [UIColor clearColor];
        _rightCollection.delegate = self;
        _rightCollection.dataSource = self;
        [_rightCollection registerClass:[CTFB6CBQCollectCCell class] forCellWithReuseIdentifier:@"cell"];
        _rightCollection.alwaysBounceVertical  = NO;
        [self.contentView addSubview:_rightCollection];
//        [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, ScaleH(10), self.width, ScaleH(25));
    _leftView.frame = CGRectMake((self.width / 2 - ScaleW(120)) / 2, self.textLabel.bottom, ScaleH(120), ScaleH(30));
    _rightView.frame = CGRectMake((self.width / 2 - ScaleW(120)) / 2 + self.width / 2, self.textLabel.bottom, ScaleH(120), ScaleH(30));
    
    _leftcollection.frame = CGRectMake(_leftView.left, _leftView.bottom, _leftView.width, ScaleH(30));
    _rightCollection.frame = CGRectMake(_rightView.left, _rightView.bottom, _rightView.width, ScaleH(30));
}

- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    CTFBDataModels *model = datas;
    NSString *text = [NSString stringWithFormat:@"%@  vs  %@",model.team1,model.team2];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([model.team1 length] + [@"占位" length],[@"vs" length])];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([model.team1 length] + [@"占位" length],[@"vs" length])];
    self.textLabel.attributedText = attrString;
    
    [_leftcollection reloadData];
    [_rightCollection reloadData];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width / 3.0, ScaleH(30));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTFB6CBQCollectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (collectionView == _leftcollection) {
        [cell setLeftDatas:_datas index:indexPath.row ];
    }
    else
    {
        [cell setRightDatas:_datas index:indexPath.row ];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CTFB6CBQCollectCCell *cell = (CTFB6CBQCollectCCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CTFBDataModels *model = _datas;
    
    BOOL hasSelected = NO;
    if (collectionView == _leftcollection)
    {
        switch (indexPath.row) {
            case 0:
            {
                model.win = !model.win;
                if (model.win) hasSelected = YES;
            }
                break;
            case 1:
            {
                model.pin = !model.pin;
                if (model.pin) hasSelected = YES;
            }
                break;
            case 2:
            {
                model.lose = !model.lose;
                if (model.lose) hasSelected = YES;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                model.bWin = !model.bWin;
                if (model.bWin) hasSelected = YES;
            }
                break;
            case 1:
            {
                model.bPin = !model.bPin;
                if (model.bPin) hasSelected = YES;
            }
                break;
            case 2:
            {
                model.bLose = !model.bLose;
                if (model.bLose) hasSelected = YES;
            }
                break;
            default:
                break;
        }

    }

    
    if (hasSelected) {
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
        cell.title.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.title.textColor = CustomRed;
    }
    
    
    if (model.win || model.pin || model.lose || model.bWin || model.bPin || model.bLose) {
        if ([CTFBTool.value_storages containsObject:model]) {
            NSNotificationPost(@"changeWithValue_storages", nil, nil);
            return;
        }
        else
        {
            [[CTFBTool mutableArrayValueForKey:@"value_storages"] addObject:model];
        }
    }
    else
    {
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] removeObject:model];
    }
    NSNotificationPost(@"changeWithValue_storages", nil, nil);
}




@end

@interface CTFB6CBQCViewController ()
@property (nonatomic, copy) void(^requestFootballVS)(NSString *period);
@property (nonatomic, copy) void(^requestPlayPeriod)();

@end


@implementation CTFB6CBQCViewController
- (id)init
{
    if ((self = [super init]))
    {
        _lottery_pk = kType_CTZQ_BQC6;
        [self.navigationItem setNewTitle:@"6场半全场"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(105);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    CTFB6CBQCCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CTFB6CBQCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.datas = _datas[indexPath.row];
    return cell;
}


- (void)setUpDatas
{
    
    /*任务一，获取彩票期数*/
    self.requestPlayPeriod = ^{
        /*
         数据加载延迟处理
         */
        [SVProgressHUD show];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_BQC6];
        [params setPublicDomain:kAPI_QueryPlayPeriod];
        _connection = [RequestModel POST:URL(kAPI_QueryPlayPeriod) parameter:params   class:[RequestModel class]
                                 success:^(id data)
                       {
                           [SVProgressHUD dismiss];
                           _requestFootballVS(data[@"item"][0][@"period"]);
                           self.requestFootballVS = nil;
                       }
                                 failure:^(NSString *msg, NSString *state)
                       {
                           [SVProgressHUD showInfoWithStatus:msg];
                       }];
    };
    
    /*任务二，拉取14对阵信息*/
    self.requestFootballVS = ^(NSString *period){
        /*
         数据加载延迟处理
         */
        [SVProgressHUD show];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_BQC6];
        params[@"period"] = period;
        
        [params setPublicDomain:kAPI_QueryFootballVS];
        _connection = [CTFBDataModels POST:URL(kAPI_QueryFootballVS) parameter:params   class:[CTFBDataModels class]
                                   success:^(id data)
                       {
                           _datas = data;
                           [self reloadTabData];
                           [SVProgressHUD dismiss];
                       }
                                   failure:^(NSString *msg, NSString *state)
                       {
                           
                           [SVProgressHUD showInfoWithStatus:msg];
                       }];
        
    };
    _requestPlayPeriod();
    self.requestPlayPeriod = nil;
}

- (void)changeWithValue_storages
{
    if (CTFBTool.value_storages.count == 6)
    {
        int i = 0;
        for (CTFBDataModels *model in CTFBTool.value_storages)
        {
            if ((model.win || model.pin || model.lose) && (model.bWin || model.bPin || model.bLose))
            {
                i ++;
            }
        }
        
        if (i == 6)
        {
            [CTFBModel calculateWithBettingNum:6 result:^(NSInteger bettingNum)
             {
                 [self setInfoTitleWithText:bettingNum];
             } hasSelectDouble:YES];
        }
        else
        {
            [self setInfoTitleWithText:0];
        }
    }
    else
    {
        [self setInfoTitleWithText:0];
    }
}

- (void)createShake
{
    [super createShake];
    if (!_datas.count) {
        return;
    }

    [CTFBModel get6RandomGames:_datas result:^(NSArray *datas)
     {
         [self changeWithValue_storages];
         [self animationIndex:0];
     }];

}

- (void)animationIndex:(NSInteger)index
{
    
    if (index == CTFBTool.value_storages.count || !CTFBTool.value_storages.count) {
        return;
    }
    CTFBDataModels *model = CTFBTool.value_storages[index];
    
    NSInteger cellIndex = [model.index integerValue];
    
    
    CTFB6CBQCCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
    
    NSInteger leftCollectCellIndex = 0;
    if (model.win) {
        leftCollectCellIndex = 0;
    }
    else if (model.pin){
        leftCollectCellIndex = 1;
    }
    else if (model.lose)
    {
        leftCollectCellIndex = 2;
    }
    
    NSInteger rightCollectCellIndex = 0;
    if (model.bWin) {
        rightCollectCellIndex = 0;
    }
    else if (model.bPin){
        rightCollectCellIndex = 1;
    }
    else if (model.bLose)
    {
        rightCollectCellIndex = 2;
    }

    CTFB6CBQCollectCCell *leftCollectCell = (CTFB6CBQCollectCCell *)[cell.leftcollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:leftCollectCellIndex inSection:0]];
    CTFB6CBQCollectCCell *rightCollectCell = (CTFB6CBQCollectCCell *)[cell.rightCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:rightCollectCellIndex inSection:0]];
    
    [UIView animateWithDuration:.2 animations:^{
        leftCollectCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:leftCollectCell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
        leftCollectCell.title.textColor = [UIColor whiteColor];
        [self shakeToShow:leftCollectCell];
        
        rightCollectCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:leftCollectCell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
        rightCollectCell.title.textColor = [UIColor whiteColor];
        [self shakeToShow:rightCollectCell];

    } completion:^(BOOL finished)
     {
         [self animationIndex:index + 1];
     }];
}

- (void) shakeToShow:(UIView*)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}


#pragma mark - 选择投注
- (void)eventWithBetting
{
    if (_bettingNum < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请至少选择6场比赛"];
        return;
    }
    [self eventWithBettingType:k6CBQC];
}

- (void)eventWithSCP
{
    if (_bettingNum < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请至少选择6场比赛"];
        return;
    }
    [self eventWithSCP:k6CBQC];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
