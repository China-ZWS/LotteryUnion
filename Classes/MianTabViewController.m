//
//  MianTabViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/23.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "MianTabViewController.h"
#import "PJNavigationController.h"
#import "DataConfigManager.h"
#import "HallVC.h"
#import "RunLotteryVC.h"
#import "MineVC.h"
#import "MessageVC.h"
#import "MoreViewController.h"
#import "PJNavigationBar.h"
#import "UserInfo.h"

@interface MianTabViewController ()
<UITabBarControllerDelegate>
{
    NSArray *_tabConfigList;
    NSInteger _currentIndex;
}
@end

@implementation MianTabViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.delegate = self;
    }
    return self;
}

- (NSArray *)createTabItemArr
{
    _tabConfigList = [DataConfigManager getTabList];
    NSMutableArray *item = [NSMutableArray array];
    for (int i = 0; i < _tabConfigList.count; i ++)
    {
        switch (i) {
            case 0:
            {
                PJNavigationController*nav = [[PJNavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[[HallVC new]];
                
                [item addObject:nav];
            }
                break;
            case 1:
            {
                
                PJNavigationController *nav = [[PJNavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[[RunLotteryVC new]];
                [item addObject:nav];
            }
                break;
            case 2:
            {
                PJNavigationController *nav = [[PJNavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[[MineVC new]];
                [item addObject:nav];
                
            }
                break;
            case 3:
            {
                PJNavigationController *nav = [[PJNavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[[MessageVC new]];
                [item addObject:nav];
                
            }
                break;
            case 4:
            {
                PJNavigationController *nav = [[PJNavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
                nav.viewControllers = @[[MoreViewController new]];
                [item addObject:nav];
                
            }
                break;

            default:
                break;
        }
        
    }
    return item;
}

- (void)createTabItemBk:(NSInteger)items;
{
    
    for (int i = 0; i < items; i ++)
    {
        NSDictionary *dict = [_tabConfigList objectAtIndex:i];
        UIImage *hightlightImg = [[UIImage imageNamed:[dict objectForKey:@"highlightedImage"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] ;
        UIImage *img = [[UIImage imageNamed:[dict objectForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        [self.tabBar.items objectAtIndex:i].selectedImage = hightlightImg;
        [self.tabBar.items objectAtIndex:i].image = img;

//        [[self.tabBar.items objectAtIndex:i] setFinishedSelectedImage:hightlightImg withFinishedUnselectedImage:img];
        
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:i] setTitle:[dict objectForKey:@"title"]];
        [[self.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:CustomBlack,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:11],NSFontAttributeName,nil] forState:UIControlStateNormal];
        
        [[self.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:CustomRed,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:11],NSFontAttributeName,nil] forState:UIControlStateSelected];
        
        /* You may specify the font, text color, text shadow color, and text shadow offset for the title in the text attributes dictionary, using the keys found in UIStringDrawing.h. */
        //        - (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
        //        其中作为attributes的字典参数，要获取有哪些可以的话可以参照下面这句。
        //        [self.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor] } forState:UIControlStateNormal];
        //        [NSValue valueWithCGSize:CGSizeMake(0.5, .5)] , UITextAttributeTextShadowOffset ,kUIColorFromRGB(0xFFFFFF) ,UITextAttributeTextShadowColor ,
        //        这里是修改颜色的，你可以用UITextAttributeFont来修改字体。
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tabBar setBackgroundImage:[self createTabBarBk] ];    /*设置Bar的背景颜色*/
    
    self.viewControllers = [self createTabItemArr];     /*设置Bar的items*/
    [self createTabItemBk:self.viewControllers.count];     /*设置Bar的item的背景及Title*/
    //    self.selectedIndex = 0;     /*设置Bar的第一个item*/
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    UINavigationController *nav = (UINavigationController *)viewController;
    
    if ([nav.viewControllers[0] isKindOfClass:[MineVC class]])
    {
        BaseViewController *controller = (BaseViewController *)nav.viewControllers[0];
        
        
        
        if (!UserInfoTool.isLogined && !UserInfoTool.isLoginedWithVirefi)
        {
            [controller gotoLogingWithSuccess:^(BOOL isSuccess)
             {
                 if (isSuccess)
                 {
                     [controller.view makeToast:@"登录成功"];
                     _currentIndex = self.selectedIndex;
                     NSNotificationPost(RefreshWithViews, nil, nil);
                 }
                 else
                 {
                     self.selectedIndex = _currentIndex;
                 }
             }
                                        class:@"LoginVC"];
        }

    }
    else
    {
        _currentIndex = self.selectedIndex;
    }
}

- (void)setSelected:(NSInteger)index;
{
    _currentIndex = 0;
    self.selectedIndex = index;
    
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
