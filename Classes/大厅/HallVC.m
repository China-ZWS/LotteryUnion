//
//  HallVC.m
//  LotteryUnion
//
//  Created by xhd945 on 15/10/19.
//  Copyright © 2015年 xhd945. All rights reserved.
//

#import "HallVC.h"
#import "BannerView.h"
#import "FootballLotteryManagers.h"
#import "PJNavigationBar.h"
#import "DataConfigManager.h"
#import "PJCollectionViewCell.h"
#import "BetCartViewController.h"

#import "CTFBBettingViewController.h"
#define ItemHeight 50

#import "TZBaseViewController.h"


@interface HallVCCell : PJCollectionViewCell
{
    NSInteger _index;
}
@end

@implementation HallVCCell

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) - .1, 0) end:CGPointMake(CGRectGetWidth(rect) - .1, CGRectGetHeight(rect)) lineColor:CustomGray lineWidth:.5];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect)) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)) lineColor:CustomGray lineWidth:.5];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _title = [UILabel new];
        _title.font = Font(14);
        _title.textColor = CustomBlack;
        
        _imageView = [UIImageView new];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(kDefaultInset.left * 1.5, 0, CGRectGetWidth(self.frame) - kDefaultInset.left * 2 - _imageView.image.size.width, CGRectGetHeight(self.frame));
    _imageView.frame = CGRectMake(CGRectGetWidth(self.frame) - kDefaultInset.right * 1.5 - _imageView.image.size.width, (CGRectGetHeight(self.frame) - _imageView.image.size.height) / 2, _imageView.image.size.width, _imageView.image.size.height);
}

- (void)setDatas:(id)datas index:(NSInteger)index
{
    _index = index;
    
    _title.text = datas[@"title"];
    _imageView.image = mImageByName(datas[@"image"]);
    [self setNeedsDisplay];
}

@end


#import "FootballLotteryManagers.h"

@interface HallVC ()
<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
}
@property (nonatomic, strong) BannerView *adHeader; //广告版
@property (nonatomic, strong) UILabel *titleHeader;

@end

@implementation HallVC

- (id)init
{
    if ((self = [super init])) {
        
        [self.navigationItem setNewTitle:@"彩票联盟"];
    }
    return self;
}


#pragma mark - 广告位
- (UIView *)adHeader
{
    if (!_adHeader)
    {
        HallVC __weak*safeSelf = self;
        _adHeader = [[BannerView alloc] initWithSelect:^(id data)
                       {
                           [safeSelf pushViewWithDatas:data];
                       }];
    }
    return _adHeader;
}

- (UILabel *)titleHeader
{
    if (!_titleHeader)
    {
        _titleHeader = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultInset.left, 0, 200, ScaleH(50))];;
        _titleHeader.tag = 100;
        _titleHeader.font = Font(14);
        _titleHeader.textColor = CustomBlue;
    }
    return _titleHeader;
}


#pragma mark - 广告位touche
- (void)pushViewWithDatas:(id)data
{

}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = DeviceW / 2 ;
    segmentBarLayout.itemSize = CGSizeMake(width,ScaleH(50));
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}

//TODO:入口
- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [DataConfigManager getMainConfigList];
    
    /*判断一下，如果hide_pk有值，就隐藏双色球*/
    NSString *str = [mUserDefaults valueForKey:@"Hide_pk"];
//    if(str.length>0)
//    {
//        NSMutableArray *datas = [[NSMutableArray alloc]initWithArray:_datas];
//        [datas[2][@"row"] removeObjectAtIndex:1];        
//        _datas = datas;
//    }
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self segmentBarLayout]];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[HallVCCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = YES;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    [_collectionView addSubview:self.adHeader];
    _collectionView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(_adHeader.frame), 0, 0, 0);

    //TODO:广告版预留
    
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]stringByAppendingPathComponent:@"banner.archiver"] ;
    _adHeader.data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

}

- (void)setUpDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain:kAPI_banner];
    _connection = [RequestModel POST:URL(kAPI_banner) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]stringByAppendingPathComponent:@"banner.archiver"] ;
                       [NSKeyedArchiver archiveRootObject:data[@"item"] toFile:filePath];

                       _adHeader.data = data[@"item"];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showInfoWithStatus:msg];
                   }];

}


#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, ScaleH(50)); // header
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.backgroundColor = NavColor;
    UILabel *titleHeader = (UILabel *)[headerView viewWithTag:100];
    if (!titleHeader)
    {
        titleHeader = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultInset.left, 0, 200, ScaleH(50))];;
        titleHeader.tag = 100;
        titleHeader.font = Font(14);
        titleHeader.textColor = CustomBlue;
        [headerView addSubview:titleHeader];
    }
    titleHeader.text = _datas[indexPath.section][@"headerTitle"];
    return headerView;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _datas.count ;
}


//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[section ][@"row"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HallVCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDatas:_datas[indexPath.section ][@"row"][indexPath.row] index:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0)
    {
        [self gotoFootballcompetition:indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        [self gotoCTZQ:indexPath];
     }
    else if(indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:  //大乐透
            {
                [self gotoLeTouNumber:lDLT_lottery];
            }
                break;
            case 1: //双色球
            {
                /*判断一下，如果hide_pk有值，就隐藏双色球*/
                NSString *str = [mUserDefaults valueForKey:@"Hide_pk"];
                if(str.length>0)
                {
                   [SVProgressHUD showInfoWithStatus:@"即将开放，敬请期待~"];
                }
                else
                {
                   [self gotoLeTouNumber:lSSQ_lottery];
                }
                
            }
                break;
            case 2: //七星彩
            {
                [self gotoLeTouNumber:lSenvenStar_lottery];
            }
                break;
            case 3: //排列3
            {
                [self gotoLeTouNumber:lPL3_lottery];
            }
                break;
            case 4:  //排列5
            {
                [self gotoLeTouNumber:lPL5_lottery];
            }
                break;
                
            default:
                break;
        }

    
    }
    else if(indexPath.section == 3)
    {
        switch (indexPath.row)
        {
            case 0:  //22选5
            {
                [self gotoLeTouNumber:lT225_lottery];
            }
                break;
            case 1: //32选7
            {
                [self gotoLeTouNumber:lT317_lottery];
            }
                break;
            case 2: //36选7
            {
                [self gotoLeTouNumber:lT367_lottery];
            }
                break;
            
            default:
                break;
        }
        
    }
}


#pragma mark - 竞彩足球
- (void)gotoFootballcompetition:(FBPlayType)lotterytype
{
    FootballLotteryManagers *manager = [[FootballLotteryManagers alloc] initWithPlayType:lotterytype];
    manager.hidesBottomBarWhenPushed = YES;
    [self pushViewController:manager];
}

#pragma mark 传统足球
- (void)gotoCTZQ:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _datas[indexPath.section][@"row"][indexPath.row];
    Class class = NSClassFromString(dic[@"viewController"]);
    UIViewController *controller = [class new];
    [self addNavigationWithPresentViewController:controller];
}

#pragma mark - 乐透数字
- (void)gotoLeTouNumber:(NSInteger)lotteryType
{
    // 初始化购物车视图控制器
    NSString *vcStr = getLotVCString(lotteryType);
    Class class =  NSClassFromString(vcStr);
    TZBaseViewController*  mController = [(TZBaseViewController*)[class alloc] initWithLotter_pk:GET_INT(lotteryType) period:nil requestCode:YES delegate:nil];
    
    PJNavigationController *nav = [[PJNavigationController alloc]initWithRootViewController:mController];
    [self presentViewController:nav];
    
}


@end
