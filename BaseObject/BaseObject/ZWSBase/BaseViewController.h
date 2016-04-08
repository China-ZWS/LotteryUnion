//
//  BaseViewController.h
//  MoodMovie
//
//  Created by 周文松 on 14-7-22.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//


#import <UIKit/UIKit.h>


typedef void (^SuccessLoginBlock)(UIViewController *viewController,BOOL isSuccess);

@interface BaseViewController : UIViewController
{
    SuccessLoginBlock _successLogin;
    NSURLConnection *_connection;
    id _parameters;
    NSArray *_datas; //静态
    NSMutableArray *_mDatas;
}

@property (nonatomic, copy) SuccessLoginBlock successLogin;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) id parameters;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *mDatas;
- (id)initWithParameters:(id)parameters;


/**
 *  @brief   初始化子视图
 */
- (void)setUpViews;


/**
 *  @brief  初始化数据
 */
- (void)setUpDatas;


/**
 *  @brief  登录界面初始化
 *
 *  @param success 登录成功回调
 *
 *  @return 返回self
 */
- (id)initWithLoginSuccess:(SuccessLoginBlock)success;

/**
 *  @brief  调用登录界面
 *
 *  @param success   登录成功回调
 *  @param className 登录界面的ViewController 名称
 */
- (void)gotoLogingWithSuccess:(void(^)(BOOL isSuccess))success class:(NSString *)className;

/**
 *  @brief  是否隐藏navigationBar
 *
 *  @param navigationBarHidden <#navigationBarHidden description#>
 */
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden;


/**
 *  @brief  简化push
 *
 *  @param viewcontroller 要push到的界面
 */
- (void)pushViewController:(UIViewController *)viewcontroller;

/**
 *  @brief  波浪push到下层界面
 *
 *  @param viewcontroller 要push到的界面
 */
- (void)pushAnimated:(UIViewController *)viewcontroller;


/**
 *  @brief  返回
 */
- (void)popViewController;

/**
 *  @brief  波浪返回
 */
- (void)popAnimated;


/**
 *  @brief  present简化
 *
 *  @param viewcontroller 要present的界面
 */
- (void)presentViewController:(UIViewController *)viewcontroller;

/**
 *  @brief  dismiss简化
 */
- (void)dismissViewController;

/**
 *  @brief  alert简化

 *
 *  @param alertTitle title
 *  @param message    message
 */
- (void)alertTitle:(NSString *)alertTitle message:(NSString *)message;

/**
 *  @brief  加上导航条push到下个界面
 *
 *  @param controller 要push到的界面
 */
- (void)addNavigationWithPushController:(UIViewController *)controller;

/**
 *  @brief  加上导航条present下个界面
 *
 *  @param controller 要present到的界面
 */
- (void)addNavigationWithPresentViewController:(UIViewController *)controller;

/**
 *  @brief  用Aler模仿安卓的 tosat
 *
 *  @param message message
 */
- (void)makeToast:(NSString *)message;


/**
 *  @brief  进度；
 */
- (void)progressView:(NSString *)title;

/**
 *  @brief  进度消失；
 */
- (void)progressHide:(BOOL)isHide;


///**
// *  @brief  网络状态监控回调
// *
// *  @param status 即时网络状态
// */
//- (void)reloadDatas:(NetworkStatus)status;

/**
 *  @brief  界面刷新（登录、登出）
 */
- (void)refreshWithViews;

- (void)gotoLoging;


@end