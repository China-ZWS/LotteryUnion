//
//  CTFB4CJQViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/15.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFB4CJQViewController.h"
#import "PJCollectionViewCell.h"
@interface CTFB4CJQCollectCCell :PJCollectionViewCell

@end

@implementation CTFB4CJQCollectCCell

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

- (void)setRightDatas:(CTFBDataModels *)model index:(NSInteger)index
{
    _title.text = [NSString stringWithFormat:@"%d",index];
    
    BOOL hasSelected = NO;
    switch (index) {
        case 0:
        {
            if (model.team2_select_one) hasSelected = YES;
        }
            break;
        case 1:
        {
            if (model.team2_select_two) hasSelected = YES;
        }
            break;
        case 2:
        {
            if (model.team2_select_three) hasSelected = YES;
        }
            break;
        case 3:
        {
            if (model.team2_select_four) hasSelected = YES;
            _title.text = [NSString stringWithFormat:@"%d+",index];
        }
            break;
            
        default:
            break;
    }
    [self titleType:hasSelected];
    
}

- (void)setLeftDatas:(CTFBDataModels *)model index:(NSInteger)index
{
    _title.text = [NSString stringWithFormat:@"%d",index];

    BOOL hasSelected = NO;
    switch (index) {
        case 0:
        {
            if (model.team1_select_one) hasSelected = YES;
        }
            break;
        case 1:
        {
            if (model.team1_select_two) hasSelected = YES;
        }
            break;
        case 2:
        {
            if (model.team1_select_three) hasSelected = YES;
        }
            break;
        case 3:
        {
            if (model.team1_select_four) hasSelected = YES;
            _title.text = [NSString stringWithFormat:@"%d+",index];
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

@interface CTFB4CJQCell : PJTableViewCell
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) UICollectionView *leftcollection;
@property (nonatomic) UICollectionView *rightCollection;
@property (nonatomic) UILabel *leftView;
@property (nonatomic) UILabel *rightView;
@end

@implementation CTFB4CJQCell

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, NavColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), ScaleH(10)));

    [self drawRectWithLine:rect start:CGPointMake(0, ScaleH(35)) end:CGPointMake(CGRectGetWidth(rect), ScaleH(35)) lineColor:CustomBlack lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetMidX(rect), ScaleH(35)) end:CGPointMake(CGRectGetMidX(rect), CGRectGetHeight(rect)) lineColor:CustomBlack lineWidth:LineWidth];


    
    CGRect leftContentRect = CGRectMake(self.width / 2 - ScaleW(140) - ScaleW(6), ScaleH(65), ScaleH(140), ScaleH(30));
    [self drawWithChamferOfRectangle:leftContentRect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomRed backgroundColor:[UIColor clearColor]];
    [self drawRectWithLine:leftContentRect start:CGPointMake(CGRectGetWidth(leftContentRect) / 4, 0) end:CGPointMake(CGRectGetWidth(leftContentRect) / 4, CGRectGetHeight(leftContentRect)) lineColor:CustomRed lineWidth:LineWidth];
    [self drawRectWithLine:leftContentRect start:CGPointMake(CGRectGetWidth(leftContentRect) / 2, 0) end:CGPointMake(CGRectGetWidth(leftContentRect) / 2, CGRectGetHeight(leftContentRect)) lineColor:CustomRed lineWidth:LineWidth];
    [self drawRectWithLine:leftContentRect start:CGPointMake(CGRectGetWidth(leftContentRect) / 4 * 3, 0) end:CGPointMake(CGRectGetWidth(leftContentRect) / 4 * 3, CGRectGetHeight(leftContentRect)) lineColor:CustomRed lineWidth:LineWidth];

    
    CGRect rightContentRect = CGRectMake(self.width / 2 + ScaleW(6), ScaleH(65), ScaleH(140), ScaleH(30));
    [self drawWithChamferOfRectangle:rightContentRect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomRed backgroundColor:[UIColor clearColor]];
    [self drawRectWithLine:rightContentRect start:CGPointMake(CGRectGetWidth(rightContentRect) / 4, 0) end:CGPointMake(CGRectGetWidth(rightContentRect) / 4, CGRectGetHeight(rightContentRect)) lineColor:CustomRed lineWidth:LineWidth];
    [self drawRectWithLine:rightContentRect start:CGPointMake(CGRectGetWidth(rightContentRect) / 2, 0) end:CGPointMake(CGRectGetWidth(rightContentRect) / 2, CGRectGetHeight(rightContentRect)) lineColor:CustomRed lineWidth:LineWidth];
    [self drawRectWithLine:rightContentRect start:CGPointMake(CGRectGetWidth(rightContentRect) / 4 * 3, 0) end:CGPointMake(CGRectGetWidth(rightContentRect) / 4 * 3, CGRectGetHeight(rightContentRect)) lineColor:CustomRed lineWidth:LineWidth];


}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(ScaleW(140) / 4,ScaleH(30));
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
        [_leftcollection registerClass:[CTFB4CJQCollectCCell class] forCellWithReuseIdentifier:@"cell"];
        _leftcollection.alwaysBounceVertical  = NO;
        [self.contentView addSubview:_leftcollection];
        
        _rightCollection = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:[self segmentBarLayout]];
        _rightCollection.backgroundColor = [UIColor clearColor];
        _rightCollection.delegate = self;
        _rightCollection.dataSource = self;
        [_rightCollection registerClass:[CTFB4CJQCollectCCell class] forCellWithReuseIdentifier:@"cell"];
        _rightCollection.alwaysBounceVertical  = NO;
        [self.contentView addSubview:_rightCollection];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, ScaleH(10), self.width, ScaleH(25));
    _leftView.frame = CGRectMake(self.width / 2 - ScaleW(140) - ScaleW(6), self.textLabel.bottom, ScaleH(140), ScaleH(30));
    _rightView.frame = CGRectMake(self.width / 2 + ScaleW(6), self.textLabel.bottom, ScaleH(140), ScaleH(30));
    
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



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTFB4CJQCollectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
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
    
    CTFB4CJQCollectCCell *cell = (CTFB4CJQCollectCCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CTFBDataModels *model = _datas;
    
    BOOL hasSelected = NO;
    if (collectionView == _leftcollection)
    {
        switch (indexPath.row) {
            case 0:
            {
                model.team1_select_one = !model.team1_select_one;
                if (model.team1_select_one) hasSelected = YES;
            }
                break;
            case 1:
            {
                model.team1_select_two = !model.team1_select_two;
                if (model.team1_select_two) hasSelected = YES;
            }
                break;
            case 2:
            {
                model.team1_select_three = !model.team1_select_three;
                if (model.team1_select_three) hasSelected = YES;
            }
                break;
            case 3:
            {
                model.team1_select_four = !model.team1_select_four;
                if (model.team1_select_four) hasSelected = YES;
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
                model.team2_select_one = !model.team2_select_one;
                if (model.team2_select_one) hasSelected = YES;
            }
                break;
            case 1:
            {
                model.team2_select_two = !model.team2_select_two;
                if (model.team2_select_two) hasSelected = YES;
            }
                break;
            case 2:
            {
                model.team2_select_three = !model.team2_select_three;
                if (model.team2_select_three) hasSelected = YES;
            }
                break;
            case 3:
            {
                model.team2_select_four = !model.team2_select_four;
                if (model.team2_select_four) hasSelected = YES;
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
    
    
    if (model.team1_select_one || model.team1_select_two || model.team1_select_three || model.team1_select_four || model.team2_select_one || model.team2_select_two || model.team2_select_three || model.team2_select_four) {
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



@interface CTFB4CJQViewController ()
@property (nonatomic, copy) void(^requestFootballVS)(NSString *period);
@property (nonatomic, copy) void(^requestPlayPeriod)();
@end

@implementation CTFB4CJQViewController
- (id)init
{
    if ((self = [super init]))
    {
        _lottery_pk = kType_CTZQ_JQ4;
        [self.navigationItem setNewTitle:@"4场进球"];
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
    CTFB4CJQCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CTFB4CJQCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_JQ4];
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
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_JQ4];
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
    
    if (CTFBTool.value_storages.count == 4)
    {
        int i = 0;
        for (CTFBDataModels *model in CTFBTool.value_storages)
        {
            if ((model.team1_select_one || model.team1_select_two || model.team1_select_three || model.team1_select_four) && (model.team2_select_one || model.team2_select_two || model.team2_select_three || model.team2_select_four))
            {
                i ++;
            }
        }
        
        

        if (i == 4)
        {
            [CTFBModel calculateWithBettingNum:4 result:^(NSInteger bettingNum)
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

    [CTFBModel get4RandomGames:_datas result:^(NSArray *datas)
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
    
    
    CTFB4CJQCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
    
    NSInteger leftCollectCellIndex = 0;
    if (model.team1_select_one) {
        leftCollectCellIndex = 0;
    }
    else if (model.team1_select_two){
        leftCollectCellIndex = 1;
    }
    else if (model.team1_select_three)
    {
        leftCollectCellIndex = 2;
    }
    else if (model.team1_select_four)
    {
        leftCollectCellIndex = 3;
    }

    
    NSInteger rightCollectCellIndex = 0;
    if (model.team2_select_one) {
        rightCollectCellIndex = 0;
    }
    else if (model.team2_select_two){
        rightCollectCellIndex = 1;
    }
    else if (model.team2_select_three)
    {
        rightCollectCellIndex = 2;
    }
    else if (model.team2_select_four)
    {
        rightCollectCellIndex = 3;
    }

    CTFB4CJQCollectCCell *leftCollectCell = (CTFB4CJQCollectCCell *)[cell.leftcollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:leftCollectCellIndex inSection:0]];
    CTFB4CJQCollectCCell *rightCollectCell = (CTFB4CJQCollectCCell *)[cell.rightCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:rightCollectCellIndex inSection:0]];
    
    
    [UIView animateWithDuration:.2 animations:^{
        leftCollectCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:leftCollectCell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
        leftCollectCell.title.textColor = [UIColor whiteColor];
        [self shakeToShow:leftCollectCell];
        
        rightCollectCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:rightCollectCell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
        rightCollectCell.title.textColor = [UIColor whiteColor];
        [self shakeToShow:rightCollectCell];
        
    } completion:^(BOOL finished)
     {
         [self animationIndex:index + 1];
     }];
}

- (void) shakeToShow:(UIView*)aView{
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
        [SVProgressHUD showInfoWithStatus:@"请至少选择4场比赛"];
        return;
    }
    
    [self eventWithBettingType:k4CJQ];
}

- (void)eventWithSCP
{
    if (_bettingNum < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请至少选择4场比赛"];
        return;
    }
    [self eventWithSCP:k4CJQ];
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
