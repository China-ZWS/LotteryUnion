//
//  CTFBBaseViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/13.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFBBaseViewController.h"
#include <AudioToolbox/AudioToolbox.h>
#import "CTFBBettingViewController.h"
#import "AwardVC.h"

@interface CTFBBaseBtn : UIButton
@end

@implementation CTFBBaseBtn

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.titleLabel.font = NFont(13);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.showsTouchWhenHighlighted = YES;
        [self setTitleColor:CustomBlack forState:UIControlStateNormal];
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




@interface CTFBBaseViewController ()
@property (nonatomic) UILabel *bettinNum;
@property (nonatomic) UILabel *infoTitle;
@property (nonatomic) UIView *headerView;
@end

@implementation CTFBBaseViewController

- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(eventWithRight) image:@"jczq_no.png"];

    }
    return self;
}

- (void)back
{
    [_connection cancel];
    [SVProgressHUD dismiss];
    [self dismissViewController];
}

- (void)eventWithRight
{
    NSString *title = nil;
    switch (_lottery_pk) {
        case kType_CTZQ_SF14:
            title = @"胜负14场";
            break;
        case kType_CTZQ_SF9:
            title = @"任选9场";
            break;
        case kType_CTZQ_BQC6:
            title = @"6场半全场";
            break;
        case kType_CTZQ_JQ4:
            title = @"4场进球";
            break;
    
        default:
            break;
    }
    //将id和彩名传过去
    AwardVC *awardVC = [[AwardVC alloc] initWithLottery_pk:GET_INT(_lottery_pk)
                                                  playName:title];
    awardVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:awardVC animated:YES];

}

- (void)dealloc
{
    [CTFBTool removeObserver:self forKeyPath:@"value_storages" context:NULL];
    [CTFBTool.value_storages removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UIButton *)image:(UIImage *)image  title:(NSString *)title target:(nullable id)target  action:(nonnull SEL)action
{
    CTFBBaseBtn *view = [CTFBBaseBtn buttonWithType:UIButtonTypeCustom];
    view.frame = CGRectMake(0, 0, CGRectGetHeight(self.navigationController.toolbar.frame), CGRectGetHeight(self.navigationController.toolbar.frame));
    [view setImage:image forState:UIControlStateNormal];
    [view setTitle:title forState:UIControlStateNormal];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (NSArray *)getItems
{
    NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *buttonItem = nil;
    for (int i = 0; i < 5; i ++) {
        switch (i) {
            case 0:
                buttonItem = [[UIBarButtonItem alloc] initWithCustomView:[self image:[UIImage imageNamed:@"ctzq_bet.png"] title:@"投注" target:self action:@selector(eventWithBetting)]];
                [items addObject:buttonItem];
                break;
            case 1:
                buttonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                [items addObject:buttonItem];
                break;

            case 2:
                buttonItem = [[UIBarButtonItem alloc] initWithCustomView:[self image:[UIImage imageNamed:@"ctzq_send.png"] title:@"送彩票" target:self action:@selector(eventWithSCP)]];
                [items addObject:buttonItem];
                break;
            case 3:
                buttonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                [items addObject:buttonItem];
                break;

            case 4:
                buttonItem = [[UIBarButtonItem alloc] initWithCustomView:[self image:[UIImage imageNamed:@"ctzq_empty.png"] title:@"清空" target:self action:@selector(eventWithClear)]];
                [items addObject:buttonItem];
                break;
            default:
                break;
        }
    }
    return items;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [UIView new];
        _headerView.backgroundColor = RGBA(129, 152, 204, .8);
        _bettinNum = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultInset.left, 0, DeviceW - ScaleW(50), ScaleH(25))];
        _bettinNum.textColor = [UIColor whiteColor];
        _bettinNum.font = Font(13);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DeviceW - ScaleW(90), (ScaleH(30) - ScaleH(20)) / 2, ScaleW(90), ScaleH(20));
        btn.titleLabel.font = NFont(13);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ctzq_yaoyiyao.png"] forState:UIControlStateNormal];
        [btn setTitle:@"机选一注" forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [btn setBackgroundImage:[UIImage drawrWithLeftRound:btn.size lineWidth:LineWidth lineColor:CustomBlack backgroundColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(createShake) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
        [_headerView addSubview:_bettinNum];
        [self setBettinNumTitle:0];
    }
    return _headerView;
}

- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_table.frame) - 44, DeviceW, ScaleH(25))];
        _infoTitle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _infoTitle.font = Font(14);
        _infoTitle.textAlignment = NSTextAlignmentCenter;
        _infoTitle.textColor = CustomRed;
        _infoTitle.backgroundColor = NavColor;
        [self setInfoTitleWithText:0];
    }
    return _infoTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _table.height -= ScaleH(25);
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // Do any additional setup after loading the view.
    self.toolbarItems = [self getItems];
    [self.view addSubview:self.infoTitle];
    /*数组KVO*/
    [CTFBTool addObserver:self forKeyPath:@"value_storages" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    NSNotificationAdd(self, changeWithValue_storages, @"changeWithValue_storages", nil);
}

