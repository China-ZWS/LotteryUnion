//
//  DataConfigManager.h
//  NetSchool
//
//  Created by 周文松 on 15/8/28.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataConfigManager : NSObject
/**
 *  @brief  获取根目录
 *
 *  @return 返回根目录
 */
+ (NSDictionary *)returnRoot;

/**
 *  @brief  获取首页数据
 *
 *  @return 返回首页数据
 */
+ (NSArray *)getMainConfigList;

/**
 *  @brief  获取TabBer数据
 *
 *  @return 返回TabBer数据
 */
+ (NSArray *)getTabList;

/**
 *  @brief  获取 “更多” 数据
 *
 *  @return 返回 “更多” 数据
 */
+ (NSArray *)getMoreList;


/**
 *  @brief  获取竞彩主球对阵信息
 *
 *  @return 返回竞彩主球对阵信息
 */
+ (NSArray *)getLottery_JCZQ;

/**
 *  @brief  得到竞彩足球串法
 *
 *  @param bettingNum 最大串法
 *
 *  @return 返回串法
 */
+ (NSDictionary *)getFB_bettingPlay:(NSInteger)bettingNum;

@end
