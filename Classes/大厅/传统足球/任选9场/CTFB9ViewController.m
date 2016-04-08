//
//  CTFB9ViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/13.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFB9ViewController.h"
#import "PJCollectionViewCell.h"
@interface CTFB9CollectCell : PJCollectionViewCell

@end
@implementation CTFB9CollectCell



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

- (void)setDatas:(CTFBDataModels *)model index:(NSInteger)index
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

@interface CTFB9Cell :PJTableViewCell
<UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation CTFB9Cell

- (void)drawRect:(CGRect)rect
{
    CGRect contentRect = CGRectMake(DeviceW - ScaleW(120) - ScaleW(15), (self.height - ScaleH(30)) / 2, ScaleW(120), ScaleH(30));
    [self drawWithChamferOfRectangle:contentRect inset:UIEdgeInsetsZero radius:0 lineWidth:LineWidth lineColor:CustomRed backgroundColor:[UIColor clearColor]];
    [self drawRectWithLine:contentRect start:CGPointMake(CGRectGetWidth(contentRect) / 3, 0) end:CGPointMake(CGRectGetWidth(contentRect) / 3, CGRectGetHeight(contentRect)) lineColor:CustomRed lineWidth:LineWidth];
    [self drawRectWithLine:contentRect start:CGPointMake(CGRectGetWidth(contentRect) / 3 * 2, 0) end:CGPointMake(CGRectGetWidth(contentRect) / 3 * 2, CGRectGetHeight(contentRect)) lineColor:CustomRed lineWidth:LineWidth];

}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    segmentBarLayout.itemSize = CGSizeMake(ScaleW(120) / 3,ScaleH(30));
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = Font(14);
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:[self segmentBarLayout]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CTFB9CollectCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.alwaysBounceVertical  = NO;
        [self.contentView addSubview:_collectionView];

    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(DeviceW - ScaleW(120) - ScaleW(15), (self.height - ScaleH(30)) / 2, ScaleW(120), ScaleH(30));
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
    CTFB9CollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell setDatas:_datas index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTFB9CollectCell *cell = (CTFB9CollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CTFBDataModels *model = _datas;
    BOOL hasSelected = NO;
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
    
    if (hasSelected) {
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
        cell.title.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.title.textColor = CustomRed;
    }
    

    if (model.win || model.pin || model.lose) {
        if ([CTFBTool.value_storages containsObject:model]) {
            NSNotificationPost(@"changeWithValue_storages", nil, nil);
            return;
        }
        else
        {
            if (CTFBTool.value_storages.count >= 9) {
                cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:cell.size lineWidth:LineWidth lineColor:CustomRed backgroundColor:[UIColor whiteColor] hasCenterLine:NO]];
                cell.title.textColor = CustomRed;
                [SVProgressHUD showInfoWithStatus:@"最多选择9场比赛"];
                return;
            }
            [[CTFBTool mutableArrayValueForKey:@"value_storages"] addObject:model];
        }
    }
    else
    {
        [[CTFBTool mutableArrayValueForKey:@"value_storages"] removeObject:model];
    }
    NSNotificationPost(@"changeWithValue_storages", nil, nil);

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
    [_collectionView reloadData];
}

@end

@interface CTFB9ViewController ()
@property (nonatomic, copy) void(^requestFootballVS)(NSString *period);
@property (nonatomic, copy) void(^requestPlayPeriod)();

@end

@implementation CTFB9ViewController

- (id)init
{
    if ((self = [super init]))
    {
        _lottery_pk = kType_CTZQ_SF9;
        [self.navigationItem setNewTitle:@"任选9场"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    CTFB9Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CTFB9Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_SF9];
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
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_SF9];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeWithValue_storages
{
    if (CTFBTool.value_storages.count >= 9) {
        [CTFBModel calculateWithBettingNum:9 result:^(NSInteger bettingNum)
         {
             [self setInfoTitleWithText:bettingNum];
         } hasSelectDouble:NO];
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

    [CTFBModel get9RandomGames:_datas result:^(NSArray *datas)
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
   
    
    CTFB9Cell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
    NSInteger collectCellIndex = NSNotFound;
    if (model.win) {
        collectCellIndex = 0;
    }
    else if (model.pin){
        collectCellIndex = 1;
    }
    else if (model.lose){
        collectCellIndex = 2;
    }
    
    if (collectCellIndex == NSNotFound) {
        [self animationIndex:index + 1];
    }
    else
    {
        CTFB9CollectCell *collectCell = (CTFB9CollectCell *)[cell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:collectCellIndex inSection:0]];
        
        [UIView animateWithDuration:.2 animations:^{
            collectCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:collectCell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
            collectCell.title.textColor = [UIColor whiteColor];
            [self shakeToShow:collectCell];
        } completion:^(BOOL finished)
         {
             [self animationIndex:index + 1];
         }];
    }
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
    if (CTFBTool.value_storages.count < 9 || CTFBTool.value_storages.count > 9) {
        [SVProgressHUD showInfoWithStatus:@"请选择9场比赛"];
        return;
    }
    
    if (CTFBTool.value_storages.count) {
        [CTFBTool.value_storages removeAllObjects];
    }
    [CTFBTool.value_storages addObjectsFromArray:_datas];
    [self eventWithBettingType:kRX9];
}

- (void)eventWithSCP
{
    if (CTFBTool.value_storages.count < 9 || CTFBTool.value_storages.count > 9) {
        [SVProgressHUD showInfoWithStatus:@"请选择9场比赛"];
        return;
    }
    if (CTFBTool.value_storages.count) {
        [CTFBTool.value_storages removeAllObjects];
    }
    [CTFBTool.value_storages addObjectsFromArray:_datas];

    [self eventWithSCP:kRX9];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