#pragma mark - 去投注
- (void)eventWithBetting
{
    [self eventWithBettingType:NSNotFound];
}

- (void)eventWithBettingType:(CTZQPlayType)bettingType;
{
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    datas[@"bettingNum"] = [NSNumber numberWithInteger:_bettingNum];
    datas[@"type"] = _bettingNum > 1?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
    datas[@"bettingText"] = [CTFBModel getBettingResultBettingType:_bettingNum>1?1:0];
    [[CTFBTool mutableArrayValueForKey:@"betting_results"] addObject:datas];
    
    UITabBarController *tabbarController = (UITabBarController *)self.presentingViewController;
    UINavigationController *navController = tabbarController.viewControllers[tabbarController.selectedIndex];
    UIViewController *viewController= navController.topViewController;
    
    if (![viewController isKindOfClass:[CTFBBettingViewController class]])
    {
        CTFBBettingViewController *bettiogController = [[CTFBBettingViewController alloc] initWithPlayType:bettingType];
        [viewController.navigationController pushViewController:bettiogController animated:NO];
    }
    
    [self dismissViewController];
}

#pragma mark - 去送彩
- (void)eventWithSCP
{
    [self eventWithSCP:NSNotFound];
}

- (void)eventWithSCP:(CTZQPlayType)bettingType
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    datas[@"bettingNum"] = [NSNumber numberWithInteger:_bettingNum];
    datas[@"type"] = _bettingNum > 1?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
    datas[@"bettingText"] = [CTFBModel getBettingResultBettingType:_bettingNum>1?1:0];
    [[CTFBTool mutableArrayValueForKey:@"betting_results"] addObject:datas];
    
    UITabBarController *tabbarController = (UITabBarController *)self.presentingViewController;
    UINavigationController *navController = tabbarController.viewControllers[tabbarController.selectedIndex];
    UIViewController *viewController= navController.topViewController;
    
    if (![viewController isKindOfClass:[CTFBSCBaseViewController class]])
    {
        CTFBSCBaseViewController *bettiogController = [[CTFBSCBaseViewController alloc] initWithPlayType:bettingType];
        [viewController.navigationController pushViewController:bettiogController animated:NO];
    }
    
    [self dismissViewController];

}

#pragma mark - 清空
- (void)eventWithClear
{

    if (CTFBTool.value_storages.count) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (CTFBDataModels *model in CTFBTool.value_storages)
            {
                model.win = model.pin = model.lose = model.bWin = model.bPin = model.bLose = model.team1_select_one = model.team1_select_two = model.team1_select_three = model.bLose = model.team1_select_four = model.team2_select_one = model.team2_select_two = model.team2_select_three = model.team2_select_four = NO;
            }
            [[CTFBTool mutableArrayValueForKey:@"value_storages"] removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                /*
                 清空用户当前选择玩法投注，提示用户行为
                 */
                [SVProgressHUD  showSuccessWithStatus:@"清除成功"];
                [self changeWithValue_storages];
                [_table reloadData];
                
            });
        });
        
    }
}

- (void)changeWithValue_storages
{
    /*
      监听Value_storages的变化
     */
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(40);
}




#pragma mark - 数组KVO 监听，目的是知道用户在当前玩法及投注类型选择的场次
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"value_storages"])
    {
        /*数据进行筛选*/
        [self setBettinNumTitle:CTFBTool.value_storages.count];
    }
}



- (void)setBettinNumTitle:(NSInteger)num
{
    NSString *title = [NSString stringWithFormat:@"已选场次: %d",num];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([@"已选场次: " length], [[NSString stringWithFormat:@"%d",num] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(15) range:NSMakeRange([@"已选场次: " length], [[NSString stringWithFormat:@"%d",num] length])];
    _bettinNum.attributedText = attrString;
}

- (void)setInfoTitleWithText:(NSInteger)bettingNum
{
    _bettingNum = bettingNum;
    NSString *money = [NSString stringWithFormat:@"%d",bettingNum * 2];
    NSString *title = [NSString stringWithFormat:@"%d注 共 %@ 元",bettingNum,money];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGBA(129, 152, 204, 1) range:NSMakeRange(0, [[NSString stringWithFormat:@"%d注",bettingNum] length])];
    _infoTitle.attributedText = attrString;
}



- (void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController  setToolbarHidden:YES animated:YES];
    [self becomeFirstResponder];
    [super viewDidDisappear:animated];
}
- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    [self.navigationController  setToolbarHidden:NO animated:YES];
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    [self createShake];
    return;
}

//// 摇一摇取消摇动
//- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    NSLog(@"取消摇动");
//    return;
//}
//
// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
//        NSLog(@"摇动结束");
//
//        [self createShake];
//    }
    return;
}

- (void)createShake
{
    for (CTFBDataModels *model in CTFBTool.value_storages)
    {
        model.win = model.pin = model.lose = model.bWin = model.bPin = model.bLose = model.team1_select_one = model.team1_select_two = model.team1_select_three = model.team1_select_four = model.team2_select_one = model.team2_select_two = model.team2_select_three = model.team2_select_four = NO;
    }
    [self reloadTabData];
    [_table layoutIfNeeded];

    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
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
