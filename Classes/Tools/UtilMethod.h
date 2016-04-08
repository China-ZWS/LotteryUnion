//
//  UtilMethod.h
//  LotteryUnion
//
//  Created by xhd945 on 15/10/26.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilMethod : NSObject
//TODO:保存基本信息
+(NSMutableArray*)saveVersionInfo:(NSDictionary*)aDict;

// 根据lot_pk查找icon或name
NSString *getLotNames(NSString *lot_pk);

// 获取控制器
NSString *getLotViewController(API_LotteryType lot_pk);
NSString *getLotVCString(API_LotteryType lot_pk);
//TODO:
/* 彩种开奖号码是否为单号 */
BOOL isSingleBall(API_LotteryType lot_PK);
/* 彩种是否为足彩 */
BOOL isFootBallLottery(API_LotteryType lotPK);

//TODO:根据状态码获取信息
NSString *getCodeMessageWithCode(NSString * code);

//TDOO:生成红球和蓝球开奖号码
UIButton *makeRedBallLabel(NSString *number,BOOL isSmall);
UIButton *makeBlueBallLabel(NSString *number,BOOL isSmall);

// 拿到客户端版本号
NSString *getBuildVersion();

//TODO:判断字符串是否为空
BOOL isValidateStr(NSString* dest);

//TODO:是否为纯汉字
BOOL isChinese(NSString *str);

//TODO:创建文件夹
BOOL makeDirs(NSString *dirPath);

//TODO:组合Document文件夹下的路径
NSString *getPathInDocument(NSString *fileName);

//TODO:获取中文单位 （个,十,百,千,万）
NSString *getChinseHundred(int number);

//TODO:获取中文数字
NSString *getChineseNumber(int number);

//TODO:获取百十个未
NSString *getChinseHundredFrom3(int number);

#pragma mark -- 获取随机数的方法
int randomValueBetween(int min,int max);
NSMutableArray *getRadomNumber(int number,int high);
NSMutableArray *getRadomNumberFromZero(int number,int high);
// 多少个数里面随机选出几个数
NSMutableArray *getUnRepeatRadomNumber(int number,int high);

// 获取投注状态
NSString *getBetStatus(int status);

//彩种是否为竞彩足球
BOOL isJCBallLottery(API_LotteryType lotPK);

//彩种是否为乐透数字
BOOL isLTLottery(API_LotteryType lotPK);

//彩种是否为地方彩
BOOL isDFLottery(API_LotteryType lotPK);

@end
