//
//  AbnormalView.h
//  BabyStory
//
//  Created by 周文松 on 14-12-18.
//  Copyright (c) 2014年 com.talkweb.www.HCTProject. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AbnormalViewDelegate <NSObject>

- (void)abnormalReloadDatas;

@end

typedef NS_ENUM(NSInteger, AbnormalType)
{
    NotNetWork = 10,  /// 没有网络.
    NotDatas = 11,///  没有数据
    kError = 12,
    NetTimeOut
};

@interface AbnormalView : UIView
@property (nonatomic, assign) id<AbnormalViewDelegate>delegate;

@property (assign) BOOL removeFromSuperViewOnHide;
@property (assign) AbnormalType abnormalType;

/**
 *  @brief  设置View
 *
 *  @param rect         范围
 *  @param view         superView
 *  @param AbnormalType 类型
 *
 *  @return 返回AbnormalView 示例
 */
+ (AbnormalView *)setRect:(CGRect)rect toView:(UIView *)view abnormalType:(AbnormalType)AbnormalType;

/**
 *  @brief  设置View
 *
 *  @param rect         frame范围
 *  @param view         superView
 *  @param AbnormalType 类型
 *  @param title        提示Title
 *
 *  @return 返回实例
 */
+ (AbnormalView *)setRect:(CGRect)rect toView:(UIView *)view abnormalType:(AbnormalType)AbnormalType title:(NSString *)title;
/**
 *  @brief  隐藏View
 *
 *  @param view superView
 *
 *  @return 成功或失败
 */
+ (BOOL)hideHUDForView:(UIView *)view;

/**
 *  @brief  设置代理单击事件
 *
 *  @param target 委托
 *  @param view   superView;
 */
+ (void)setDelegate:(id)target toView:(UIView *)view;


@end
