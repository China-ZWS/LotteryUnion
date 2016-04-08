//
//  FootballLotteryManagers.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/22.
//  Copyright © 2015年 xhd945. All rights reserved.
//

#import "FootballLotteryManagers.h"
#import "FootBallModel.h"
#import "FootBallQueryViewController.h"
#import "FBBettingViewController.h"
#import "FBSCBaseViewController.h"

#import "FTHeader.h"
#import "FTFooter.h"

#import "DataConfigManager.h"
#import "DropdownMenu.h"
#import "SFPView.h"
#import "RQSFPView.h"
#import "SCOREView.h"
#import "BQCView.h"
#import "JQSView.h"
#import "HHGGView.h"

@interface FootballLotteryManagers ()
{
    FBPlayType _playType; // 足彩类型
    FBBettingType _bettingType; // 投注类型
    NSArray *_playViews; // 所有玩法类型Views
    BaseTypeTableView *_currentView;
    id _footBallDatas;
    UIButton *_titleBtn;
}
@property (nonatomic, strong) FTHeader *header;
@property (nonatomic, strong) FTFooter *footer;

@end

@implementation FootballLotteryManagers

- (void)dealloc
{
    [FBTool.selectDatas removeAllObjects];
    FBTool.multiple = 1;
}


- (id)initWithPlayType:(FBPlayType)playType;
{
    if ((self = [super init])) {
        _playType = playType;
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(eventWithRight) image:@"jczq_no.png"];
        /*
         获取竞彩足球对阵信息
         */
        _datas = [DataConfigManager getLottery_JCZQ];
        /*
         初始化下拉菜单点击按钮
         */
        _titleBtn = [self.navigationItem setOptionView:self title:_datas[playType][@"title"] action:@selector(showOptions:) image:@"jczq_arrow_red_down.png"];
    }
    return self;
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
            [DropdownMenu showMenu:_datas toView:self.view index:_playType select:^(id data)
             {
                 _playType = [data[@"type"] integerValue];
                 if ([_currentView isEqual:_playViews[_playType]])
                 {
                     /*
                      如果当前view一样就Ruturn;
                      */
                     return ;
                 }
                 /*数据加载可能延迟，所以加个进度提示*/
                 [SVProgressHUD show];
                 
                 
                 /*
                  切换类型view
                  */
                 [UIView transitionFromView:_currentView toView:_playViews[_playType] duration:0 options:UIViewAnimationOptionTransitionNone completion:^(BOOL finished)
                  {
                      _currentView = _playViews[_playType];
                      _currentView.frame = CGRectMake(0, ScaleH(35), DeviceW, DeviceH - ScaleH(85) - CGRectGetHeight(self.navigationController.navigationBar.frame) - 20);
                      
                      /*
                       每次跳转界面默认过关投注选项
                       */
                      [_header defaultTouchWithSkipmatch];
                  }];
                 
                 [_titleBtn setTitle:data[@"title"] forState:UIControlStateNormal];
                 [UIView animateWithDuration:0.3f animations:^{
                     button.imageView.transform = CGAffineTransformIdentity;
                 }];
                 button.selected = !button.selected;
                 
             }
                        otherEvent:^{
                            [_titleBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                        } ];
            
            
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
                button.imageView.transform = CGAffineTransformIdentity;
            }];
        }
        
    }
}

#pragma mark -  返回
- (void)back
{
    [SVProgressHUD dismiss];
    [_connection cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 去足彩对阵查询
- (void)eventWithRight
{
    if (_playType == kHHGG) {
        _playType = kSFP;
    }
    [self pushViewController:[[FootBallQueryViewController alloc] initWithPlayType:_playType match_no:@""]];
}

#pragma mark - 去投注结算界面
- (void)gotoBetting:(id)datas
{
    [self pushViewController:[[FBBettingViewController alloc] initWithParameters:datas  playType:_playType bettingType:_bettingType clear:^{
        [self refreshDatasAndViews];
    }]];
}

#pragma mark - 去送彩票界面
- (void)gotoSCP:(id)datas
{
    [self pushViewController:[[FBSCBaseViewController  alloc] initWithParameters:datas  playType:_playType bettingType:_bettingType clear:^{
        [self refreshDatasAndViews];
    }]];

}

#pragma mark - 设置投注类型选择器
- (FTHeader *)header
{
    if (!_header) {
        WEAKSELF
        _header = [FTHeader selectBlock:^(FBBettingType type)
                   {
                       /*
                        修改用户选择单关还是过关投注的方式
                        */
                       [weakSelf changeWithBettingType:type];
                     
                       /*
                        数据加载延迟处理
                        */
                       [SVProgressHUD show];
                       
                       /*
                        刷新单场投注或则过关投注
                        */
                       [weakSelf refreshDatasAndViews];
                   }];
    }
    return _header;
}

#pragma  mark 设置底部选择器
- (FTFooter *)footer
{

    if (!_footer)
    {
        WEAKSELF
        _footer = [FTFooter select:^(id datas)
                   {
                       /*
                        判断是否允许去投注结算界面的依据
                        */
                       BOOL hasAllow = [weakSelf hasLimitForDatas:datas];
                       if (!hasAllow) return;
                       
                       /*
                        去投注结算界面
                        */
                       [weakSelf gotoBetting:datas];
                   }
                           SCEvent:^(id datas)
                   {
                       /*
                        判断是否允许去投注结算界面的依据
                        */
                       BOOL hasAllow = [weakSelf hasLimitForDatas:datas];
                       if (!hasAllow) return;
                       /*
                        去投注结算界面
                        */
                       [weakSelf gotoSCP:datas];

                   }
                             clear:^{
                                 /*
                                  清空用户当前选择玩法投注，提示用户行为
                                  */
                                 [SVProgressHUD  showSuccessWithStatus:@"清除成功"];
                                 /*
                                  刷新UI
                                  */
                                 [weakSelf refreshViews];
                             }];
    }
    return _footer;
}




#pragma mark - 刷洗不同玩法类型数据及UI
- (void)refreshDatasAndViews
{
   
    if (!_footBallDatas) {
        return;
    }

    /*
     影藏或打开单场投注选项
     */
    if (_playType == kHHGG)
    {
        [_header hideSingleOption:YES];
    }
    else
    {
        [_header hideSingleOption:NO];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         加载当前用户选择玩法的数据
         */
        [_currentView setDatas:_footBallDatas bettingType:_bettingType];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /*刷新UI*/
            [self refreshViews];
            [SVProgressHUD dismiss];

        });
    });
    
}

