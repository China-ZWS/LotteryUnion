//
//  MoreViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/23.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "MoreViewController.h"
#import "DataConfigManager.h"
#import "PJCollectionViewCell.h"
#import "AboutViewController.h"
#import "HelpManualVCViewController.h"
#import "ShareTools.h"

@interface MoreCell :PJCollectionViewCell


@end

@implementation MoreCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _imageView = [UIImageView new];
        _title = [UILabel new];
        _title.font = Font(14);
        _title.textColor = CustomBlack;
        _title.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat allHeight = _imageView.image.size.height + kDefaultInset.top * 2 + _title.font.lineHeight;
    _imageView.frame = CGRectMake((CGRectGetWidth(self.frame) - _imageView.image.size.width) / 2, (CGRectGetHeight(self.frame) - allHeight) / 2, _imageView.image.size.width, _imageView.image.size.height);
    _title.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame) + kDefaultInset.top * 2, CGRectGetWidth(self.frame), _title.font.lineHeight);
}

- (void)setDatas:(id)datas
{
    _imageView.image = mImageByName(datas[@"image"]);
    _title.text = datas[@"title"];
}

@end

@interface MoreViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSString *UpdateURL;
    NSString *ShareURL;
}
@end

@implementation MoreViewController

- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"更 多"];
    }
    return self;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = DeviceW / 3 ;
    segmentBarLayout.sectionInset = UIEdgeInsetsMake(width * .2f, 0, 0, 0);
    segmentBarLayout.itemSize = CGSizeMake(width,width );
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _datas = [DataConfigManager getMoreList];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self segmentBarLayout]];
    _collectionView.userInteractionEnabled = YES;
    _collectionView.alwaysBounceVertical  = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[MoreCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
}


#pragma mark -- UICollectionViewDataSource 、UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datas.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datas = _datas[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.row)
    {
        case 0:
            // 帮助指南
        {
            [self helpManalBook];
        }
            break;
        case 1:
            // 检查更新
        {
            [self checkVersionUpdate];
        }
            break;
        case 2:
            // 关于我们
        {
            [self aboutUs];
        }
            break;
        case 3:
            // 分享推荐
        {
            [self shareToFriend];
        }
            break;
        case 4:
            // 客服电话
        {
            [self callService];
        }
            break;
        default:
            break;
    }
}

//TODO:帮助指南
-(void)helpManalBook
{
    HelpManualVCViewController *help = [[HelpManualVCViewController alloc]init];
    help.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:help animated:YES];
}

//TODO:检测更新
- (void)checkVersionUpdate
{
    [SVProgressHUD showWithStatus:@"正在查询版本号~"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *date = [NS_USERDEFAULT objectForKey:@"msg_time"];      // 消息时间
    date = isValidateStr(date)?date:@"00000000000000";             // 判断时间是否为零
    NSString *vHelp = [NS_USERDEFAULT objectForKey:@"help_version"]; // 获取当前help版本号
    params[@"ver"] = getBuildVersion();
    params[@"help_version"] = vHelp?:GET_INT(HELP_VER);
    params[@"system"] = @"iOS"; // 系统类型
    params[@"display"] = [NSString stringWithFormat:@"%.0fx%.0f",mScreenWidth,mScreenHeight];  // 屏幕展示的大小
    params[@"phone_name"] = IsPhone?@"iPhone":@"iPad"; // 获取客户端类型
    params[@"msg_time"] = date ;// 消息时间
    params[@"client_id"] = client_id; // 获取客户端id
    [params setPublicDomain:kAPI_QueryVersion];
    
    NSLog(@"------\n%@",params);
    _connection = [RequestModel POST:URL(kAPI_QueryVersion) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [SVProgressHUD dismiss];
                       // 升级提示
                       NSString *cancel = [data objectForKey:@"force_update"]==0? nil : LocStr(@"取消");
                       
                       NSString *releaseNote = [data objectForKey:@"release_note"];
                       
                       // 判断版本是否有更新
                       if ([[data objectForKey:@"ver"] floatValue]>[getBuildVersion() floatValue]){
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"升级提示") message:releaseNote delegate:self cancelButtonTitle:cancel otherButtonTitles:LocStr(@"确定"), nil];
                           /*保存下载地址*/
                           UpdateURL = [data objectForKey:@"url"];
                           /*分享地址*/
                           ShareURL = [data objectForKey:@"shore_url"];
                           
                           [alert setTag:10087];
                           [alert show];
                       }
                       else
                       {
                           [SVProgressHUD showInfoWithStatus:LocStr(@"您当前的版本为最新版本~")];
                       }
            
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                       [SVProgressHUD dismiss];
                   }];
    
}
//TODO:关于我们
-(void)aboutUs
{
    AboutViewController *aboutUs = [[AboutViewController alloc]init];
    aboutUs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutUs animated:YES];
    
}
//TODO:分享推荐
-(void)shareToFriend
{
    NSLog(@"=====%@",kkShareURLAddress);
    
    [ShareTools shareAllButtonClickHandler:@"彩票联盟客户端" andUser:kkShare_recommend andUrl:kkShareURLAddress andDes:@"快来下载吧~"];
}

//TODO:客服电话
-(void)callService
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"拨打 %@ 客服电话",kefuNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     alert.tag = 10086;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10087&&buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UpdateURL]];
        
    }else if(alertView.tag==10086&&buttonIndex!=alertView.cancelButtonIndex){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",kefuNumber]]];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
