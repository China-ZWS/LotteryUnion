//
//  WXBaseModel.h
//  MTWeibo
//  所有对象实体的基类

//  Created by wei.chen on 11-9-22.
//  Copyright 2011年 www.iphonetrain.com 无限互联ios开发培训中心 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXBaseModel : NSObject <NSCoding>{

}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

@end
