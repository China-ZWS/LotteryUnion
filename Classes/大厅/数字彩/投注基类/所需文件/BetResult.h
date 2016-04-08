//
//  BetResult.h
//  YaBoCaiPiao
//
//  Created by liuchan on 12-8-10.
//  Copyright (c) 2012年 DoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BetResult : NSObject
/* 投注号码 */
@property (nonatomic,strong) NSString *numbers;

/* 彩种代码 */
@property (nonatomic,strong) NSString *lot_pk;

/* 玩法代码 */
@property (nonatomic,strong) NSString *play_code;

/* 注数 */
@property (nonatomic,assign) NSInteger zhushu;

/* 玩法类型，胆拖，前三，组三等...*/
@property (nonatomic,strong) NSString *play_type;


@end
