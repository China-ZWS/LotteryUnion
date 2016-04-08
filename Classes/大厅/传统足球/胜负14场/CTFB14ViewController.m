//
//  CTFB14ViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/12.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFB14ViewController.h"
#import "PJCollectionViewCell.h"
@interface CTFB14CollectCell : PJCollectionViewCell

@end
@implementation CTFB14CollectCell


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
        _title.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:self.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
    }
    else
    {
        _title.textColor = CustomRed;
        self.backgroundColor = [UIColor clearColor];
    }
}


@end

@interface CTFB14Cell :PJTableViewCell
<UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation CTFB14Cell

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
        [_collectionView registerClass:[CTFB14CollectCell class] forCellWithReuseIdentifier:@"cell"];
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
    CTFB14CollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell setDatas:_datas index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    CTFB14CollectCell *cell = (CTFB14CollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
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

#import "CTFBBettingViewController.h"

@interface CTFB14ViewController ()
{

}

@property (nonatomic, copy) void(^requestFootballVS)(NSString *period);
@property (nonatomic, copy) void(^requestPlayPeriod)();
@end

@implementation CTFB14ViewController

- (id)init
{
    if ((self = [super init]))
    {
        _lottery_pk = kType_CTZQ_SF14;
        [self.navigationItem setNewTitle:@"胜负14场"];
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
    CTFB14Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CTFB14Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.datas = _datas[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_SF14];
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
        params[@"lottery_pk"] = [NSNumber numberWithInt:kType_CTZQ_SF14];
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
    if (CTFBTool.value_storages.count == 14) {
        [CTFBModel calculateWithBettingNum:14 result:^(NSInteger bettingNum)
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

    [CTFBModel get14RandomGames:_datas result:^(NSArray *datas)
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
    
    
    CTFB14Cell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
    
    NSInteger collectCellIndex = 0;
    if (model.win) {
        collectCellIndex = 0;
    }
    else if (model.pin){
        collectCellIndex = 1;
    }
    else{
        collectCellIndex = 2;
    }
    
    CTFB14CollectCell *collectCell = (CTFB14CollectCell *)[cell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:collectCellIndex inSection:0]];
    
    
    [UIView animateWithDuration:.2 animations:^{
        collectCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage drawrWithQuadrateLine:collectCell.size lineWidth:1 lineColor:[UIColor whiteColor] backgroundColor:CustomRed hasCenterLine:NO]];
        collectCell.title.textColor = [UIColor whiteColor];
        [self shakeToShow:collectCell];
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


- (void)eventWithBetting
{
    if (CTFBTool.value_storages.count < 14) {
        [SVProgressHUD showInfoWithStatus:@"请至少选择14场比赛"];
        return;
    }
    [super eventWithBettingType:kSF14];
}

- (void)eventWithSCP
{
    if (CTFBTool.value_storages.count < 14) {
        [SVProgressHUD showInfoWithStatus:@"请至少选择14场比赛"];
        return;
    }
    
    [self eventWithSCP:kSF14];
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