#pragma mark - 刷新UI
- (void)refreshViews
{
    /*
     设置用户当前玩法选择了多少场次
     */
    [_footer setCurrentBettingType:_bettingType playType:_playType];
    /*
    刷新当前UI
     */
    [_currentView reloadData];

}

#pragma mark - 修改用户单场还是过关的投注方式
- (void)changeWithBettingType:(FBBettingType)type
{
    _bettingType = type;
    /*
        修改footer的单场还是过关投注的提示
     */
    if (type == kSingle ) {
        [_footer  setRuleForSingle:YES];
    }
    else
    {
        [_footer  setRuleForSingle:NO];
    }
}


- (BOOL)hasLimitForDatas:(NSArray *)datas
{
    /*
     去投注结算界面，如果是用户选择的过关投注界面，至少要选择2场，如果是单关投注，则不限制用户选择的场次
     */
    if (_bettingType == kSkipmatch)
    {
        if ([datas count] < 2)
        {
            /*
             提示用户行为
             */
            [SVProgressHUD showInfoWithStatus:@"请至少选择2场比赛"];
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 加载数据
- (void)setUpDatas
{
    /*
     数据加载延迟处理
     */
    [SVProgressHUD show];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        /*
//         每次首先加载本地数据
//         */
//        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]stringByAppendingPathComponent:@"ZCJJRequestDate.archiver"] ;
//        NSDictionary *datas = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            /*
//             如果用户是第一次使用这个产品，就没有本地缓存数据，有则相反
//             */
//            if (datas)
//            {
//                /*
//                 这里是有效缓存期是一天，超过一天则重新请求，没有就使用缓存数据
//                 */
//                if ([FootBallModel isSameDay:datas[@"date"] date2:[NSDate date]]) {
//                    _footBallDatas = datas[@"datas"];
//                    /*
//                     设置左上角全部赛事的数量
//                     */
//                    [_header setHeaderWithAllCompetition:[datas[@"datas"][@"item"] count]];
//                    /*
//                     刷新各个足彩界面及数据
//                     */
//                    [self refreshDatasAndViews];
//                    return ;
//                }
//            }
        
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setPublicDomain:kAPI_ZJZQ];
            _connection = [RequestModel POST:URL(kAPI_ZJZQ) parameter:params   class:[RequestModel class]
                                     success:^(id data)
                           {
                               /*
                                数据可能为空，及处理
                                */
                               if (!data || ![data[@"item"] count]) {
                                   [SVProgressHUD dismiss];
                                   return ;
                               }
                               /*
                                数据归档
                                */
//                               [NSKeyedArchiver archiveRootObject:@{@"date":[NSDate date],@"datas":data} toFile:filePath];
                               _footBallDatas = data;
                               /*
                                设置左上角全部赛事的数量
                                */
                               [_header setHeaderWithAllCompetition:[data[@"item"] count]];
                               /*
                                刷新各个足彩界面及数据
                                */
                               [self refreshDatasAndViews];
                           }
                                     failure:^(NSString *msg, NSString *state)
                           {
                               [SVProgressHUD showInfoWithStatus:msg];
                           }];
//        });
//    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /*
     投注类型选择器
     */
    [self.view addSubview:self.header];
    [self.view addSubview:self.footer];
    
    /*
     初始化 所有 类型View
     */
    _playViews = @[[SFPView new], [RQSFPView new], [SCOREView new], [BQCView new], [JQSView new], [HHGGView new]];
    
    /*
     获取当前显示的view
     */
    _currentView = _playViews[_playType];
    
    /*
     显示用户当前所选View
     */
    [self.view addSubview:_playViews[_playType]];
}



@end
